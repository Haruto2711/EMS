package com.ems.controller;

import com.ems.dao.ShiftAssignmentDAO;
import com.ems.dto.EmployeeDTO;
import com.ems.dto.ShiftAssignmentBatchDTO;
import com.ems.util.ExcelAttendanceExporter;
import com.ems.util.ShiftRecurrenceHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Servlet xử lý export file Excel template chấm công từ 1 batch phân ca.
 *
 * URL: GET /shift-assignment/export-attendance?batchId=X
 *
 * Quy tắc nghiệp vụ:
 *  - Chỉ export khi batch đang active HÔM NAY:
 *    startDate ≤ hôm nay ≤ endDate VÀ hôm nay thuộc recurrence rule.
 *  - File Excel gồm N dòng (1 dòng/nhân viên), ngày cố định = hôm nay,
 *    cột Check in / Check out để trống → quản lý điền tay rồi import lại.
 */
@WebServlet("/shift-assignment/export-attendance")
public class ExportAttendanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── 1. Đọc batchId ──
        String batchIdStr = req.getParameter("batchId");
        if (batchIdStr == null || batchIdStr.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu batchId.");
            return;
        }

        int batchId;
        try {
            batchId = Integer.parseInt(batchIdStr.trim());
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "batchId không hợp lệ.");
            return;
        }

        // ── 2. Load batch ──
        ShiftAssignmentBatchDTO batch = ShiftAssignmentDAO.getBatchById(batchId);
        if (batch == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy batch phân ca.");
            return;
        }

        // ── 3. Kiểm tra batch có active hôm nay không ──
        LocalDate today = LocalDate.now();
        if (!ShiftRecurrenceHelper.isActiveOn(batch, today)) {
            // Redirect về trang phân ca kèm thông báo
            String msg;
            if (batch.getEndDate() == null || today.isAfter(batch.getEndDate())) {
                msg = "Batch phân ca đã hết hạn. Vui lòng cập nhật ngày kết thúc để export.";
            } else if (today.isBefore(batch.getStartDate())) {
                msg = "Batch phân ca chưa bắt đầu (từ " + batch.getStartDateStr() + ").";
            } else {
                msg = "Hôm nay không phải ngày làm việc theo lịch phân ca này.";
            }
            req.getSession().setAttribute("exportError", msg);
            resp.sendRedirect(req.getContextPath() + "/shift-assignment");
            return;
        }

        // ── 4. Lấy danh sách nhân viên của batch ──
        List<EmployeeDTO> employees = ShiftAssignmentDAO.getEmployeesOfBatch(batchId);
        if (employees.isEmpty()) {
            req.getSession().setAttribute("exportError",
                    "Batch phân ca không có nhân viên nào. Vui lòng thêm nhân viên.");
            resp.sendRedirect(req.getContextPath() + "/shift-assignment");
            return;
        }

        // ── 5. Set header download ──
        String dateTag = today.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String safeName = sanitizeFileName(batch.getName());
        String fileName = "ChamCong_" + dateTag + "_" + safeName + ".xlsx";
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition",
                "attachment; filename*=UTF-8''" + java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20"));
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        // ── 6. Stream file Excel ──
        try (OutputStream out = resp.getOutputStream()) {
            ExcelAttendanceExporter.export(employees, today, out);
            out.flush();
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tạo file Excel: " + e.getMessage(), e);
        }
    }

    /**
     * Loại bỏ / thay thế các ký tự không hợp lệ trong tên file:
     *   - Ký tự đặc biệt của OS: \ / : * ? " < > |
     *   - Khoảng trắng → dấu gạch dưới
     *   - Trim và giới hạn độ dài 50 ký tự để tránh tên quá dài
     */
    private static String sanitizeFileName(String name) {
        if (name == null || name.isBlank()) return "PhânCa";
        return name.trim()
                   .replaceAll("[\\\\/:*?\"<>|]", "")   // xóa ký tự cấm
                   .replaceAll("\\s+", "_")               // khoảng trắng → _
                   .replaceAll("_+", "_")                 // nhiều _ liên tiếp → 1 _
                   .replaceAll("^_|_$", "")               // trim _ đầu/cuối
                   .substring(0, Math.min(name.trim().length(), 50));
    }
}

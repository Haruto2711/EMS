package com.ems.servlet;

import com.ems.model.AttendanceRecord;
import com.ems.util.ExcelParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@WebServlet("/Attendance/upload")
@MultipartConfig(
        maxFileSize = 1024 * 1024 * 10,      // tối đa 10MB
        maxRequestSize = 1024 * 1024 * 15
)
public class UploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Part filePart = request.getPart("excelFile");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file Excel để upload.");
            request.getRequestDispatcher("upload.jsp").forward(request, response);
            return;
        }

        try (InputStream fileContent = filePart.getInputStream()) {
            List<AttendanceRecord> records = ExcelParser.parse(fileContent);

            if (records.isEmpty()) {
                request.setAttribute("error", "Không đọc được dữ liệu nào từ file. Kiểm tra lại định dạng cột.");
                request.getRequestDispatcher("upload.jsp").forward(request, response);
                return;
            }

            // Lưu tạm vào session để trang preview + ConfirmServlet dùng lại
            HttpSession session = request.getSession();
            session.setAttribute("previewList", records);

            request.getRequestDispatcher("preview.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi đọc file Excel: " + e.getMessage());
            request.getRequestDispatcher("upload.jsp").forward(request, response);
        }
    }
}

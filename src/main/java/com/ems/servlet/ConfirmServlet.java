package com.ems.servlet;

import com.ems.dao.AttendanceDAO;
import com.ems.model.AttendanceRecord;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/confirm")
public class ConfirmServlet extends HttpServlet {

    private final AttendanceDAO dao = new AttendanceDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<AttendanceRecord> records = (List<AttendanceRecord>) session.getAttribute("previewList");

        if (records == null || records.isEmpty()) {
            request.setAttribute("error", "Không có dữ liệu để lưu. Vui lòng upload lại file.");
            request.getRequestDispatcher("upload.jsp").forward(request, response);
            return;
        }

        try {
            dao.saveAll(records);
            session.removeAttribute("previewList"); // xóa dữ liệu tạm sau khi lưu xong
            request.setAttribute("savedCount", records.size());
            request.getRequestDispatcher("success.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi lưu vào database: " + e.getMessage());
            request.getRequestDispatcher("preview.jsp").forward(request, response);
        }
    }
}

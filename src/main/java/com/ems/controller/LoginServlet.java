package com.ems.controller;

import com.ems.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trả về trang login.jsp
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Gọi DAO kiểm tra thông tin đăng nhập
        String role = userDAO.authenticate(username, password);

        if (role != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            // Điều hướng sang trang chủ tương ứng của từng vai trò
            role = role.trim().toLowerCase();
            if (role.equals("employee") || role.equals("nhân viên")) {
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            } else if (role.equals("manager") || role.equals("quản lý")) {
                response.sendRedirect(request.getContextPath() + "/home_manager.jsp");
            } else if (role.equals("admin") || role.equals("quản trị viên")) {
                response.sendRedirect(request.getContextPath() + "/home_admin.jsp");
            } else {
                // Mặc định trả về trang chủ nhân viên
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            }
        } else {
            // Sai thông tin đăng nhập, hiển thị thông báo lỗi
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không chính xác, hoặc tài khoản đã bị khóa!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}

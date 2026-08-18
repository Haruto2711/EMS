package com.ems.controller;

import com.ems.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"Admin".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        // Lấy danh sách nhân viên đầy đủ
        List<Map<String, Object>> employeeList = userDAO.getAllEmployees();

        // Thống kê
        int totalEmp = employeeList.size();
        int activeEmp = 0;
        for (Map<String, Object> e : employeeList) {
            Boolean status = (Boolean) e.get("userStatus");
            if (status != null && status) activeEmp++;
        }

        // Lấy thông tin Admin đang đăng nhập
        String username = (String) session.getAttribute("username");
        String adminFullName = "";
        String adminDeptName = "";
        try (java.sql.Connection conn = com.ems.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                 "SELECT u.FullName, d.Name as deptName FROM accounts a " +
                 "JOIN users u ON a.UserId = u.Id " +
                 "LEFT JOIN departments d ON u.DepartmentId = d.Id " +
                 "WHERE a.Username = ?")) {
            ps.setString(1, username);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    adminFullName = rs.getString("FullName");
                    adminDeptName = rs.getString("deptName");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // Lấy danh sách phòng ban để lọc
        List<Map<String, Object>> deptsList = userDAO.getDepartments();

        request.setAttribute("employeeList", employeeList);
        request.setAttribute("totalEmp", totalEmp);
        request.setAttribute("activeEmp", activeEmp);
        request.setAttribute("deptsList", deptsList);
        request.setAttribute("fullName", adminFullName);
        request.setAttribute("deptName", adminDeptName);

        request.getRequestDispatcher("/employees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // Cập nhật thông tin cá nhân nhân viên
            int userId       = Integer.parseInt(request.getParameter("userId"));
            String fullName  = request.getParameter("fullName");
            String email     = request.getParameter("email");
            String phone     = request.getParameter("phone");
            userDAO.updateEmployeeInfo(userId, fullName, email, phone);

        } else if ("toggleStatus".equals(action)) {
            // Bật/Tắt trạng thái nhân viên (bảng users)
            int userId         = Integer.parseInt(request.getParameter("userId"));
            boolean currStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
            userDAO.updateEmployeeStatus(userId, !currStatus);
        }

        response.sendRedirect(request.getContextPath() + "/employees");
    }
}

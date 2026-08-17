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

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String loggedInUserRole = (String) session.getAttribute("role");
        if (!"Admin".equalsIgnoreCase(loggedInUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        // Fetch User list & stats
        List<Map<String, Object>> usersList = userDAO.getAllUsers();
        int totalCount = usersList.size();
        int activeCount = 0;
        int lockedCount = 0;
        for (Map<String, Object> u : usersList) {
            Boolean status = (Boolean) u.get("accountStatus");
            if (status != null && status) {
                activeCount++;
            } else {
                lockedCount++;
            }
        }

        // Fetch list of roles, departments, positions
        List<String> rolesList = userDAO.getAllRoles();
        List<Map<String, Object>> deptsList = userDAO.getDepartments();
        List<Map<String, Object>> positionsList = userDAO.getPositions();

        // Fetch fullName of logged in Admin
        String username = (String) session.getAttribute("username");
        String adminFullName = "";
        String adminDeptName = "";
        try (java.sql.Connection conn = com.ems.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                     "SELECT u.FullName, d.Name as DeptName " +
                     "FROM accounts a " +
                     "JOIN users u ON a.UserId = u.Id " +
                     "LEFT JOIN departments d ON u.DepartmentId = d.Id " +
                     "WHERE a.Username = ?")) {
            ps.setString(1, username);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    adminFullName = rs.getString("FullName");
                    adminDeptName = rs.getString("DeptName");
                }
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("usersList", usersList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("lockedCount", lockedCount);
        request.setAttribute("rolesList", rolesList);
        request.setAttribute("deptsList", deptsList);
        request.setAttribute("positionsList", positionsList);
        request.setAttribute("adminUsername", username);
        request.setAttribute("fullName", adminFullName);
        request.setAttribute("deptName", adminDeptName);

        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String loggedInUserRole = (String) session.getAttribute("role");
        if (!"Admin".equalsIgnoreCase(loggedInUserRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("toggleStatus".equalsIgnoreCase(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
                userDAO.updateAccountStatus(accountId, !currentStatus);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("updateRole".equalsIgnoreCase(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                String roleName = request.getParameter("roleName");
                userDAO.updateAccountRole(accountId, roleName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("create".equalsIgnoreCase(action)) {
            try {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String role = request.getParameter("role");
                int departmentId = Integer.parseInt(request.getParameter("departmentId"));
                int positionId = Integer.parseInt(request.getParameter("positionId"));

                userDAO.createAccountWithUser(username, password, fullName, email, role, departmentId, positionId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("update".equalsIgnoreCase(action)) {
            try {
                int accountId = Integer.parseInt(request.getParameter("accountId"));
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String role = request.getParameter("role");
                int departmentId = Integer.parseInt(request.getParameter("departmentId"));
                int positionId = Integer.parseInt(request.getParameter("positionId"));

                userDAO.updateAccountWithUser(accountId, fullName, email, role, departmentId, positionId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/users");
    }
}
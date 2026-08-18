package com.ems.dao;

import com.ems.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    /** Returns the account ID for the supplied username, or null when absent. */
    public Integer findAccountIdByUsername(String username) {
        String query = "SELECT Id FROM accounts WHERE Username = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("Id") : null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Xác thực tài khoản đăng nhập từ database.
     * Trả về tên vai trò (Role Name) nếu thông tin đăng nhập đúng và tài khoản đang hoạt động.
     * Trả về null nếu sai tài khoản/mật khẩu hoặc tài khoản bị khóa.
     */
    public String authenticate(String username, String password) {
        String query = "SELECT r.Name FROM accounts a " +
                       "JOIN users u ON a.UserId = u.Id " +
                       "LEFT JOIN accountroles ar ON a.Id = ar.AccountId " +
                       "LEFT JOIN roles r ON ar.RoleId = r.Id " +
                       "WHERE a.Username = ? AND a.PasswordHash = ? AND a.Status = 1 AND u.Status = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, username);
            ps.setString(2, password); // Dự án đang để trơn hoặc dùng hàm băm, ở mức cơ bản kiểm tra chuỗi thường
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Name"); // Trả về "Employee", "Manager", "Admin", v.v.
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Lấy tất cả người dùng trong hệ thống */
    public java.util.List<java.util.Map<String, Object>> getAllUsers() {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String query = "SELECT a.Id as accountId, a.Username, a.Status as accountStatus, u.FullName, u.EmailCompany, r.Name as roleName, u.DepartmentId, u.PositionId " +
                       "FROM accounts a " +
                       "JOIN users u ON a.UserId = u.Id " +
                       "LEFT JOIN accountroles ar ON a.Id = ar.AccountId " +
                       "LEFT JOIN roles r ON ar.RoleId = r.Id " +
                       "ORDER BY a.Id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("accountId", rs.getInt("accountId"));
                map.put("username", rs.getString("Username"));
                map.put("accountStatus", rs.getBoolean("accountStatus"));
                map.put("fullName", rs.getString("FullName"));
                map.put("emailCompany", rs.getString("EmailCompany"));
                map.put("roleName", rs.getString("roleName"));
                map.put("departmentId", rs.getInt("DepartmentId"));
                map.put("positionId", rs.getInt("PositionId"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Cập nhật trạng thái hoạt động/khóa của tài khoản */
    public void updateAccountStatus(int accountId, boolean status) {
        String query = "UPDATE accounts SET Status = ? WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setBoolean(1, status);
            ps.setInt(2, accountId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Cập nhật vai trò của tài khoản */
    public void updateAccountRole(int accountId, String roleName) {
        String deleteQuery = "DELETE FROM accountroles WHERE AccountId = ?";
        String insertQuery = "INSERT INTO accountroles (AccountId, RoleId) VALUES (?, (SELECT Id FROM roles WHERE Name = ?))";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps1 = conn.prepareStatement(deleteQuery)) {
                    ps1.setInt(1, accountId);
                    ps1.executeUpdate();
                }
                try (PreparedStatement ps2 = conn.prepareStatement(insertQuery)) {
                    ps2.setInt(1, accountId);
                    ps2.setString(2, roleName);
                    ps2.executeUpdate();
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Lấy tất cả vai trò */
    public java.util.List<String> getAllRoles() {
        java.util.List<String> list = new java.util.ArrayList<>();
        String query = "SELECT Name FROM roles";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("Name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy danh sách phòng ban */
    public java.util.List<java.util.Map<String, Object>> getDepartments() {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String query = "SELECT Id, Name FROM departments";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("id", rs.getInt("Id"));
                map.put("name", rs.getString("Name"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy danh sách chức vụ */
    public java.util.List<java.util.Map<String, Object>> getPositions() {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String query = "SELECT Id, Name FROM positions";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("id", rs.getInt("Id"));
                map.put("name", rs.getString("Name"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Tạo tài khoản mới đi kèm thông tin nhân viên */
    public boolean createAccountWithUser(String username, String password, String fullName, String email, String role, int departmentId, int positionId) {
        String insertUser = "INSERT INTO users (EmployeeCode, FullName, EmailCompany, DepartmentId, PositionId, Status) VALUES (?, ?, ?, ?, ?, 1)";
        String insertAccount = "INSERT INTO accounts (Username, PasswordHash, Status, UserId) VALUES (?, ?, 1, ?)";
        String insertRole = "INSERT INTO accountroles (AccountId, RoleId) VALUES (?, (SELECT Id FROM roles WHERE Name = ?))";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Lấy số lượng user để sinh EmployeeCode
                int nextId = 1;
                String countQuery = "SELECT COUNT(*) FROM users";
                try (PreparedStatement ps = conn.prepareStatement(countQuery);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        nextId = rs.getInt(1) + 1;
                    }
                }
                String empCode = "EMP" + String.format("%04d", nextId);

                // 2. Thêm mới User
                int userId = -1;
                try (PreparedStatement ps = conn.prepareStatement(insertUser, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, empCode);
                    ps.setString(2, fullName);
                    ps.setString(3, email);
                    ps.setInt(4, departmentId);
                    ps.setInt(5, positionId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            userId = rs.getInt(1);
                        }
                    }
                }

                if (userId == -1) {
                    conn.rollback();
                    return false;
                }

                // 3. Thêm mới Account
                int accountId = -1;
                try (PreparedStatement ps = conn.prepareStatement(insertAccount, java.sql.Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, username);
                    ps.setString(2, password);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            accountId = rs.getInt(1);
                        }
                    }
                }

                if (accountId == -1) {
                    conn.rollback();
                    return false;
                }

                // 4. Thêm quyền cho tài khoản
                try (PreparedStatement ps = conn.prepareStatement(insertRole)) {
                    ps.setInt(1, accountId);
                    ps.setString(2, role);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Cập nhật toàn bộ thông tin tài khoản và thông tin nhân viên đi kèm */
    public boolean updateAccountWithUser(int accountId, String fullName, String email, String role, int departmentId, int positionId) {
        String updateUser = "UPDATE users u " +
                             "JOIN accounts a ON a.UserId = u.Id " +
                             "SET u.FullName = ?, u.EmailCompany = ?, u.DepartmentId = ?, u.PositionId = ? " +
                             "WHERE a.Id = ?";
        String deleteRole = "DELETE FROM accountroles WHERE AccountId = ?";
        String insertRole = "INSERT INTO accountroles (AccountId, RoleId) VALUES (?, (SELECT Id FROM roles WHERE Name = ?))";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Cập nhật thông tin User
                try (PreparedStatement ps = conn.prepareStatement(updateUser)) {
                    ps.setString(1, fullName);
                    ps.setString(2, email);
                    ps.setInt(3, departmentId);
                    ps.setInt(4, positionId);
                    ps.setInt(5, accountId);
                    ps.executeUpdate();
                }
                
                // 2. Xóa và thêm mới quyền trong bảng trung gian
                try (PreparedStatement ps = conn.prepareStatement(deleteRole)) {
                    ps.setInt(1, accountId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(insertRole)) {
                    ps.setInt(1, accountId);
                    ps.setString(2, role);
                    ps.executeUpdate();
                }
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Lấy danh sách nhân viên đầy đủ thông tin (cho màn Quản lý thông tin nhân viên) */
    public java.util.List<java.util.Map<String, Object>> getAllEmployees() {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String query =
            "SELECT u.Id as userId, u.EmployeeCode, u.FullName, u.EmailCompany, u.Phone, " +
            "       u.Gender, u.DateOfBirth, u.Status as userStatus, u.DependentsCount, " +
            "       d.Name as departmentName, p.Name as positionName, p.JobLevel " +
            "FROM users u " +
            "LEFT JOIN departments d ON u.DepartmentId = d.Id " +
            "LEFT JOIN positions p ON u.PositionId = p.Id " +
            "ORDER BY LENGTH(u.EmployeeCode) ASC, u.EmployeeCode ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("userId",         rs.getInt("userId"));
                map.put("employeeCode",   rs.getString("EmployeeCode"));
                map.put("fullName",       rs.getString("FullName"));
                map.put("emailCompany",   rs.getString("EmailCompany"));
                map.put("phone",          rs.getString("Phone"));
                map.put("gender",         rs.getObject("Gender"));
                map.put("dateOfBirth",    rs.getDate("DateOfBirth"));
                map.put("userStatus",     rs.getBoolean("userStatus"));
                map.put("dependentsCount",rs.getInt("DependentsCount"));
                map.put("departmentName", rs.getString("departmentName"));
                map.put("positionName",   rs.getString("positionName"));
                map.put("jobLevel",       rs.getInt("JobLevel"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Cập nhật thông tin cá nhân nhân viên (Họ tên, Email, SĐT) */
    public void updateEmployeeInfo(int userId, String fullName, String email, String phone) {
        String query = "UPDATE users SET FullName = ?, EmailCompany = ?, Phone = ? WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null);
            ps.setInt(4, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Bật/Tắt trạng thái nhân viên trong bảng users */
    public void updateEmployeeStatus(int userId, boolean status) {
        String query = "UPDATE users SET Status = ? WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

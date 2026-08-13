package com.ems.dao;

import com.ems.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

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
}

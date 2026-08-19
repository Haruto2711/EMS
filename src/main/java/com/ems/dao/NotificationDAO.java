package com.ems.dao;

import com.ems.dto.NotificationDTO;
import com.ems.model.Notifications;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public static List<Notifications> getNotifications(Integer userId) {
        List<Notifications> notifications = new ArrayList<>();
        String sql = "select Id, Title, Message, IsRead, CreatedAt from notifications where UserId = ? ";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, userId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return notifications;
    }

    public static List<Notifications> getNotificationById(Integer userId, String keyword, String sort, int offset, int pageSize) {
        List<Notifications> notifications = new ArrayList<>();
        String orderDir = "DESC".equalsIgnoreCase(sort) ? "DESC" : "ASC";
        String sql = "select Id, Title, Message, IsRead, CreatedAt from notifications where UserId = ? and Title like ? " +
                "ORDER BY Title " + orderDir +
                " LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setString(2, "%" + keyword + "%");
            stm.setInt(3, pageSize);
            stm.setInt(4, offset);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return notifications;
    }

    public static int countNotifications(Integer userId, String keyword) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE UserId = ? && Title like ? ";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setString(2, "%" + keyword + "%");
            try(ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public static void notifyAllEmployee(String title, String message) {
        String sql = "INSERT INTO notifications (UserId, Title, Message, IsRead, CreatedAt) " +
                "SELECT Id, ?, ?, 0, NOW() FROM users WHERE Status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, title);
            stm.setString(2, message);
            System.out.println("Đã gửi thông báo cho " + stm.executeUpdate() + " nhân viên!");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void notifyEmployees(String title, String message, List<Integer> userIds) {
        if (userIds == null || userIds.isEmpty()) return;

        StringBuilder sql = new StringBuilder(
                "INSERT INTO notifications (UserId, Title, Message, IsRead, CreatedAt) " +
                        "SELECT Id, ?, ?, 0, NOW() FROM users WHERE Status = 1 AND Id IN (");
        for (int i = 0; i < userIds.size(); i++) {
            sql.append(i == 0 ? "?" : ",?");
        }
        sql.append(")");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql.toString())) {
            stm.setString(1, title);
            stm.setString(2, message);
            int idx = 3;
            for (Integer id : userIds) stm.setInt(idx++, id);
            System.out.println("Đã gửi thông báo cho " + stm.executeUpdate() + " nhân viên!");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private static Notifications mapRow(ResultSet rs) throws SQLException {
        Notifications n = new Notifications();
        n.setId(rs.getInt("Id"));
        n.setTitle(rs.getString("Title"));
        n.setMessage(rs.getString("Message"));
        n.setIsread(rs.getBoolean("IsRead"));
        java.sql.Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) n.setCreatedat(ts.toLocalDateTime());
        return n;
    }
}

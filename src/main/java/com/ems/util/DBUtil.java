package com.ems.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // TODO: đổi lại đúng thông tin SQL Server của bạn
    private static final String URL =
            "jdbc:mysql://localhost:3306/AttendanceDb";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy driver SQL Server", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

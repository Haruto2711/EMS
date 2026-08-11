package com.ems.dao;

import com.ems.model.Shifts;
import com.ems.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WorkScheduleDAO {

    public static List<Shifts> getWeekDefaultShift() {
        List<Shifts> list = new ArrayList<>();
        String sql = "select * from shifts where IsDefault = 1 order by DayOfweek asc";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToShift(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public static int checkExistDayOfWeek(int dayOfWeek) {
        try (Connection conn = DBConnection.getConnection()) {
            return checkExistDayOfWeek(conn, dayOfWeek);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void saveWorkSchedule(List<Shifts> list) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Shifts shift : list) {
                    int id = checkExistDayOfWeek(conn, shift.getDayOfweek());
                    if (id == -1) {
                        insertShift(conn, shift);
                    } else {
                        updateShift(conn, id, shift);
                    }
                }
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException(e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private static int checkExistDayOfWeek(Connection conn, int dayOfWeek) throws SQLException {
        String sql = "Select Id from Shifts where DayOfWeek = ? and IsDefault = 1";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, dayOfWeek);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Id");
                }
            }
        }
        return -1;
    }

    private static void insertShift(Connection conn, Shifts shifts) throws SQLException {
        String sql = "Insert into shifts (Name, StartTime, EndTime, BreakStart, BreakEnd, IsActive, IsDefault, DayOfWeek) " +
                "values (?, ?, ?, ?, ?, ?, 1, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, shifts.getName());
            stmt.setObject(2, shifts.getStarttime());
            stmt.setObject(3, shifts.getEndtime());
            stmt.setObject(4, shifts.getBreakstart());
            stmt.setObject(5, shifts.getBreakend());
            stmt.setBoolean(6, Boolean.TRUE.equals(shifts.getIsactive()));
            stmt.setInt(7, shifts.getDayOfweek());
            stmt.executeUpdate();
        }
    }

    private static void updateShift(Connection conn, int id, Shifts shifts) throws SQLException {
        String sql = "Update shifts set Name = ?, StartTime = ?, EndTime = ?, BreakStart = ?, BreakEnd = ?, IsActive = ? where Id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, shifts.getName());
            stmt.setObject(2, shifts.getStarttime());
            stmt.setObject(3, shifts.getEndtime());
            stmt.setObject(4, shifts.getBreakstart());
            stmt.setObject(5, shifts.getBreakend());
            stmt.setBoolean(6, Boolean.TRUE.equals(shifts.getIsactive()));
            stmt.setInt(7, id);
            stmt.executeUpdate();
        }
    }

    private static Shifts mapResultSetToShift(ResultSet rs) throws SQLException {
        Shifts shift = new Shifts();
        shift.setId(rs.getInt("Id"));
        shift.setName(rs.getString("Name"));
        shift.setDayOfweek(rs.getInt("DayOfweek"));
        Time start = rs.getTime("StartTime");
        Time end = rs.getTime("EndTime");
        Time breakStart = rs.getTime("BreakStart");
        Time breakEnd = rs.getTime("BreakEnd");

        shift.setStarttime(start != null ? start.toLocalTime() : null);
        shift.setEndtime(end != null ? end.toLocalTime() : null);
        shift.setBreakstart(breakStart != null ? breakStart.toLocalTime() : null);
        shift.setBreakend(breakEnd != null ? breakEnd.toLocalTime() : null);
        shift.setIsactive(rs.getBoolean("IsActive"));
        return shift;
    }
}
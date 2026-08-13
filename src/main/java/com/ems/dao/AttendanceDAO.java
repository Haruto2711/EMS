package com.ems.dao;

import com.ems.model.AttendanceRecord;
import com.ems.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Time;
import java.util.List;

public class AttendanceDAO {

    private static final String INSERT_SQL =
            "INSERT INTO attendance ( Id, CheckInTime, CheckOutTime) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    /**
     * Lưu toàn bộ danh sách vào DB trong 1 transaction.
     * Nếu có lỗi ở bất kỳ dòng nào -> rollback toàn bộ, không lưu 1 phần.
     */
    public void saveAll(List<AttendanceRecord> records) throws Exception {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
                for (AttendanceRecord r : records) {
                    ps.setDate(1, r.getDate() != null ? java.sql.Date.valueOf(r.getDate()) : null);
                    ps.setString(2, r.getEmployeeCode());
                    ps.setString(3, r.getFullName());
                    ps.setString(4, r.getDepartment());
                    ps.setTime(5, r.getCheckIn() != null ? Time.valueOf(r.getCheckIn()) : null);
                    ps.setTime(6, r.getCheckOut() != null ? Time.valueOf(r.getCheckOut()) : null);
                    ps.setLong(7, r.getLateMinutes());
                    ps.addBatch();
                }
                ps.executeBatch();
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
}

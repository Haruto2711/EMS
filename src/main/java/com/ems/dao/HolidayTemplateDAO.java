package com.ems.dao;

import com.ems.model.HolidayTemplate;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HolidayTemplateDAO {

    public static List<HolidayTemplate> getAllActiveTemplates() {
        List<HolidayTemplate> holidayTemplates = new ArrayList<>();
        String sql = "select Id, HolidayName, RecurType, FixedMonth, FixedDay, " +
                "FixedDurationDays, DefaultCoefficient, IsCoefficientLocked, " +
                "IsActive, CreatedBy " +
                "from holidaytemplates where IsActive = 1 Order by Id";
        try(Connection con = DBConnection.getConnection();
            PreparedStatement stm = con.prepareStatement(sql);
            ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                HolidayTemplate holidayTemplate = new HolidayTemplate();
                holidayTemplate.setId(rs.getInt("Id"));
                holidayTemplate.setHolidayName(rs.getString("HolidayName"));
                holidayTemplate.setRecurType(rs.getString("RecurType"));
                holidayTemplate.setFixedMonth((Integer) rs.getObject("FixedMonth"));
                holidayTemplate.setFixedDay((Integer) rs.getObject("FixedDay"));
                holidayTemplate.setFixedDurationDays(rs.getInt("FixedDurationDays"));
                holidayTemplate.setDefaultCoefficient(rs.getDouble("DefaultCoefficient"));
                holidayTemplate.setCoefficientLocked(rs.getBoolean("IsCoefficientLocked"));
                holidayTemplate.setActive(rs.getBoolean("IsActive"));
                holidayTemplate.setCreatedBy((Integer) rs.getObject("CreatedBy"));
                holidayTemplates.add(holidayTemplate);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return holidayTemplates;
    }

    public static void insertHolidayTemplate(HolidayTemplate t) {
        String sql = "insert into holidaytemplates " +
                "(HolidayName, RecurType, FixedMonth, FixedDay, FixedDurationDays, DefaultCoefficient, IsCoefficientLocked, CreatedBy) " +
                "values (?, ?, ?, ?, ?, ?, ?, ?)";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, t.getHolidayName());
            stm.setString(2, t.getRecurType());
            stm.setObject(3, t.getFixedMonth());
            stm.setObject(4, t.getFixedDay());
            stm.setInt(5, t.getFixedDurationDays() == null ? 1 : t.getFixedDurationDays());
            stm.setDouble(6, t.getDefaultCoefficient() == null ? 1.0 : t.getDefaultCoefficient());
            stm.setBoolean(7, Boolean.TRUE.equals(t.getCoefficientLocked()));
            stm.setObject(8, t.getCreatedBy());
            stm.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void updateHolidayTemplate(int id , double coefficient, boolean locked) {
        String sql = "update holidaytemplates  set DefaultCoefficient = ?, IsCoefficientLocked = ? where Id = ?";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setDouble(1, coefficient);
            stm.setBoolean(2, locked);
            stm.setInt(3, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

}

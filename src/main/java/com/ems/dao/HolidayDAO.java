package com.ems.dao;

import com.ems.model.Holidays;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class HolidayDAO {

    public static void insertHoliday(Holidays h) {
        String sql = "Insert into holidays (HolidayName, StartDate, EndDate, CreatedBy) values (?, ?, ?, ?)";
        try(Connection conn = DBConnection.getConnection();
        PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, h.getHolidayname());
            stm.setObject(2, h.getStartdate());
            stm.setObject(3, h.getEnddate());
            stm.setObject(4, h.getCreatedby());
            stm.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static List<Holidays> getAllHolidays(){
        List<Holidays> holidays = new ArrayList<>();
        String sql = "select Id, HolidayName, StartDate, EndDate from holidays";
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement stm = conn.prepareStatement(sql);
            ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                Holidays h = new Holidays();
                h.setId(rs.getInt("Id"));
                h.setHolidayname(rs.getString("HolidayName"));
                h.setStartdate(rs.getObject("StartDate", LocalDate.class));
                h.setEnddate(rs.getObject("EndDate", LocalDate.class));
                holidays.add(h);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return holidays;
    }
}

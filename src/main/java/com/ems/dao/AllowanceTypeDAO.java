package com.ems.dao;

import com.ems.model.Allowancetypes;
import com.ems.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AllowanceTypeDAO {
    private Allowancetypes mapResultSet(ResultSet rs) throws SQLException {
        Allowancetypes item = new Allowancetypes();
        item.setId(rs.getInt("Id"));
        item.setCode(rs.getString("Code"));
        item.setName(rs.getString("Name"));
        item.setType(rs.getString("Type"));
        item.setCalculationmethod(rs.getString("CalculationMethod"));
        item.setDefaultamount(rs.getBigDecimal("DefaultAmount"));
        item.setIstaxable(rs.getBoolean("IsTaxable"));
        item.setTaxexemptlimit(rs.getBigDecimal("TaxExemptLimit"));
        item.setIsinsurancesalary(rs.getBoolean("IsInsuranceSalary"));
        item.setIsactive(rs.getBoolean("IsActive"));
        return item;
    }

    public List<Allowancetypes> getAllAllowanceTypes() {
        List<Allowancetypes> list = new ArrayList<>();
        String sql = "SELECT * FROM allowancetypes WHERE 1=1";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Allowancetypes getById(int id) {
        String sql = "SELECT * FROM allowancetypes WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Allowancetypes getByCode(String code) {
        String sql = "SELECT * FROM allowancetypes WHERE Code = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Allowancetypes> getAllActive() {
        List<Allowancetypes> list = new ArrayList<>();
        String sql = "SELECT * FROM allowancetypes WHERE IsActive = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Allowancetypes item) {
        String sql = "INSERT INTO allowancetypes (Code, Name, Type, CalculationMethod, DefaultAmount, IsTaxable, TaxExemptLimit, IsInsuranceSalary, IsActive) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, item.getCode());
            ps.setString(2, item.getName());
            ps.setString(3, item.getType() != null ? item.getType() : "Allowance");
            ps.setString(4, item.getCalculationmethod() != null ? item.getCalculationmethod() : "Fixed");
            ps.setBigDecimal(5, item.getDefaultamount() != null ? item.getDefaultamount() : BigDecimal.ZERO);
            ps.setBoolean(6, item.getIstaxable() != null ? item.getIstaxable() : true);
            ps.setBigDecimal(7, item.getTaxexemptlimit() != null ? item.getTaxexemptlimit() : BigDecimal.ZERO);
            ps.setBoolean(8, item.getIsinsurancesalary() != null ? item.getIsinsurancesalary() : false);
            ps.setBoolean(9, item.getIsactive() != null ? item.getIsactive() : true);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next())
                        item.setId(generatedKeys.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Allowancetypes item) {
        String sql = "UPDATE allowancetypes SET Name = ?, Type = ?, CalculationMethod = ?, DefaultAmount = ?, "
                + "IsTaxable = ?, TaxExemptLimit = ?, IsInsuranceSalary = ?, IsActive = ? WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getType());
            ps.setString(3, item.getCalculationmethod());
            ps.setBigDecimal(4, item.getDefaultamount());
            ps.setBoolean(5, item.getIstaxable());
            ps.setBigDecimal(6, item.getTaxexemptlimit());
            ps.setBoolean(7, item.getIsinsurancesalary());
            ps.setBoolean(8, item.getIsactive());
            ps.setInt(9, item.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleStatus(int id) {
        String sql = "UPDATE allowancetypes SET IsActive = NOT IsActive WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

package com.ems.dao;

import com.ems.dto.AllowanceDetailDTO;
import com.ems.dto.ManagerPayslipDTO;
import com.ems.dto.PayslipDTO;
import com.ems.model.Timesheetperiods;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PayslipDAO {
    public List<PayslipDTO> getPayslipsByPeriodForView(int periodId, String search, Integer departmentId) {
        List<PayslipDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT p.Id, p.PeriodId, p.StandardWorkDays, p.ActualWorkDays, " +
                "p.BaseSalary, p.ActualBaseSalary, p.OtHours, p.OtSalary, p.BonusAmount, " +
                "p.DependentsCount, p.DependentDeduction, p.TaxableIncome, p.PenaltyAmount, p.AdvanceAmount, " +
                "(COALESCE(p.PenaltyAmount, 0) + COALESCE(p.AdvanceAmount, 0) + COALESCE(p.OtherDeductions, 0)) AS OtherDeductions, " +
                "p.GrossAmount, p.TotalInsuranceDeduction, p.BhxhAmount, p.BhytAmount, p.BhtnAmount, p.TaxDeduction, p.NetAmount, p.Status, " +
                "u.EmployeeCode, u.FullName, d.Name AS DepartmentName, pos.Name AS PositionName " +
                "FROM payslips p " +
                "JOIN users u ON p.UserId = u.Id " +
                "LEFT JOIN departments d ON u.DepartmentId = d.Id " +
                "LEFT JOIN positions pos ON u.PositionId = pos.Id " +
                "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (periodId > 0) {
            sql.append("AND p.PeriodId = ? ");
            params.add(periodId);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(u.FullName) LIKE ? OR LOWER(u.EmployeeCode) LIKE ?) ");
            String likeSearch = "%" + search.trim().toLowerCase() + "%";
            params.add(likeSearch);
            params.add(likeSearch);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append("AND u.DepartmentId = ? ");
            params.add(departmentId);
        }

        sql.append("ORDER BY p.Id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PayslipDTO dto = new PayslipDTO();
                    dto.setId(rs.getInt("Id"));
                    dto.setPeriodId(rs.getInt("PeriodId"));
                    dto.setStatus(rs.getString("Status"));

                    dto.setEmployeeCode(rs.getString("EmployeeCode"));
                    dto.setFullName(rs.getString("FullName"));
                    dto.setDepartmentName(rs.getString("DepartmentName"));
                    dto.setPositionName(rs.getString("PositionName"));

                    dto.setStandardWorkDays(rs.getInt("StandardWorkDays"));
                    dto.setActualWorkDays(rs.getBigDecimal("ActualWorkDays"));
                    dto.setBaseSalary(rs.getBigDecimal("BaseSalary"));
                    dto.setActualBaseSalary(rs.getBigDecimal("ActualBaseSalary"));
                    dto.setOtHours(rs.getBigDecimal("OtHours"));
                    dto.setOtSalary(rs.getBigDecimal("OtSalary"));
                    dto.setBonusAmount(rs.getBigDecimal("BonusAmount"));
                    dto.setDependentsCount(rs.getInt("DependentsCount"));
                    dto.setDependentDeduction(rs.getBigDecimal("DependentDeduction"));
                    dto.setTaxableIncome(rs.getBigDecimal("TaxableIncome"));
                    dto.setPenaltyAmount(rs.getBigDecimal("PenaltyAmount"));
                    dto.setAdvanceAmount(rs.getBigDecimal("AdvanceAmount"));
                    dto.setOtherDeductions(rs.getBigDecimal("OtherDeductions"));
                    dto.setGrossAmount(rs.getBigDecimal("GrossAmount"));
                    dto.setTotalInsurance(rs.getBigDecimal("TotalInsuranceDeduction"));
                    dto.setBhxh(rs.getBigDecimal("BhxhAmount"));
                    dto.setBhyt(rs.getBigDecimal("BhytAmount"));
                    dto.setBhtn(rs.getBigDecimal("BhtnAmount"));
                    dto.setTaxDeduction(rs.getBigDecimal("TaxDeduction"));
                    dto.setNetAmount(rs.getBigDecimal("NetAmount"));

                    dto.setAllowanceDetails(getAllowanceDetailsByPayslipId(dto.getId()));

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<AllowanceDetailDTO> getAllowanceDetailsByPayslipId(int payslipId) {
        List<AllowanceDetailDTO> details = new ArrayList<>();
        String sql = "SELECT a.Name, pa.Amount " +
                "FROM payslip_allowances pa " +
                "JOIN allowancetypes a ON pa.AllowanceTypeId = a.Id " +
                "WHERE pa.PayslipId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, payslipId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    details.add(new AllowanceDetailDTO(
                            rs.getString("Name"),
                            rs.getBigDecimal("Amount")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public List<Timesheetperiods> getAllTimesheetPeriods() {
        List<Timesheetperiods> list = new ArrayList<>();
        String sql = "SELECT * FROM timesheetperiods ORDER BY StartDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Timesheetperiods item = new Timesheetperiods();
                item.setId(rs.getInt("Id"));
                item.setName(rs.getString("Name"));
                if (rs.getDate("StartDate") != null) {
                    item.setStartdate(rs.getDate("StartDate").toLocalDate());
                }
                if (rs.getDate("EndDate") != null) {
                    item.setEnddate(rs.getDate("EndDate").toLocalDate());
                }
                item.setIslocked(rs.getBoolean("IsLocked"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ManagerPayslipDTO> getPayslipsByPeriod(Integer periodId, String search, Integer departmentId) {
        List<ManagerPayslipDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.Id, p.UserId, u.EmployeeCode, u.FullName, d.Name AS DepartmentName, pos.Name AS PositionName, " +
            "t.Id AS PeriodId, t.Name AS PeriodName, " +
            "p.BaseSalary, p.OtSalary, p.TotalAllowanceAmount, p.TotalInsuranceDeduction, " +
            "p.DependentDeduction, p.TaxDeduction, " +
            "(COALESCE(p.PenaltyAmount, 0) + COALESCE(p.AdvanceAmount, 0) + COALESCE(p.OtherDeductions, 0)) AS OtherDeductions, " +
            "p.GrossAmount, p.NetAmount, p.Status, p.Note, p.CreatedAt " +
            "FROM payslips p " +
            "JOIN users u ON p.UserId = u.Id " +
            "LEFT JOIN departments d ON u.DepartmentId = d.Id " +
            "LEFT JOIN positions pos ON u.PositionId = pos.Id " +
            "LEFT JOIN timesheetperiods t ON p.PeriodId = t.Id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (periodId != null && periodId > 0) {
            sql.append("AND p.PeriodId = ? ");
            params.add(periodId);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(u.FullName) LIKE ? OR LOWER(u.EmployeeCode) LIKE ?) ");
            String likeSearch = "%" + search.trim().toLowerCase() + "%";
            params.add(likeSearch);
            params.add(likeSearch);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append("AND u.DepartmentId = ? ");
            params.add(departmentId);
        }

        sql.append("ORDER BY u.EmployeeCode ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ManagerPayslipDTO dto = new ManagerPayslipDTO();
                    dto.setId(rs.getInt("Id"));
                    dto.setUserId(rs.getInt("UserId"));
                    dto.setEmployeeCode(rs.getString("EmployeeCode"));
                    dto.setFullName(rs.getString("FullName"));
                    dto.setDepartmentName(rs.getString("DepartmentName"));
                    dto.setPositionName(rs.getString("PositionName"));
                    
                    dto.setPeriodId(rs.getInt("PeriodId"));
                    dto.setPeriodName(rs.getString("PeriodName"));
                    
                    dto.setBaseSalary(rs.getBigDecimal("BaseSalary"));
                    dto.setOtSalary(rs.getBigDecimal("OtSalary"));
                    dto.setAllowances(rs.getBigDecimal("TotalAllowanceAmount"));
                    dto.setInsuranceDeduction(rs.getBigDecimal("TotalInsuranceDeduction"));
                    dto.setDependentDeduction(rs.getBigDecimal("DependentDeduction"));
                    dto.setTaxDeduction(rs.getBigDecimal("TaxDeduction"));
                    dto.setOtherDeductions(rs.getBigDecimal("OtherDeductions"));
                    dto.setGrossAmount(rs.getBigDecimal("GrossAmount"));
                    dto.setNetAmount(rs.getBigDecimal("NetAmount"));
                    dto.setStatus(rs.getString("Status"));
                    dto.setNote(rs.getString("Note"));
                    
                    if (rs.getTimestamp("CreatedAt") != null) {
                        dto.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    }

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
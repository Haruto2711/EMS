package com.ems.dao;

import com.ems.dto.ManagerPayslipDTO;
import com.ems.model.Timesheetperiods;
import com.ems.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PayslipDAO {

    public List<Timesheetperiods> getAllTimesheetPeriods() {
        ensureSampleDataExists();
        List<Timesheetperiods> periods = new ArrayList<>();
        String sql = "SELECT Id, Name, StartDate, EndDate, IsLocked FROM timesheetperiods ORDER BY StartDate DESC, Id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Timesheetperiods period = new Timesheetperiods();
                period.setId(rs.getInt("Id"));
                period.setName(rs.getString("Name"));
                Date start = rs.getDate("StartDate");
                if (start != null) period.setStartdate(start.toLocalDate());
                Date end = rs.getDate("EndDate");
                if (end != null) period.setEnddate(end.toLocalDate());
                period.setIslocked(rs.getBoolean("IsLocked"));
                periods.add(period);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return periods;
    }

    public List<ManagerPayslipDTO> getPayslipsByPeriod(Integer periodId, String search, Integer departmentId) {
        ensureSampleDataExists();
        List<ManagerPayslipDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.Id AS PayslipId, p.BaseSalary, p.OtSalary, p.TotalAllowanceAmount, ")
           .append("p.TotalInsuranceDeduction, p.DependentDeduction, p.TaxDeduction, p.OtherDeductions, ")
           .append("p.GrossAmount, p.NetAmount, p.Status, p.Note, p.CreatedAt, ")
           .append("u.Id AS UserId, u.EmployeeCode, u.FullName, ")
           .append("d.Name AS DepartmentName, pos.Name AS PositionName, ")
           .append("tp.Id AS PeriodId, tp.Name AS PeriodName ")
           .append("FROM payslips p ")
           .append("JOIN users u ON p.UserId = u.Id ")
           .append("LEFT JOIN departments d ON u.DepartmentId = d.Id ")
           .append("LEFT JOIN positions pos ON u.PositionId = pos.Id ")
           .append("JOIN timesheetperiods tp ON p.PeriodId = tp.Id ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (periodId != null && periodId > 0) {
            sql.append("AND p.PeriodId = ? ");
            params.add(periodId);
        }

        if (departmentId != null && departmentId > 0) {
            sql.append("AND u.DepartmentId = ? ");
            params.add(departmentId);
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.FullName LIKE ? OR u.EmployeeCode LIKE ?) ");
            String keyword = "%" + search.trim() + "%";
            params.add(keyword);
            params.add(keyword);
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
                    dto.setId(rs.getInt("PayslipId"));
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
                    Timestamp ts = rs.getTimestamp("CreatedAt");
                    if (ts != null) dto.setCreatedAt(ts.toLocalDateTime());

                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Seeds initial timesheet periods & calculated payslips if DB has users but no payslips.
     */
    private synchronized void ensureSampleDataExists() {
        String checkPeriodsSql = "SELECT COUNT(*) FROM timesheetperiods";
        String checkPayslipsSql = "SELECT COUNT(*) FROM payslips";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            ResultSet rs1 = stmt.executeQuery(checkPeriodsSql);
            int periodCount = 0;
            if (rs1.next()) periodCount = rs1.getInt(1);

            if (periodCount == 0) {
                // Insert 2 sample periods
                String insertPeriod = "INSERT INTO timesheetperiods (Name, StartDate, EndDate, IsLocked) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertPeriod, Statement.RETURN_GENERATED_KEYS)) {
                    // Period 1: August 2026
                    ps.setString(1, "Kỳ lương Tháng 08/2026");
                    ps.setDate(2, Date.valueOf(LocalDate.of(2026, 8, 1)));
                    ps.setDate(3, Date.valueOf(LocalDate.of(2026, 8, 31)));
                    ps.setBoolean(4, false);
                    ps.executeUpdate();

                    // Period 2: July 2026
                    ps.setString(1, "Kỳ lương Tháng 07/2026");
                    ps.setDate(2, Date.valueOf(LocalDate.of(2026, 7, 1)));
                    ps.setDate(3, Date.valueOf(LocalDate.of(2026, 7, 31)));
                    ps.setBoolean(4, true);
                    ps.executeUpdate();
                }
            }

            ResultSet rs2 = stmt.executeQuery(checkPayslipsSql);
            int payslipCount = 0;
            if (rs2.next()) payslipCount = rs2.getInt(1);

            if (payslipCount == 0) {
                // Fetch periods
                List<Integer> periodIds = new ArrayList<>();
                ResultSet rsP = stmt.executeQuery("SELECT Id FROM timesheetperiods ORDER BY Id ASC");
                while (rsP.next()) periodIds.add(rsP.getInt(1));

                // Fetch users with their base salary & dependents
                String userSalarySql = "SELECT u.Id, u.DependentsCount, COALESCE(ebs.BaseSalary, 15000000) AS BaseSalary " +
                                       "FROM users u LEFT JOIN employmentbasesalarys ebs ON u.Id = ebs.UserId";
                ResultSet rsU = stmt.executeQuery(userSalarySql);

                List<Object[]> userSalaries = new ArrayList<>();
                while (rsU.next()) {
                    int userId = rsU.getInt("Id");
                    int npt = rsU.getInt("DependentsCount");
                    BigDecimal baseSalary = rsU.getBigDecimal("BaseSalary");
                    userSalaries.add(new Object[]{userId, npt, baseSalary});
                }

                if (!periodIds.isEmpty() && !userSalaries.isEmpty()) {
                    String insertPayslip = "INSERT INTO payslips (BaseSalary, OtSalary, TotalAllowanceAmount, TotalInsuranceDeduction, " +
                            "DependentDeduction, TaxDeduction, OtherDeductions, GrossAmount, NetAmount, Status, Note, UserId, PeriodId, DependentsCount) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement ps = conn.prepareStatement(insertPayslip)) {
                        for (Integer pid : periodIds) {
                            for (Object[] uData : userSalaries) {
                                int uid = (Integer) uData[0];
                                int npt = (Integer) uData[1];
                                BigDecimal baseSal = (BigDecimal) uData[2];

                                // Mock realistic calculations
                                BigDecimal otSal = new BigDecimal(Math.round(Math.random() * 20) * 100000); // 0 -> 2M
                                BigDecimal allow = new BigDecimal("1000000.00");
                                BigDecimal gross = baseSal.add(otSal).add(allow);

                                // Insurance: 10.5% of base salary
                                BigDecimal ins = baseSal.multiply(new BigDecimal("0.105")).setScale(2, RoundingMode.HALF_UP);
                                // Dependent deduction: 4.4M per dependent
                                BigDecimal depDed = new BigDecimal(npt * 4400000L);
                                // Tax: simple estimate ~ 5% of taxable
                                BigDecimal taxable = gross.subtract(ins).subtract(new BigDecimal("11000000")).subtract(depDed);
                                BigDecimal tax = BigDecimal.ZERO;
                                if (taxable.compareTo(BigDecimal.ZERO) > 0) {
                                    tax = taxable.multiply(new BigDecimal("0.05")).setScale(2, RoundingMode.HALF_UP);
                                }
                                BigDecimal otherDed = BigDecimal.ZERO;
                                BigDecimal net = gross.subtract(ins).subtract(tax).subtract(otherDed);

                                ps.setBigDecimal(1, baseSal);
                                ps.setBigDecimal(2, otSal);
                                ps.setBigDecimal(3, allow);
                                ps.setBigDecimal(4, ins);
                                ps.setBigDecimal(5, depDed);
                                ps.setBigDecimal(6, tax);
                                ps.setBigDecimal(7, otherDed);
                                ps.setBigDecimal(8, gross);
                                ps.setBigDecimal(9, net);
                                ps.setString(10, pid.equals(periodIds.get(0)) ? "Approved" : "Paid");
                                ps.setString(11, "Đã tính toán tự động");
                                ps.setInt(12, uid);
                                ps.setInt(13, pid);
                                ps.setInt(14, npt);
                                ps.addBatch();
                            }
                        }
                        ps.executeBatch();
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

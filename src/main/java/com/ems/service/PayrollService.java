package com.ems.service;

import com.ems.model.*;
// Import các DAO tương ứng (Bạn tự tạo các file DAO này nếu chưa có, hoặc tôi sẽ viết ở bước sau)
import com.ems.dao.PayrollconfigsDAO;
import com.ems.dao.AllowanceTypeDAO;
import com.ems.dao.UserDAO;
import com.ems.dao.BaseSalaryDAO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

public class PayrollService {

    private PayrollconfigsDAO configDAO = new PayrollconfigsDAO();
    private AllowanceTypeDAO allowanceDAO = new AllowanceTypeDAO();
    private UserDAO userDAO = new UserDAO(); // Chứa thông tin số người phụ thuộc
    private BaseSalaryDAO salaryDAO = new BaseSalaryDAO(); // Chứa lương cơ bản

    /**
     * HÀM CHÍNH: Tính toán ra 1 tờ Phiếu Lương (Payslips) hoàn chỉnh cho 1 nhân viên
     * Lưu ý: Hàm này chỉ TÍNH TOÁN trên RAM (chưa lưu xuống DB)
     */
    public Payslips calculatePayslip(int userId, int periodId, BigDecimal actualWorkDays, BigDecimal otHours, BigDecimal bonus, BigDecimal penalty, BigDecimal advance) {

        // 1. Lấy dữ liệu cấu hình ĐANG ÁP DỤNG
        Payrollconfigs config = configDAO.getActiveConfig();
        if (config == null) throw new RuntimeException("Lỗi: Chưa có Cấu hình lương nào được kích hoạt!");

        // 2. Lấy thông tin nhân viên & Lương cơ bản
        Users user = userDAO.getById(userId);
        Employmentbasesalarys baseSalaryInfo = salaryDAO.getByUserId(userId);
        BigDecimal baseSalary = baseSalaryInfo != null ? baseSalaryInfo.getBasesalary() : BigDecimal.ZERO;

        // Khởi tạo Phiếu lương
        Payslips payslip = new Payslips();
        payslip.setUserid(userId);
        payslip.setPeriodid(periodId);
        payslip.setStandardworkdays(config.getStandardworkingdays());
        payslip.setActualworkdays(actualWorkDays);
        payslip.setOthours(otHours);
        payslip.setBasesalary(baseSalary);
        payslip.setBonusamount(bonus != null ? bonus : BigDecimal.ZERO);
        payslip.setPenaltyamount(penalty != null ? penalty : BigDecimal.ZERO);
        payslip.setAdvanceamount(advance != null ? advance : BigDecimal.ZERO);

        // --- BƯỚC 1: TÍNH LƯONG THỰC TẾ ---
        BigDecimal actualBaseSalary = baseSalary
                .multiply(actualWorkDays)
                .divide(new BigDecimal(config.getStandardworkingdays()), 2, RoundingMode.HALF_UP);
        payslip.setActualbasesalary(actualBaseSalary);

        // --- BƯỚC 2: TÍNH TIỀN OT (Giả sử OT tính theo ngày thường) ---
        // Tiền 1 giờ = (Lương cơ bản / Ngày chuẩn / 8 tiếng)
        BigDecimal hourlyRate = baseSalary
                .divide(new BigDecimal(config.getStandardworkingdays()), 2, RoundingMode.HALF_UP)
                .divide(new BigDecimal("8"), 2, RoundingMode.HALF_UP);
        BigDecimal otSalary = hourlyRate.multiply(otHours).multiply(config.getOtweekdayrate());
        payslip.setOtsalary(otSalary);

        // --- BƯỚC 3: TÍNH PHỤ CẤP ---
        List<Allowancetypes> allowances = allowanceDAO.getAllActive(); // Lấy các phụ cấp đang bật
        BigDecimal totalAllowance = BigDecimal.ZERO;
        BigDecimal totalTaxExemptAllowance = BigDecimal.ZERO; // Phụ cấp miễn thuế
        BigDecimal totalInsuranceAllowance = BigDecimal.ZERO; // Phụ cấp đóng BH

        for (Allowancetypes alw : allowances) {
            BigDecimal amt = alw.getDefaultamount(); // Tạm tính theo Fixed
            if ("ByWorkDay".equals(alw.getCalculationmethod())) {
                amt = amt.multiply(actualWorkDays).divide(new BigDecimal(config.getStandardworkingdays()), 2, RoundingMode.HALF_UP);
            }
            totalAllowance = totalAllowance.add(amt);

            // Kiểm tra miễn thuế TNCN
            if (!alw.getIstaxable()) {
                totalTaxExemptAllowance = totalTaxExemptAllowance.add(amt);
            } else if (alw.getTaxexemptlimit().compareTo(BigDecimal.ZERO) > 0) {
                // Có hạn mức miễn thuế (Ví dụ: Miễn 730k ăn trưa)
                BigDecimal exemptAmt = amt.min(alw.getTaxexemptlimit());
                totalTaxExemptAllowance = totalTaxExemptAllowance.add(exemptAmt);
            }

            // Kiểm tra đóng BHXH
            if (alw.getIsinsurancesalary()) {
                totalInsuranceAllowance = totalInsuranceAllowance.add(amt);
            }
        }
        payslip.setTotalallowanceamount(totalAllowance);

        // --- BƯỚC 4: TÍNH TỔNG THU NHẬP (GROSS) ---
        BigDecimal grossAmount = actualBaseSalary.add(otSalary).add(totalAllowance).add(payslip.getBonusamount());
        payslip.setGrossamount(grossAmount);

        // --- BƯỚC 5: TÍNH BẢO HIỂM ---
        // Nền đóng bảo hiểm (bị giới hạn bởi MaxInsuranceSalary)
        BigDecimal insuranceBase = baseSalary.add(totalInsuranceAllowance);
        if (insuranceBase.compareTo(config.getMaxinsurancesalary()) > 0) {
            insuranceBase = config.getMaxinsurancesalary();
        }

        BigDecimal bhxh = insuranceBase.multiply(config.getBhxhpercent()).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        BigDecimal bhyt = insuranceBase.multiply(config.getBhytpercent()).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        BigDecimal bhtn = insuranceBase.multiply(config.getBhtnpercent()).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        BigDecimal totalInsurance = bhxh.add(bhyt).add(bhtn);

        payslip.setBhxhamount(bhxh);
        payslip.setBhytamount(bhyt);
        payslip.setBhtnamount(bhtn);
        payslip.setTotalinsurancededuction(totalInsurance);

        // --- BƯỚC 6: TÍNH THUẾ TNCN (Bậc Thang) ---
        payslip.setDependentscount(user.getDependentscount());
        BigDecimal dependentDeduction = config.getDependenttaxdeduction().multiply(new BigDecimal(user.getDependentscount()));
        payslip.setDependentdeduction(dependentDeduction);

        // Thu nhập tính thuế = Gross - Phụ cấp miễn thuế - Bảo hiểm - Giảm trừ bản thân - Giảm trừ NPT
        BigDecimal assessableIncome = grossAmount
                .subtract(totalTaxExemptAllowance)
                .subtract(totalInsurance)
                .subtract(config.getPersonaltaxdeduction())
                .subtract(dependentDeduction);

        if (assessableIncome.compareTo(BigDecimal.ZERO) < 0) {
            assessableIncome = BigDecimal.ZERO;
        }
        payslip.setTaxableincome(assessableIncome);
        payslip.setTaxdeduction(calculatePIT(assessableIncome)); // Gọi hàm tính thuế 7 bậc

        // --- BƯỚC 7: TÍNH THỰC LĨNH (NET) ---
        BigDecimal netAmount = grossAmount
                .subtract(totalInsurance)
                .subtract(payslip.getTaxdeduction())
                .subtract(payslip.getPenaltyamount())
                .subtract(payslip.getAdvanceamount());

        payslip.setNetamount(netAmount);
        payslip.setStatus("Draft");

        return payslip;
    }

    /**
     * HÀM HELPER: Tính Thuế TNCN theo 7 Bậc lũy tiến của Việt Nam
     * Công thức rút gọn (triệu VNĐ):
     * Bậc 1: <= 5tr      (TN x 5%)
     * Bậc 2: 5 - 10tr    (TN x 10% - 0.25tr)
     * Bậc 3: 10 - 18tr   (TN x 15% - 0.75tr)
     * Bậc 4: 18 - 32tr   (TN x 20% - 1.65tr)
     * Bậc 5: 32 - 52tr   (TN x 25% - 3.25tr)
     * Bậc 6: 52 - 80tr   (TN x 30% - 5.85tr)
     * Bậc 7: > 80tr      (TN x 35% - 9.85tr)
     */
    private BigDecimal calculatePIT(BigDecimal assessableIncome) {
        double income = assessableIncome.doubleValue();
        double tax = 0;

        if (income <= 0) return BigDecimal.ZERO;

        if (income <= 5000000) {
            tax = income * 0.05;
        } else if (income <= 10000000) {
            tax = income * 0.10 - 250000;
        } else if (income <= 18000000) {
            tax = income * 0.15 - 750000;
        } else if (income <= 32000000) {
            tax = income * 0.20 - 1650000;
        } else if (income <= 52000000) {
            tax = income * 0.25 - 3250000;
        } else if (income <= 80000000) {
            tax = income * 0.30 - 5850000;
        } else {
            tax = income * 0.35 - 9850000;
        }

        return BigDecimal.valueOf(tax).setScale(2, RoundingMode.HALF_UP);
    }
}
package com.ems.service;

import com.ems.model.*;

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
    private UserDAO userDAO = new UserDAO();
    private BaseSalaryDAO salaryDAO = new BaseSalaryDAO();

    public Payslips calculatePayslip(int userId, int periodId, BigDecimal actualWorkDays, BigDecimal otHours, BigDecimal bonus, BigDecimal penalty, BigDecimal advance){
        Payrollconfigs config = configDAO.getActiveConfig();
        if (config == null) throw new RuntimeException("Error: Chưa có Cấu hình lương nào được kích hoạt!");
    }

    //Phieu luong
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

}

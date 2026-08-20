package com.ems.controller;

import com.ems.dao.PayslipDAO;
import com.ems.dto.PayslipDTO;
import com.ems.model.Departments;
import com.ems.model.Timesheetperiods;
import com.ems.model.Users;
import com.ems.service.PayrollService;
import com.ems.service.PayslipService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

@WebServlet("/payslips")
public class PayslipServlet extends HttpServlet {

    private PayslipDAO payslipDAO;
    private PayslipService payslipService;

    @Override
    public void init() throws ServletException {
        payslipDAO = new PayslipDAO();
        payslipService = new PayslipService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String periodIdParam = request.getParameter("periodId");
        String searchParam = request.getParameter("search");
        String deptIdParam = request.getParameter("departmentId");

        int periodId = 0;
        if (periodIdParam != null && !periodIdParam.isEmpty()) {
            try { periodId = Integer.parseInt(periodIdParam); } catch (NumberFormatException e) { }
        }

        Integer departmentId = null;
        if (deptIdParam != null && !deptIdParam.isEmpty()) {
            try { departmentId = Integer.parseInt(deptIdParam); } catch (NumberFormatException e) {}
        }
        
        String searchStr = (searchParam != null) ? searchParam.trim() : "";

        // Get periods and default to latest if none requested
        List<Timesheetperiods> periods = payslipService.getAllTimesheetPeriods();
        if (periodId == 0 && !periods.isEmpty()) {
            periodId = periods.get(0).getId();
        }

        List<PayslipDTO> payslips = payslipDAO.getPayslipsByPeriodForView(periodId, searchStr, departmentId);
        List<Departments> departments = payslipService.getAllDepartments();

        // Calculate stats
        int totalEmployees = payslips.size();
        BigDecimal totalGross = BigDecimal.ZERO;
        BigDecimal totalNet = BigDecimal.ZERO;
        BigDecimal totalDeductions = BigDecimal.ZERO;

        for (PayslipDTO p : payslips) {
            if (p.getGrossAmount() != null) totalGross = totalGross.add(p.getGrossAmount());
            if (p.getNetAmount() != null) totalNet = totalNet.add(p.getNetAmount());
            if (p.getTotalInsurance() != null) totalDeductions = totalDeductions.add(p.getTotalInsurance());
            if (p.getTaxDeduction() != null) totalDeductions = totalDeductions.add(p.getTaxDeduction());
        }

        DecimalFormat decimalFormat = new DecimalFormat("#,###");

        request.setAttribute("payslips", payslips);
        request.setAttribute("periods", periods);
        request.setAttribute("departments", departments);
        request.setAttribute("selectedPeriodId", periodId);
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("search", searchStr);
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("formattedTotalGross", decimalFormat.format(totalGross).replace(',', '.'));
        request.setAttribute("formattedTotalNet", decimalFormat.format(totalNet).replace(',', '.'));
        request.setAttribute("formattedTotalDeductions", decimalFormat.format(totalDeductions).replace(',', '.'));

        request.getRequestDispatcher("/payslip-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("generate".equals(action)){
            int periodId = Integer.parseInt(request.getParameter("periodId"));
            HttpSession session = request.getSession();
            Integer managerId = (Integer) session.getAttribute("accountId");

            if (managerId == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            PayrollService payrollService = new PayrollService();
            String result = payrollService.generatePayrollMonth(periodId, managerId);

            if (result.startsWith("SUCCESS")){
                String count = result.split(":")[1];
                request.getSession().setAttribute("msgSuccess", "Đã tính lương thành công cho " + count + " nhân viên!");

            }else {
                request.getSession().setAttribute("msgError", result);
            }

            response.sendRedirect(request.getContextPath() + "/payslips?periodId=" + periodId);
        }
    }
}

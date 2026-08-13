package com.ems.controller;

import com.ems.dto.ManagerPayslipDTO;
import com.ems.model.Departments;
import com.ems.model.Timesheetperiods;
import com.ems.service.PayslipService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

@WebServlet(name = "ManagerPayslipServlet", urlPatterns = {"/manager-payslips", "/manager-payslip"})
public class ManagerPayslipServlet extends HttpServlet {

    private final PayslipService payslipService = new PayslipService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<Timesheetperiods> periods = payslipService.getAllTimesheetPeriods();
        List<Departments> departments = payslipService.getAllDepartments();

        String periodIdParam = request.getParameter("periodId");
        String search = request.getParameter("search");
        String deptIdParam = request.getParameter("departmentId");

        Integer periodId = null;
        if (periodIdParam != null && !periodIdParam.trim().isEmpty()) {
            try {
                periodId = Integer.parseInt(periodIdParam);
            } catch (NumberFormatException ignored) {}
        }

        // Default to latest period if none selected
        if (periodId == null && periods != null && !periods.isEmpty()) {
            periodId = periods.get(0).getId();
        }

        Integer departmentId = null;
        if (deptIdParam != null && !deptIdParam.trim().isEmpty()) {
            try {
                departmentId = Integer.parseInt(deptIdParam);
            } catch (NumberFormatException ignored) {}
        }

        List<ManagerPayslipDTO> payslips = payslipService.getPayslipsByPeriod(periodId, search, departmentId);

        // Summary Calculations
        BigDecimal totalGross = BigDecimal.ZERO;
        BigDecimal totalNet = BigDecimal.ZERO;
        BigDecimal totalDeductions = BigDecimal.ZERO;

        for (ManagerPayslipDTO p : payslips) {
            if (p.getGrossAmount() != null) totalGross = totalGross.add(p.getGrossAmount());
            if (p.getNetAmount() != null) totalNet = totalNet.add(p.getNetAmount());
            totalDeductions = totalDeductions.add(p.getTotalDeductions());
        }

        DecimalFormat df = new DecimalFormat("#,###");

        request.setAttribute("periods", periods);
        request.setAttribute("departments", departments);
        request.setAttribute("payslips", payslips);
        request.setAttribute("selectedPeriodId", periodId);
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("search", search != null ? search : "");

        request.setAttribute("totalEmployees", payslips.size());
        request.setAttribute("formattedTotalGross", df.format(totalGross).replace(',', '.'));
        request.setAttribute("formattedTotalNet", df.format(totalNet).replace(',', '.'));
        request.setAttribute("formattedTotalDeductions", df.format(totalDeductions).replace(',', '.'));

        request.getRequestDispatcher("/manager-payslip-list.jsp").forward(request, response);
    }
}

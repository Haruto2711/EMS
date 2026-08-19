package com.ems.controller;

import com.ems.model.Allowancetypes;
import com.ems.service.AllowanceService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/allowances")
public class AllowanceServlet extends HttpServlet {
    private AllowanceService allowanceService;

    @Override
    public void init() throws ServletException {
        allowanceService = new AllowanceService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        
        List<Allowancetypes> allowances = allowanceService.getAllAllowances(keyword);
        
        // Filter by keyword since DAO only returns all
        if (keyword != null && !keyword.trim().isEmpty()) {
            String lowerKw = keyword.toLowerCase();
            allowances = allowances.stream()
                .filter(a -> (a.getCode() != null && a.getCode().toLowerCase().contains(lowerKw)) || 
                             (a.getName() != null && a.getName().toLowerCase().contains(lowerKw)))
                .collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("allowances", allowances);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/allowance-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/allowances");
            return;
        }

        try {
            switch (action) {
                case "toggle":
                    int idToToggle = Integer.parseInt(request.getParameter("id"));
                    allowanceService.toggleAllowanceStatus(idToToggle);
                    request.getSession().setAttribute("successMsg", "Đổi trạng thái thành công!");
                    break;

                case "add":
                    Allowancetypes newItem = extractAllowanceFromRequest(request);
                    String addResult = allowanceService.createAllowance(newItem);
                    if ("SUCCESS".equals(addResult)) {
                        request.getSession().setAttribute("successMsg", "Thêm mới phụ cấp thành công!");
                    } else {
                        request.getSession().setAttribute("errorMsg", addResult);
                    }
                    break;
                    
                case "edit":
                    Allowancetypes editItem = extractAllowanceFromRequest(request);
                    editItem.setId(Integer.parseInt(request.getParameter("id")));
                    String editResult = allowanceService.updateAllowance(editItem);
                    if ("SUCCESS".equals(editResult)) {
                        request.getSession().setAttribute("successMsg", "Cập nhật phụ cấp thành công!");
                    } else {
                        request.getSession().setAttribute("errorMsg", editResult);
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/allowances");
    }
    
    private Allowancetypes extractAllowanceFromRequest(HttpServletRequest request) {
        Allowancetypes item = new Allowancetypes();
        item.setCode(request.getParameter("code"));
        item.setName(request.getParameter("name"));
        item.setType(request.getParameter("type"));
        item.setCalculationmethod(request.getParameter("calculationmethod"));
        
        String defaultAmountStr = request.getParameter("defaultamount");
        if (defaultAmountStr != null && !defaultAmountStr.isEmpty()) {
            item.setDefaultamount(new BigDecimal(defaultAmountStr));
        } else {
            item.setDefaultamount(BigDecimal.ZERO);
        }
        
        String taxLimitStr = request.getParameter("taxexemptlimit");
        if (taxLimitStr != null && !taxLimitStr.isEmpty()) {
            item.setTaxexemptlimit(new BigDecimal(taxLimitStr));
        } else {
            item.setTaxexemptlimit(BigDecimal.ZERO);
        }
        
        item.setIstaxable(request.getParameter("istaxable") != null);
        item.setIsinsurancesalary(request.getParameter("isinsurancesalary") != null);
        item.setIsactive(request.getParameter("isactive") != null);
        
        return item;
    }
}

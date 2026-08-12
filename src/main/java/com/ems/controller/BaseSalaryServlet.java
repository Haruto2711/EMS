package com.ems.controller;

import com.ems.dto.BaseSalaryDTO;
import com.ems.dto.SalarySummaryDTO;
import com.ems.model.Departments;
import com.ems.model.Positions;
import com.ems.service.BaseSalaryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BaseSalaryServlet", urlPatterns = {"/base-salaries", "/base-salary"})
public class BaseSalaryServlet extends HttpServlet {

    private final BaseSalaryService baseSalaryService = new BaseSalaryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String search = request.getParameter("search");
        String deptIdParam = request.getParameter("departmentId");
        String posIdParam = request.getParameter("positionId");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        Integer departmentId = null;
        if (deptIdParam != null && !deptIdParam.trim().isEmpty()) {
            try {
                departmentId = Integer.parseInt(deptIdParam);
            } catch (NumberFormatException ignored) {
            }
        }

        Integer positionId = null;
        if (posIdParam != null && !posIdParam.trim().isEmpty()) {
            try {
                positionId = Integer.parseInt(posIdParam);
            } catch (NumberFormatException ignored) {
            }
        }

        List<BaseSalaryDTO> baseSalaries = baseSalaryService.getBaseSalaries(search, departmentId, positionId, sortBy, sortOrder);
        SalarySummaryDTO summary = baseSalaryService.getSalarySummary(search, departmentId, positionId);
        List<Departments> departments = baseSalaryService.getAllDepartments();
        List<Positions> positions = baseSalaryService.getAllPositions();

        request.setAttribute("baseSalaries", baseSalaries);
        request.setAttribute("summary", summary);
        request.setAttribute("departments", departments);
        request.setAttribute("positions", positions);

        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("selectedDepartmentId", departmentId);
        request.setAttribute("selectedPositionId", positionId);
        request.setAttribute("sortBy", sortBy != null ? sortBy : "code");
        request.setAttribute("sortOrder", sortOrder != null ? sortOrder : "ASC");

        request.getRequestDispatcher("/base-salary-list.jsp").forward(request, response);
    }
}

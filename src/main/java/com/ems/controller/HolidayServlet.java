package com.ems.controller;

import com.ems.dto.HolidayYearViewDTO;
import com.ems.model.HolidayTemplate;
import com.ems.service.HolidayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.Year;
import java.util.List;

@WebServlet(name = "HolidayServlet", urlPatterns = { "/holiday" })
public class HolidayServlet extends HttpServlet {

    private HolidayService holidayService;

    @Override
    public void init() {
        holidayService = new HolidayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int year = Year.now().getValue();
        try {
            year = Integer.parseInt(request.getParameter("year"));
        } catch (NumberFormatException ignored) { }

        List<HolidayYearViewDTO> holidays = holidayService.getHolidaysForYear(year);

        request.setAttribute("holidays", holidays);
        request.setAttribute("year", year);
        request.getRequestDispatcher("/holiday.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int year = Integer.parseInt(request.getParameter("year"));
        Integer accountId = (Integer) request.getSession().getAttribute("accountId");

        try {
            if ("saveDates".equals(action)) {
                int templateId = Integer.parseInt(request.getParameter("templateId"));
                holidayService.saveInstanceDates(
                        templateId, year,
                        request.getParameter("startDate"),
                        request.getParameter("endDate"),
                        accountId);
            } else if ("saveCoefficient".equals(action)) {
                int templateId = Integer.parseInt(request.getParameter("templateId"));
                double coefficient = Double.parseDouble(request.getParameter("coefficient"));
                boolean locked = "on".equals(request.getParameter("locked"));
                holidayService.saveCoefficient(templateId, year, coefficient, locked, accountId);
            } else if ("createTemplate".equals(action)) {
                HolidayTemplate t = new HolidayTemplate();
                t.setHolidayName(request.getParameter("name"));
                t.setRecurType(request.getParameter("recurType"));
                String month = request.getParameter("fixedMonth");
                String day = request.getParameter("fixedDay");
                if (month != null && !month.isBlank()) t.setFixedMonth(Integer.parseInt(month));
                if (day != null && !day.isBlank()) t.setFixedDay(Integer.parseInt(day));
                t.setFixedDurationDays(1);
                t.setDefaultCoefficient(1.0);
                t.setCoefficientLocked(false);
                t.setCreatedBy(accountId);
                holidayService.createTemplate(t);
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            request.setAttribute("errorMsg", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/holiday?year=" + year);
    }
}
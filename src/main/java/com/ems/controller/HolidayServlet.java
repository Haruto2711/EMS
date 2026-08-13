package com.ems.controller;

import com.ems.dto.HolidayDTO;
import com.ems.model.Holidays;
import com.ems.service.HoidayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HolidayServlet", urlPatterns = { "/holiday" })
public class HolidayServlet extends HttpServlet {

    private HoidayService holidayService;

    @Override
    public void init() {
        holidayService = new HoidayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Holidays> holidays = holidayService.getAllHolidays();
        request.setAttribute("holidays", holidays);
        request.getRequestDispatcher("/holiday.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String name      = request.getParameter("name");
            String startDate = request.getParameter("startDate");
            String endDate   = request.getParameter("endDate");

            if (name != null && !name.isBlank()
                    && startDate != null && !startDate.isBlank()
                    && endDate != null && !endDate.isBlank()) {
                try {
                    HolidayDTO dto = new HolidayDTO();
                    dto.setName(name.trim());
                    dto.setStartdate(startDate.trim());
                    dto.setEnddate(endDate.trim());
                    holidayService.createHoliday(List.of(dto));
                    response.sendRedirect(request.getContextPath() + "/holiday?saved=1");
                    return;
                } catch (IllegalArgumentException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    List<Holidays> holidays = holidayService.getAllHolidays();
                    request.setAttribute("holidays", holidays);
                    request.getRequestDispatcher("/holiday.jsp").forward(request, response);
                    return;
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/holiday");
    }
}

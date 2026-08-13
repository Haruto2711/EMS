package com.ems.controller;

import com.ems.dto.HolidayDTO;
import com.ems.model.Holidays;
import com.ems.service.HolidayService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
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

        // ── 1. Đọc & validate tham số từ URL ──────────────────────────────
        String keyword = request.getParameter("search");
        if (keyword == null) keyword = "";
        else keyword = keyword.trim();

        String sort = request.getParameter("sort");
        if (!"DESC".equals(sort)) sort = "ASC"; // mặc định A→Z

        int pageSize = 5;
        try {
            int ps = Integer.parseInt(request.getParameter("pageSize"));
            if (ps == 10 || ps == 20) pageSize = ps;
        } catch (NumberFormatException ignored) { }

        int page = 1;
        try {
            page = Math.max(1, Integer.parseInt(request.getParameter("page")));
        } catch (NumberFormatException ignored) { }

        // ── 2. Lấy dữ liệu từ service ──────────────────────────────────────
        int totalRecords = holidayService.countHolidays(keyword);
        int totalPages   = Math.max(1, (int) Math.ceil((double) totalRecords / pageSize));
        if (page > totalPages) page = totalPages;

        List<Holidays> holidays = holidayService.searchHolidays(keyword, sort, page, pageSize);

        // ── 3. Đẩy attributes sang JSP ─────────────────────────────────────
        request.setAttribute("holidays",     holidays);
        request.setAttribute("keyword",      keyword);
        request.setAttribute("sort",         sort);
        request.setAttribute("currentPage",  page);
        request.setAttribute("pageSize",     pageSize);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("totalRecords", totalRecords);

        request.getRequestDispatcher("/holiday.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String id = request.getParameter("id");

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

        if("update".equals(action)) {
            String name =  request.getParameter("name");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            if (name != null && !name.isBlank()
            && startDate != null && !startDate.isBlank()
            && endDate != null && !endDate.isBlank()) {
                try {
                    HolidayDTO dto = new HolidayDTO();
                    dto.setId(Integer.parseInt(id));
                    dto.setName(name.trim());
                    dto.setStartdate(startDate.trim());
                    dto.setEnddate(endDate.trim());
                    holidayService.updateHoliday(List.of(dto));
                    response.sendRedirect(request.getContextPath() + "/holiday?updated=1");
                    return;
                }catch (IllegalArgumentException e) {
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

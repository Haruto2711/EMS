package com.ems.controller;

import com.ems.dto.EmployeeCalendarDayDTO;
import com.ems.service.EmployeeCalendarService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@WebServlet(name = "EmployeeCalendarServlet", urlPatterns = { "/employee-calendar" })
public class EmployeeCalendarServlet extends HttpServlet {

    private EmployeeCalendarService calendarService;

    @Override
    public void init() {
        calendarService = new EmployeeCalendarService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nhân viên đang đăng nhập tự xem lịch của mình
        // Nếu admin/manager xem hộ nhân viên khác thì lấy employeeId từ param
        Integer sessionUserId = (Integer) request.getSession().getAttribute("accountId");

        int employeeId = sessionUserId != null ? sessionUserId : 0;
        try {
            String paramEmployeeId = request.getParameter("employeeId");
            if (paramEmployeeId != null && !paramEmployeeId.isBlank()) {
                employeeId = Integer.parseInt(paramEmployeeId);
            }
        } catch (NumberFormatException ignored) { }

        LocalDate now = LocalDate.now();
        int year  = now.getYear();
        int month = now.getMonthValue();

        boolean hasYearParam  = request.getParameter("year")  != null;
        boolean hasMonthParam = request.getParameter("month") != null;

        try { year  = Integer.parseInt(request.getParameter("year"));  } catch (NumberFormatException ignored) { }
        try { month = Integer.parseInt(request.getParameter("month")); } catch (NumberFormatException ignored) { }

        // Nếu URL chưa có year hoặc month (lần đầu click từ sidebar),
        // redirect để URL luôn đầy đủ → JSTL c:set và nút điều hướng hoạt động đúng ngay lập tức
        if (!hasYearParam || !hasMonthParam) {
            response.sendRedirect(request.getContextPath()
                    + "/employee-calendar?year=" + year
                    + "&month=" + month
                    + "&employeeId=" + employeeId);
            return;
        }

        YearMonth ym = YearMonth.of(year, month);
        List<EmployeeCalendarDayDTO> days = calendarService.getMonthCalendar(employeeId, year, month);

        // Số ô trống đầu tháng để căn lưới lịch (Thứ 2 = 1 ... Chủ nhật = 7)
        int leadingBlanks = ym.atDay(1).getDayOfWeek().getValue() - 1;

        request.setAttribute("days", days);
        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("employeeId", employeeId);
        request.setAttribute("leadingBlanks", leadingBlanks);
        request.getRequestDispatcher("/employee-calendar.jsp").forward(request, response);
    }
}
package com.ems.controller;

import com.ems.dto.ShiftDTO;
import com.ems.service.WorkScheduleService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "WorkScheduleServlet", urlPatterns = { "/work-schedule" })
public class WorkScheduleServlet extends HttpServlet {

    private WorkScheduleService workScheduleService;

    @Override
    public void init() {
        workScheduleService = new WorkScheduleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ShiftDTO> shifts = workScheduleService.getWorkSchedule();
        request.setAttribute("shifts", shifts);
        request.getRequestDispatcher("/work-schedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        List<ShiftDTO> shiftDTOS = new ArrayList<>();

        for (int i = 0; i < 7; i++) {
            String dayOfWeek = request.getParameter("dayOfWeek_" + i);
            String workingParam = request.getParameter("working_" + i);
            String startTime = request.getParameter("startTime_" + i);
            String endTime = request.getParameter("endTime_" + i);
            String breakStart = request.getParameter("breakStart_" + i);
            String breakEnd = request.getParameter("breakEnd_" + i);
            ShiftDTO dto = new ShiftDTO();
            dto.setDayOfWeek(Integer.parseInt(dayOfWeek));
            boolean working = "true".equals(workingParam);
            dto.setWorking(working);
            if (working) {
                dto.setStartTime(startTime);
                dto.setEndTime(endTime);
                dto.setBreakStart(breakStart);
                dto.setBreakEnd(breakEnd);
            } else {
                dto.setStartTime(null);
                dto.setEndTime(null);
                dto.setBreakStart(null);
                dto.setBreakEnd(null);
            }
            shiftDTOS.add(dto);
        }
        workScheduleService.saveWorkSchedule(shiftDTOS);
        response.sendRedirect(request.getContextPath() + "/work-schedule");
    }
}
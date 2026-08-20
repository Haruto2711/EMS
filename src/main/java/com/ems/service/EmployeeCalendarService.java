package com.ems.service;

import com.ems.dao.HolidayYearInstanceDAO;
import com.ems.dao.ShiftAssignmentCalendarDAO;
import com.ems.dto.EmployeeCalendarDayDTO;
import com.ems.dto.ShiftAssignmentDayDTO;
import com.ems.model.HolidayYearInstance;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmployeeCalendarService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    public List<EmployeeCalendarDayDTO> getMonthCalendar(int employeeId, int year, int month) {
        YearMonth ym = YearMonth.of(year, month);
        LocalDate from = ym.atDay(1);
        LocalDate to = ym.atEndOfMonth();

        List<HolidayYearInstance> holidays = HolidayYearInstanceDAO.getInstanceInRange(from, to);

        List<ShiftAssignmentDayDTO> assignments = ShiftAssignmentCalendarDAO.getAssignmentsForEmployee(employeeId, from, to);
        Map<LocalDate, ShiftAssignmentDayDTO> assignmentByDate = new HashMap<>();
        for (ShiftAssignmentDayDTO a : assignments) {
            assignmentByDate.put(a.getDate(), a);
        }

        List<EmployeeCalendarDayDTO> result = new ArrayList<>();
        for (LocalDate d = from; !d.isAfter(to); d = d.plusDays(1)) {
            EmployeeCalendarDayDTO dto = new EmployeeCalendarDayDTO();
            dto.setDate(d.toString());
            dto.setDayOfMonth(d.getDayOfMonth());

            HolidayYearInstance holiday = findHolidayForDate(holidays, d);
            if (holiday != null) {
                dto.setDayType("HOLIDAY");
                dto.setHolidayName(holiday.getHolidayName());
                dto.setHolidayCoefficient(holiday.getCoefficient());
                result.add(dto);
                continue;
            }

            ShiftAssignmentDayDTO assignment = assignmentByDate.get(d);
            if (assignment != null) {
                dto.setDayType("WORK");
                dto.setShiftName(assignment.getShiftName());
                String start = assignment.getStartTime() != null ? assignment.getStartTime().format(TIME_FMT) : "--:--";
                String end = assignment.getEndTime() != null ? assignment.getEndTime().format(TIME_FMT) : "--:--";
                dto.setShiftTime(start + " - " + end);
            } else if (d.getDayOfWeek() == DayOfWeek.SUNDAY) {
                dto.setDayType("WEEKEND");
            } else {
                dto.setDayType("OFF");
            }
            result.add(dto);
        }
        return result;
    }

    private HolidayYearInstance findHolidayForDate(List<HolidayYearInstance> holidays, LocalDate date) {
        for (HolidayYearInstance h : holidays) {
            if (!date.isBefore(h.getStartDate()) && !date.isAfter(h.getEndDate())) return h;
        }
        return null;
    }
}
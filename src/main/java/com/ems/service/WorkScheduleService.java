package com.ems.service;

import com.ems.dao.WorkScheduleDAO;
import com.ems.dto.ShiftDTO;
import com.ems.model.Shifts;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class WorkScheduleService {
    public void saveWorkSchedule(List<ShiftDTO>shiftDTOS) {
        List<Shifts>list = new ArrayList<Shifts>();
        for (ShiftDTO shiftDTO : shiftDTOS) {
            Shifts shift = new Shifts();
            shift.setDayOfweek(shiftDTO.getDayOfWeek());
            boolean working = Boolean.TRUE.equals(shiftDTO.getWorking());
            shift.setIsactive(working);
            if(working){
                shift.setStarttime(LocalTime.parse(shiftDTO.getStartTime()));
                shift.setEndtime(LocalTime.parse(shiftDTO.getEndTime()));
                shift.setBreakstart(LocalTime.parse(shiftDTO.getBreakStart()));
                shift.setBreakend(LocalTime.parse(shiftDTO.getBreakEnd()));
                list.add(shift);
            }else{
                shift.setStarttime(null);
                shift.setEndtime(null);
                shift.setBreakstart(null);
                shift.setBreakend(null);
                list.add(shift);
            }
        }
        WorkScheduleDAO.saveWorkSchedule(list);
    }

    public List<ShiftDTO> getWorkSchedule() {
        List<Shifts>shift = WorkScheduleDAO.getWeekDefaultShift();
        List<ShiftDTO>shiftDTO = new ArrayList<>();
        for (Shifts s : shift) {
            ShiftDTO dto = new ShiftDTO();
            dto.setDayOfWeek(s.getDayOfweek());
            dto.setWorking(Boolean.TRUE.equals(s.getIsactive()));
            dto.setStartTime(s.getStarttime() != null ? s.getStarttime().toString() : null);
            dto.setEndTime(s.getEndtime() != null ? s.getEndtime().toString() : null);
            dto.setBreakStart(s.getBreakstart() != null ? s.getBreakstart().toString() : null);
            dto.setBreakEnd(s.getBreakend() != null ? s.getBreakend().toString() : null);
            shiftDTO.add(dto);
        }
        return shiftDTO;
    }
}

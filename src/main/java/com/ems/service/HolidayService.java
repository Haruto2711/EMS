package com.ems.service;

import com.ems.dao.HolidayDAO;
import com.ems.dto.HolidayDTO;
import com.ems.model.Holidays;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class HolidayService {

    public void createHoliday(List<HolidayDTO> dtos) {
        List<Holidays> list = new ArrayList<>();
        for (HolidayDTO dto : dtos) {
            Holidays h = new Holidays();
            h.setHolidayname(dto.getName());
            h.setStartdate(LocalDate.parse(dto.getStartdate()));
            h.setEnddate(LocalDate.parse(dto.getEnddate()));
            if (h.getStartdate().isAfter(h.getEnddate())) {
                throw new IllegalArgumentException("Ngày bắt đầu không được sau ngày kết thúc");
            }
            list.add(h);
        }
        for (Holidays h : list) {
            HolidayDAO.insertHoliday(h);
        }
    }

    public List<Holidays> getAllHolidays() {
        return HolidayDAO.getAllHolidays();
    }

    public List<Holidays> searchHolidays(String keyword, String sort, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return HolidayDAO.searchHolidays(keyword == null ? "" : keyword, sort, offset, pageSize);
    }

    public int countHolidays(String keyword) {
        return HolidayDAO.countHolidays(keyword == null ? "" : keyword);
    }

    public void updateHoliday(List<HolidayDTO> dos) {
       for (HolidayDTO dto : dos) {
           Holidays h = new Holidays();
            h.setHolidayname(dto.getName());
            h.setStartdate(LocalDate.parse(dto.getStartdate()));
            h.setEnddate(LocalDate.parse(dto.getEnddate()));
            if (h.getStartdate().isAfter(h.getEnddate())) {
                throw new IllegalArgumentException("Ngày bắt đầu không được sau ngày kết thúc");
            }
            HolidayDAO.updateHoliday(h, dto.getId());
       }
    }
}

package com.ems.model;

import java.time.LocalDate;

public class Holidays {

    private Integer id;
    private String holidayname;
    private LocalDate startdate;
    private LocalDate enddate;
    private Integer createdby;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getHolidayname() {
        return holidayname;
    }

    public void setHolidayname(String holidayname) {
        this.holidayname = holidayname;
    }

    public LocalDate getStartdate() {
        return startdate;
    }

    public void setStartdate(LocalDate startdate) {
        this.startdate = startdate;
    }

    public LocalDate getEnddate() {
        return enddate;
    }

    public void setEnddate(LocalDate enddate) {
        this.enddate = enddate;
    }


    public Integer getCreatedby() {
        return createdby;
    }

    public void setCreatedby(Integer createdby) {
        this.createdby = createdby;
    }

    public long getTotalDays() {
        return java.time.temporal.ChronoUnit.DAYS.between(startdate, enddate) + 1;
    }
}
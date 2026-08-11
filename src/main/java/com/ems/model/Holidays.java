package com.ems.model;

// Model được tự động sinh từ bảng 'holidays'
public class Holidays {

    private Integer id;
    private java.time.LocalDate holidaydate;
    private String holidayname;
    private Integer year;
    private Integer createdby;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public java.time.LocalDate getHolidaydate() {
        return holidaydate;
    }

    public void setHolidaydate(java.time.LocalDate holidaydate) {
        this.holidaydate = holidaydate;
    }

    public String getHolidayname() {
        return holidayname;
    }

    public void setHolidayname(String holidayname) {
        this.holidayname = holidayname;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Integer getCreatedby() {
        return createdby;
    }

    public void setCreatedby(Integer createdby) {
        this.createdby = createdby;
    }
}

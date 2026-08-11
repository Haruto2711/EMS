package com.ems.model;

// Model được tự động sinh từ bảng 'timesheetperiods'
public class Timesheetperiods {

    private Integer id;
    private String name;
    private java.time.LocalDate startdate;
    private java.time.LocalDate enddate;
    private Boolean islocked;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public java.time.LocalDate getStartdate() {
        return startdate;
    }

    public void setStartdate(java.time.LocalDate startdate) {
        this.startdate = startdate;
    }

    public java.time.LocalDate getEnddate() {
        return enddate;
    }

    public void setEnddate(java.time.LocalDate enddate) {
        this.enddate = enddate;
    }

    public Boolean getIslocked() {
        return islocked;
    }

    public void setIslocked(Boolean islocked) {
        this.islocked = islocked;
    }
}

package com.ems.model;

// Model được tự động sinh từ bảng 'shiftassignments'
public class Shiftassignments {

    private Integer id;
    private Integer employeeid;
    private Integer shiftid;
    private java.time.LocalDate startdate;
    private java.time.LocalDate enddate;
    private Integer assignedby;
    private java.time.LocalDateTime createdat;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getEmployeeid() {
        return employeeid;
    }

    public void setEmployeeid(Integer employeeid) {
        this.employeeid = employeeid;
    }

    public Integer getShiftid() {
        return shiftid;
    }

    public void setShiftid(Integer shiftid) {
        this.shiftid = shiftid;
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

    public Integer getAssignedby() {
        return assignedby;
    }

    public void setAssignedby(Integer assignedby) {
        this.assignedby = assignedby;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }
}

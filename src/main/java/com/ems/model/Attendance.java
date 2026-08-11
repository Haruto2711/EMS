package com.ems.model;

// Model được tự động sinh từ bảng 'attendance'
public class Attendance {

    private Integer id;
    private Integer employeeid;
    private java.time.LocalDate attendancedate;
    private java.time.LocalTime checkintime;
    private java.time.LocalTime checkouttime;
    private Integer periodid;

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

    public java.time.LocalDate getAttendancedate() {
        return attendancedate;
    }

    public void setAttendancedate(java.time.LocalDate attendancedate) {
        this.attendancedate = attendancedate;
    }

    public java.time.LocalTime getCheckintime() {
        return checkintime;
    }

    public void setCheckintime(java.time.LocalTime checkintime) {
        this.checkintime = checkintime;
    }

    public java.time.LocalTime getCheckouttime() {
        return checkouttime;
    }

    public void setCheckouttime(java.time.LocalTime checkouttime) {
        this.checkouttime = checkouttime;
    }

    public Integer getPeriodid() {
        return periodid;
    }

    public void setPeriodid(Integer periodid) {
        this.periodid = periodid;
    }
}

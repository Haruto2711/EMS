package com.ems.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class AttendanceRecord {

    private LocalDate date;
    private String employeeCode;
    private String fullName;
    private String department;
    private LocalTime checkIn;
    private LocalTime checkOut;
    private long lateMinutes; // số phút đi muộn, tính từ mốc 08:00

    public AttendanceRecord() {
    }

    public AttendanceRecord(LocalDate date, String employeeCode, String fullName,
                            String department, LocalTime checkIn, LocalTime checkOut,
                            long lateMinutes) {
        this.date = date;
        this.employeeCode = employeeCode;
        this.fullName = fullName;
        this.department = department;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.lateMinutes = lateMinutes;
    }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public LocalTime getCheckIn() { return checkIn; }
    public void setCheckIn(LocalTime checkIn) { this.checkIn = checkIn; }

    public LocalTime getCheckOut() { return checkOut; }
    public void setCheckOut(LocalTime checkOut) { this.checkOut = checkOut; }

    public long getLateMinutes() { return lateMinutes; }
    public void setLateMinutes(long lateMinutes) { this.lateMinutes = lateMinutes; }
}

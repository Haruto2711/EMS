package com.ems.dto;

public class EmployeeCalendarDayDTO {

    private String date;          // yyyy-MM-dd
    private int dayOfMonth;
    private String dayType;       // "WORK", "HOLIDAY", "WEEKEND", "OFF"
    private String shiftName;
    private String shiftTime;     // "08:00 - 17:00"
    private String holidayName;
    private Double holidayCoefficient;

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public int getDayOfMonth() { return dayOfMonth; }
    public void setDayOfMonth(int dayOfMonth) { this.dayOfMonth = dayOfMonth; }

    public String getDayType() { return dayType; }
    public void setDayType(String dayType) { this.dayType = dayType; }

    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }

    public String getShiftTime() { return shiftTime; }
    public void setShiftTime(String shiftTime) { this.shiftTime = shiftTime; }

    public String getHolidayName() { return holidayName; }
    public void setHolidayName(String holidayName) { this.holidayName = holidayName; }

    public Double getHolidayCoefficient() { return holidayCoefficient; }
    public void setHolidayCoefficient(Double holidayCoefficient) { this.holidayCoefficient = holidayCoefficient; }
}
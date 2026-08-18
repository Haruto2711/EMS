package com.ems.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class ShiftAssignmentBatchDTO {
    private Integer id;
    private String name;
    private Integer shiftId;
    private String shiftName;
    private String shiftTime;        // "08:00 - 17:00"
    private LocalDate startDate;
    private LocalDate endDate;
    private String recurType;        // NONE | WEEKLY | MONTHLY
    private Integer recurInterval;
    private String monthlyType;      // WEEKDAY | DATE
    private Integer monthlyWeekday;
    private Integer monthlyOccurrence;
    private Integer monthlyDay;
    private String createdByName;
    private LocalDateTime createdAt;
    private Integer employeeCount;
    private List<Integer> weekdays;
    private List<Integer> employeeIds;
    private List<String> employeeNames;

    // Getters & Setters
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

    public Integer getShiftId() {
        return shiftId;
    }

    public void setShiftId(Integer shiftId) {
        this.shiftId = shiftId;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public String getShiftTime() {
        return shiftTime;
    }

    public void setShiftTime(String shiftTime) {
        this.shiftTime = shiftTime;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getRecurType() {
        return recurType;
    }

    public void setRecurType(String recurType) {
        this.recurType = recurType;
    }

    public Integer getRecurInterval() {
        return recurInterval;
    }

    public void setRecurInterval(Integer recurInterval) {
        this.recurInterval = recurInterval;
    }

    public String getMonthlyType() {
        return monthlyType;
    }

    public void setMonthlyType(String monthlyType) {
        this.monthlyType = monthlyType;
    }

    public Integer getMonthlyWeekday() {
        return monthlyWeekday;
    }

    public void setMonthlyWeekday(Integer monthlyWeekday) {
        this.monthlyWeekday = monthlyWeekday;
    }

    public Integer getMonthlyOccurrence() {
        return monthlyOccurrence;
    }

    public void setMonthlyOccurrence(Integer monthlyOccurrence) {
        this.monthlyOccurrence = monthlyOccurrence;
    }

    public Integer getMonthlyDay() {
        return monthlyDay;
    }

    public void setMonthlyDay(Integer monthlyDay) {
        this.monthlyDay = monthlyDay;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getEmployeeCount() {
        return employeeCount;
    }

    public void setEmployeeCount(Integer employeeCount) {
        this.employeeCount = employeeCount;
    }

    public List<Integer> getWeekdays() {
        return weekdays;
    }

    public void setWeekdays(List<Integer> weekdays) {
        this.weekdays = weekdays;
    }

    public List<Integer> getEmployeeIds() {
        return employeeIds;
    }

    public void setEmployeeIds(List<Integer> employeeIds) {
        this.employeeIds = employeeIds;
    }

    public List<String> getEmployeeNames() {
        return employeeNames;
    }

    public void setEmployeeNames(List<String> employeeNames) {
        this.employeeNames = employeeNames;
    }
}
package com.ems.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

// Model tự động sinh từ bảng 'shiftassignmentbatches'
public class Shiftassignmentbatches {

    private Integer id;
    private String name;
    private Integer shiftId;
    private LocalDate startDate;
    private LocalDate endDate;

    // Quy tắc lặp: NONE | WEEKLY | MONTHLY
    private String recurType;
    private Integer recurInterval;

    // Lặp tháng – chỉ dùng khi recurType = 'MONTHLY'
    private String monthlyType;       // WEEKDAY | DATE
    private Integer monthlyWeekday;   // 1=CN..7=T7
    private Integer monthlyOccurrence;// 1=Đầu tiên, 2=Thứ hai, -1=Cuối cùng
    private Integer monthlyDay;       // 1-31

    private Integer createdBy;
    private LocalDateTime createdAt;

    // ── Getters & Setters ──

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getShiftId() { return shiftId; }
    public void setShiftId(Integer shiftId) { this.shiftId = shiftId; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getRecurType() { return recurType; }
    public void setRecurType(String recurType) { this.recurType = recurType; }

    public Integer getRecurInterval() { return recurInterval; }
    public void setRecurInterval(Integer recurInterval) { this.recurInterval = recurInterval; }

    public String getMonthlyType() { return monthlyType; }
    public void setMonthlyType(String monthlyType) { this.monthlyType = monthlyType; }

    public Integer getMonthlyWeekday() { return monthlyWeekday; }
    public void setMonthlyWeekday(Integer monthlyWeekday) { this.monthlyWeekday = monthlyWeekday; }

    public Integer getMonthlyOccurrence() { return monthlyOccurrence; }
    public void setMonthlyOccurrence(Integer monthlyOccurrence) { this.monthlyOccurrence = monthlyOccurrence; }

    public Integer getMonthlyDay() { return monthlyDay; }
    public void setMonthlyDay(Integer monthlyDay) { this.monthlyDay = monthlyDay; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

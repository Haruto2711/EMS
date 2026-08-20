package com.ems.model;

import java.time.LocalDate;

public class HolidayYearInstance {

    private Integer id;
    private Integer templateId;
    private Integer year;
    private LocalDate startDate;
    private LocalDate endDate;
    private Double coefficient;
    private Integer createdBy;

    // Trường tiện dùng khi JOIN với holidaytemplates - không có cột riêng trong bảng này
    private String holidayName;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getTemplateId() { return templateId; }
    public void setTemplateId(Integer templateId) { this.templateId = templateId; }

    public Integer getYear() { return year; }
    public void setYear(Integer year) { this.year = year; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public Double getCoefficient() { return coefficient; }
    public void setCoefficient(Double coefficient) { this.coefficient = coefficient; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public String getHolidayName() { return holidayName; }
    public void setHolidayName(String holidayName) { this.holidayName = holidayName; }
}
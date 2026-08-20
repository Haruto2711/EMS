package com.ems.model;

public class HolidayTemplate {

    private Integer id;
    private String holidayName;
    private String recurType;       // "FIXED_SOLAR" | "LUNAR"
    private Integer fixedMonth;
    private Integer fixedDay;
    private Integer fixedDurationDays;
    private Double defaultCoefficient;
    private Boolean coefficientLocked;
    private Boolean active;
    private Integer createdBy;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getHolidayName() { return holidayName; }
    public void setHolidayName(String holidayName) { this.holidayName = holidayName; }

    public String getRecurType() { return recurType; }
    public void setRecurType(String recurType) { this.recurType = recurType; }

    public Integer getFixedMonth() { return fixedMonth; }
    public void setFixedMonth(Integer fixedMonth) { this.fixedMonth = fixedMonth; }

    public Integer getFixedDay() { return fixedDay; }
    public void setFixedDay(Integer fixedDay) { this.fixedDay = fixedDay; }

    public Integer getFixedDurationDays() { return fixedDurationDays; }
    public void setFixedDurationDays(Integer fixedDurationDays) { this.fixedDurationDays = fixedDurationDays; }

    public Double getDefaultCoefficient() { return defaultCoefficient; }
    public void setDefaultCoefficient(Double defaultCoefficient) { this.defaultCoefficient = defaultCoefficient; }

    public Boolean getCoefficientLocked() { return coefficientLocked; }
    public void setCoefficientLocked(Boolean coefficientLocked) { this.coefficientLocked = coefficientLocked; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
}
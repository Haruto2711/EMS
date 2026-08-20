package com.ems.dto;

public class HolidayYearViewDTO {

    private Integer instanceId;
    private Integer templateId;
    private String holidayName;
    private String startDate;     // dd/MM/yyyy - hiển thị
    private String endDate;
    private String startDateIso;  // yyyy-MM-dd - cho <input type="date">
    private String endDateIso;
    private Double coefficient;
    private Boolean coefficientLocked;
    private String recurType;

    public Integer getInstanceId() { return instanceId; }
    public void setInstanceId(Integer instanceId) { this.instanceId = instanceId; }

    public Integer getTemplateId() { return templateId; }
    public void setTemplateId(Integer templateId) { this.templateId = templateId; }

    public String getHolidayName() { return holidayName; }
    public void setHolidayName(String holidayName) { this.holidayName = holidayName; }

    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }

    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }

    public String getStartDateIso() { return startDateIso; }
    public void setStartDateIso(String startDateIso) { this.startDateIso = startDateIso; }

    public String getEndDateIso() { return endDateIso; }
    public void setEndDateIso(String endDateIso) { this.endDateIso = endDateIso; }

    public Double getCoefficient() { return coefficient; }
    public void setCoefficient(Double coefficient) { this.coefficient = coefficient; }

    public Boolean getCoefficientLocked() { return coefficientLocked; }
    public void setCoefficientLocked(Boolean coefficientLocked) { this.coefficientLocked = coefficientLocked; }

    public String getRecurType() { return recurType; }
    public void setRecurType(String recurType) { this.recurType = recurType; }
}
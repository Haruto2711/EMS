package com.ems.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class PayslipDTO {

    private int id;
    private int periodId;
    private String status;

    private String employeeCode;
    private String fullName;
    private String departmentName;
    private String positionName;

    private int standardWorkDays;
    private BigDecimal actualWorkDays;

    private BigDecimal grossAmount;
    private BigDecimal totalInsurance;
    private BigDecimal taxDeduction;
    private BigDecimal netAmount;

    private List<AllowanceDetailDTO> allowanceDetails = new ArrayList<>();

    public PayslipDTO() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPeriodId() { return periodId; }
    public void setPeriodId(int periodId) { this.periodId = periodId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }
    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public int getStandardWorkDays() { return standardWorkDays; }
    public void setStandardWorkDays(int standardWorkDays) { this.standardWorkDays = standardWorkDays; }
    public BigDecimal getActualWorkDays() { return actualWorkDays; }
    public void setActualWorkDays(BigDecimal actualWorkDays) { this.actualWorkDays = actualWorkDays; }

    public BigDecimal getGrossAmount() { return grossAmount; }
    public void setGrossAmount(BigDecimal grossAmount) { this.grossAmount = grossAmount; }
    public BigDecimal getTotalInsurance() { return totalInsurance; }
    public void setTotalInsurance(BigDecimal totalInsurance) { this.totalInsurance = totalInsurance; }
    public BigDecimal getTaxDeduction() { return taxDeduction; }
    public void setTaxDeduction(BigDecimal taxDeduction) { this.taxDeduction = taxDeduction; }
    public BigDecimal getNetAmount() { return netAmount; }
    public void setNetAmount(BigDecimal netAmount) { this.netAmount = netAmount; }

    public List<AllowanceDetailDTO> getAllowanceDetails() { return allowanceDetails; }
    public void setAllowanceDetails(List<AllowanceDetailDTO> allowanceDetails) { this.allowanceDetails = allowanceDetails; }

    public void addAllowanceDetail(AllowanceDetailDTO detail) {
        this.allowanceDetails.add(detail);
    }

}

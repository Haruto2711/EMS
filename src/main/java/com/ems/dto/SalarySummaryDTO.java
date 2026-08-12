package com.ems.dto;

import java.math.BigDecimal;

public class SalarySummaryDTO {

    private int totalEmployees;
    private BigDecimal averageSalary;
    private BigDecimal maxSalary;
    private BigDecimal minSalary;
    private BigDecimal totalBudget;

    public SalarySummaryDTO() {
        this.totalEmployees = 0;
        this.averageSalary = BigDecimal.ZERO;
        this.maxSalary = BigDecimal.ZERO;
        this.minSalary = BigDecimal.ZERO;
        this.totalBudget = BigDecimal.ZERO;
    }

    public SalarySummaryDTO(int totalEmployees, BigDecimal averageSalary, BigDecimal maxSalary, BigDecimal minSalary, BigDecimal totalBudget) {
        this.totalEmployees = totalEmployees;
        this.averageSalary = averageSalary;
        this.maxSalary = maxSalary;
        this.minSalary = minSalary;
        this.totalBudget = totalBudget;
    }

    public int getTotalEmployees() {
        return totalEmployees;
    }

    public void setTotalEmployees(int totalEmployees) {
        this.totalEmployees = totalEmployees;
    }

    public BigDecimal getAverageSalary() {
        return averageSalary;
    }

    public void setAverageSalary(BigDecimal averageSalary) {
        this.averageSalary = averageSalary;
    }

    public BigDecimal getMaxSalary() {
        return maxSalary;
    }

    public void setMaxSalary(BigDecimal maxSalary) {
        this.maxSalary = maxSalary;
    }

    public BigDecimal getMinSalary() {
        return minSalary;
    }

    public void setMinSalary(BigDecimal minSalary) {
        this.minSalary = minSalary;
    }

    public BigDecimal getTotalBudget() {
        return totalBudget;
    }

    public void setTotalBudget(BigDecimal totalBudget) {
        this.totalBudget = totalBudget;
    }

    public String getFormattedAverageSalary() {
        if (averageSalary == null) return "0";
        return String.format("%,.0f", averageSalary);
    }

    public String getFormattedTotalBudget() {
        if (totalBudget == null) return "0";
        return String.format("%,.0f", totalBudget);
    }

    public String getFormattedMaxSalary() {
        if (maxSalary == null) return "0";
        return String.format("%,.0f", maxSalary);
    }

    public String getFormattedMinSalary() {
        if (minSalary == null) return "0";
        return String.format("%,.0f", minSalary);
    }
}

package com.ems.model;

// Model được tự động sinh từ bảng 'payslips'
public class Payslips {

    private Integer id;
    private java.math.BigDecimal basesalary;
    private java.math.BigDecimal otsalary;
    private java.math.BigDecimal allowances;
    private java.math.BigDecimal insurancededuction;
    private java.math.BigDecimal dependentdeduction;
    private java.math.BigDecimal taxdeduction;
    private java.math.BigDecimal otherdeductions;
    private java.math.BigDecimal grossamount;
    private java.math.BigDecimal netamount;
    private String status;
    private String note;
    private java.time.LocalDateTime createdat;
    private Integer userid;
    private Integer periodid;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public java.math.BigDecimal getBasesalary() {
        return basesalary;
    }

    public void setBasesalary(java.math.BigDecimal basesalary) {
        this.basesalary = basesalary;
    }

    public java.math.BigDecimal getOtsalary() {
        return otsalary;
    }

    public void setOtsalary(java.math.BigDecimal otsalary) {
        this.otsalary = otsalary;
    }

    public java.math.BigDecimal getAllowances() {
        return allowances;
    }

    public void setAllowances(java.math.BigDecimal allowances) {
        this.allowances = allowances;
    }

    public java.math.BigDecimal getInsurancededuction() {
        return insurancededuction;
    }

    public void setInsurancededuction(java.math.BigDecimal insurancededuction) {
        this.insurancededuction = insurancededuction;
    }

    public java.math.BigDecimal getDependentdeduction() {
        return dependentdeduction;
    }

    public void setDependentdeduction(java.math.BigDecimal dependentdeduction) {
        this.dependentdeduction = dependentdeduction;
    }

    public java.math.BigDecimal getTaxdeduction() {
        return taxdeduction;
    }

    public void setTaxdeduction(java.math.BigDecimal taxdeduction) {
        this.taxdeduction = taxdeduction;
    }

    public java.math.BigDecimal getOtherdeductions() {
        return otherdeductions;
    }

    public void setOtherdeductions(java.math.BigDecimal otherdeductions) {
        this.otherdeductions = otherdeductions;
    }

    public java.math.BigDecimal getGrossamount() {
        return grossamount;
    }

    public void setGrossamount(java.math.BigDecimal grossamount) {
        this.grossamount = grossamount;
    }

    public java.math.BigDecimal getNetamount() {
        return netamount;
    }

    public void setNetamount(java.math.BigDecimal netamount) {
        this.netamount = netamount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public Integer getPeriodid() {
        return periodid;
    }

    public void setPeriodid(Integer periodid) {
        this.periodid = periodid;
    }
}

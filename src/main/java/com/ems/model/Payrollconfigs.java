package com.ems.model;

// Model được tự động sinh từ bảng 'payrollconfigs'
public class Payrollconfigs {

    private Integer id;
    private String configname;
    private java.time.LocalDate effectivedate;
    private java.math.BigDecimal bhxhpercent;
    private java.math.BigDecimal bhytpercent;
    private java.math.BigDecimal bhtnpercent;
    private java.math.BigDecimal maxinsurancesalary;
    private java.math.BigDecimal personaltaxdeduction;
    private java.math.BigDecimal dependenttaxdeduction;
    private Integer standardworkingdays;
    private java.math.BigDecimal otweekdayrate;
    private java.math.BigDecimal otweekendrate;
    private java.math.BigDecimal otholidayrate;
    private Boolean isactive;
    private Integer createdbyaccountid;
    private java.time.LocalDateTime createdat;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getConfigname() {
        return configname;
    }

    public void setConfigname(String configname) {
        this.configname = configname;
    }

    public java.time.LocalDate getEffectivedate() {
        return effectivedate;
    }

    public void setEffectivedate(java.time.LocalDate effectivedate) {
        this.effectivedate = effectivedate;
    }

    public java.math.BigDecimal getBhxhpercent() {
        return bhxhpercent;
    }

    public void setBhxhpercent(java.math.BigDecimal bhxhpercent) {
        this.bhxhpercent = bhxhpercent;
    }

    public java.math.BigDecimal getBhytpercent() {
        return bhytpercent;
    }

    public void setBhytpercent(java.math.BigDecimal bhytpercent) {
        this.bhytpercent = bhytpercent;
    }

    public java.math.BigDecimal getBhtnpercent() {
        return bhtnpercent;
    }

    public void setBhtnpercent(java.math.BigDecimal bhtnpercent) {
        this.bhtnpercent = bhtnpercent;
    }

    public java.math.BigDecimal getMaxinsurancesalary() {
        return maxinsurancesalary;
    }

    public void setMaxinsurancesalary(java.math.BigDecimal maxinsurancesalary) {
        this.maxinsurancesalary = maxinsurancesalary;
    }

    public java.math.BigDecimal getPersonaltaxdeduction() {
        return personaltaxdeduction;
    }

    public void setPersonaltaxdeduction(java.math.BigDecimal personaltaxdeduction) {
        this.personaltaxdeduction = personaltaxdeduction;
    }

    public java.math.BigDecimal getDependenttaxdeduction() {
        return dependenttaxdeduction;
    }

    public void setDependenttaxdeduction(java.math.BigDecimal dependenttaxdeduction) {
        this.dependenttaxdeduction = dependenttaxdeduction;
    }

    public Integer getStandardworkingdays() {
        return standardworkingdays;
    }

    public void setStandardworkingdays(Integer standardworkingdays) {
        this.standardworkingdays = standardworkingdays;
    }

    public java.math.BigDecimal getOtweekdayrate() {
        return otweekdayrate;
    }

    public void setOtweekdayrate(java.math.BigDecimal otweekdayrate) {
        this.otweekdayrate = otweekdayrate;
    }

    public java.math.BigDecimal getOtweekendrate() {
        return otweekendrate;
    }

    public void setOtweekendrate(java.math.BigDecimal otweekendrate) {
        this.otweekendrate = otweekendrate;
    }

    public java.math.BigDecimal getOtholidayrate() {
        return otholidayrate;
    }

    public void setOtholidayrate(java.math.BigDecimal otholidayrate) {
        this.otholidayrate = otholidayrate;
    }
    
    public Boolean getIsactive() {
        return isactive;
    }

    public void setIsactive(Boolean isactive) {
        this.isactive = isactive;
    }

    public Integer getCreatedbyaccountid() {
        return createdbyaccountid;
    }

    public void setCreatedbyaccountid(Integer createdbyaccountid) {
        this.createdbyaccountid = createdbyaccountid;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }
}

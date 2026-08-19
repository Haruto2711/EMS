package com.ems.model;

// Model được tự động sinh từ bảng 'salaryhistories'
public class Salaryhistories {

    private Integer id;
    private Integer userid;
    private java.math.BigDecimal oldsalary;
    private java.math.BigDecimal newsalary;
    private java.time.LocalDate effectivedate;
    private String reason;
    private Integer updatedbyaccountid;
    private java.time.LocalDateTime createdat;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public java.math.BigDecimal getOldsalary() {
        return oldsalary;
    }

    public void setOldsalary(java.math.BigDecimal oldsalary) {
        this.oldsalary = oldsalary;
    }

    public java.math.BigDecimal getNewsalary() {
        return newsalary;
    }

    public void setNewsalary(java.math.BigDecimal newsalary) {
        this.newsalary = newsalary;
    }

    public java.time.LocalDate getEffectivedate() {
        return effectivedate;
    }

    public void setEffectivedate(java.time.LocalDate effectivedate) {
        this.effectivedate = effectivedate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Integer getUpdatedbyaccountid() {
        return updatedbyaccountid;
    }

    public void setUpdatedbyaccountid(Integer updatedbyaccountid) {
        this.updatedbyaccountid = updatedbyaccountid;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }
}

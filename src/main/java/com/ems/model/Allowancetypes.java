package com.ems.model;

// Model được tự động sinh từ bảng 'allowancetypes'
public class Allowancetypes {

    private Integer id;
    private String code;
    private String name;
    private String type;
    private String calculationmethod;
    private java.math.BigDecimal defaultamount;
    private Boolean istaxable;
    private java.math.BigDecimal taxexemptlimit;
    private Boolean isinsurancesalary;
    private Boolean isactive;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCalculationmethod() {
        return calculationmethod;
    }

    public void setCalculationmethod(String calculationmethod) {
        this.calculationmethod = calculationmethod;
    }

    public java.math.BigDecimal getDefaultamount() {
        return defaultamount;
    }

    public void setDefaultamount(java.math.BigDecimal defaultamount) {
        this.defaultamount = defaultamount;
    }

    public Boolean getIstaxable() {
        return istaxable;
    }

    public void setIstaxable(Boolean istaxable) {
        this.istaxable = istaxable;
    }

    public java.math.BigDecimal getTaxexemptlimit() {
        return taxexemptlimit;
    }

    public void setTaxexemptlimit(java.math.BigDecimal taxexemptlimit) {
        this.taxexemptlimit = taxexemptlimit;
    }

    public Boolean getIsinsurancesalary() {
        return isinsurancesalary;
    }

    public void setIsinsurancesalary(Boolean isinsurancesalary) {
        this.isinsurancesalary = isinsurancesalary;
    }

    public Boolean getIsactive() {
        return isactive;
    }

    public void setIsactive(Boolean isactive) {
        this.isactive = isactive;
    }
}

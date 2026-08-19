package com.ems.model;

// Model được tự động sinh từ bảng 'payslip_allowances'
public class PayslipAllowances {

    private Integer id;
    private Integer payslipid;
    private Integer allowancetypeid;
    private java.math.BigDecimal amount;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getPayslipid() { return payslipid; }
    public void setPayslipid(Integer payslipid) { this.payslipid = payslipid; }
    
    public Integer getAllowancetypeid() { return allowancetypeid; }
    public void setAllowancetypeid(Integer allowancetypeid) { this.allowancetypeid = allowancetypeid; }
    
    public java.math.BigDecimal getAmount() { return amount; }
    public void setAmount(java.math.BigDecimal amount) { this.amount = amount; }
}

package com.ems.dto;

import java.math.BigDecimal;

public class AllowanceDetailDTO {

    private String allowanceName;
    private BigDecimal amount;

    public AllowanceDetailDTO(String allowanceName, BigDecimal amount) {
        this.allowanceName = allowanceName;
        this.amount = amount;
    }

    public String getAllowanceName() { return allowanceName; }
    public void setAllowanceName(String allowanceName) { this.allowanceName = allowanceName; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

}

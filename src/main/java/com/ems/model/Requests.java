package com.ems.model;

// Model được tự động sinh từ bảng 'requests'
public class Requests {

    private Integer id;
    private String title;
    private String reason;
    private String status;
    private java.time.LocalDateTime startdate;
    private java.time.LocalDateTime enddate;
    private java.math.BigDecimal value;
    private String imageurl;
    private java.time.LocalDateTime createdat;
    private Integer requesttypeid;
    private Integer createdbyaccountid;
    private Integer currentapproveraccountid;
    private String rejectionreason;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public java.time.LocalDateTime getStartdate() {
        return startdate;
    }

    public void setStartdate(java.time.LocalDateTime startdate) {
        this.startdate = startdate;
    }

    public java.time.LocalDateTime getEnddate() {
        return enddate;
    }

    public void setEnddate(java.time.LocalDateTime enddate) {
        this.enddate = enddate;
    }

    public java.math.BigDecimal getValue() {
        return value;
    }

    public void setValue(java.math.BigDecimal value) {
        this.value = value;
    }

    public String getImageurl() {
        return imageurl;
    }

    public void setImageurl(String imageurl) {
        this.imageurl = imageurl;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }

    public Integer getRequesttypeid() {
        return requesttypeid;
    }

    public void setRequesttypeid(Integer requesttypeid) {
        this.requesttypeid = requesttypeid;
    }

    public Integer getCreatedbyaccountid() {
        return createdbyaccountid;
    }

    public void setCreatedbyaccountid(Integer createdbyaccountid) {
        this.createdbyaccountid = createdbyaccountid;
    }

    public Integer getCurrentapproveraccountid() {
        return currentapproveraccountid;
    }

    public void setCurrentapproveraccountid(Integer currentapproveraccountid) {
        this.currentapproveraccountid = currentapproveraccountid;
    }

    public String getRejectionreason() {
        return rejectionreason;
    }

    public void setRejectionreason(String rejectionreason) {
        this.rejectionreason = rejectionreason;
    }
}

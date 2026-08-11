package com.ems.model;

// Model được tự động sinh từ bảng 'notifications'
public class Notifications {

    private Integer id;
    private Integer userid;
    private String title;
    private String message;
    private Boolean isread;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Boolean getIsread() {
        return isread;
    }

    public void setIsread(Boolean isread) {
        this.isread = isread;
    }

    public java.time.LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(java.time.LocalDateTime createdat) {
        this.createdat = createdat;
    }
}

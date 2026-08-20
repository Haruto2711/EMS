package com.ems.dto;

import java.time.LocalDateTime;

public class NotificationDTO {
    private Integer id;
    private String message;
    private Boolean isread;
    private java.time.LocalDateTime createdat;

    public NotificationDTO() {
    }

    public NotificationDTO(Integer id, String message, Boolean isread, LocalDateTime createdat) {
        this.id = id;
        this.message = message;
        this.isread = isread;
        this.createdat = createdat;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public LocalDateTime getCreatedat() {
        return createdat;
    }

    public void setCreatedat(LocalDateTime createdat) {
        this.createdat = createdat;
    }
}

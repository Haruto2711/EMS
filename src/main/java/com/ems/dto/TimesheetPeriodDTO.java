package com.ems.dto;

import java.text.SimpleDateFormat;
import java.time.temporal.ChronoUnit;

public class TimesheetPeriodDTO {
    private int id;
    private String name;
    private java.sql.Date startDate;
    private java.sql.Date endDate;
    private String status; // "Đang mở", "Đã khóa"
    private boolean isLocked;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public java.sql.Date getStartDate() {
        return startDate;
    }

    public void setStartDate(java.sql.Date startDate) {
        this.startDate = startDate;
    }

    public java.sql.Date getEndDate() {
        return endDate;
    }

    public void setEndDate(java.sql.Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        if (status != null && !status.trim().isEmpty()) {
            return status;
        }
        return isLocked ? "Đã khóa" : "Đang mở";
    }

    public void setStatus(String status) {
        this.status = status;
        if ("Đã khóa".equalsIgnoreCase(status) || "LOCKED".equalsIgnoreCase(status) || "Locked".equalsIgnoreCase(status)) {
            this.isLocked = true;
        } else if ("Đang mở".equalsIgnoreCase(status) || "OPEN".equalsIgnoreCase(status) || "Active".equalsIgnoreCase(status) || "Open".equalsIgnoreCase(status)) {
            this.isLocked = false;
        }
    }

    public boolean isLocked() {
        return isLocked;
    }

    public void setLocked(boolean locked) {
        isLocked = locked;
        this.status = locked ? "Đã khóa" : "Đang mở";
    }

    public java.sql.Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(java.sql.Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public java.sql.Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(java.sql.Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // --- Helper methods for UI presentation ---

    public String getFormattedStartDate() {
        if (startDate == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy").format(startDate);
    }

    public String getFormattedEndDate() {
        if (endDate == null) return "";
        return new SimpleDateFormat("dd/MM/yyyy").format(endDate);
    }

    public long getTotalDays() {
        if (startDate == null || endDate == null) return 0;
        try {
            return ChronoUnit.DAYS.between(startDate.toLocalDate(), endDate.toLocalDate()) + 1;
        } catch (Exception e) {
            return 0;
        }
    }

    public String getStatusBadgeClass() {
        return isLocked ? "badge-locked" : "badge-active";
    }
}


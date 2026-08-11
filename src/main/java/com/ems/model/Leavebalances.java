package com.ems.model;

// Model được tự động sinh từ bảng 'leavebalances'
public class Leavebalances {

    private Integer id;
    private Integer year;
    private Integer totaldays;
    private Integer useddays;
    private Integer remainingdays;
    private Integer userid;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public Integer getTotaldays() {
        return totaldays;
    }

    public void setTotaldays(Integer totaldays) {
        this.totaldays = totaldays;
    }

    public Integer getUseddays() {
        return useddays;
    }

    public void setUseddays(Integer useddays) {
        this.useddays = useddays;
    }

    public Integer getRemainingdays() {
        return remainingdays;
    }

    public void setRemainingdays(Integer remainingdays) {
        this.remainingdays = remainingdays;
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }
}

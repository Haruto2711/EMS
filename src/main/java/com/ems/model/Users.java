package com.ems.model;

// Model được tự động sinh từ bảng 'users'
public class Users {

    private Integer id;
    private String employeecode;
    private String fullname;
    private String emailcompany;
    private String phone;
    private Boolean gender;
    private java.time.LocalDate dateofbirth;
    private Boolean status;
    private Integer departmentid;
    private Integer positionid;
    private Integer dependentscount;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmployeecode() {
        return employeecode;
    }

    public void setEmployeecode(String employeecode) {
        this.employeecode = employeecode;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmailcompany() {
        return emailcompany;
    }

    public void setEmailcompany(String emailcompany) {
        this.emailcompany = emailcompany;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public java.time.LocalDate getDateofbirth() {
        return dateofbirth;
    }

    public void setDateofbirth(java.time.LocalDate dateofbirth) {
        this.dateofbirth = dateofbirth;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Integer getDepartmentid() {
        return departmentid;
    }

    public void setDepartmentid(Integer departmentid) {
        this.departmentid = departmentid;
    }

    public Integer getPositionid() {
        return positionid;
    }

    public void setPositionid(Integer positionid) {
        this.positionid = positionid;
    }

    public Integer getDependentscount() {
        return dependentscount;
    }

    public void setDependentscount(Integer dependentscount) {
        this.dependentscount = dependentscount;
    }
}

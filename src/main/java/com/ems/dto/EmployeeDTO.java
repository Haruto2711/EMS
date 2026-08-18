package com.ems.dto;

public class EmployeeDTO {
    private Integer id;
    private String employeeCode;
    private String fullName;
    private String departmentName;

    public EmployeeDTO() {
    }

    public EmployeeDTO(Integer id, String employeeCode, String fullName, String departmentName) {
        this.id = id;
        this.employeeCode = employeeCode;
        this.fullName = fullName;
        this.departmentName = departmentName;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(String employeeCode) {
        this.employeeCode = employeeCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}

package com.ems.model;

// Model được tự động sinh từ bảng 'departments'
public class Departments {

    private Integer id;
    private String code;
    private String name;
    private Integer headaccountid;

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

    public Integer getHeadaccountid() {
        return headaccountid;
    }

    public void setHeadaccountid(Integer headaccountid) {
        this.headaccountid = headaccountid;
    }
}

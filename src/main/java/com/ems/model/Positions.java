package com.ems.model;

// Model được tự động sinh từ bảng 'positions'
public class Positions {

    private Integer id;
    private String code;
    private String name;
    private Integer joblevel;
    private Integer defaultshiftid;

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

    public Integer getJoblevel() {
        return joblevel;
    }

    public void setJoblevel(Integer joblevel) {
        this.joblevel = joblevel;
    }

    public Integer getDefaultshiftid() {
        return defaultshiftid;
    }

    public void setDefaultshiftid(Integer defaultshiftid) {
        this.defaultshiftid = defaultshiftid;
    }
}

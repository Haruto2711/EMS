package com.ems.service;

import com.ems.dto.BaseSalaryDTO;
import com.ems.dto.SalarySummaryDTO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

public class BaseSalaryServiceTest {

    @Test
    public void testBaseSalaryDTOSettersAndGetters() {
        BaseSalaryDTO dto = new BaseSalaryDTO();
        dto.setId(1);
        dto.setEmployeeCode("EMP001");
        dto.setFullName("Nguyen Van A");
        dto.setBaseSalary(new BigDecimal("15000000.00"));
        dto.setDepartmentName("Phòng Công Nghệ Thông Tin");
        dto.setPositionName("Senior Developer");
        dto.setStatus(true);

        Assertions.assertEquals(1, dto.getId());
        Assertions.assertEquals("EMP001", dto.getEmployeeCode());
        Assertions.assertEquals("Nguyen Van A", dto.getFullName());
        Assertions.assertEquals(new BigDecimal("15000000.00"), dto.getBaseSalary());
        Assertions.assertEquals("Phòng Công Nghệ Thông Tin", dto.getDepartmentName());
        Assertions.assertEquals("Senior Developer", dto.getPositionName());
        Assertions.assertTrue(dto.getStatus());
    }

    @Test
    public void testSalarySummaryDTO() {
        SalarySummaryDTO summary = new SalarySummaryDTO(
                10,
                new BigDecimal("20000000.00"),
                new BigDecimal("35000000.00"),
                new BigDecimal("10000000.00"),
                new BigDecimal("200000000.00")
        );

        Assertions.assertEquals(10, summary.getTotalEmployees());
        Assertions.assertEquals(new BigDecimal("20000000.00"), summary.getAverageSalary());
        Assertions.assertEquals(new BigDecimal("35000000.00"), summary.getMaxSalary());
        Assertions.assertEquals(new BigDecimal("10000000.00"), summary.getMinSalary());
        Assertions.assertEquals(new BigDecimal("200000000.00"), summary.getTotalBudget());
    }
}

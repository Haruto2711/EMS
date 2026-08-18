package com.ems.service;

import com.ems.dao.ShiftAssignmentDAO;
import com.ems.dto.ShiftAssignmentBatchDTO;
import com.ems.model.Shiftassignmentbatches;

import java.util.List;

public class ShiftAssignmentService {

    public List<ShiftAssignmentBatchDTO> getAllBatches() {
        return ShiftAssignmentDAO.getAllBatches();
    }

    public ShiftAssignmentBatchDTO getById(int id) {
        return ShiftAssignmentDAO.getBatchById(id);
    }

    public void create(Shiftassignmentbatches b, List<Integer> weekdays, List<Integer> empIds) {
        validate(b, weekdays, empIds);
        ShiftAssignmentDAO.createBatch(b, weekdays, empIds);
    }

    public void update(Shiftassignmentbatches b, List<Integer> weekdays, List<Integer> empIds) {
        validate(b, weekdays, empIds);
        ShiftAssignmentDAO.updateBatch(b, weekdays, empIds);
    }

    public void delete(int id) {
        ShiftAssignmentDAO.deleteBatch(id);
    }

    private void validate(Shiftassignmentbatches b, List<Integer> weekdays, List<Integer> empIds) {
        if (b.getName() == null || b.getName().isBlank())
            throw new IllegalArgumentException("Tên bảng phân ca không được để trống.");
        if (b.getShiftId() == null)
            throw new IllegalArgumentException("Phải chọn ca làm việc.");
        if (b.getStartDate() == null)
            throw new IllegalArgumentException("Phải nhập ngày bắt đầu.");
        if (b.getEndDate() != null && b.getEndDate().isBefore(b.getStartDate()))
            throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu.");
        if (empIds == null || empIds.isEmpty())
            throw new IllegalArgumentException("Phải chọn ít nhất 1 nhân viên áp dụng.");

        if ("WEEKLY".equals(b.getRecurType()) && (weekdays == null || weekdays.isEmpty()))
            throw new IllegalArgumentException("Lặp hàng tuần phải chọn ít nhất 1 ngày trong tuần.");

        if ("MONTHLY".equals(b.getRecurType())) {
            if (b.getMonthlyType() == null)
                throw new IllegalArgumentException("Phải chọn kiểu lặp hàng tháng.");
            if ("WEEKDAY".equals(b.getMonthlyType())
                    && (b.getMonthlyWeekday() == null || b.getMonthlyOccurrence() == null))
                throw new IllegalArgumentException("Thiếu thông tin thứ/lần lặp trong tháng.");
            if ("DATE".equals(b.getMonthlyType()) && b.getMonthlyDay() == null)
                throw new IllegalArgumentException("Thiếu ngày lặp trong tháng.");
        }
    }
}
package com.ems.service;

import com.ems.dao.AllowanceTypeDAO;
import com.ems.model.Allowancetypes;

import java.math.BigDecimal;
import java.util.List;

public class AllowanceService {
    private AllowanceTypeDAO allowanceTypeDAO;

    public AllowanceService(){
        this.allowanceTypeDAO = new AllowanceTypeDAO();
    }

    public List<Allowancetypes> getAllAllowances(String keyword){
        return allowanceTypeDAO.getAllAllowanceTypes();
    }

    public Allowancetypes getAllowanceById(int id) {
        return allowanceTypeDAO.getById(id);
    }

    public String createAllowance(Allowancetypes item){
        Allowancetypes existingItem = allowanceTypeDAO.getByCode(item.getCode());
        if (existingItem != null) {
            return "Lỗi: Mã phụ cấp '" + item.getCode() + "' đã tồn tại!";
        }

        if (item.getDefaultamount().compareTo(BigDecimal.ZERO) < 0) {
            return "Lỗi: Mức tiền không được nhỏ hơn 0!";
        }


        if (item.getTaxexemptlimit().compareTo(BigDecimal.ZERO) < 0) {
            return "Lỗi: Hạn mức miễn thuế không được nhỏ hơn 0!";
        }

        boolean isSuccess = allowanceTypeDAO.insert(item);
        return isSuccess ? "SUCCESS" : "Lỗi: Không thể thêm mới phụ cấp vào hệ thống.";
    }

    public String updateAllowance(Allowancetypes item){
        // Check id available
        Allowancetypes currentItem = allowanceTypeDAO.getById(item.getId());
        if (currentItem == null) {
            return "Lỗi: Không tìm thấy khoản phụ cấp cần cập nhật!";
        }

        //Validate
        if (item.getDefaultamount().compareTo(BigDecimal.ZERO) < 0) {
            return "Lỗi: Mức tiền không được nhỏ hơn 0!";
        }

        if (item.getTaxexemptlimit().compareTo(BigDecimal.ZERO) < 0) {
            return "Lỗi: Hạn mức miễn thuế không được nhỏ hơn 0!";
        }

        boolean isSuccess = allowanceTypeDAO.update(item);
        return isSuccess ? "SUCCESS" : "Lỗi: Không thể cập nhật thông tin phụ cấp.";
    }

    public boolean toggleAllowanceStatus(int id){
        return allowanceTypeDAO.toggleStatus(id);
    }
}

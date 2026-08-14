package com.ems.util;

import com.ems.model.AttendanceRecord;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Ghi danh sách AttendanceRecord ra file Excel (.xlsx).
 * Dùng cho chức năng "Export Excel" ở trang preview — xuất lại dữ liệu
 * vừa đọc được (trước khi lưu DB) để HR lưu trữ / gửi kiểm tra chéo.
 */
public class ExcelExporter {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    public static void export(List<AttendanceRecord> records, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("ChamCong");

            // Style cho dòng header: in đậm + nền xám nhạt
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            String[] headers = {
                    "Ngày", "Mã nhân viên", "Họ và Tên", "Phòng ban",
                    "Check in", "Check out", "Đi muộn (phút)"
            };

            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            int rowIdx = 1;
            for (AttendanceRecord r : records) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(r.getDate() != null ? r.getDate().format(DATE_FMT) : "");
                row.createCell(1).setCellValue(r.getEmployeeCode());
                row.createCell(2).setCellValue(r.getFullName());
                row.createCell(3).setCellValue(r.getDepartment());
                row.createCell(4).setCellValue(r.getCheckIn() != null ? r.getCheckIn().format(TIME_FMT) : "");
                row.createCell(5).setCellValue(r.getCheckOut() != null ? r.getCheckOut().format(TIME_FMT) : "");
                row.createCell(6).setCellValue(r.getLateMinutes());
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
        }
    }
}
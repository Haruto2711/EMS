package com.ems.util;

import com.ems.dto.EmployeeDTO;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Tạo file Excel template chấm công cho 1 ngày cụ thể.
 *
 * Cấu trúc cột — khớp hoàn toàn với ExcelParser:
 *   A: Ngày | B: Mã nhân viên | C: Họ và Tên | D: Phòng ban | E: Check in | F: Check out
 *
 * Cột E, F để trống để quản lý điền tay rồi import lại qua /Attendance/upload.
 */
public class ExcelAttendanceExporter {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    /**
     * Xuất file Excel template chấm công.
     *
     * @param employees danh sách nhân viên trong batch
     * @param date      ngày chấm công (thường là hôm nay)
     * @param out       output stream để write file
     */
    public static void export(List<EmployeeDTO> employees,
                              LocalDate date,
                              OutputStream out) throws Exception {

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("ChamCong");

            // ── Style header ──
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            setBorder(headerStyle, BorderStyle.THIN);

            // ── Style data ──
            CellStyle dataStyle = workbook.createCellStyle();
            setBorder(dataStyle, BorderStyle.THIN);

            // ── Style cột Check in / Check out (nổi bật để nhắc điền) ──
            CellStyle emptyStyle = workbook.createCellStyle();
            emptyStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
            emptyStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            setBorder(emptyStyle, BorderStyle.THIN);

            // ── Header row ──
            String[] headers = {
                    "Ngày", "Mã nhân viên", "Họ và Tên", "Phòng ban",
                    "Check in", "Check out"
            };
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // ── Data rows ──
            String dateStr = date.format(DATE_FMT);
            int rowIdx = 1;
            for (EmployeeDTO emp : employees) {
                Row row = sheet.createRow(rowIdx++);

                Cell cDate = row.createCell(0);
                cDate.setCellValue(dateStr);
                cDate.setCellStyle(dataStyle);

                Cell cCode = row.createCell(1);
                cCode.setCellValue(nvl(emp.getEmployeeCode()));
                cCode.setCellStyle(dataStyle);

                Cell cName = row.createCell(2);
                cName.setCellValue(nvl(emp.getFullName()));
                cName.setCellStyle(dataStyle);

                Cell cDept = row.createCell(3);
                cDept.setCellValue(nvl(emp.getDepartmentName()));
                cDept.setCellStyle(dataStyle);

                // Check in / Check out — để trống, highlight màu vàng nhạt
                row.createCell(4).setCellStyle(emptyStyle);
                row.createCell(5).setCellStyle(emptyStyle);
            }

            // ── Auto-size cột A-D, cố định E-F ──
            for (int i = 0; i < 4; i++) sheet.autoSizeColumn(i);
            sheet.setColumnWidth(4, 4000);
            sheet.setColumnWidth(5, 4000);

            workbook.write(out);
        }
    }

    private static String nvl(String s) {
        return s != null ? s : "";
    }

    private static void setBorder(CellStyle style, BorderStyle bs) {
        style.setBorderTop(bs);
        style.setBorderBottom(bs);
        style.setBorderLeft(bs);
        style.setBorderRight(bs);
    }
}

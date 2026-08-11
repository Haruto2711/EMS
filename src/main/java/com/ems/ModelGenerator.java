package com.ems;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.*;
import java.util.*;

/**
 * ModelGenerator
 * ---------------
 * Đọc schema MySQL và tự động sinh ra các class Model (POJO) trong Java,
 * chỉ gồm field + getter/setter, dùng cho kiến trúc Servlet + Service + DAO.
 *
 * CÁCH DÙNG:
 * 1. Sửa 4 biến cấu hình bên dưới (DB_URL, DB_USER, DB_PASSWORD, PACKAGE_NAME)
 * 2. Đảm bảo mysql-connector-j (JDBC driver) đã có trong classpath
 * 3. Compile và chạy:
 *      javac ModelGenerator.java
 *      java ModelGenerator
 * 4. Các file .java sẽ được sinh ra trong thư mục OUTPUT_DIR
 *
 * LƯU Ý: Script này chỉ generate 1 lần để tiết kiệm thời gian gõ tay,
 * bạn vẫn nên xem lại code sinh ra trước khi dùng chính thức trong dự án.
 */
public class ModelGenerator {

    // ===== CẤU HÌNH - SỬA THEO DỰ ÁN CỦA BẠN =====
    private static final String DB_URL = "jdbc:mysql://localhost:3306/hrms_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";
    private static final String PACKAGE_NAME = "com.ems.model";
    private static final String OUTPUT_DIR = "src/main/java/com/ems/model";
    // Nếu chỉ muốn generate 1 số bảng cụ thể, liệt kê tên bảng vào đây.
    // Để trống (empty array) nghĩa là generate TẤT CẢ các bảng trong DB.
    private static final String[] ONLY_TABLES = {}; // vd: {"employee", "work_schedule"}

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            DatabaseMetaData metaData = conn.getMetaData();
            List<String> tableNames = getTableNames(metaData, conn.getCatalog());

            if (tableNames.isEmpty()) {
                System.out.println("Không tìm thấy bảng nào trong database.");
                return;
            }

            for (String tableName : tableNames) {
                generateModelClass(metaData, conn.getCatalog(), tableName);
            }

            System.out.println("\nHoàn tất! Đã sinh " + tableNames.size() + " model class vào thư mục: " + OUTPUT_DIR);

        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }

    /** Lấy danh sách tên bảng trong database (bỏ qua view, chỉ lấy TABLE) */
    private static List<String> getTableNames(DatabaseMetaData metaData, String catalog) throws SQLException {
        List<String> tables = new ArrayList<>();
        Set<String> filter = new HashSet<>(Arrays.asList(ONLY_TABLES));

        try (ResultSet rs = metaData.getTables(catalog, null, "%", new String[]{"TABLE"})) {
            while (rs.next()) {
                String tableName = rs.getString("TABLE_NAME");
                if (filter.isEmpty() || filter.contains(tableName)) {
                    tables.add(tableName);
                }
            }
        }
        return tables;
    }

    /** Sinh 1 file .java cho 1 bảng cụ thể */
    private static void generateModelClass(DatabaseMetaData metaData, String catalog, String tableName)
            throws SQLException, IOException {

        String className = toPascalCase(tableName);
        StringBuilder fields = new StringBuilder();
        StringBuilder getterSetters = new StringBuilder();

        try (ResultSet columns = metaData.getColumns(catalog, null, tableName, "%")) {
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                int sqlType = columns.getInt("DATA_TYPE");
                String javaType = mapSqlTypeToJava(sqlType);
                String fieldName = toCamelCase(columnName);
                String capitalized = capitalize(fieldName);

                // field
                fields.append("    private ").append(javaType).append(" ").append(fieldName).append(";\n");

                // getter
                getterSetters.append("\n    public ").append(javaType).append(" get").append(capitalized).append("() {\n");
                getterSetters.append("        return ").append(fieldName).append(";\n");
                getterSetters.append("    }\n");

                // setter
                getterSetters.append("\n    public void set").append(capitalized).append("(")
                        .append(javaType).append(" ").append(fieldName).append(") {\n");
                getterSetters.append("        this.").append(fieldName).append(" = ").append(fieldName).append(";\n");
                getterSetters.append("    }\n");
            }
        }

        String content = "package " + PACKAGE_NAME + ";\n\n"
                + "// Model được tự động sinh từ bảng '" + tableName + "'\n"
                + "public class " + className + " {\n\n"
                + fields
                + getterSetters
                + "}\n";

        String filePath = OUTPUT_DIR + "/" + className + ".java";
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write(content);
        }
        System.out.println("Đã sinh: " + filePath);
    }

    /** Map kiểu dữ liệu SQL (java.sql.Types) sang kiểu Java tương ứng */
    private static String mapSqlTypeToJava(int sqlType) {
        switch (sqlType) {
            case Types.INTEGER:
            case Types.SMALLINT:
            case Types.TINYINT:
                return "Integer";
            case Types.BIGINT:
                return "Long";
            case Types.VARCHAR:
            case Types.CHAR:
            case Types.LONGVARCHAR:
                return "String";
            case Types.DECIMAL:
            case Types.NUMERIC:
                return "java.math.BigDecimal";
            case Types.FLOAT:
            case Types.REAL:
                return "Float";
            case Types.DOUBLE:
                return "Double";
            case Types.BOOLEAN:
            case Types.BIT:
                return "Boolean";
            case Types.DATE:
                return "java.time.LocalDate";
            case Types.TIME:
                return "java.time.LocalTime";
            case Types.TIMESTAMP:
                return "java.time.LocalDateTime";
            default:
                return "String"; // fallback an toàn
        }
    }

    /** vd: "work_schedule" -> "WorkSchedule" (dùng cho tên class) */
    private static String toPascalCase(String input) {
        StringBuilder result = new StringBuilder();
        for (String part : input.split("_")) {
            if (!part.isEmpty()) {
                result.append(Character.toUpperCase(part.charAt(0))).append(part.substring(1).toLowerCase());
            }
        }
        return result.toString();
    }

    /** vd: "work_schedule_id" -> "workScheduleId" (dùng cho tên field) */
    private static String toCamelCase(String input) {
        String pascal = toPascalCase(input);
        return Character.toLowerCase(pascal.charAt(0)) + pascal.substring(1);
    }

    /** vd: "workScheduleId" -> "WorkScheduleId" (dùng để ghép vào getXxx/setXxx) */
    private static String capitalize(String input) {
        return Character.toUpperCase(input.charAt(0)) + input.substring(1);
    }
}
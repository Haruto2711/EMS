package com.ems.util;

import com.ems.dto.ShiftAssignmentBatchDTO;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashSet;
import java.util.Set;

/**
 * Helper tính toán xem 1 ngày cụ thể có thuộc recurrence rule của batch hay không.
 * Tái sử dụng trong ExportAttendanceServlet và ShiftAssignmentServlet (preview).
 */
public class ShiftRecurrenceHelper {

    /**
     * Kiểm tra xem ngày {@code date} có phải là ngày làm việc theo batch không.
     * Điều kiện:
     *  1. date nằm trong [batch.startDate, batch.endDate] (nếu endDate null → hết hạn → false)
     *  2. date khớp với recurrence rule (NONE / WEEKLY / MONTHLY)
     *
     * @param batch batch phân ca (cần startDate, endDate, recurType, recurInterval, weekdays…)
     * @param date  ngày cần kiểm tra
     * @return true nếu date là ngày active của batch
     */
    public static boolean isActiveOn(ShiftAssignmentBatchDTO batch, LocalDate date) {
        if (batch == null || batch.getStartDate() == null) return false;
        if (batch.getEndDate() == null) return false; // bắt buộc có endDate

        LocalDate start = batch.getStartDate();
        LocalDate end   = batch.getEndDate();

        // Ngoài khoảng → không active
        if (date.isBefore(start) || date.isAfter(end)) return false;

        String recurType = batch.getRecurType();
        if (recurType == null) recurType = "NONE";

        switch (recurType) {
            case "NONE":
                // Chỉ đúng ngày startDate
                return date.equals(start);

            case "WEEKLY": {
                int interval = batch.getRecurInterval() != null ? batch.getRecurInterval() : 1;

                // Tập ngày trong tuần được chọn (hệ app: 1=CN, 2=T2…7=T7)
                Set<Integer> weekdaySet = toSet(batch.getWeekdays());
                if (weekdaySet.isEmpty()) return false;

                // Kiểm tra date có thuộc ngày trong tuần không
                int javaDow = date.getDayOfWeek().getValue(); // Mon=1..Sun=7
                int appDow  = (javaDow == 7) ? 1 : javaDow + 1;
                if (!weekdaySet.contains(appDow)) return false;

                // Kiểm tra tuần có thuộc chu kỳ không
                LocalDate mondayOfStart = start.with(DayOfWeek.MONDAY);
                LocalDate mondayOfDate  = date.with(DayOfWeek.MONDAY);
                long weekDiff = ChronoUnit.WEEKS.between(mondayOfStart, mondayOfDate);
                return weekDiff >= 0 && weekDiff % interval == 0;
            }

            case "MONTHLY": {
                int interval   = batch.getRecurInterval() != null ? batch.getRecurInterval() : 1;
                String mType   = batch.getMonthlyType();
                LocalDate firstMonth = start.withDayOfMonth(1);
                long mDiff = ChronoUnit.MONTHS.between(firstMonth, date.withDayOfMonth(1));
                if (mDiff < 0 || mDiff % interval != 0) return false;

                if ("DATE".equals(mType)) {
                    int day = batch.getMonthlyDay() != null ? batch.getMonthlyDay() : 1;
                    int realDay = Math.min(day, date.lengthOfMonth());
                    return date.getDayOfMonth() == realDay;
                } else { // WEEKDAY
                    int appWeekday = batch.getMonthlyWeekday() != null ? batch.getMonthlyWeekday() : 2;
                    int occurrence = batch.getMonthlyOccurrence() != null ? batch.getMonthlyOccurrence() : 1;
                    DayOfWeek target = appDowToJava(appWeekday);
                    LocalDate candidate = nthWeekdayOfMonth(date.getYear(), date.getMonthValue(), target, occurrence);
                    return date.equals(candidate);
                }
            }

            default:
                return false;
        }
    }

    // ── Private helpers ──

    private static Set<Integer> toSet(java.util.List<Integer> list) {
        Set<Integer> set = new HashSet<>();
        if (list != null) set.addAll(list);
        return set;
    }

    /** Chuyển hệ app (1=CN, 2=T2…7=T7) → Java DayOfWeek */
    public static DayOfWeek appDowToJava(int appDow) {
        switch (appDow) {
            case 1: return DayOfWeek.SUNDAY;
            case 2: return DayOfWeek.MONDAY;
            case 3: return DayOfWeek.TUESDAY;
            case 4: return DayOfWeek.WEDNESDAY;
            case 5: return DayOfWeek.THURSDAY;
            case 6: return DayOfWeek.FRIDAY;
            case 7: return DayOfWeek.SATURDAY;
            default: return DayOfWeek.MONDAY;
        }
    }

    /** Lấy ngày của lần xuất hiện thứ N (hoặc cuối cùng nếu occurrence=-1) của weekday trong tháng */
    public static LocalDate nthWeekdayOfMonth(int year, int month, DayOfWeek dow, int occurrence) {
        if (occurrence == -1) {
            LocalDate last = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1);
            while (last.getDayOfWeek() != dow) last = last.minusDays(1);
            return last;
        }
        LocalDate first = LocalDate.of(year, month, 1);
        while (first.getDayOfWeek() != dow) first = first.plusDays(1);
        LocalDate result = first.plusWeeks(occurrence - 1);
        return (result.getMonthValue() == month) ? result : null;
    }
}

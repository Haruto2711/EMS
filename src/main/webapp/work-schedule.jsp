<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc | EMS</title>
    <link rel="stylesheet" href="css/ems.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ── Sidebar ── -->
<%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

<!-- ── Main content ── -->
<div class="main-content">
    <div class="topbar">
        <span class="topbar-left">Lịch Làm Việc</span>
        <span class="topbar-right" id="topbar-date"></span>
    </div>

    <div class="page-body">
        <!-- Page header -->
        <div class="ws-page-header">
            <div class="ws-page-header-text">
                <h1>
                    <i class="fa-regular fa-calendar-days" style="color:var(--primary);"></i>
                    Lịch Làm Việc
                </h1>
                <p>Quản lý lịch làm việc mặc định theo tuần của công ty</p>
            </div>
            <div>
                <c:choose>
                    <c:when test="${hasSchedule}">
                        <button class="btn btn-primary" id="btnOpenModal" onclick="openModal('edit')">
                            <i class="fa-solid fa-pen-to-square"></i>
                            Chỉnh sửa lịch làm việc
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary" id="btnOpenModal" onclick="openModal('add')">
                            <i class="fa-solid fa-plus"></i>
                            Thêm lịch làm việc
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Main content -->
        <c:choose>
            <c:when test="${!hasSchedule}">
                <div class="empty-card" id="emptyState">
                    <div class="empty-icon">
                        <i class="fa-regular fa-calendar-xmark"></i>
                    </div>
                    <h2>Chưa có lịch làm việc</h2>
                    <p>Công ty chưa thiết lập lịch làm việc mặc định theo tuần. Nhấn nút bên dưới để bắt đầu cấu
                        hình.</p>
                    <button class="btn btn-primary" onclick="openModal('add')">
                        <i class="fa-solid fa-plus"></i>
                        Thêm lịch làm việc
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="schedule-card">
                    <div class="schedule-card-header">
                        <div class="schedule-card-header-left">
                            <span class="schedule-card-title">Lịch làm việc theo tuần</span>
                            <c:set var="workingCount" value="0"/>
                            <c:forEach var="shift" items="${shifts}">
                                <c:if test="${shift.working}">
                                    <c:set var="workingCount" value="${workingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            <span class="active-days-badge">
                <i class="fa-solid fa-check-circle"></i>
                ${workingCount} ngày làm việc / tuần
              </span>
                        </div>
                        <span style="font-size:0.8rem;color:var(--slate-400);">
              <i class="fa-regular fa-clock"></i> Cập nhật bởi Administrator
            </span>
                    </div>

                    <div style="overflow-x:auto;">
                        <table class="schedule-table">
                            <thead>
                            <tr>
                                <th>Ngày</th>
                                <th>Bắt Đầu</th>
                                <th>Kết Thúc</th>
                                <th>Nghỉ Trưa</th>
                                <th style="text-align:center;">Làm Việc</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="shift" items="${shifts}">
                                <tr class="${!shift.working ? 'inactive-row' : ''}">
                                    <td>
                    <span class="day-name">
                      <c:choose>
                          <c:when test="${shift.dayOfWeek == 2}">Thứ Hai</c:when>
                          <c:when test="${shift.dayOfWeek == 3}">Thứ Ba</c:when>
                          <c:when test="${shift.dayOfWeek == 4}">Thứ Tư</c:when>
                          <c:when test="${shift.dayOfWeek == 5}">Thứ Năm</c:when>
                          <c:when test="${shift.dayOfWeek == 6}">Thứ Sáu</c:when>
                          <c:when test="${shift.dayOfWeek == 7}">Thứ Bảy</c:when>
                          <c:when test="${shift.dayOfWeek == 1}">Chủ Nhật</c:when>
                          <c:otherwise>Ngày ${shift.dayOfWeek}</c:otherwise>
                      </c:choose>
                    </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${shift.working && shift.startTime != null}">
                        <span class="time-chip">
                          <i class="fa-regular fa-clock"></i> ${shift.startTime}
                        </span>
                                            </c:when>
                                            <c:otherwise><span class="dash-text">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${shift.working && shift.endTime != null}">
                        <span class="time-chip">
                          <i class="fa-regular fa-clock"></i> ${shift.endTime}
                        </span>
                                            </c:when>
                                            <c:otherwise><span class="dash-text">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${shift.working && shift.breakStart != null}">
                                                <div class="time-range">
                          <span class="time-chip">
                            <i class="fa-regular fa-clock"></i> ${shift.breakStart}
                          </span>
                                                    <span>–</span>
                                                    <span class="time-chip">
                            <i class="fa-regular fa-clock"></i> ${shift.breakEnd}
                          </span>
                                                </div>
                                            </c:when>
                                            <c:otherwise><span class="dash-text">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="toggle-display">
                                            <c:choose>
                                                <c:when test="${shift.working}">
                                                    <div class="toggle-on">
                                                        <div class="toggle-knob"></div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="toggle-off">
                                                        <div class="toggle-knob"></div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<!-- ── Modal ── -->
<div class="modal-overlay" id="scheduleModal">
    <div class="modal schedule-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">

        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-header-icon">
                    <i class="fa-regular fa-calendar-days" id="modalIcon"></i>
                </div>
                <div>
                    <div class="modal-title" id="modalTitle">Thêm lịch làm việc</div>
                    <div class="modal-subtitle">Thiết lập giờ làm việc mặc định theo từng ngày trong tuần</div>
                </div>
            </div>
            <button class="modal-close" onclick="closeModal()" aria-label="Đóng">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="modal-body">
            <form id="scheduleForm" action="${pageContext.request.contextPath}/work-schedule" method="post">
                <table class="form-table">
                    <thead>
                    <tr>
                        <th>Ngày</th>
                        <th>Bắt Đầu</th>
                        <th>Kết Thúc</th>
                        <th>Nghỉ Trưa</th>
                        <th>Làm Việc</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="dayNames" value="2,3,4,5,6,7,1"/>
                    <c:forEach var="i" begin="0" end="6">
                        <c:set var="currentDay" value="${i + 2 <= 7 ? i + 2 : 1}"/>
                        <c:set var="matchedShift" value="${null}"/>
                        <c:forEach var="s" items="${shifts}">
                            <c:if test="${s.dayOfWeek == currentDay}">
                                <c:set var="matchedShift" value="${s}"/>
                            </c:if>
                        </c:forEach>

                        <c:set var="isWorking" value="${matchedShift != null ? matchedShift.working : false}"/>
                        <c:set var="startTimeVal"
                               value="${matchedShift != null && matchedShift.startTime  != null ? matchedShift.startTime  : '08:00'}"/>
                        <c:set var="endTimeVal"
                               value="${matchedShift != null && matchedShift.endTime    != null ? matchedShift.endTime    : '17:00'}"/>
                        <c:set var="breakStartVal"
                               value="${matchedShift != null && matchedShift.breakStart != null ? matchedShift.breakStart : '12:00'}"/>
                        <c:set var="breakEndVal"
                               value="${matchedShift != null && matchedShift.breakEnd   != null ? matchedShift.breakEnd   : '13:00'}"/>

                        <tr id="row_${i}">
                            <td>
                                <input type="hidden" name="dayOfWeek_${i}" value="${currentDay}">
                                <span class="day-label ${!isWorking ? 'inactive-label' : ''}" id="dayLabel_${i}">
                  <c:choose>
                      <c:when test="${currentDay == 2}">Thứ Hai</c:when>
                      <c:when test="${currentDay == 3}">Thứ Ba</c:when>
                      <c:when test="${currentDay == 4}">Thứ Tư</c:when>
                      <c:when test="${currentDay == 5}">Thứ Năm</c:when>
                      <c:when test="${currentDay == 6}">Thứ Sáu</c:when>
                      <c:when test="${currentDay == 7}">Thứ Bảy</c:when>
                      <c:when test="${currentDay == 1}">Chủ Nhật</c:when>
                  </c:choose>
                </span>
                            </td>
                            <td>
                                <div class="time-input-wrap">
                                    <input type="time" name="startTime_${i}" id="startTime_${i}"
                                           value="${startTimeVal}" ${!isWorking ? 'disabled' : ''}>
                                </div>
                            </td>
                            <td>
                                <div class="time-input-wrap">
                                    <input type="time" name="endTime_${i}" id="endTime_${i}"
                                           value="${endTimeVal}" ${!isWorking ? 'disabled' : ''}>
                                </div>
                            </td>
                            <td>
                                <div class="break-range">
                                    <div class="time-input-wrap">
                                        <input type="time" name="breakStart_${i}" id="breakStart_${i}"
                                               value="${breakStartVal}" ${!isWorking ? 'disabled' : ''}>
                                    </div>
                                    <span class="break-sep">–</span>
                                    <div class="time-input-wrap">
                                        <input type="time" name="breakEnd_${i}" id="breakEnd_${i}"
                                               value="${breakEndVal}" ${!isWorking ? 'disabled' : ''}>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="switch-wrapper">
                                    <label class="switch">
                                        <input type="checkbox" name="working_${i}" value="true"
                                               id="toggle_${i}" ${isWorking ? 'checked' : ''}
                                               onchange="toggleRow(${i})">
                                        <span class="slider"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </form>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal()">
                <i class="fa-solid fa-xmark"></i> Hủy bỏ
            </button>
            <button type="button" class="btn btn-success" onclick="submitSchedule()">
                <i class="fa-solid fa-floppy-disk"></i> Lưu lịch làm việc
            </button>
        </div>
    </div>
</div>

<!-- ── Toast ── -->
<div class="toast" id="toast">
    <i class="fa-solid fa-circle-check"></i>
    <span>Lịch làm việc đã được lưu thành công!</span>
</div>

<script>
    /* Topbar date */
    (function () {
        var now = new Date(), p = function (n) {
            return String(n).padStart(2, '0');
        };
        document.getElementById('topbar-date').textContent =
            p(now.getDate()) + '/' + p(now.getMonth() + 1) + '/' + now.getFullYear();
    })();

    function toggleRow(index) {
        var checked = document.getElementById('toggle_' + index).checked;
        ['startTime_', 'endTime_', 'breakStart_', 'breakEnd_'].forEach(function (id) {
            var el = document.getElementById(id + index);
            if (el) el.disabled = !checked;
        });
        var label = document.getElementById('dayLabel_' + index);
        if (label) label.classList.toggle('inactive-label', !checked);
    }

    function openModal(mode) {
        var modal = document.getElementById('scheduleModal');
        var title = document.getElementById('modalTitle');
        var icon = document.getElementById('modalIcon');
        if (mode === 'edit') {
            title.textContent = 'Chỉnh sửa lịch làm việc';
            icon.className = 'fa-solid fa-pen-to-square';
        } else {
            title.textContent = 'Thêm lịch làm việc';
            icon.className = 'fa-regular fa-calendar-plus';
        }
        modal.classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('scheduleModal').classList.remove('open');
        document.body.style.overflow = '';
    }

    document.getElementById('scheduleModal').addEventListener('click', function (e) {
        if (e.target === this) closeModal();
    });

    function submitSchedule() {
        document.getElementById('scheduleForm').submit();
    }

    (function () {
        var params = new URLSearchParams(window.location.search);
        if (params.get('saved') === '1') {
            showToast();
            window.history.replaceState({}, '', window.location.pathname + window.location.hash);
        }
    })();

    function showToast() {
        var t = document.getElementById('toast');
        t.classList.add('show');
        setTimeout(function () {
            t.classList.remove('show');
        }, 3500);
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
</body>
</html>
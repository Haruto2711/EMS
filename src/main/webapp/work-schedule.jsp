<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE htm<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Làm Việc | EMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --primary-light: #eeeffe;
            --secondary: #06b6d4;
            --success: #10b981;
            --success-light: #d1fae5;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #0f172a;
            --slate-800: #1e293b;
            --slate-700: #334155;
            --slate-600: #475569;
            --slate-500: #64748b;
            --slate-400: #94a3b8;
            --slate-300: #cbd5e1;
            --slate-200: #e2e8f0;
            --slate-100: #f1f5f9;
            --slate-50: #f8fafc;
            --card-shadow: 0 10px 25px -5px rgba(15,23,42,0.05), 0 8px 10px -6px rgba(15,23,42,0.04);
            --card-shadow-hover: 0 20px 25px -5px rgba(79,70,229,0.1), 0 8px 10px -6px rgba(79,70,229,0.04);
            --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f4f6fb;
            color: var(--slate-800);
            line-height: 1.5;
            min-height: 100vh;
        }

        /* ── Navbar ── */
        .navbar {
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--slate-200);
            position: sticky;
            top: 0;
            z-index: 200;
            padding: 0.875rem 2rem;
        }
        .navbar-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }
        .brand-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: white; font-size: 1.15rem;
            box-shadow: 0 4px 12px rgba(79,70,229,0.3);
        }
        .brand-title { font-weight: 800; font-size: 1.2rem; color: var(--dark); letter-spacing: -0.02em; }
        .brand-badge {
            background: var(--primary-light); color: var(--primary);
            font-size: 0.7rem; font-weight: 700;
            padding: 0.2rem 0.5rem; border-radius: 6px; text-transform: uppercase;
        }
        .user-pill {
            display: flex; align-items: center; gap: 0.5rem;
            background: var(--slate-100); padding: 0.35rem 0.75rem;
            border-radius: 9999px; font-size: 0.875rem; font-weight: 600; color: var(--slate-700);
        }
        .user-avatar {
            width: 28px; height: 28px; background: var(--primary); color: white;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem; font-weight: 700;
        }

        /* ── Container ── */
        .container { max-width: 1200px; margin: 0 auto; padding: 2rem; }

        /* ── Page header ── */
        .page-header {
            margin-bottom: 2rem;
            display: flex; flex-wrap: wrap;
            align-items: center; justify-content: space-between; gap: 1rem;
        }
        .page-header-text h1 {
            font-size: 1.75rem; font-weight: 800; color: var(--dark);
            letter-spacing: -0.02em;
            display: flex; align-items: center; gap: 0.75rem;
        }
        .page-header-text p { color: var(--slate-500); font-size: 0.95rem; margin-top: 0.25rem; }

        /* ── Buttons ── */
        .btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            padding: 0.625rem 1.25rem;
            border-radius: 10px; font-weight: 600; font-size: 0.875rem;
            cursor: pointer; transition: var(--transition);
            border: 1px solid transparent; text-decoration: none; font-family: inherit;
        }
        .btn-primary {
            background-color: var(--primary); color: white;
            box-shadow: 0 4px 12px rgba(79,70,229,0.25);
        }
        .btn-primary:hover { background-color: var(--primary-hover); transform: translateY(-1px); }
        .btn-secondary {
            background-color: white; color: var(--slate-700);
            border-color: var(--slate-200);
            box-shadow: 0 2px 4px rgba(0,0,0,0.03);
        }
        .btn-secondary:hover { background-color: var(--slate-50); border-color: var(--slate-300); color: var(--dark); }
        .btn-success {
            background-color: var(--success); color: white;
            box-shadow: 0 4px 12px rgba(16,185,129,0.25);
        }
        .btn-success:hover { background-color: #059669; transform: translateY(-1px); }

        /* ── Empty state card ── */
        .empty-card {
            background: white; border-radius: 20px;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            padding: 5rem 2rem;
            text-align: center;
        }
        .empty-icon {
            width: 90px; height: 90px;
            background: linear-gradient(135deg, var(--primary-light), #e0f2fe);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: var(--primary);
            margin: 0 auto 1.5rem;
            box-shadow: 0 8px 20px rgba(79,70,229,0.15);
        }
        .empty-card h2 { font-size: 1.4rem; font-weight: 800; color: var(--dark); margin-bottom: 0.5rem; }
        .empty-card p { color: var(--slate-500); font-size: 0.95rem; max-width: 400px; margin: 0 auto 2rem; }

        /* ── Schedule display card ── */
        .schedule-card {
            background: white; border-radius: 20px;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }
        .schedule-card-header {
            padding: 1.25rem 1.75rem;
            border-bottom: 1px solid var(--slate-200);
            display: flex; align-items: center; justify-content: space-between;
            background: white;
        }
        .schedule-card-header-left {
            display: flex; align-items: center; gap: 0.75rem;
        }
        .schedule-card-title { font-weight: 700; font-size: 1.05rem; color: var(--dark); }
        .active-days-badge {
            background: var(--success-light); color: var(--success);
            font-size: 0.75rem; font-weight: 700;
            padding: 0.25rem 0.65rem; border-radius: 9999px;
        }

        /* ── Schedule table ── */
        .schedule-table { width: 100%; border-collapse: collapse; }
        .schedule-table th {
            background: var(--slate-50);
            color: var(--slate-500); font-weight: 700; font-size: 0.75rem;
            text-transform: uppercase; letter-spacing: 0.06em;
            padding: 0.875rem 1.5rem;
            border-bottom: 1px solid var(--slate-200);
            text-align: left;
        }
        .schedule-table th:last-child { text-align: center; }
        .schedule-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle; color: var(--slate-700);
            font-size: 0.875rem;
        }
        .schedule-table tbody tr:last-child td { border-bottom: none; }
        .schedule-table tbody tr { transition: var(--transition); }
        .schedule-table tbody tr:hover { background-color: var(--slate-50); }
        .schedule-table tbody tr.inactive-row { opacity: 0.55; }

        .day-name { font-weight: 700; color: var(--dark); font-size: 0.9rem; }
        .time-chip {
            display: inline-flex; align-items: center; gap: 0.4rem;
            background: var(--slate-100); color: var(--slate-700);
            padding: 0.3rem 0.7rem; border-radius: 8px;
            font-weight: 600; font-size: 0.825rem; font-variant-numeric: tabular-nums;
        }
        .time-chip i { color: var(--slate-400); font-size: 0.75rem; }
        .time-range {
            display: flex; align-items: center; gap: 0.4rem;
        }
        .time-range span { color: var(--slate-400); font-size: 0.75rem; }
        .dash-text { color: var(--slate-400); font-size: 1.2rem; font-weight: 300; }

        /* toggle read-only indicator */
        .toggle-display {
            display: flex; justify-content: center;
        }
        .toggle-on, .toggle-off {
            width: 46px; height: 26px; border-radius: 13px;
            display: flex; align-items: center;
            padding: 0 3px;
            position: relative;
        }
        .toggle-on { background: var(--primary); }
        .toggle-off { background: var(--slate-300); }
        .toggle-knob {
            width: 20px; height: 20px; border-radius: 50%;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
            position: absolute;
            transition: var(--transition);
        }
        .toggle-on .toggle-knob { right: 3px; }
        .toggle-off .toggle-knob { left: 3px; }

        /* ── Modal overlay ── */
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(15,23,42,0.55);
            backdrop-filter: blur(4px);
            z-index: 1000;
            align-items: center; justify-content: center;
            padding: 1rem;
        }
        .modal-overlay.open { display: flex; }

        .modal {
            background: white;
            border-radius: 20px;
            width: 100%; max-width: 900px;
            max-height: 90vh;
            overflow: hidden;
            display: flex; flex-direction: column;
            box-shadow: 0 25px 50px -12px rgba(15,23,42,0.25);
            animation: modalSlideIn 0.3s cubic-bezier(0.34,1.56,0.64,1);
        }
        @keyframes modalSlideIn {
            from { opacity: 0; transform: scale(0.92) translateY(20px); }
            to   { opacity: 1; transform: scale(1)   translateY(0); }
        }

        .modal-header {
            padding: 1.5rem 1.75rem;
            border-bottom: 1px solid var(--slate-200);
            display: flex; align-items: center; justify-content: space-between;
            flex-shrink: 0;
        }
        .modal-header-left { display: flex; align-items: center; gap: 0.75rem; }
        .modal-header-icon {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, var(--primary-light), #e0f2fe);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            color: var(--primary); font-size: 1.15rem;
        }
        .modal-title { font-size: 1.1rem; font-weight: 800; color: var(--dark); }
        .modal-subtitle { font-size: 0.8rem; color: var(--slate-500); margin-top: 0.1rem; }
        .modal-close {
            width: 36px; height: 36px; border-radius: 10px;
            background: var(--slate-100); border: none; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            color: var(--slate-600); font-size: 1rem;
            transition: var(--transition);
        }
        .modal-close:hover { background: var(--slate-200); color: var(--dark); }

        .modal-body {
            overflow-y: auto; flex: 1;
            padding: 0;
        }

        /* ── Schedule form table ── */
        .form-table { width: 100%; border-collapse: collapse; }
        .form-table th {
            background: var(--slate-50);
            color: var(--slate-500); font-weight: 700; font-size: 0.72rem;
            text-transform: uppercase; letter-spacing: 0.07em;
            padding: 0.875rem 1.25rem;
            border-bottom: 1px solid var(--slate-200);
            text-align: left;
            white-space: nowrap;
        }
        .form-table th:last-child { text-align: center; }
        .form-table td {
            padding: 0.875rem 1.25rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle;
        }
        .form-table tbody tr:last-child td { border-bottom: none; }
        .form-table tbody tr { transition: background 0.15s; }
        .form-table tbody tr:hover { background: var(--slate-50); }

        .day-label { font-weight: 700; font-size: 0.9rem; color: var(--dark); }
        .day-label.inactive-label { color: var(--slate-400); font-weight: 600; }

        /* Time input styled */
        .time-input-wrap {
            position: relative; display: inline-flex; align-items: center;
        }
        .time-input-wrap input[type="time"] {
            padding: 0.45rem 0.7rem 0.45rem 0.7rem;
            border: 1.5px solid var(--slate-200);
            border-radius: 10px;
            font-family: inherit; font-size: 0.875rem; font-weight: 600;
            color: var(--slate-800);
            background: var(--slate-50);
            transition: var(--transition);
            outline: none;
            cursor: pointer;
            min-width: 110px;
        }
        .time-input-wrap input[type="time"]:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px rgba(79,70,229,0.12);
        }
        .time-input-wrap input[type="time"]:disabled {
            background: var(--slate-100); color: var(--slate-400);
            border-color: var(--slate-200); cursor: not-allowed;
        }

        .break-range { display: flex; align-items: center; gap: 0.5rem; }
        .break-sep { color: var(--slate-400); font-size: 0.85rem; font-weight: 600; }

        /* Toggle switch (interactive) */
        .switch-wrapper {
            display: flex; justify-content: center;
        }
        .switch {
            position: relative; display: inline-block;
            width: 46px; height: 26px;
        }
        .switch input { opacity: 0; width: 0; height: 0; }
        .slider {
            position: absolute; cursor: pointer; inset: 0;
            background: var(--slate-300); border-radius: 13px;
            transition: 0.3s;
        }
        .slider::before {
            content: '';
            position: absolute;
            width: 20px; height: 20px; border-radius: 50%;
            left: 3px; bottom: 3px;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
            transition: 0.3s;
        }
        .switch input:checked + .slider { background: var(--primary); }
        .switch input:checked + .slider::before { transform: translateX(20px); }

        /* Modal footer */
        .modal-footer {
            padding: 1.25rem 1.75rem;
            border-top: 1px solid var(--slate-200);
            display: flex; align-items: center; justify-content: flex-end;
            gap: 0.75rem; flex-shrink: 0;
            background: var(--slate-50);
        }

        /* Success toast */
        .toast {
            position: fixed; bottom: 1.5rem; right: 1.5rem;
            background: white; border-radius: 14px;
            padding: 1rem 1.25rem;
            box-shadow: 0 10px 30px rgba(15,23,42,0.15);
            border-left: 4px solid var(--success);
            display: flex; align-items: center; gap: 0.75rem;
            font-size: 0.875rem; font-weight: 600; color: var(--dark);
            transform: translateY(80px); opacity: 0;
            transition: all 0.4s cubic-bezier(0.34,1.56,0.64,1);
            z-index: 2000;
        }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast i { color: var(--success); font-size: 1.1rem; }

        /* Responsive */
        @media (max-width: 768px) {
            .container { padding: 1rem; }
            .modal { border-radius: 16px; }
            .page-header { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>

<!-- ── Navbar ── -->
<nav class="navbar">
    <div class="navbar-container">
        <a href="${pageContext.request.contextPath}/" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
            <span class="brand-title">EMS System</span>
            <span class="brand-badge">HR Portal</span>
        </a>
        <div class="user-pill">
            <div class="user-avatar">HR</div>
            <span>Administrator</span>
        </div>
    </div>
</nav>

<main class="container">

    <!-- ── Page header ── -->
    <header class="page-header">
        <div class="page-header-text">
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
    </header>

    <!-- ── Main content ── -->
    <c:choose>
        <c:when test="${!hasSchedule}">
            <!-- Empty state -->
            <div class="empty-card" id="emptyState">
                <div class="empty-icon">
                    <i class="fa-regular fa-calendar-xmark"></i>
                </div>
                <h2>Chưa có lịch làm việc</h2>
                <p>Công ty chưa thiết lập lịch làm việc mặc định theo tuần. Nhấn nút bên dưới để bắt đầu cấu hình.</p>
                <button class="btn btn-primary" onclick="openModal('add')">
                    <i class="fa-solid fa-plus"></i>
                    Thêm lịch làm việc
                </button>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Schedule display -->
            <div class="schedule-card">
                <div class="schedule-card-header">
                    <div class="schedule-card-header-left">
                        <span class="schedule-card-title">Lịch làm việc theo tuần</span>
                            <%-- Count working days --%>
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
                                                    <i class="fa-regular fa-clock"></i>
                                                    ${shift.startTime}
                                                </span>
                                        </c:when>
                                        <c:otherwise><span class="dash-text">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${shift.working && shift.endTime != null}">
                                                <span class="time-chip">
                                                    <i class="fa-regular fa-clock"></i>
                                                    ${shift.endTime}
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
                                                        <i class="fa-regular fa-clock"></i>
                                                        ${shift.breakStart}
                                                    </span>
                                                <span>–</span>
                                                <span class="time-chip">
                                                        <i class="fa-regular fa-clock"></i>
                                                        ${shift.breakEnd}
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
                                                <div class="toggle-on"><div class="toggle-knob"></div></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="toggle-off"><div class="toggle-knob"></div></div>
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

</main>

<!-- ── Modal ── -->
<div class="modal-overlay" id="scheduleModal">
    <div class="modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">

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
                    <%-- Default 7 days data, prefilled from shifts if available --%>
                    <c:set var="dayNames" value="2,3,4,5,6,7,1"/>
                    <c:forEach var="i" begin="0" end="6">
                        <c:set var="currentDay" value="${i + 2 <= 7 ? i + 2 : 1}"/>
                        <%-- Find matching shift --%>
                        <c:set var="matchedShift" value="${null}"/>
                        <c:forEach var="s" items="${shifts}">
                            <c:if test="${s.dayOfWeek == currentDay}">
                                <c:set var="matchedShift" value="${s}"/>
                            </c:if>
                        </c:forEach>

                        <c:set var="isWorking" value="${matchedShift != null ? matchedShift.working : false}"/>
                        <c:set var="startTimeVal" value="${matchedShift != null && matchedShift.startTime != null ? matchedShift.startTime : '08:00'}"/>
                        <c:set var="endTimeVal" value="${matchedShift != null && matchedShift.endTime != null ? matchedShift.endTime : '17:00'}"/>
                        <c:set var="breakStartVal" value="${matchedShift != null && matchedShift.breakStart != null ? matchedShift.breakStart : '12:00'}"/>
                        <c:set var="breakEndVal" value="${matchedShift != null && matchedShift.breakEnd != null ? matchedShift.breakEnd : '13:00'}"/>

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
                                    <input type="time" name="startTime_${i}"
                                           id="startTime_${i}"
                                           value="${startTimeVal}"
                                        ${!isWorking ? 'disabled' : ''}>
                                </div>
                            </td>
                            <td>
                                <div class="time-input-wrap">
                                    <input type="time" name="endTime_${i}"
                                           id="endTime_${i}"
                                           value="${endTimeVal}"
                                        ${!isWorking ? 'disabled' : ''}>
                                </div>
                            </td>
                            <td>
                                <div class="break-range">
                                    <div class="time-input-wrap">
                                        <input type="time" name="breakStart_${i}"
                                               id="breakStart_${i}"
                                               value="${breakStartVal}"
                                            ${!isWorking ? 'disabled' : ''}>
                                    </div>
                                    <span class="break-sep">–</span>
                                    <div class="time-input-wrap">
                                        <input type="time" name="breakEnd_${i}"
                                               id="breakEnd_${i}"
                                               value="${breakEndVal}"
                                            ${!isWorking ? 'disabled' : ''}>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="switch-wrapper">
                                    <label class="switch">
                                        <input type="checkbox"
                                               name="working_${i}"
                                               value="true"
                                               id="toggle_${i}"
                                            ${isWorking ? 'checked' : ''}
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
    /* ── Toggle row enable/disable ── */
    function toggleRow(index) {
        const checked = document.getElementById('toggle_' + index).checked;
        const ids = ['startTime_', 'endTime_', 'breakStart_', 'breakEnd_'];
        ids.forEach(function(id) {
            const el = document.getElementById(id + index);
            if (el) el.disabled = !checked;
        });
        const label = document.getElementById('dayLabel_' + index);
        if (label) {
            label.classList.toggle('inactive-label', !checked);
        }
    }

    /* ── Open modal ── */
    function openModal(mode) {
        const modal = document.getElementById('scheduleModal');
        const title = document.getElementById('modalTitle');
        const icon  = document.getElementById('modalIcon');
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

    /* ── Close modal ── */
    function closeModal() {
        document.getElementById('scheduleModal').classList.remove('open');
        document.body.style.overflow = '';
    }

    /* ── Close on backdrop click ── */
    document.getElementById('scheduleModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    /* ── Submit form ── */
    function submitSchedule() {
        document.getElementById('scheduleForm').submit();
    }

    /* ── Show toast if redirected after save ── */
    (function() {
        var params = new URLSearchParams(window.location.search);
        if (params.get('saved') === '1') {
            showToast();
            // Clean URL
            var url = window.location.pathname + window.location.hash;
            window.history.replaceState({}, '', url);
        }
    })();

    function showToast() {
        var t = document.getElementById('toast');
        t.classList.add('show');
        setTimeout(function() { t.classList.remove('show'); }, 3500);
    }

    /* ── Keyboard: ESC closes modal ── */
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
</form>
</body>
</html>
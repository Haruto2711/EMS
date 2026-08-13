<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ngày Nghỉ Lễ | EMS</title>
    <meta name="description" content="Quản lý danh sách ngày nghỉ lễ theo quy định nhà nước">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary:        #4f46e5;
            --primary-hover:  #4338ca;
            --primary-light:  #eeeffe;
            --secondary:      #06b6d4;
            --success:        #10b981;
            --success-light:  #d1fae5;
            --warning:        #f59e0b;
            --warning-light:  #fef3c7;
            --info:           #3b82f6;
            --info-light:     #dbeafe;
            --danger:         #ef4444;
            --danger-light:   #fee2e2;
            --dark:           #0f172a;
            --slate-800:      #1e293b;
            --slate-700:      #334155;
            --slate-600:      #475569;
            --slate-500:      #64748b;
            --slate-400:      #94a3b8;
            --slate-300:      #cbd5e1;
            --slate-200:      #e2e8f0;
            --slate-100:      #f1f5f9;
            --slate-50:       #f8fafc;
            --card-shadow:    0 10px 25px -5px rgba(15,23,42,0.05), 0 8px 10px -6px rgba(15,23,42,0.04);
            --transition:     all 0.25s cubic-bezier(0.4,0,0.2,1);
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
            position: sticky; top: 0; z-index: 200;
            padding: 0.875rem 2rem;
        }
        .navbar-container {
            max-width: 1200px; margin: 0 auto;
            display: flex; align-items: center; justify-content: space-between;
        }
        .brand {
            display: flex; align-items: center; gap: 0.75rem;
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

        /* ── Alert error ── */
        .alert-error {
            display: flex; align-items: center; gap: 0.75rem;
            background: var(--danger-light); border: 1px solid #fca5a5;
            border-radius: 12px; padding: 1rem 1.25rem;
            color: #b91c1c; font-size: 0.875rem; font-weight: 600;
            margin-bottom: 1.5rem;
        }

        /* ── Holiday card / table ── */
        .holiday-card {
            background: white; border-radius: 20px;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .holiday-table { width: 100%; border-collapse: collapse; }
        .holiday-table th {
            background: var(--slate-50);
            color: var(--slate-500); font-weight: 700; font-size: 0.75rem;
            text-transform: uppercase; letter-spacing: 0.06em;
            padding: 0.875rem 1.5rem;
            border-bottom: 1px solid var(--slate-200);
            text-align: left;
        }
        .holiday-table th.center { text-align: center; }
        .holiday-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle; color: var(--slate-700);
            font-size: 0.875rem;
        }
        .holiday-table tbody tr:last-child td { border-bottom: none; }
        .holiday-table tbody tr { transition: var(--transition); }
        .holiday-table tbody tr:hover { background-color: var(--slate-50); }

        .stt-cell { color: var(--slate-400); font-size: 0.8rem; font-weight: 700; }
        .holiday-name { font-weight: 700; color: var(--dark); font-size: 0.9rem; }
        .date-range {
            display: inline-flex; align-items: center; gap: 0.35rem;
            font-variant-numeric: tabular-nums; color: var(--slate-600);
        }
        .date-range i { color: var(--slate-400); font-size: 0.75rem; }

        /* Days badge */
        .days-badge {
            display: inline-flex; align-items: center; gap: 0.3rem;
            font-size: 0.82rem;
        }
        .days-badge strong { color: var(--dark); font-size: 0.9rem; }

        /* Status badges */
        .badge {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.3rem 0.8rem; border-radius: 9999px;
            font-size: 0.78rem; font-weight: 700; white-space: nowrap;
        }
        .badge-upcoming {
            background: var(--warning-light); color: #92400e;
        }
        .badge-ongoing {
            background: var(--info-light); color: #1e40af;
        }
        .badge-passed {
            background: var(--success-light); color: #065f46;
        }

        /* ── Card footer totals ── */
        .card-footer {
            padding: 0.875rem 1.5rem;
            border-top: 1px solid var(--slate-200);
            background: var(--slate-50);
            font-size: 0.82rem; color: var(--slate-500);
        }
        .card-footer strong { color: var(--dark); }

        /* ── Empty state ── */
        .empty-card {
            background: white; border-radius: 20px;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            padding: 5rem 2rem; text-align: center;
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
        .empty-card p  { color: var(--slate-500); font-size: 0.95rem; max-width: 400px; margin: 0 auto 2rem; }

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
            background: white; border-radius: 20px;
            width: 100%; max-width: 520px;
            box-shadow: 0 25px 50px -12px rgba(15,23,42,0.25);
            animation: modalSlideIn 0.3s cubic-bezier(0.34,1.56,0.64,1);
            overflow: hidden;
        }
        @keyframes modalSlideIn {
            from { opacity: 0; transform: scale(0.92) translateY(20px); }
            to   { opacity: 1; transform: scale(1)   translateY(0); }
        }

        .modal-header {
            padding: 1.5rem 1.75rem;
            border-bottom: 1px solid var(--slate-200);
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-header-left { display: flex; align-items: center; gap: 0.75rem; }
        .modal-header-icon {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, var(--primary-light), #e0f2fe);
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            color: var(--primary); font-size: 1.15rem;
        }
        .modal-title    { font-size: 1.1rem; font-weight: 800; color: var(--dark); }
        .modal-subtitle { font-size: 0.8rem; color: var(--slate-500); margin-top: 0.1rem; }
        .modal-close {
            width: 36px; height: 36px; border-radius: 10px;
            background: var(--slate-100); border: none; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            color: var(--slate-600); font-size: 1rem; transition: var(--transition);
        }
        .modal-close:hover { background: var(--slate-200); color: var(--dark); }

        .modal-body { padding: 1.75rem; }

        /* ── Form fields ── */
        .form-group { margin-bottom: 1.25rem; }
        .form-label {
            display: block; font-size: 0.82rem; font-weight: 700;
            color: var(--slate-600); margin-bottom: 0.45rem;
            text-transform: uppercase; letter-spacing: 0.04em;
        }
        .form-control {
            width: 100%;
            padding: 0.6rem 0.875rem;
            border: 1.5px solid var(--slate-200);
            border-radius: 10px;
            font-family: inherit; font-size: 0.9rem; color: var(--slate-800);
            background: var(--slate-50);
            transition: var(--transition); outline: none;
        }
        .form-control:focus {
            border-color: var(--primary);
            background: white;
            box-shadow: 0 0 0 3px rgba(79,70,229,0.12);
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-hint { font-size: 0.78rem; color: var(--slate-400); margin-top: 0.35rem; }

        /* Modal footer */
        .modal-footer {
            padding: 1.25rem 1.75rem;
            border-top: 1px solid var(--slate-200);
            display: flex; align-items: center; justify-content: flex-end;
            gap: 0.75rem;
            background: var(--slate-50);
        }

        /* ── Toast ── */
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

        /* ── Responsive ── */
        @media (max-width: 768px) {
            .container { padding: 1rem; }
            .modal { border-radius: 16px; }
            .page-header { flex-direction: column; align-items: flex-start; }
            .form-row { grid-template-columns: 1fr; }
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
                <i class="fa-regular fa-calendar-heart" style="color:var(--primary);"></i>
                Danh sách ngày nghỉ lễ
            </h1>
            <p>Cập nhật ngày nghỉ lễ theo quy định nhà nước năm 2026.</p>
        </div>
        <button id="btnOpenModal" class="btn btn-primary" onclick="openModal()">
            <i class="fa-solid fa-plus"></i>
            Thêm ngày nghỉ
        </button>
    </header>

    <!-- ── Error alert ── -->
    <c:if test="${not empty errorMsg}">
        <div class="alert-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>${errorMsg}</span>
        </div>
    </c:if>

    <!-- ── Main content ── -->
    <c:choose>
        <c:when test="${empty holidays}">
            <div class="empty-card">
                <div class="empty-icon">
                    <i class="fa-regular fa-calendar-xmark"></i>
                </div>
                <h2>Chưa có ngày nghỉ lễ</h2>
                <p>Chưa có ngày nghỉ lễ nào được thêm vào hệ thống. Nhấn nút bên dưới để bắt đầu thêm.</p>
                <button class="btn btn-primary" onclick="openModal()">
                    <i class="fa-solid fa-plus"></i>
                    Thêm ngày nghỉ
                </button>
            </div>
        </c:when>
        <c:otherwise>
            <%-- Tính tổng số lượng ngày nghỉ lễ --%>
            <c:set var="totalHolidayDays" value="${0}"/>
            <c:forEach var="h" items="${holidays}">
                <c:set var="totalHolidayDays" value="${totalHolidayDays + h.totalDays}"/>
            </c:forEach>

            <div class="holiday-card">
                <div style="overflow-x:auto;">
                    <table class="holiday-table" id="holidayTable">
                        <thead>
                        <tr>
                            <th style="width:60px;">STT</th>
                            <th>Tên Ngày Nghỉ</th>
                            <th>Ngày</th>
                            <th class="center">Số Ngày</th>
                            <th class="center">Trạng Thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="h" items="${holidays}" varStatus="loop">
                            <%-- Determine status via JS data attributes; use JSTL to embed dates --%>
                            <tr
                                data-start="${h.startdate}"
                                data-end="${h.enddate}"
                            >
                                <td class="stt-cell"><fmt:formatNumber value="${loop.index + 1}" pattern="00"/></td>
                                <td><span class="holiday-name">${h.holidayname}</span></td>
                                <td>
                                    <%-- LocalDate.toString() = "YYYY-MM-DD"; reformat to dd/MM/yyyy --%>
                                    <c:set var="sd" value="${h.startdate}"/><%-- e.g. 2026-01-01 --%>
                                    <c:set var="ed" value="${h.enddate}"/>
                                    <c:set var="sdFmt" value="${fn:substring(sd,8,10)}/${fn:substring(sd,5,7)}/${fn:substring(sd,0,4)}"/>
                                    <c:set var="edFmt" value="${fn:substring(ed,8,10)}/${fn:substring(ed,5,7)}/${fn:substring(ed,0,4)}"/>
                                    <span class="date-range">
                                        <i class="fa-regular fa-calendar"></i>
                                        <c:choose>
                                            <c:when test="${sd == ed}">${sdFmt}</c:when>
                                            <c:otherwise>${fn:substring(sd,8,10)}/${fn:substring(sd,5,7)}–${edFmt}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td class="center">
                                    <span class="days-badge">
                                        <strong>${h.totalDays}</strong> ngày
                                    </span>
                                </td>
                                <td class="center">
                                    <span class="badge status-badge">...</span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    Tổng: <strong>${fn:length(holidays)} ngày nghỉ</strong> &mdash; <strong>${totalHolidayDays} ngày</strong> trong năm
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</main>

<!-- ── Modal thêm ngày nghỉ ── -->
<div class="modal-overlay" id="holidayModal">
    <div class="modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">

        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-header-icon">
                    <i class="fa-regular fa-calendar-plus"></i>
                </div>
                <div>
                    <div class="modal-title" id="modalTitle">Thêm ngày nghỉ lễ</div>
                    <div class="modal-subtitle">Điền thông tin ngày nghỉ lễ mới</div>
                </div>
            </div>
            <button class="modal-close" onclick="closeModal()" aria-label="Đóng">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="modal-body">
            <form id="holidayForm" action="${pageContext.request.contextPath}/holiday" method="post" novalidate>
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label class="form-label" for="fieldName">Tên ngày lễ</label>
                    <input
                        type="text"
                        id="fieldName"
                        name="name"
                        class="form-control"
                        placeholder="Ví dụ: Tết Dương Lịch"
                        required
                        maxlength="200"
                    >
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="fieldStartDate">Ngày bắt đầu</label>
                        <input
                            type="date"
                            id="fieldStartDate"
                            name="startDate"
                            class="form-control"
                            required
                        >
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="fieldEndDate">Ngày kết thúc</label>
                        <input
                            type="date"
                            id="fieldEndDate"
                            name="endDate"
                            class="form-control"
                            required
                        >
                        <div class="form-hint" id="daysPreview"></div>
                    </div>
                </div>
            </form>
        </div>

        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeModal()">
                <i class="fa-solid fa-xmark"></i> Hủy bỏ
            </button>
            <button type="button" class="btn btn-success" onclick="submitHoliday()" id="btnSubmit">
                <i class="fa-solid fa-floppy-disk"></i> Lưu ngày nghỉ
            </button>
        </div>
    </div>
</div>

<!-- ── Toast ── -->
<div class="toast" id="toast">
    <i class="fa-solid fa-circle-check"></i>
    <span>Ngày nghỉ lễ đã được thêm thành công!</span>
</div>

<script>
    /* ── Helpers ── */
    function parseLocalDate(str) {
        // str is "YYYY-MM-DD" from data attributes
        const parts = str.split('-');
        return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
    }

    /* ── Render status badges ── */
    function renderStatuses() {
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        document.querySelectorAll('#holidayTable tbody tr[data-start]').forEach(function(row) {
            const startStr = row.getAttribute('data-start');
            const endStr   = row.getAttribute('data-end');
            const start    = parseLocalDate(startStr);
            const end      = parseLocalDate(endStr);
            end.setHours(23, 59, 59, 999);

            const badge = row.querySelector('.status-badge');
            if (!badge) return;

            if (today < start) {
                badge.className = 'badge badge-upcoming status-badge';
                badge.innerHTML = '<i class="fa-regular fa-clock"></i> Sắp diễn ra';
            } else if (today > end) {
                badge.className = 'badge badge-passed status-badge';
                badge.innerHTML = '<i class="fa-solid fa-check"></i> Đã diễn ra';
            } else {
                badge.className = 'badge badge-ongoing status-badge';
                badge.innerHTML = '<i class="fa-solid fa-circle-dot"></i> Đang diễn ra';
            }
        });
    }

    /* ── Days preview in modal ── */
    function updateDaysPreview() {
        const startVal = document.getElementById('fieldStartDate').value;
        const endVal   = document.getElementById('fieldEndDate').value;
        const hint     = document.getElementById('daysPreview');
        if (startVal && endVal) {
            const start = new Date(startVal);
            const end   = new Date(endVal);
            if (end >= start) {
                const days = Math.round((end - start) / 86400000) + 1;
                hint.textContent = '\u2192 ' + days + ' ngày nghỉ';
                hint.style.color = 'var(--success)';
            } else {
                hint.textContent = 'Ngày kết thúc phải từ ngày bắt đầu trở đi';
                hint.style.color = 'var(--danger)';
            }
        } else {
            hint.textContent = '';
        }
    }

    document.getElementById('fieldStartDate').addEventListener('change', function() {
        // Auto-set endDate min + preview
        const endField = document.getElementById('fieldEndDate');
        endField.min = this.value;
        if (endField.value && endField.value < this.value) {
            endField.value = this.value;
        }
        updateDaysPreview();
    });
    document.getElementById('fieldEndDate').addEventListener('change', updateDaysPreview);

    /* ── Modal ── */
    function openModal() {
        document.getElementById('holidayModal').classList.add('open');
        document.body.style.overflow = 'hidden';
        setTimeout(function() { document.getElementById('fieldName').focus(); }, 100);
    }

    function closeModal() {
        document.getElementById('holidayModal').classList.remove('open');
        document.body.style.overflow = '';
    }

    document.getElementById('holidayModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });

    /* ── Submit ── */
    function submitHoliday() {
        const name      = document.getElementById('fieldName').value.trim();
        const startDate = document.getElementById('fieldStartDate').value;
        const endDate   = document.getElementById('fieldEndDate').value;

        if (!name) {
            document.getElementById('fieldName').focus();
            document.getElementById('fieldName').style.borderColor = 'var(--danger)';
            return;
        }
        if (!startDate) {
            document.getElementById('fieldStartDate').focus();
            document.getElementById('fieldStartDate').style.borderColor = 'var(--danger)';
            return;
        }
        if (!endDate) {
            document.getElementById('fieldEndDate').focus();
            document.getElementById('fieldEndDate').style.borderColor = 'var(--danger)';
            return;
        }
        if (endDate < startDate) {
            document.getElementById('fieldEndDate').style.borderColor = 'var(--danger)';
            document.getElementById('daysPreview').textContent = 'Ngày kết thúc phải từ ngày bắt đầu trở đi';
            document.getElementById('daysPreview').style.color = 'var(--danger)';
            return;
        }

        document.getElementById('btnSubmit').disabled = true;
        document.getElementById('holidayForm').submit();
    }

    /* ── Toast on redirect ── */
    (function() {
        var params = new URLSearchParams(window.location.search);
        if (params.get('saved') === '1') {
            showToast();
            window.history.replaceState({}, '', window.location.pathname);
        }
    })();

    function showToast() {
        var t = document.getElementById('toast');
        t.classList.add('show');
        setTimeout(function() { t.classList.remove('show'); }, 3500);
    }

    /* ── Init ── */
    renderStatuses();
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>EMS – Xem trước dữ liệu chấm công</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/ems.css"/>
    <style>
        /* Tùy biến bảng và trạng thái phù hợp phong cách EMS */
        .preview-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 14px;
        }
        .preview-table th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
        }
        .preview-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }
        .preview-table tr:hover {
            background-color: #f8fafc;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-danger {
            background-color: #fee2e2;
            color: #dc2626;
        }
        .badge-success {
            background-color: #d1fae5;
            color: #059669;
        }
        .btn-action-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 20px;
        }
        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            background: #1e3a8a;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-primary:hover {
            background: #172554;
        }
        .btn-secondary {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 9px 18px;
            background: #ffffff;
            color: #475569;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-secondary:hover {
            background: #f8fafc;
            color: #0f172a;
        }
        .alert-danger {
            background-color: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
    </style>
</head>

<body>

<aside class="sidebar">

    <a href="${pageContext.request.contextPath}/home"
       class="sidebar-brand">
        <div class="brand-dot">E</div>
        <span class="brand-name">EMS</span>
    </a>

    <nav class="nav-group">

        <div class="nav-section-label">Menu chính</div>

         <a href="${pageContext.request.contextPath}/home_manager.jsp"
                       class="nav-link ${pageContext.request.servletPath == '/home_manager.jsp' ? 'active' : ''}">
                        Trang chủ
                    </a>
                    <div class="nav-section-label">Quản lý</div>
                    <a href="${pageContext.request.contextPath}/work-schedule"
                       class="nav-link ${pageContext.request.servletPath == '/work-schedule.jsp' ? 'active' : ''}">
                        Lịch làm việc
                    </a>
                    <a href="${pageContext.request.contextPath}/requests?action=pending"
                                   class="nav-link ${pageContext.request.servletPath == '/request-manager.jsp' ? 'active' : ''}">
                                    Xử lý đơn
                                </a>
                    <a href="${pageContext.request.contextPath}/holiday"
                       class="nav-link ${pageContext.request.servletPath == '/holiday.jsp' ? 'active' : ''}">
                        Quản lý ngày nghỉ lễ
                    </a>

                    <a href="${pageContext.request.contextPath}/shift-management"
                       class="nav-link ${pageContext.request.servletPath == '/shift-management.jsp' ? 'active' : ''}">
                        Ca làm việc
                    </a>

                    <a href="${pageContext.request.contextPath}/shift-assignment"
                       class="nav-link ${pageContext.request.servletPath == '/shift-assignment.jsp' ? 'active' : ''}">
                        Phân ca làm việc
                    </a>

                    <a href="${pageContext.request.contextPath}/salary-management"
                       class="nav-link ${pageContext.request.servletPath == '/salary-management.jsp' ? 'active' : ''}">
                        Quản lý lương
                    </a>
                    <a href="${pageContext.request.contextPath}/Attendance/upload.jsp"
                                   class="nav-link ${pageContext.request.servletPath == '/Attendance/attendance.jsp' ? 'active' : ''}">
                                    Quản lý chấm công
                      </a>

    </nav>

    <div class="sidebar-footer">

        <div class="user-block">
            <div class="user-avatar">
                M
            </div>

            <div>
                <div class="user-name">Manager</div>
                <div class="user-role">Quản lý</div>
            </div>
        </div>

        <button class="btn-logout"
                onclick="window.location='${pageContext.request.contextPath}/login'">
            Đăng xuất
        </button>

    </div>

</aside>

<div class="main-content">

    <div class="topbar">
        <span class="topbar-left">Chấm công</span>

        <div>
            <span class="topbar-right" id="topbar-date"></span>
        </div>
    </div>

    <div class="page-body">

        <div class="page-header" style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1>Xem trước dữ liệu chấm công</h1>
                <p>
                    Đã đọc <strong>${sessionScope.previewList.size()}</strong> dòng từ file Excel. Kiểm tra lại trước khi xác nhận lưu.
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/Attendance/upload.jsp" class="btn-secondary">
                ↻ Upload lại file khác
            </a>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert-danger">
                ⚠ <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="card" style="padding: 0; overflow: hidden;">
            <div class="card-header">
                Danh sách chi tiết
            </div>

            <div style="overflow-x: auto;">
                <table class="preview-table">
                    <thead>
                        <tr>
                            <th>Ngày</th>
                            <th>Mã NV</th>
                            <th>Họ và Tên</th>
                            <th>Phòng ban</th>
                            <th>Check in</th>
                            <th>Check out</th>
                            <th>Trạng thái</th>
                             <th>Chỉnh sửa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty sessionScope.previewList}">
                                <c:forEach var="r" items="${sessionScope.previewList}">
                                    <tr>
                                        <td>${r.date}</td>
                                        <td style="font-weight: 600; color: #1e293b;">${r.employeeCode}</td>
                                        <td>${r.fullName}</td>
                                        <td style="color: #64748b;">${r.department}</td>
                                        <td>${r.checkIn}</td>
                                        <td>${r.checkOut}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.lateMinutes > 0}">
                                                    <span class="badge badge-danger">Muộn ${r.lateMinutes} phút</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-success">Đúng giờ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                                <a href="${pageContext.request.contextPath}/Attendance/edit?code=${r.employeeCode}&date=${r.date}"
                                                   class="btn-edit">
                                                    ✏ Sửa
                                                </a>
                                            </td>

                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 40px; color: #94a3b8;">
                                        Không có dữ liệu hiển thị.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="btn-action-group">
            <form action="${pageContext.request.contextPath}/Attendance/confirm" method="post" style="margin:0;">
                <button type="submit" class="btn-primary">
                    ✓ Xác nhận lưu vào hệ thống
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/export-excel"
                               style="
                               display:inline-block;
                               padding:10px 18px;
                               background:#059669;
                               color:white;
                               border-radius:8px;
                               text-decoration:none;
                               font-weight:600;
                               ">
                                ↓ Export Excel
                            </a>
            <a href="${pageContext.request.contextPath}/Attendance/upload.jsp" class="btn-secondary" style="border-color: transparent;">
                Hủy bỏ
            </a>
        </div>

    </div>

    <footer>
        © 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391
    </footer>

</div>

<script>
    function tick() {
        var now = new Date();
        var p = function(n) {
            return String(n).padStart(2, '0');
        };
        var element = document.getElementById('topbar-date');
        if (element) {
            element.textContent =
                p(now.getDate()) + '/' +
                p(now.getMonth() + 1) + '/' +
                now.getFullYear();
        }
    }
    tick();
</script>

</body>
</html>
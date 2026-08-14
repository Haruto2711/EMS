<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String username = (String) currentSession.getAttribute("username");
    String role = (String) currentSession.getAttribute("role");
    String displayName = username != null ? username : "Nhân viên";
    String initial = displayName.isEmpty() ? "N" : displayName.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EMS – Gửi yêu cầu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ems.css">
    <style>
        .request-card { max-width: 920px; }
        .request-card-body { padding: 22px; }
        .request-form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .request-field { display: flex; flex-direction: column; gap: 7px; }
        .request-field.full { grid-column: 1 / -1; }
        .request-field label { color: #374151; font-size: 13px; font-weight: 600; }
        .required { color: #dc2626; }
        .request-field input, .request-field select, .request-field textarea {
            width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 8px;
            background: #fff; color: #111827; font: inherit;
        }
        .request-field input:focus, .request-field select:focus, .request-field textarea:focus {
            outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
        }
        .request-field textarea { min-height: 120px; resize: vertical; }
        .request-field input[readonly] { background: #f9fafb; color: #6b7280; }
        .request-notice { margin-top: 18px; padding: 12px 14px; border: 1px solid #bfdbfe; border-radius: 8px; background: #eff6ff; color: #1e40af; font-size: 13px; }
        .request-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 22px; padding-top: 18px; border-top: 1px solid #e5e7eb; }
        @media (max-width: 768px) {
            .sidebar { position: static; width: 100%; min-height: auto; }
            .main-content { margin-left: 0; }
            body { display: block; }
            .request-form-grid { grid-template-columns: 1fr; }
            .request-field.full { grid-column: auto; }
            .page-body { padding: 20px 16px; }
        }
    </style>
</head>
<body>
<aside class="sidebar">
    <a href="<%= request.getContextPath() %>/home" class="sidebar-brand">
        <div class="brand-dot">E</div>
        <span class="brand-name">EMS</span>
    </a>
    <nav class="nav-group">
        <div class="nav-section-label">Menu chính</div>
        <a href="<%= request.getContextPath() %>/home" class="nav-link">Trang chủ</a>
        <a href="#" class="nav-link">Lịch trình</a>
        <div class="nav-section-label">Công việc</div>
        <a href="<%= request.getContextPath() %>/request.jsp" class="nav-link active">Yêu cầu</a>
        <a href="#" class="nav-link">Bảng lương</a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-block">
            <div class="user-avatar"><%= initial %></div>
            <div>
                <div class="user-name"><%= displayName %></div>
                <div class="user-role"><%= role != null ? role : "Nhân viên" %></div>
            </div>
        </div>
        <button class="btn-logout" onclick="window.location='<%= request.getContextPath() %>/login'">Đăng xuất</button>
    </div>
</aside>

<div class="main-content">
    <div class="topbar">
        <span class="topbar-left">Yêu cầu</span>
        <span class="topbar-right" id="topbar-date"></span>
    </div>

    <main class="page-body">
        <div class="page-header">
            <h1>Gửi yêu cầu</h1>
            <p>Tạo và gửi yêu cầu đến quản lý để được phê duyệt.</p>
        </div>

        <section class="card request-card">
            <div class="card-header">Thông tin yêu cầu</div>
            <div class="request-card-body">
                <form action="<%= request.getContextPath() %>/requests" method="post">
                    <input type="hidden" name="action" value="insert">
                    <div class="request-form-grid">
                        <div class="request-field">
                            <label for="requestTypeId">Loại đơn <span class="required">*</span></label>
                            <select id="requestTypeId" name="requestTypeId" required>
                                <option value="">-- Chọn loại đơn --</option>
                                <option value="1">Nghỉ phép</option>
                                <option value="2">Nghỉ ốm</option>
                                <option value="3">Làm việc từ xa</option>
                                <option value="4">Đi công tác</option>
                                <option value="5">Tăng ca</option>
                            </select>
                        </div>
                        <div class="request-field">
                            <label for="title">Tiêu đề <span class="required">*</span></label>
                            <input id="title" type="text" name="title" maxlength="100" placeholder="Nhập tiêu đề đơn" required>
                        </div>
                        <div class="request-field">
                            <label for="startDate">Từ ngày <span class="required">*</span></label>
                            <input id="startDate" type="datetime-local" name="startDate" required>
                        </div>
                        <div class="request-field">
                            <label for="endDate">Đến ngày <span class="required">*</span></label>
                            <input id="endDate" type="datetime-local" name="endDate" required>
                        </div>
                        <div class="request-field">
                            <label for="value">Giá trị / Số ngày</label>
                            <input id="value" type="number" name="value" step="0.5" min="0" placeholder="Ví dụ: 1.0">
                        </div>
                        <div class="request-field">
                            <label>Người phê duyệt</label>
                            <input type="text" value="Quản lý trực tiếp" readonly>
                        </div>
                        <div class="request-field full">
                            <label for="reason">Lý do / Nội dung</label>
                            <textarea id="reason" name="reason" maxlength="255" placeholder="Nhập lý do hoặc nội dung chi tiết của đơn..."></textarea>
                        </div>
                    </div>
                    <div class="request-notice">Sau khi gửi, đơn sẽ ở trạng thái <strong>Pending</strong> và được chuyển đến quản lý để phê duyệt.</div>
                    <div class="request-actions">
                        <a href="<%= request.getContextPath() %>/requests?action=myRequests" class="btn btn-secondary">Danh sách yêu cầu</a>
                        <button type="reset" class="btn btn-secondary">Nhập lại</button>
                        <button type="submit" class="btn btn-primary">Gửi đơn</button>
                    </div>
                </form>
            </div>
        </section>
    </main>
    <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<script>
    (function () {
        var now = new Date();
        document.getElementById('topbar-date').textContent = String(now.getDate()).padStart(2, '0') + '/' + String(now.getMonth() + 1).padStart(2, '0') + '/' + now.getFullYear();
    }());
</script>
</body>
</html>

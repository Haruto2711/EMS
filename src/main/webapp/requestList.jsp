<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ems.dto.RequestDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<RequestDTO> requests = (List<RequestDTO>) request.getAttribute("requests");
    if (requests == null) {
        response.sendRedirect(request.getContextPath() + "/requests?action=myRequests");
        return;
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    String username = (String) session.getAttribute("username");

    Integer totalFilteredItems = (Integer) request.getAttribute("totalFilteredItems");
    if (totalFilteredItems == null) totalFilteredItems = (requests != null ? requests.size() : 0);

    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;

    Integer pageSize = (Integer) request.getAttribute("pageSize");
    if (pageSize == null) pageSize = 5;

    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;

    int startItem = totalFilteredItems > 0 ? (currentPage - 1) * pageSize + 1 : 0;
    int endItem = Math.min(currentPage * pageSize, totalFilteredItems);
%>
<%!
    private String buildPageUrl(String contextPath, int page, int pageSize) {
        return contextPath + "/requests?action=myRequests&page=" + page + "&pageSize=" + pageSize;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EMS - Yêu cầu của tôi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ems.css">
    <style>
        .request-actions { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 20px; }
        .btn-create { display: inline-block; padding: 9px 16px; border-radius: 7px; background: #2563eb; color: #fff; text-decoration: none; font-size: 13px; font-weight: 600; }
        .btn-create:hover { background: #1d4ed8; }
        .request-title { color: #111827; font-weight: 600; }
        .request-reason { max-width: 260px; color: #6b7280; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .empty-state { padding: 48px 20px; text-align: center; color: #6b7280; }
        .empty-state p { margin: 8px 0 18px; }
        .delete-form { display: inline; }
        .btn-delete { border: 0; background: transparent; color: #dc2626; font: inherit; font-size: 12px; cursor: pointer; }
        .btn-delete:hover { text-decoration: underline; }
        @media (max-width: 800px) { .sidebar { position: static; width: 100%; min-height: auto; } body { display: block; } .main-content { margin-left: 0; } .table-wrap { overflow-x: auto; } th, td { white-space: nowrap; } }
    </style>
</head>
<body>
<aside class="sidebar">
    <a href="home" class="sidebar-brand"><div class="brand-dot">E</div><span class="brand-name">EMS</span></a>
    <nav class="nav-group">
        <div class="nav-section-label">Menu chính</div>
        <a href="home" class="nav-link">Trang chủ</a>
        <a href="#" class="nav-link">Lịch trình</a>
        <div class="nav-section-label">Công việc</div>
        <a href="<%= request.getContextPath() %>/requests?action=myRequests" class="nav-link active">Yêu cầu</a>
        <a href="#" class="nav-link">Bảng lương</a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-block">
            <div class="user-avatar"><%= username != null && !username.isEmpty() ? username.substring(0, 1).toUpperCase() : "N" %></div>
            <div><div class="user-name"><%= username != null ? username : "Nhân viên" %></div><div class="user-role">Nhân viên</div></div>
        </div>
        <button class="btn-logout" onclick="window.location='<%= request.getContextPath() %>/login'">Đăng xuất</button>
    </div>
</aside>

<main class="main-content">
    <div class="topbar"><span class="topbar-left">Yêu cầu của tôi</span><span class="topbar-right" id="topbar-date"></span></div>
    <div class="page-body">
        <div class="request-actions">
            <div class="page-header"><h1>Danh sách yêu cầu</h1><p>Theo dõi trạng thái các yêu cầu bạn đã gửi.</p></div>
            <a class="btn-create" href="request.jsp">+ Tạo yêu cầu</a>
        </div>
        <section class="card">
            <div class="card-header"><span>Tất cả yêu cầu</span><span class="badge badge-active"><%= totalFilteredItems %> yêu cầu</span></div>
            <% if (requests.isEmpty()) { %>
                <div class="empty-state"><strong>Bạn chưa gửi yêu cầu nào.</strong><p>Tạo yêu cầu mới để bắt đầu.</p><a class="btn-create" href="request.jsp">Tạo yêu cầu</a></div>
            <% } else { %>
                <div class="table-wrap"><table>
                    <thead><tr><th>Tiêu đề</th><th>Loại</th><th>Thời gian</th><th>Giá trị</th><th>Người duyệt</th><th>Trạng thái</th><th></th></tr></thead>
                    <tbody>
                    <% for (RequestDTO item : requests) {
                        String status = item.getStatus() == null ? "" : item.getStatus();
                        String badgeClass = "badge-pending";
                        if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                        else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
                    %>
                    <tr>
                        <td><div class="request-title"><%= item.getTitle() %></div><div class="request-reason" title="<%= item.getReason() == null ? "" : item.getReason() %>"><%= item.getReason() == null ? "" : item.getReason() %></div></td>
                        <td><%= item.getRequestTypeName() %></td>
                        <td><%= item.getStartDate() != null ? dateFormat.format(item.getStartDate()) : "-" %><br><span style="color:#9ca3af; font-size:12px;">đến <%= item.getEndDate() != null ? dateFormat.format(item.getEndDate()) : "-" %></span></td>
                        <td><%= item.getValue() %></td>
                        <td><%= item.getCurrentApproverName() != null ? item.getCurrentApproverName() : "Chưa phân công" %></td>
                        <td><span class="badge <%= badgeClass %>"><%= "Approved".equalsIgnoreCase(status) ? "Đã duyệt" : "Rejected".equalsIgnoreCase(status) ? "Từ chối" : "Chờ duyệt" %></span></td>
                        <td><% if ("Pending".equalsIgnoreCase(status)) { %><form class="delete-form" method="post" action="<%= request.getContextPath() %>/requests" onsubmit="return confirm('Bạn có muốn hủy yêu cầu này?');"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%= item.getId() %>"><button class="btn-delete" type="submit">Hủy</button></form><% } %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table></div>

                <!-- Thanh phân trang -->
                <div class="hol-pagination" style="display: flex; align-items: center; justify-content: space-between; padding: 12px 20px; border-top: 1px solid #e5e7eb; flex-wrap: wrap; gap: 10px;">
                    <div class="hol-page-info" style="font-size: 0.84rem; color: #6b7280;">
                        <span>Hiển thị <strong><%= startItem %>-<%= endItem %></strong> / <%= totalFilteredItems %> yêu cầu</span>
                    </div>
                    <% if (totalPages > 1) { %>
                    <div class="hol-page-btns" style="display: flex; align-items: center; gap: 4px;">
                        <%-- Nút Trước --%>
                        <a href="<%= buildPageUrl(request.getContextPath(), currentPage - 1, pageSize) %>"
                           class="hol-page-btn <%= currentPage <= 1 ? "disabled" : "" %>">&lt; Trước</a>

                        <%-- Các số trang --%>
                        <%
                            int winStart = Math.max(2, currentPage - 2);
                            int winEnd = Math.min(totalPages - 1, currentPage + 2);
                        %>

                        <a href="<%= buildPageUrl(request.getContextPath(), 1, pageSize) %>"
                           class="hol-page-btn <%= currentPage == 1 ? "active" : "" %>">1</a>

                        <% if (currentPage > 4) { %>
                            <span class="hol-page-ellipsis" style="color: #6b7280; padding: 0 4px;">&hellip;</span>
                        <% } %>

                        <% for (int p = winStart; p <= winEnd; p++) { %>
                            <a href="<%= buildPageUrl(request.getContextPath(), p, pageSize) %>"
                               class="hol-page-btn <%= p == currentPage ? "active" : "" %>"><%= p %></a>
                        <% } %>

                        <% if (currentPage < totalPages - 3) { %>
                            <span class="hol-page-ellipsis" style="color: #6b7280; padding: 0 4px;">&hellip;</span>
                        <% } %>

                        <% if (totalPages > 1) { %>
                            <a href="<%= buildPageUrl(request.getContextPath(), totalPages, pageSize) %>"
                               class="hol-page-btn <%= currentPage == totalPages ? "active" : "" %>"><%= totalPages %></a>
                        <% } %>

                        <%-- Nút Tiếp --%>
                        <a href="<%= buildPageUrl(request.getContextPath(), currentPage + 1, pageSize) %>"
                           class="hol-page-btn <%= currentPage >= totalPages ? "disabled" : "" %>">Tiếp &gt;</a>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </section>
    </div>
    <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</main>
<script>
    (function () { var now = new Date(), pad = function (n) { return String(n).padStart(2, '0'); }; document.getElementById('topbar-date').textContent = pad(now.getDate()) + '/' + pad(now.getMonth() + 1) + '/' + now.getFullYear(); }());
</script>
</body>
</html>

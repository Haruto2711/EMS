<%@ page pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%@ page import="java.util.List" %>
<%@ page import="com.ems.dto.RequestDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<RequestDTO> requests = (List<RequestDTO>) request.getAttribute("requests");
    if (requests == null) {
        response.sendRedirect(request.getContextPath() + "/requests?action=pending");
        return;
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EMS - Xử lý đơn</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ems.css">
    <style>
        .request-name { color: #111827; font-weight: 600; }
        .request-reason { max-width: 280px; color: #6b7280; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .request-actions { display: flex; gap: 8px; justify-content: flex-end; }
        .decision-form { display: inline; }
        .btn-decision { border: 0; border-radius: 6px; padding: 7px 11px; color: #fff; font: inherit; font-size: 12px; font-weight: 600; cursor: pointer; }
        .btn-approve { background: #059669; } .btn-approve:hover { background: #047857; }
        .btn-reject { background: #dc2626; } .btn-reject:hover { background: #b91c1c; }
        .empty-state { padding: 48px 20px; text-align: center; color: #6b7280; }
        .request-image { display: inline-block; margin-top: 5px; color: #2563eb; font-size: 12px; }
        @media (max-width: 800px) { .sidebar { position: static; width: 100%; min-height: auto; } body { display: block; } .main-content { margin-left: 0; } .table-wrap { overflow-x: auto; } th, td { white-space: nowrap; } }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jspf/sidebar.jsp" %>
<main class="main-content">
    <div class="topbar"><span class="topbar-left">Xử lý đơn</span><span class="topbar-right" id="topbar-date"></span></div>
    <div class="page-body">
        <div class="page-header"><h1>Đơn chờ xử lý</h1><p>Xem thông tin và phê duyệt hoặc từ chối các đơn được phân công cho bạn.</p></div>
        <section class="card">
            <div class="card-header"><span>Đơn chờ phê duyệt</span><span class="badge badge-pending"><%= requests.size() %> đơn</span></div>
            <% if (requests.isEmpty()) { %>
                <div class="empty-state"><strong>Không có đơn nào chờ xử lý.</strong><p>Các đơn được phân công cho bạn sẽ hiển thị tại đây.</p></div>
            <% } else { %>
                <div class="table-wrap"><table>
                    <thead><tr><th>Nhân viên</th><th>Đơn yêu cầu</th><th>Loại</th><th>Thời gian</th><th>Giá trị</th><th>Ngày gửi</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <% for (RequestDTO item : requests) { %>
                        <tr>
                            <td><span class="request-name"><%= item.getCreatedByName() %></span></td>
                            <td><div class="request-name"><%= item.getTitle() %></div><div class="request-reason" title="<%= item.getReason() == null ? "" : item.getReason() %>"><%= item.getReason() == null ? "Không có nội dung" : item.getReason() %></div><% if (item.getImageUrl() != null && !item.getImageUrl().isBlank()) { %><a class="request-image" href="<%= item.getImageUrl() %>" target="_blank" rel="noopener">Xem minh chứng</a><% } %></td>
                            <td><%= item.getRequestTypeName() %></td>
                            <td><%= item.getStartDate() == null ? "-" : dateFormat.format(item.getStartDate()) %><br><span style="color:#9ca3af;font-size:12px;">đến <%= item.getEndDate() == null ? "-" : dateFormat.format(item.getEndDate()) %></span></td>
                            <td><%= item.getValue() %></td>
                            <td><%= item.getCreatedAt() == null ? "-" : dateFormat.format(item.getCreatedAt()) %></td>
                            <td><div class="request-actions"><form class="decision-form" method="post" action="<%= request.getContextPath() %>/requests" onsubmit="return confirm('Duyệt đơn này?');"><input type="hidden" name="action" value="approve"><input type="hidden" name="id" value="<%= item.getId() %>"><button class="btn-decision btn-approve" type="submit">Duyệt</button></form><form class="decision-form" method="post" action="<%= request.getContextPath() %>/requests" onsubmit="return confirm('Từ chối đơn này?');"><input type="hidden" name="action" value="reject"><input type="hidden" name="id" value="<%= item.getId() %>"><button class="btn-decision btn-reject" type="submit">Từ chối</button></form></div></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table></div>
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

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ems.dto.EmployeeBalanceDTO" %>
<%
    List<EmployeeBalanceDTO> balances = (List<EmployeeBalanceDTO>) request.getAttribute("balances");
    if (balances == null) {
        response.sendRedirect(request.getContextPath() + "/requests?action=employeeBalances");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EMS - Trạng thái phép & ứng lương</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ems.css">
    <style>
        .balance-value { font-weight: 600; color: #111827; }
        .balance-remaining { color: #059669; font-weight: 700; }
        .balance-advance { color: #dc2626; font-weight: 700; }
        @media (max-width: 800px) {
            .sidebar { position: static; width: 100%; min-height: auto; }
            body { display: block; }
            .main-content { margin-left: 0; }
            .table-wrap { overflow-x: auto; }
            th, td { white-space: nowrap; }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/jspf/sidebar.jsp" %>
<main class="main-content">
    <div class="topbar">
        <span class="topbar-left">Trạng thái nhân sự</span>
        <span class="topbar-right" id="topbar-date"></span>
    </div>
    <div class="page-body">
        <div class="page-header">
            <h1>Theo dõi phép & ứng lương</h1>
            <p>Theo dõi số ngày phép còn lại và tổng tiền ứng lương trong tháng này của từng nhân viên.</p>
        </div>
        <section class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <span>Trạng thái phép & ứng lương</span>
                    <span class="badge badge-active" id="staffCountBadge"><%= balances.size() %> nhân sự</span>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <input type="text" id="searchInput" placeholder="Tìm theo tên nhân viên..."
                           oninput="filterTable(this.value)"
                           style="padding: 6px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 13px; outline: none; width: 220px;">
                </div>
            </div>
            <% if (balances.isEmpty()) { %>
                <div style="padding: 48px 20px; text-align: center; color: #6b7280;">
                    <strong>Không có dữ liệu nhân sự.</strong>
                </div>
            <% } else { %>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th style="text-align: center;">Phép còn lại</th>
                                <th style="text-align: right;">Đã ứng tháng này</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                java.text.NumberFormat curFormat = java.text.NumberFormat.getIntegerInstance(new java.util.Locale("vi", "VN"));
                                for (EmployeeBalanceDTO item : balances) {
                            %>
                                <tr class="staff-row">
                                    <td><strong style="color: #111827;"><%= item.getEmployeeName() %></strong></td>
                                    <td><%= item.getDepartmentName() != null ? item.getDepartmentName() : "Chưa xếp phòng" %></td>
                                    <td style="text-align: center;" class="balance-remaining"><%= item.getRemainingDays() %> ngày</td>
                                    <td style="text-align: right;" class="balance-advance">
                                        <%= item.getAdvancedThisMonth() > 0 ? curFormat.format(item.getAdvancedThisMonth()) + " đ" : "0 đ" %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </section>
    </div>
    <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</main>
<script>
    (function () {
        var now = new Date(), pad = function (n) { return String(n).padStart(2, '0'); };
        document.getElementById('topbar-date').textContent = pad(now.getDate()) + '/' + pad(now.getMonth() + 1) + '/' + now.getFullYear();
    }());

    function filterTable(keyword) {
        var kw   = keyword.trim().toLowerCase();
        var rows = document.querySelectorAll('tbody .staff-row');
        var count = 0;
        rows.forEach(function (row) {
            var name = row.querySelector('td:first-child').textContent.toLowerCase();
            var show = kw === '' || name.includes(kw);
            row.style.display = show ? '' : 'none';
            if (show) count++;
        });
        document.getElementById('staffCountBadge').textContent = count + ' nhân sự';
    }
</script>
</body>
</html>

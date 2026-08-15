<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (request.getAttribute("isLoaded") == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
    Integer totalAccounts = (Integer) request.getAttribute("totalAccounts");
    Integer totalRoles = (Integer) request.getAttribute("totalRoles");
    Integer totalPeriods = (Integer) request.getAttribute("totalPeriods");
    List<Map<String, Object>> recentAccounts = (List<Map<String, Object>>) request.getAttribute("recentAccounts");
    Integer totalShifts = (Integer) request.getAttribute("totalShifts");
    Integer totalHolidays = (Integer) request.getAttribute("totalHolidays");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Admin</title>
  <link rel="stylesheet" href="css/ems.css"/>
  <style>
    .user-avatar-circle {
      width: 32px; height: 32px;
      background: #dbeafe;
      color: #1e40af;
      border-radius: 50%;
      display: flex;
      align-items: center; justify-content: center;
      font-size: 11px;
      font-weight: 600;
      flex-shrink: 0;
    }
    .badge-role {
      background: #eff6ff;
      color: #2563eb;
      padding: 4px 10px;
      border-radius: 9999px;
      font-size: 11.5px;
      font-weight: 600;
      text-transform: lowercase;
      display: inline-block;
    }
    .badge-active {
      background: #ecfdf5;
      color: #065f46;
      padding: 4px 8px;
      border-radius: 9999px;
      font-size: 11.5px;
      font-weight: 500;
      display: inline-block;
    }
    .badge-locked {
      background: #fef2f2;
      color: #991b1b;
      padding: 4px 8px;
      border-radius: 9999px;
      font-size: 11.5px;
      font-weight: 500;
      display: inline-block;
    }
    .dashboard-table th {
      padding: 10px 12px;
      font-size: 10px;
      background: #fff;
      border-bottom: 1.5px solid #f3f4f6;
    }
    .dashboard-table td {
      padding: 10px 12px;
      font-size: 12.5px;
    }
  </style>
</head>
<body>

<aside class="sidebar">
  <a href="home" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Tổng quan</div>
    <a href="home" class="nav-link active">Trang chủ</a>
    <div class="nav-section-label">Quản trị</div>
    <a href="users" class="nav-link">Tài khoản</a>
    <a href="#" class="nav-link">Phân quyền</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= fullName != null && !fullName.isEmpty() ? fullName.substring(0,1).toUpperCase() : "A" %>
      </div>
      <div>
        <div class="user-name"><%= fullName != null ? fullName : "Admin" %></div>
        <div class="user-role"><%= deptName != null ? deptName : "Quản trị viên" %></div>
      </div>
    </div>
    <button class="btn-logout" onclick="window.location='login'">Đăng xuất</button>
  </div>
</aside>

<div class="main-content">
  <div class="topbar">
    <span class="topbar-left">Trang chủ</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">
    <div class="page-header">
      <h1>Chào mừng, <%= fullName != null ? fullName : "Admin" %></h1>
      <p>Hệ thống đang hoạt động bình thường.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Tổng số tài khoản</div>
        <div class="stat-value"><%= totalAccounts != null ? totalAccounts : 0 %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Số vai trò</div>
        <div class="stat-value"><%= totalRoles != null ? totalRoles : 0 %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Chu kỳ bảng lương</div>
        <div class="stat-value"><%= totalPeriods != null ? totalPeriods : 0 %></div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header" style="font-weight: 700; font-size: 14px; color: #111827;">
          Danh sách tài khoản
        </div>
        
        <div style="overflow-x: auto;">
          <table class="dashboard-table" style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
              <tr style="border-bottom: 1.5px solid #f3f4f6; color: #6b7280; text-transform: uppercase; font-size: 10px; font-weight: 700; letter-spacing: 0.5px;">
                <th style="padding: 10px 12px;">Người dùng</th>
                <th style="padding: 10px 12px;">Email</th>
                <th style="padding: 10px 12px;">Vai trò</th>
                <th style="padding: 10px 12px;">Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <%
                if (recentAccounts != null && !recentAccounts.isEmpty()) {
                  for (Map<String, Object> acc : recentAccounts) {
                    String name = (String) acc.get("fullName");
                    String username = (String) acc.get("username");
                    
                    Boolean status = (Boolean) acc.get("status");
                    boolean isCurrentStatus = (status != null && status);
              %>
                    <tr style="border-bottom: 1px solid #f3f4f6; transition: background 0.1s;" onmouseover="this.style.background='#f9fafb'" onmouseout="this.style.background='transparent'">
                      <td style="padding: 10px 12px;">
                        <div style="font-weight: 600; color: #111827; font-size: 12.5px;"><%= name %></div>
                        <div style="font-size: 11px; color: #6b7280;">@<%= username %></div>
                      </td>
                      <td style="padding: 10px 12px; color: #4b5563; font-size: 12px;"><%= acc.get("emailCompany") != null ? acc.get("emailCompany") : "" %></td>
                      <td style="padding: 10px 12px;">
                        <span class="badge-role">
                          <%= (acc.get("roleName") != null ? (String) acc.get("roleName") : "employee").toLowerCase() %>
                        </span>
                      </td>
                      <td style="padding: 10px 12px;">
                        <span class="<%= isCurrentStatus ? "badge-active" : "badge-locked" %>">
                          <%= isCurrentStatus ? "Hoạt động" : "Bị khóa" %>
                        </span>
                      </td>
                    </tr>
              <%
                  }
                } else {
              %>
                <tr>
                  <td colspan="4" style="padding: 20px; text-align: center; color: #9ca3af;">Chưa có tài khoản nào.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card">
        <div class="card-header">Cấu hình tổng quan</div>
        <div class="cfg-row">
          <span class="cfg-label">Tổng số ca làm việc (Shifts)</span>
          <span class="cfg-val"><%= totalShifts != null ? totalShifts : 0 %> ca</span>
        </div>
        <div class="cfg-row">
          <span class="cfg-label">Số ngày nghỉ lễ cấu hình (Holidays)</span>
          <span class="cfg-val"><%= totalHolidays != null ? totalHolidays : 0 %> ngày</span>
        </div>
        <div class="cfg-row">
          <span class="cfg-label">Hạn mức nghỉ phép tiêu chuẩn</span>
          <span class="cfg-val">12 ngày/năm</span>
        </div>
      </div>
    </div>
  </div>

  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<script>
  function tick() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('topbar-date').textContent = p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  }
  tick();
</script>
</body>
</html>

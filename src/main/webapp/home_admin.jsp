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
    <a href="#" class="nav-link">Tài khoản</a>
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
        <div class="card-header">Tài khoản mới tạo gần đây</div>
        <%
          if (recentAccounts != null && !recentAccounts.isEmpty()) {
            for (Map<String, Object> acc : recentAccounts) {
              Boolean status = (Boolean) acc.get("status");
              String badgeClass = (status != null && status) ? "badge-approved" : "badge-locked";
              String statusText = (status != null && status) ? "Hoạt động" : "Khóa";
        %>
              <div class="row-item">
                <div>
                  <div class="row-main"><%= acc.get("fullName") %> (<%= acc.get("username") %>)</div>
                  <div class="row-sub">Vai trò: <%= acc.get("roleName") != null ? acc.get("roleName") : "Chưa phân" %></div>
                </div>
                <span class="badge <%= badgeClass %>"><%= statusText %></span>
              </div>
        <%
            }
          } else {
        %>
          <div style="padding: 20px; text-align: center; color: #9ca3af; font-size: 13.5px;">Chưa có tài khoản nào.</div>
        <% } %>
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

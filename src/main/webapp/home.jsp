<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (request.getAttribute("isLoaded") == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
    Integer totalLeave = (Integer) request.getAttribute("totalLeave");
    Integer remainingLeave = (Integer) request.getAttribute("remainingLeave");
    String periodName = (String) request.getAttribute("periodName");
    Integer actualWorkingDays = (Integer) request.getAttribute("actualWorkingDays");
    String todayCheckIn = (String) request.getAttribute("todayCheckIn");
    String todayCheckOut = (String) request.getAttribute("todayCheckOut");
    List<Map<String, Object>> requestsList = (List<Map<String, Object>>) request.getAttribute("requestsList");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Trang chủ</title>
  <link rel="stylesheet" href="ems.css"/>
</head>
<body>

<aside class="sidebar">
  <a href="home" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Menu chính</div>
    <a href="home" class="nav-link active">Trang chủ</a>
    <a href="#" class="nav-link">Lịch trình</a>
    <div class="nav-section-label">Công việc</div>
    <a href="#" class="nav-link">Yêu cầu</a>
    <a href="#" class="nav-link">Bảng lương</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= fullName != null && !fullName.isEmpty() ? fullName.substring(0,1).toUpperCase() : "N" %>
      </div>
      <div>
        <div class="user-name"><%= fullName != null ? fullName : "Nhân viên" %></div>
        <div class="user-role"><%= deptName != null ? deptName : "Nhân viên" %></div>
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
      <h1>Chào mừng, <%= fullName != null ? fullName : "Nhân viên" %></h1>
      <p>Dưới đây là tổng quan hoạt động trong ngày của bạn.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Chu kỳ công</div>
        <div class="stat-value" style="font-size: 16px; margin-top: 10px;"><%= periodName != null ? periodName : "Không có" %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Số ngày đã đi làm</div>
        <div class="stat-value"><%= actualWorkingDays != null ? actualWorkingDays : 0 %> <span class="stat-unit">ngày</span></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Ngày phép còn lại</div>
        <div class="stat-value"><%= remainingLeave != null ? remainingLeave : 12 %> <span class="stat-unit">ngày</span></div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header">Điểm danh hôm nay</div>
        <div class="clock-block">
          <div class="clock-time" id="clock">00:00:00</div>
          <div class="clock-date" id="clock-date"></div>
          <div class="clock-actions">
            <% if (todayCheckIn == null) { %>
              <button class="btn-checkin">Check In</button>
            <% } else { %>
              <button class="btn-checkin" disabled style="opacity: 0.5; background: #9ca3af;">Đã Check In</button>
            <% } %>
            
            <% if (todayCheckOut == null) { %>
              <button class="btn-checkout">Check Out</button>
            <% } else { %>
              <button class="btn-checkout" disabled style="opacity: 0.5; background: #e5e7eb; color: #9ca3af;">Đã Check Out</button>
            <% } %>
          </div>
          <div class="clock-note">
            <% if (todayCheckIn == null) { %>
              Hôm nay bạn chưa điểm danh vào.
            <% } else if (todayCheckOut == null) { %>
              Đã check in vào lúc: <strong><%= todayCheckIn %></strong>. Chưa check out.
            <% } else { %>
              Đã check in: <strong><%= todayCheckIn %></strong> | Check out: <strong><%= todayCheckOut %></strong>.
            <% } %>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">Yêu cầu nghỉ phép gần đây</div>
        <% 
          if (requestsList != null && !requestsList.isEmpty()) {
            for (Map<String, Object> req : requestsList) {
              String status = (String) req.get("status");
              String badgeClass = "badge-pending";
              String statusVN = "Chờ duyệt";
              if ("Approved".equalsIgnoreCase(status)) {
                badgeClass = "badge-approved";
                statusVN = "Đã duyệt";
              } else if ("Rejected".equalsIgnoreCase(status)) {
                badgeClass = "badge-rejected";
                statusVN = "Từ chối";
              }
        %>
              <%
                Object valObj = req.get("value");
                String valStr = "0";
                if (valObj instanceof Number) {
                  double val = ((Number) valObj).doubleValue();
                  if (val == (int) val) {
                    valStr = String.valueOf((int) val);
                  } else {
                    valStr = String.valueOf(val);
                  }
                } else if (valObj != null) {
                  valStr = valObj.toString();
                }
              %>
              <div class="row-item">
                <div>
                  <div class="row-main"><%= req.get("title") %> (<%= valStr %> ngày)</div>
                  <div class="row-sub"><%= req.get("startDate") %> – <%= req.get("endDate") %></div>
                </div>
                <span class="badge <%= badgeClass %>"><%= statusVN %></span>
              </div>
        <% 
            }
          } else {
        %>
          <div style="padding: 20px; text-align: center; color: #9ca3af; font-size: 13.5px;">Chưa có yêu cầu nào.</div>
        <% } %>
      </div>
    </div>
  </div>

  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<script>
  function update() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('clock').textContent = p(now.getHours())+':'+p(now.getMinutes())+':'+p(now.getSeconds());
    var days   = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
    var months = ['tháng 1','tháng 2','tháng 3','tháng 4','tháng 5','tháng 6','tháng 7','tháng 8','tháng 9','tháng 10','tháng 11','tháng 12'];
    document.getElementById('clock-date').textContent = days[now.getDay()]+', ngày '+now.getDate()+' '+months[now.getMonth()]+' năm '+now.getFullYear();
    document.getElementById('topbar-date').textContent = p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  }
  setInterval(update, 1000); update();
</script>
</body>
</html>

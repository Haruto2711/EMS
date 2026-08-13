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
    List<Map<String, Object>> notificationsList = (List<Map<String, Object>>) request.getAttribute("notificationsList");
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
    <div style="display: flex; align-items: center; gap: 16px;">
      <span class="topbar-right" id="topbar-date"></span>
      <div class="noti-dropdown-wrapper" style="position: relative; display: inline-block;">
        <button class="btn-noti-bell" onclick="toggleNotiDropdown()" style="background: none; border: none; cursor: pointer; position: relative; padding: 4px; display: flex; align-items: center; outline: none;">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #4b5563;"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>

        </button>
        <div id="noti-dropdown" style="display: none; position: absolute; right: 0; top: 32px; width: 320px; background: #fff; border: 1px solid #e5e7eb; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); z-index: 100; max-height: 280px; overflow-y: auto;">
          <div style="padding: 10px 14px; font-weight: 600; border-bottom: 1px solid #f3f4f6; font-size: 13px; color: #111;">Thông báo mới nhận</div>
          <%
            if (notificationsList != null && !notificationsList.isEmpty()) {
              for (Map<String, Object> noti : notificationsList) {
          %>
                <div style="padding: 10px 14px; border-bottom: 1px solid #f9fafb; transition: background 0.1s; cursor: pointer;" onmouseover="this.style.background='#f9fafb'" onmouseout="this.style.background='transparent'">
                  <div style="font-weight: 500; font-size: 12.5px; color: #111;"><%= noti.get("title") %></div>
                  <div style="font-size: 11.5px; color: #6b7280; margin-top: 2px;"><%= noti.get("message") %></div>
                </div>
          <%
              }
            } else {
          %>
            <div style="padding: 20px; text-align: center; color: #9ca3af; font-size: 12px;">Không có thông báo nào.</div>
          <% } %>
        </div>
      </div>
    </div>
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
        <div class="card-header">Thông báo mới nhất</div>
        <%
          if (notificationsList != null && !notificationsList.isEmpty()) {
            for (Map<String, Object> noti : notificationsList) {
              java.sql.Timestamp ts = (java.sql.Timestamp) noti.get("createdAt");
              String timeStr = "";
              if (ts != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                timeStr = sdf.format(ts);
              }
        %>
              <div class="row-item">
                <div>
                  <div class="row-main"><%= noti.get("title") %></div>
                  <div class="row-sub"><%= noti.get("message") %></div>
                </div>
                <span class="row-sub" style="font-size: 11px; white-space: nowrap; margin-left: 10px;"><%= timeStr %></span>
              </div>
        <%
            }
          } else {
        %>
          <div style="padding: 20px; text-align: center; color: #9ca3af; font-size: 13.5px;">Không có thông báo nào.</div>
        <% } %>
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
    document.getElementById('topbar-date').textContent = p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  }
  update();

  function toggleNotiDropdown() {
    var dd = document.getElementById('noti-dropdown');
    if (dd.style.display === 'none' || dd.style.display === '') {
      dd.style.display = 'block';
    } else {
      dd.style.display = 'none';
    }
  }
  window.addEventListener('click', function(e) {
    var dd = document.getElementById('noti-dropdown');
    var wrapper = document.querySelector('.noti-dropdown-wrapper');
    if (dd && wrapper && !wrapper.contains(e.target)) {
      dd.style.display = 'none';
    }
  });
</script>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (request.getAttribute("isLoaded") == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
    Integer deptEmployeeCount = (Integer) request.getAttribute("deptEmployeeCount");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    String attendanceRate = (String) request.getAttribute("attendanceRate");
    List<Map<String, Object>> pendingRequests = (List<Map<String, Object>>) request.getAttribute("pendingRequests");
    List<Map<String, Object>> departmentAttendance = (List<Map<String, Object>>) request.getAttribute("departmentAttendance");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý</title>
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
    <a href="home_manager.jsp" class="nav-link active">Trang chủ</a>
    <div class="nav-section-label">Quản lý</div>
    <a href="work-schedule" class="nav-link">Lịch làm việc </a>
    <a href="holiday" class="nav-link">Quản lý ngày nghỉ lễ </a>
    <a href="#" class="nav-link">Điểm danh phòng ban</a>
    <a href="base-salaries" class="nav-link">Quản lý lương</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= fullName != null && !fullName.isEmpty() ? fullName.substring(0,1).toUpperCase() : "M" %>
      </div>
      <div>
        <div class="user-name"><%= fullName != null ? fullName : "Manager" %></div>
        <div class="user-role"><%= deptName != null ? deptName : "Quản lý" %></div>
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
      <h1>Chào mừng, <%= fullName != null ? fullName : "Manager" %></h1>
      <p>Dưới đây là tổng quan quản lý phòng ban: <strong><%= deptName != null ? deptName : "N/A" %></strong>.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Tổng số nhân sự</div>
        <div class="stat-value"><%= deptEmployeeCount != null ? deptEmployeeCount : 0 %> <span class="stat-unit">nhân viên</span></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Yêu cầu chờ duyệt</div>
        <div class="stat-value"><%= pendingCount != null ? pendingCount : 0 %></div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Tỷ lệ đi làm hôm nay</div>
        <div class="stat-value"><%= attendanceRate != null ? attendanceRate : "0%" %></div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header">Yêu cầu chờ duyệt</div>
        <%
          if (pendingRequests != null && !pendingRequests.isEmpty()) {
            for (Map<String, Object> req : pendingRequests) {
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
                  <div class="row-main"><%= req.get("fullName") %></div>
                  <div class="row-sub"><%= req.get("title") %> · <%= req.get("startDate") %> (<%= valStr %> ngày)</div>
                </div>
                <div class="btn-group">
                  <button class="btn-sm btn-ok" onclick="alert('Duyệt yêu cầu: <%= req.get("title") %>')">Duyệt</button>
                  <button class="btn-sm btn-no" onclick="alert('Từ chối yêu cầu: <%= req.get("title") %>')">Từ chối</button>
                </div>
              </div>
        <%
            }
          } else {
        %>
          <div style="padding: 20px; text-align: center; color: #9ca3af; font-size: 13.5px;">Không có yêu cầu nào chờ duyệt.</div>
        <% } %>
      </div>

      <div class="card">
        <div class="card-header">Tình hình điểm danh hôm nay</div>
        <div style="max-height: 300px; overflow-y: auto;">
          <table>
            <thead>
              <tr><th>Nhân viên</th><th>Giờ vào</th><th>Trạng thái</th></tr>
            </thead>
            <tbody>
              <%
                if (departmentAttendance != null && !departmentAttendance.isEmpty()) {
                  for (Map<String, Object> att : departmentAttendance) {
                    String checkIn = (String) att.get("checkIn");
                    String statusDot = (checkIn == null) ? "dot-yellow" : "dot-green";
                    String statusText = (checkIn == null) ? "Vắng mặt" : "Có mặt";
              %>
                    <tr>
                      <td><%= att.get("fullName") %></td>
                      <td><%= checkIn != null ? checkIn : "--:--" %></td>
                      <td><span class="dot <%= statusDot %>"></span><%= statusText %></td>
                    </tr>
              <%
                  }
                } else {
              %>
                <tr><td colspan="3" style="text-align: center; color: #9ca3af;">Không có nhân viên nào trong phòng ban.</td></tr>
              <% } %>
            </tbody>
          </table>
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

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
  <a href="home.jsp" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Menu chính</div>
    <a href="home.jsp" class="nav-link active">Trang chủ</a>
    <a href="#" class="nav-link">Lịch trình</a>
    <div class="nav-section-label">Công việc</div>
    <a href="#" class="nav-link">Yêu cầu</a>
    <a href="#" class="nav-link">Bảng lương</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= session.getAttribute("username") != null ? session.getAttribute("username").toString().substring(0,1).toUpperCase() : "N" %>
      </div>
      <div>
        <div class="user-name"><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Nhân viên" %></div>
        <div class="user-role">Nhân viên</div>
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
      <h1>Chào mừng, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Nhân viên" %></h1>
      <p>Dưới đây là tổng quan hoạt động trong ngày của bạn.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Ngày công định mức</div>
        <div class="stat-value">22</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Số ngày đã đi làm</div>
        <div class="stat-value">18</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Ngày phép còn lại</div>
        <div class="stat-value">12 <span class="stat-unit">ngày</span></div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header">Điểm danh hôm nay</div>
        <div class="clock-block">
          <div class="clock-time" id="clock">00:00:00</div>
          <div class="clock-date" id="clock-date"></div>
          <div class="clock-actions">
            <button class="btn-checkin">Check In</button>
            <button class="btn-checkout">Check Out</button>
          </div>
          <div class="clock-note">Hôm nay bạn chưa điểm danh.</div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">Yêu cầu nghỉ phép gần đây</div>
        <div class="row-item">
          <div>
            <div class="row-main">Nghỉ phép năm (3 ngày)</div>
            <div class="row-sub">15/08/2026 – 17/08/2026</div>
          </div>
          <span class="badge badge-pending">Chờ duyệt</span>
        </div>
        <div class="row-item">
          <div>
            <div class="row-main">Nghỉ ốm (1 ngày)</div>
            <div class="row-sub">05/08/2026</div>
          </div>
          <span class="badge badge-approved">Đã duyệt</span>
        </div>
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

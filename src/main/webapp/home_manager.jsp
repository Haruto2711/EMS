<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
  <a href="home_manager.jsp" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Menu chính</div>
    <a href="home_manager.jsp" class="nav-link active">Trang chủ</a>
    <a href="#" class="nav-link">Lịch trình nhóm</a>
    <div class="nav-section-label">Quản lý</div>
    <a href="#" class="nav-link">Điểm danh phòng ban</a>
    <a href="base-salaries" class="nav-link">Quản lý lương</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= session.getAttribute("username") != null ? session.getAttribute("username").toString().substring(0,1).toUpperCase() : "M" %>
      </div>
      <div>
        <div class="user-name"><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Manager" %></div>
        <div class="user-role">Quản lý</div>
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
      <h1>Chào mừng, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Manager" %></h1>
      <p>Dưới đây là tổng quan quản lý phòng ban của bạn.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Tổng số nhân sự</div>
        <div class="stat-value">24</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Yêu cầu chờ duyệt</div>
        <div class="stat-value">3</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Tỷ lệ đi làm hôm nay</div>
        <div class="stat-value">94%</div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header">Yêu cầu chờ duyệt</div>
        <div class="row-item">
          <div>
            <div class="row-main">Nguyễn Văn Thanh</div>
            <div class="row-sub">Nghỉ phép năm · 15/08 – 17/08</div>
          </div>
          <div class="btn-group">
            <button class="btn-sm btn-ok">Duyệt</button>
            <button class="btn-sm btn-no">Từ chối</button>
          </div>
        </div>
        <div class="row-item">
          <div>
            <div class="row-main">Lê Thị Mai</div>
            <div class="row-sub">Nghỉ ốm · 12/08</div>
          </div>
          <div class="btn-group">
            <button class="btn-sm btn-ok">Duyệt</button>
            <button class="btn-sm btn-no">Từ chối</button>
          </div>
        </div>
      </div>

      <div class="card">
        <div class="card-header">Tình hình điểm danh hôm nay</div>
        <table>
          <thead>
            <tr><th>Nhân viên</th><th>Giờ vào</th><th>Trạng thái</th></tr>
          </thead>
          <tbody>
            <tr><td>Nguyễn Văn Thanh</td><td>08:02</td><td><span class="dot dot-green"></span>Có mặt</td></tr>
            <tr><td>Lê Thị Mai</td><td>08:45</td><td><span class="dot dot-yellow"></span>Đi muộn</td></tr>
            <tr><td>Phạm Thị Lan</td><td>07:58</td><td><span class="dot dot-green"></span>Có mặt</td></tr>
          </tbody>
        </table>
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

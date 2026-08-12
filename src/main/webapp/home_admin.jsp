<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Admin</title>
  <link rel="stylesheet" href="ems.css"/>
</head>
<body>

<aside class="sidebar">
  <a href="home_admin.jsp" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Tổng quan</div>
    <a href="home_admin.jsp" class="nav-link active">Trang chủ</a>
    <div class="nav-section-label">Quản trị</div>
    <a href="#" class="nav-link">Tài khoản</a>
    <a href="#" class="nav-link">Phân quyền</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= session.getAttribute("username") != null ? session.getAttribute("username").toString().substring(0,1).toUpperCase() : "A" %>
      </div>
      <div>
        <div class="user-name"><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Admin" %></div>
        <div class="user-role">Quản trị viên</div>
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
      <h1>Chào mừng, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Admin" %></h1>
      <p>Hệ thống đang hoạt động bình thường.</p>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-label">Tổng số tài khoản</div>
        <div class="stat-value">87</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Số vai trò</div>
        <div class="stat-value">3</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Công thức lương</div>
        <div class="stat-value">5</div>
      </div>
    </div>

    <div class="cards-row">
      <div class="card">
        <div class="card-header">Tài khoản nhân viên gần đây</div>
        <div class="row-item">
          <div>
            <div class="row-main">Nguyễn Văn Thanh</div>
            <div class="row-sub">thanh@ems.com · Nhân viên</div>
          </div>
          <span class="badge badge-active">Hoạt động</span>
        </div>
        <div class="row-item">
          <div>
            <div class="row-main">Manager Khoa</div>
            <div class="row-sub">khoa@ems.com · Quản lý</div>
          </div>
          <span class="badge badge-active">Hoạt động</span>
        </div>
        <div class="row-item">
          <div>
            <div class="row-main">Trần Văn Nam</div>
            <div class="row-sub">nam@ems.com · Nhân viên</div>
          </div>
          <span class="badge badge-locked">Khóa</span>
        </div>
      </div>

      <div class="card">
        <div class="card-header">Cấu hình hệ thống</div>
        <div class="cfg-row">
          <span class="cfg-label">Số giờ làm việc định mức</span>
          <span class="cfg-val">8 giờ/ngày</span>
        </div>
        <div class="cfg-row">
          <span class="cfg-label">Hệ số làm thêm giờ</span>
          <span class="cfg-val">1.5x</span>
        </div>
        <div class="cfg-row">
          <span class="cfg-label">Hạn mức nghỉ phép/năm</span>
          <span class="cfg-val">12 ngày</span>
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

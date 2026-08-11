<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Trang chủ Admin</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <style>
    /* Reset & Base styles */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', sans-serif;
      background-color: #f8fafc;
      color: #334155;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* Header */
    header {
      background-color: #1e293b;
      color: #ffffff;
      padding: 0 20px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .logo {
      font-size: 20px;
      font-weight: 700;
      color: #ffffff;
      text-decoration: none;
    }
    nav {
      display: flex;
      gap: 20px;
    }
    nav a {
      color: #cbd5e1;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      padding: 6px 12px;
      border-radius: 6px;
      transition: background 0.2s, color 0.2s;
    }
    nav a:hover, nav a.active {
      background-color: #334155;
      color: #ffffff;
    }
    .user-menu {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .role-badge {
      background-color: #ef4444;
      color: #ffffff;
      font-size: 11px;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 12px;
    }
    .logout-btn {
      color: #f1f5f9;
      background-color: #ef4444;
      border: none;
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      transition: background 0.2s;
    }
    .logout-btn:hover {
      background-color: #dc2626;
    }

    /* Container */
    .container {
      max-width: 1200px;
      width: 100%;
      margin: 0 auto;
      padding: 24px 20px;
      flex: 1;
    }

    .welcome-section {
      margin-bottom: 24px;
    }
    .welcome-section h1 {
      font-size: 24px;
      font-weight: 700;
      color: #0f172a;
    }
    .welcome-section p {
      font-size: 14px;
      color: #64748b;
      margin-top: 4px;
    }

    /* Stats Dashboard */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 20px;
      margin-bottom: 24px;
    }
    .stat-card {
      background: #ffffff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e2e8f0;
    }
    .stat-title {
      font-size: 13px;
      font-weight: 500;
      color: #64748b;
      text-transform: uppercase;
    }
    .stat-value {
      font-size: 28px;
      font-weight: 700;
      color: #0f172a;
      margin-top: 8px;
    }

    /* Content Layout */
    .main-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    @media (max-width: 768px) {
      .main-grid { grid-template-columns: 1fr; }
    }

    .card {
      background: #ffffff;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      border: 1px solid #e2e8f0;
      overflow: hidden;
    }
    .card-header {
      padding: 16px 20px;
      background-color: #f8fafc;
      border-bottom: 1px solid #e2e8f0;
      font-weight: 600;
      font-size: 15px;
      color: #0f172a;
    }
    .card-body {
      padding: 20px;
    }

    /* Recent Accounts List */
    .acc-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .acc-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px;
      background-color: #f8fafc;
      border-radius: 6px;
      border: 1px solid #e2e8f0;
    }
    .acc-info h4 {
      font-size: 14px;
      font-weight: 600;
      color: #334155;
    }
    .acc-info p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px;
    }
    .status-badge {
      font-size: 11px;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 12px;
    }
    .status-badge.active { background-color: #dcfce7; color: #166534; }
    .status-badge.inactive { background-color: #f1f5f9; color: #64748b; }

    /* Configuration List */
    .config-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .config-item {
      display: flex;
      justify-content: space-between;
      font-size: 13.5px;
      padding: 8px 0;
      border-bottom: 1px solid #f1f5f9;
    }
    .config-item:last-child {
      border-bottom: none;
    }
    .config-lbl {
      font-weight: 500;
      color: #334155;
    }
    .config-val {
      color: #64748b;
    }

    /* Footer */
    footer {
      background-color: #1e293b;
      color: #94a3b8;
      text-align: center;
      padding: 16px 20px;
      font-size: 12px;
      border-top: 1px solid #334155;
    }
  </style>
</head>
<body>

<!-- Header -->
<header>
  <a href="home.jsp" class="logo">EMS</a>
  <nav>
    <a href="home_admin.jsp" class="active">Trang chủ</a>
    <a href="#">Tài khoản</a>
    <a href="#">Phân quyền</a>
    <a href="#">Công thức lương</a>
    <a href="#">Cấu hình</a>
  </nav>
  <div class="user-menu">
    <span class="role-badge">Quản trị viên</span>
    <span style="font-size:13px;">Admin</span>
    <button class="logout-btn" onclick="alert('Đã đăng xuất')">Đăng xuất</button>
  </div>
</header>

<!-- Main Container -->
<div class="container">
  <div class="welcome-section">
    <h1>Chào mừng, Quản trị viên</h1>
    <p>Hệ thống hoạt động bình thường.</p>
  </div>

  <!-- Quick Stats -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-title">Tổng số tài khoản</div>
      <div class="stat-value">87</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Số vai trò</div>
      <div class="stat-value">3</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Công thức lương</div>
      <div class="stat-value">5</div>
    </div>
  </div>

  <div class="main-grid">
    <!-- Recent Accounts -->
    <div class="card">
      <div class="card-header">Tài khoản nhân viên gần đây</div>
      <div class="card-body">
        <div class="acc-list">
          <div class="acc-item">
            <div class="acc-info">
              <h4>Nguyễn Văn Thanh</h4>
              <p>thanh@ems.com · Nhân viên</p>
            </div>
            <span class="status-badge active">Hoạt động</span>
          </div>
          <div class="acc-item">
            <div class="acc-info">
              <h4>Manager Khoa</h4>
              <p>khoa@ems.com · Quản lý</p>
            </div>
            <span class="status-badge active">Hoạt động</span>
          </div>
          <div class="acc-item">
            <div class="acc-info">
              <h4>Trần Văn Nam</h4>
              <p>nam@ems.com · Nhân viên</p>
            </div>
            <span class="status-badge inactive">Khóa</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Configuration Settings -->
    <div class="card">
      <div class="card-header">Cấu hình hệ thống</div>
      <div class="card-body">
        <div class="config-list">
          <div class="config-item">
            <span class="config-lbl">Số giờ làm việc định mức</span>
            <span class="config-val">8 giờ/ngày</span>
          </div>
          <div class="config-item">
            <span class="config-lbl">Hệ số làm thêm giờ</span>
            <span class="config-val">1.5x</span>
          </div>
          <div class="config-item">
            <span class="config-lbl">Hạn mức nghỉ phép/năm</span>
            <span class="config-val">12 ngày</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Footer -->
<footer>
  © 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391
</footer>

</body>
</html>

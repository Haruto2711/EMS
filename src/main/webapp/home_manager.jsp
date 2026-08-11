<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Trang chủ Quản lý</title>
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
    }

    /* Sidebar Layout */
    .sidebar {
      width: 260px;
      background-color: #1e293b;
      color: #ffffff;
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      padding: 24px 16px;
      z-index: 100;
    }
    .logo {
      font-size: 24px;
      font-weight: 700;
      color: #ffffff;
      text-decoration: none;
      margin-bottom: 32px;
      padding-left: 12px;
    }
    .sidebar nav {
      display: flex;
      flex-direction: column;
      gap: 8px;
      flex: 1;
    }
    .sidebar nav a {
      color: #cbd5e1;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      padding: 12px;
      border-radius: 8px;
      transition: background 0.2s, color 0.2s;
    }
    .sidebar nav a:hover, .sidebar nav a.active {
      background-color: #334155;
      color: #ffffff;
    }
    .sidebar-footer {
      border-top: 1px solid #334155;
      padding-top: 16px;
      margin-top: auto;
    }
    .user-info {
      margin-bottom: 12px;
      padding: 0 12px;
    }
    .user-name {
      font-size: 14px;
      font-weight: 600;
      color: #ffffff;
      display: block;
    }
    .role-badge {
      display: inline-block;
      background-color: #6366f1;
      color: #ffffff;
      font-size: 11px;
      font-weight: 600;
      padding: 2px 8px;
      border-radius: 12px;
      margin-top: 4px;
    }
    .logout-btn {
      width: 100%;
      color: #ffffff;
      background-color: #ef4444;
      border: none;
      padding: 10px;
      border-radius: 8px;
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s;
    }
    .logout-btn:hover {
      background-color: #dc2626;
    }

    /* Main Content */
    .main-content {
      margin-left: 260px;
      flex: 1;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    .container {
      width: 100%;
      max-width: 1100px;
      padding: 32px 40px;
      flex: 1;
    }

    .welcome-section {
      margin-bottom: 24px;
    }
    .welcome-section h1 {
      font-size: 26px;
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
      margin-bottom: 28px;
    }
    .stat-card {
      background: #ffffff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
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
    @media (max-width: 992px) {
      .main-grid { grid-template-columns: 1fr; }
    }

    .card {
      background: #ffffff;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
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

    /* Request Item List */
    .req-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .req-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px;
      background-color: #f8fafc;
      border-radius: 6px;
      border: 1px solid #e2e8f0;
    }
    .req-info h4 {
      font-size: 14px;
      font-weight: 600;
      color: #334155;
    }
    .req-info p {
      font-size: 12px;
      color: #64748b;
      margin-top: 2px;
    }
    .action-btns {
      display: flex;
      gap: 8px;
    }
    .btn-small {
      padding: 6px 12px;
      font-size: 12px;
      font-weight: 600;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      transition: opacity 0.2s;
    }
    .btn-small:hover { opacity: 0.9; }
    .btn-small.approve { background-color: #dcfce7; color: #166534; }
    .btn-small.reject { background-color: #fee2e2; color: #991b1b; }

    /* Attendance Table */
    .att-table {
      width: 100%;
      border-collapse: collapse;
    }
    .att-table th {
      text-align: left;
      font-size: 11px;
      font-weight: 600;
      color: #64748b;
      padding: 10px;
      border-bottom: 1px solid #e2e8f0;
      background-color: #f8fafc;
    }
    .att-table td {
      padding: 10px;
      font-size: 13px;
      border-bottom: 1px solid #e2e8f0;
    }
    .status-dot {
      display: inline-block;
      width: 8px;
      height: 8px;
      border-radius: 50%;
      margin-right: 6px;
    }
    .status-dot.present { background-color: #10b981; }
    .status-dot.late { background-color: #f59e0b; }

    /* Footer */
    footer {
      background-color: #f8fafc;
      color: #94a3b8;
      text-align: center;
      padding: 20px;
      font-size: 12px;
      border-top: 1px solid #e2e8f0;
      margin-top: auto;
    }
  </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
  <a href="home.jsp" class="logo">EMS</a>
  <nav>
    <a href="home_manager.jsp" class="active">Trang chủ</a>
    <a href="#">Lịch trình nhóm</a>
    <a href="#">Điểm danh phòng ban</a>
    <a href="#">Bảng lương nháp</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-info">
      <span class="user-name">Manager Khoa</span>
      <span class="role-badge">Quản lý</span>
    </div>
    <button class="logout-btn" onclick="alert('Đã đăng xuất')">Đăng xuất</button>
  </div>
</aside>

<!-- Main Content Area -->
<div class="main-content">
  <div class="container">
    <div class="welcome-section">
      <h1>Chào mừng, Manager Khoa</h1>
      <p>Dưới đây là tổng quan quản lý phòng ban của bạn.</p>
    </div>

    <!-- Quick Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-title">Tổng số nhân sự</div>
        <div class="stat-value">24</div>
      </div>
      <div class="stat-card">
        <div class="stat-title">Yêu cầu chờ duyệt</div>
        <div class="stat-value">3</div>
      </div>
      <div class="stat-card">
        <div class="stat-title">Tỷ lệ đi làm hôm nay</div>
        <div class="stat-value">94%</div>
      </div>
    </div>

    <div class="main-grid">
      <!-- Approve List -->
      <div class="card">
        <div class="card-header">Yêu cầu chờ duyệt</div>
        <div class="card-body">
          <div class="req-list">
            <div class="req-item">
              <div class="req-info">
                <h4>Nguyễn Văn Thanh</h4>
                <p>Nghỉ phép năm · 15/08 - 17/08</p>
              </div>
              <div class="action-btns">
                <button class="btn-small approve" onclick="alert('Đã duyệt')">Duyệt</button>
                <button class="btn-small reject" onclick="alert('Đã từ chối')">Từ chối</button>
              </div>
            </div>
            <div class="req-item">
              <div class="req-info">
                <h4>Lê Thị Mai</h4>
                <p>Nghỉ ốm · 12/08</p>
              </div>
              <div class="action-btns">
                <button class="btn-small approve" onclick="alert('Đã duyệt')">Duyệt</button>
                <button class="btn-small reject" onclick="alert('Đã từ chối')">Từ chối</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Dept Attendance -->
      <div class="card">
        <div class="card-header">Tình hình điểm danh hôm nay</div>
        <div class="card-body">
          <table class="att-table">
            <thead>
              <tr>
                <th>Nhân viên</th>
                <th>Giờ vào</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Nguyễn Văn Thanh</td>
                <td>08:02</td>
                <td><span class="status-dot present"></span>Có mặt</td>
              </tr>
              <tr>
                <td>Lê Thị Mai</td>
                <td>08:45</td>
                <td><span class="status-dot late"></span>Đi muộn</td>
              </tr>
              <tr>
                <td>Phạm Thị Lan</td>
                <td>07:58</td>
                <td><span class="status-dot present"></span>Có mặt</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer>
    © 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391
  </footer>
</div>

</body>
</html>

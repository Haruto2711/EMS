<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Trang chủ Nhân viên</title>
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
      background-color: #3b82f6;
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

    /* Attendance Form */
    .attendance-box {
      text-align: center;
    }
    .clock {
      font-size: 36px;
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 8px;
    }
    .date-str {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 20px;
    }
    .btn-group {
      display: flex;
      gap: 12px;
      justify-content: center;
    }
    .btn {
      padding: 10px 20px;
      font-size: 14px;
      font-weight: 600;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: opacity 0.2s;
    }
    .btn:hover { opacity: 0.9; }
    .btn-primary { background-color: #10b981; color: #ffffff; }
    .btn-secondary { background-color: #f59e0b; color: #ffffff; }
    .status-message {
      margin-top: 16px;
      font-size: 13px;
      color: #64748b;
    }

    /* Recent Requests List */
    .request-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .request-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px;
      background-color: #f8fafc;
      border-radius: 6px;
      border: 1px solid #e2e8f0;
    }
    .request-info h4 {
      font-size: 14px;
      font-weight: 600;
      color: #334155;
    }
    .request-info p {
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
    .status-badge.pending { background-color: #fef9c3; color: #854d0e; }
    .status-badge.approved { background-color: #dcfce7; color: #166534; }

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
    <a href="home.jsp" class="active">Trang chủ</a>
    <a href="#">Lịch trình</a>
    <a href="#">Yêu cầu</a>
    <a href="#">Bảng lương</a>
  </nav>
  <div class="user-menu">
    <span class="role-badge">Nhân viên</span>
    <span style="font-size:13px;">Nguyễn Văn Thanh</span>
    <button class="logout-btn" onclick="alert('Đã đăng xuất')">Đăng xuất</button>
  </div>
</header>

<!-- Main Container -->
<div class="container">
  <div class="welcome-section">
    <h1>Chào mừng, Nguyễn Văn Thanh</h1>
    <p>Dưới đây là tổng quan hoạt động trong ngày của bạn.</p>
  </div>

  <!-- Quick Stats -->
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-title">Ngày công định mức (Tháng)</div>
      <div class="stat-value">22</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Số ngày đã đi làm</div>
      <div class="stat-value">18</div>
    </div>
    <div class="stat-card">
      <div class="stat-title">Ngày phép còn lại</div>
      <div class="stat-value">12 ngày</div>
    </div>
  </div>

  <div class="main-grid">
    <!-- Attendance -->
    <div class="card">
      <div class="card-header">Điểm danh hàng ngày</div>
      <div class="card-body">
        <div class="attendance-box">
          <div class="clock" id="live-clock">00:00:00</div>
          <div class="date-str" id="live-date">...</div>
          <div class="btn-group">
            <button class="btn btn-primary" onclick="checkIn()">Check In</button>
            <button class="btn btn-secondary" onclick="checkOut()">Check Out</button>
          </div>
          <div class="status-message" id="attendance-status">Hôm nay bạn chưa điểm danh.</div>
        </div>
      </div>
    </div>

    <!-- Leave Requests -->
    <div class="card">
      <div class="card-header">Yêu cầu nghỉ phép gần đây</div>
      <div class="card-body">
        <ul class="request-list">
          <li class="request-item">
            <div class="request-info">
              <h4>Nghỉ phép năm (3 ngày)</h4>
              <p>15/08/2026 - 17/08/2026</p>
            </div>
            <span class="status-badge pending">Chờ duyệt</span>
          </li>
          <li class="request-item">
            <div class="request-info">
              <h4>Nghỉ ốm (1 ngày)</h4>
              <p>05/08/2026</p>
            </div>
            <span class="status-badge approved">Đã duyệt</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- Footer -->
<footer>
  © 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391
</footer>

<script>
  // Live Clock
  function updateTime() {
    var now = new Date();
    var h = String(now.getHours()).padStart(2, '0');
    var m = String(now.getMinutes()).padStart(2, '0');
    var s = String(now.getSeconds()).padStart(2, '0');
    document.getElementById('live-clock').textContent = h + ':' + m + ':' + s;

    var days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
    document.getElementById('live-date').textContent = days[now.getDay()] + ', ngày ' + now.getDate() + ' tháng ' + (now.getMonth() + 1) + ' năm ' + now.getFullYear();
  }
  updateTime();
  setInterval(updateTime, 1000);

  // Checkin dummy triggers
  var checkedIn = false;
  function checkIn() {
    if (checkedIn) {
      alert("Bạn đã điểm danh vào hôm nay rồi!");
      return;
    }
    checkedIn = true;
    var timeStr = new Date().toLocaleTimeString('en-GB');
    document.getElementById('attendance-status').innerHTML = "Đã điểm danh vào lúc <strong>" + timeStr + "</strong>";
  }
  function checkOut() {
    if (!checkedIn) {
      alert("Vui lòng điểm danh vào trước!");
      return;
    }
    var timeStr = new Date().toLocaleTimeString('en-GB');
    document.getElementById('attendance-status').innerHTML = "Đã điểm danh ra lúc <strong>" + timeStr + "</strong>";
  }
</script>
</body>
</html>

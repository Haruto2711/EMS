<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Quản lý lương – EMS Manager</title>
  <link rel="stylesheet" href="ems.css"/>
  <link rel="stylesheet" href="salary-management.css"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <a href="home_manager.jsp" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Menu chính</div>
    <a href="home_manager.jsp" class="nav-link">Trang chủ</a>
    <a href="#" class="nav-link">Lịch trình nhóm</a>
    <div class="nav-section-label">Quản lý</div>
    <a href="#" class="nav-link">Điểm danh phòng ban</a>
    <a href="salary-management" class="nav-link active">Quản lý lương</a>
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

<!-- MAIN CONTENT WRAPPER -->
<div class="main-content">
  <!-- TOPBAR -->
  <div class="topbar">
    <span class="topbar-left">Trang chủ / Quản lý lương</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <!-- PAGE BODY -->
  <div class="page-body">
    <!-- Header Section -->
    <div class="sm-header">
      <h1>Trung tâm Quản lý Lương (Salary Management)</h1>
      <p>Chọn một trong các danh mục quản lý lương dưới đây để tiếp tục</p>
    </div>

    <!-- Option Cards Grid in BODY -->
    <div class="sm-grid">
      
      <!-- Option Card 1: Xem Lương cơ bản -->
      <div class="sm-card">
        <div>
          <div class="sm-card-icon-wrapper icon-blue">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="5" width="20" height="14" rx="2"></rect>
              <line x1="2" y1="10" x2="22" y2="10"></line>
            </svg>
          </div>
          <div class="sm-card-title">Xem lương cơ bản</div>
          <div class="sm-card-desc">
            Quản lý mức lương cơ bản (Base Salary) hợp đồng và thiết lập số người phụ thuộc (NPT) cho toàn bộ nhân viên.
          </div>
        </div>
        <div class="sm-card-footer">
          <a href="base-salaries" class="btn-sm-action btn-action-primary">
            Truy cập ngay →
          </a>
        </div>
      </div>

      <!-- Option Card 2: Quản lý các kỳ lương -->
      <div class="sm-card">
        <div>
          <div class="sm-card-icon-wrapper icon-emerald">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
              <line x1="16" y1="2" x2="16" y2="6"></line>
              <line x1="8" y1="2" x2="8" y2="6"></line>
              <line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
          </div>
          <div class="sm-card-title">Quản lý kỳ lương</div>
          <div class="sm-card-desc">
            Tạo mới, chỉnh sửa chu kỳ thời gian, chốt sổ/khóa hoặc mở khóa các kỳ tính lương nhân viên.
          </div>
        </div>
        <div class="sm-card-footer">
          <a href="pay-periods" class="btn-sm-action btn-action-emerald">
            Quản lý kỳ lương →
          </a>
        </div>
      </div>

      <!-- Option Card 3: Xem Bảng lương các kỳ -->
      <div class="sm-card">
        <div>
          <div class="sm-card-icon-wrapper icon-indigo">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
              <polyline points="14 2 14 8 20 8"></polyline>
              <line x1="16" y1="13" x2="8" y2="13"></line>
              <line x1="16" y1="17" x2="8" y2="17"></line>
              <polyline points="10 9 9 9 8 9"></polyline>
            </svg>
          </div>
          <div class="sm-card-title">Xem bảng lương chi tiết</div>
          <div class="sm-card-desc">
            Lựa chọn từng kỳ lương để kiểm tra toàn bộ phiếu lương nhân viên, phụ cấp, OT, BHXH và thuế TNCN.
          </div>
        </div>
        <div class="sm-card-footer">
          <a href="manager-payslips" class="btn-sm-action btn-action-indigo">
            Xem bảng lương →
          </a>
        </div>
      </div>

    </div>
  </div>


  <!-- FOOTER -->
  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<script>
  function tick() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    var el = document.getElementById('topbar-date');
    if (el) {
      el.textContent = p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
    }
  }
  tick();
</script>

</body>
</html>

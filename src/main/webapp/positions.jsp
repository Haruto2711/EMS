<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> positionsList = (List<Map<String, Object>>) request.getAttribute("positionsList");
    Map<Integer, List<Map<String, Object>>> posEmployeesMap = (Map<Integer, List<Map<String, Object>>>) request.getAttribute("posEmployeesMap");
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
    Integer totalPositions = (Integer) request.getAttribute("totalPositions");
    Integer assignedPositions = (Integer) request.getAttribute("assignedPositions");
    if (totalPositions == null) totalPositions = positionsList != null ? positionsList.size() : 0;
    if (assignedPositions == null) assignedPositions = 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý chức vụ</title>
  <link rel="stylesheet" href="css/ems.css"/>
  <link rel="stylesheet" href="css/users.css"/>
  <link rel="stylesheet" href="css/departments.css"/>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
  <a href="home" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Tổng quan</div>
    <a href="home" class="nav-link">Trang chủ</a>
    <div class="nav-section-label">Quản trị</div>
    <a href="users"       class="nav-link">Tài khoản</a>
    <a href="employees"   class="nav-link">Nhân viên</a>
    <a href="departments" class="nav-link">Phòng ban</a>
    <a href="positions"   class="nav-link active">Chức vụ</a>
  </nav>
  <div class="sidebar-footer">
    <div class="user-block">
      <div class="user-avatar">
        <%= fullName != null && !fullName.isEmpty() ? fullName.substring(0,1).toUpperCase() : "A" %>
      </div>
      <div>
        <div class="user-name"><%= fullName != null ? fullName : "Admin" %></div>
        <div class="user-role"><%= deptName != null ? deptName : "Quản trị viên" %></div>
      </div>
    </div>
    <button class="btn-logout" onclick="window.location='logout'">Đăng xuất</button>
  </div>
</aside>

<!-- Main content -->
<div class="main-content">
  <div class="topbar">
    <span class="topbar-left">Quản lý chức vụ</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">

    <!-- Page Header -->
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
      <div>
        <h1 style="font-size: 24px; font-weight: 700; color: #111827; margin-bottom: 4px;">Quản lý chức vụ</h1>
        <p style="font-size: 14px; color: #4b5563;">Danh sách các chức danh nghề nghiệp và phân cấp chuyên môn trong công ty</p>
      </div>
      <button class="btn-add-acc" onclick="openAddModal()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        Thêm chức vụ
      </button>
    </div>

    <!-- Stats Section -->
    <div class="stats-row" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 24px;">
      <div class="stat-card" style="border-left: 4px solid #3b82f6;">
        <div class="stat-label">TỔNG CHỨC VỤ</div>
        <div class="stat-value"><%= totalPositions %></div>
      </div>
      <div class="stat-card" style="border-left: 4px solid #10b981;">
        <div class="stat-label">ĐÃ CÓ NHÂN SỰ</div>
        <div class="stat-value"><%= assignedPositions %></div>
      </div>
    </div>

    <!-- Main Card -->
    <div class="card">
      <div class="card-header">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0d9488" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
        <span>Danh sách chức vụ</span>
      </div>

      <!-- Filter / Search Bar -->
      <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="Tìm kiếm theo mã hoặc tên chức vụ..." oninput="filterTable()"/>
      </div>

      <!-- Table -->
      <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 13.5px;" id="posTable">
          <thead>
            <tr style="border-bottom: 1.5px solid #f3f4f6; color: #6b7280; text-transform: uppercase; font-size: 11px; font-weight: 700; letter-spacing: 0.5px;">
              <th style="padding: 14px 16px;">Mã CV</th>
              <th style="padding: 14px 16px;">Tên chức vụ</th>
              <th style="padding: 14px 16px;">Cấp bậc</th>
              <th style="padding: 14px 16px;">Số nhân sự</th>
              <th style="padding: 14px 16px;">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (positionsList != null && !positionsList.isEmpty()) {
                for (Map<String, Object> pos : positionsList) {
                  int id = (Integer) pos.get("id");
                  String code = (String) pos.get("code");
                  String name = (String) pos.get("name");
                  int jobLevel = (Integer) pos.get("jobLevel");
                  int totalEmp = (Integer) pos.get("totalEmployees");
            %>
            <tr class="pos-row" data-code="<%= code != null ? code.toLowerCase() : "" %>" data-name="<%= name != null ? name.toLowerCase() : "" %>" style="border-bottom: 1px solid #f3f4f6; transition: background 0.1s;" onmouseover="this.style.background='#f9fafb'" onmouseout="this.style.background='transparent'">
              <td style="padding: 12px 16px;">
                <span class="dept-code-tag"><%= code != null ? code : "" %></span>
              </td>
              <td style="padding: 12px 16px; font-weight: 600; color: #111827;">
                <%= name != null ? name : "" %>
              </td>
              <td style="padding: 12px 16px;">
                <span class="badge-role">Level <%= jobLevel %></span>
              </td>
              <td style="padding: 12px 16px;">
                <a href="employees?pos=<%= java.net.URLEncoder.encode(name != null ? name : "", "UTF-8") %>" style="text-decoration: none;" title="Xem danh sách nhân viên giữ chức vụ <%= name %>">
                  <span class="badge-headcount <%= totalEmp == 0 ? "empty" : "" %>" style="cursor: pointer;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    <%= totalEmp %> nhân sự
                  </span>
                </a>
              </td>
              <td style="padding: 12px 16px;">
                <a href="javascript:void(0)" onclick="openEditModal(<%= id %>, '<%= code %>', '<%= name %>', <%= jobLevel %>)" style="color: #0d9488; text-decoration: none; font-weight: 600;">Sửa</a>
              </td>
            </tr>
            <%
                }
              } else {
            %>
            <tr>
              <td colspan="5" style="text-align: center; color: #9ca3af; padding: 40px;">
                Chưa có chức vụ nào trong hệ thống
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<!-- ==========================================
     MODAL 1: THÊM CHỨC VỤ MỚI
     ========================================== -->
<div class="modal-backdrop" id="addModal">
  <div class="modal-content">
    <div class="modal-header">
      <div class="modal-title">Thêm chức vụ mới</div>
      <button class="modal-close" onclick="closeAddModal()">&times;</button>
    </div>
    <form action="positions" method="post">
      <input type="hidden" name="action" value="create"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Mã chức vụ <span style="color:red;">*</span></label>
          <input type="text" name="code" class="form-input" placeholder="Ví dụ: DEV, TEST, ACC, HR_SPEC..." required/>
        </div>
        <div class="form-group">
          <label class="form-label">Tên chức vụ <span style="color:red;">*</span></label>
          <input type="text" name="name" class="form-input" placeholder="Ví dụ: Lập trình viên, Kế toán viên..." required/>
        </div>
        <div class="form-group">
          <label class="form-label">Cấp bậc (Job Level) <span style="color:red;">*</span></label>
          <select name="jobLevel" class="form-input" required>
            <option value="1">Level 1 - Junior / Thực tập</option>
            <option value="2" selected>Level 2 - Middle / Nhân viên chính thức</option>
            <option value="3">Level 3 - Senior / Chuyên viên</option>
            <option value="4">Level 4 - Lead / Trưởng nhóm / Quản lý</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeAddModal()">Hủy</button>
        <button type="submit" class="btn-primary">Thêm mới</button>
      </div>
    </form>
  </div>
</div>

<!-- ==========================================
     MODAL 2: SỬA CHỨC VỤ
     ========================================== -->
<div class="modal-backdrop" id="editModal">
  <div class="modal-content">
    <div class="modal-header">
      <div class="modal-title">Chỉnh sửa chức vụ</div>
      <button class="modal-close" onclick="closeEditModal()">&times;</button>
    </div>
    <form action="positions" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" id="editPosId"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Mã chức vụ</label>
          <input type="text" id="editPosCode" class="form-input" readonly style="background:#f3f4f6; color:#6b7280; cursor:not-allowed;"/>
        </div>
        <div class="form-group">
          <label class="form-label">Tên chức vụ <span style="color:red;">*</span></label>
          <input type="text" name="name" id="editPosName" class="form-input" required/>
        </div>
        <div class="form-group">
          <label class="form-label">Cấp bậc (Job Level) <span style="color:red;">*</span></label>
          <select name="jobLevel" id="editPosLevel" class="form-input" required>
            <option value="1">Level 1 - Junior / Thực tập</option>
            <option value="2">Level 2 - Middle / Nhân viên chính thức</option>
            <option value="3">Level 3 - Senior / Chuyên viên</option>
            <option value="4">Level 4 - Lead / Trưởng nhóm / Quản lý</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeEditModal()">Hủy</button>
        <button type="submit" class="btn-primary">Lưu thay đổi</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Cập nhật ngày tháng trên Topbar
  (function updateDate() {
    const d = new Date();
    const str = String(d.getDate()).padStart(2,'0') + '/' +
                String(d.getMonth()+1).padStart(2,'0') + '/' +
                d.getFullYear();
    const el = document.getElementById('topbar-date');
    if (el) el.textContent = str;
  })();

  // Lọc tìm kiếm theo Mã hoặc Tên chức vụ
  function filterTable() {
    const term = document.getElementById('searchInput').value.toLowerCase().trim();
    const rows = document.querySelectorAll('.pos-row');
    rows.forEach(r => {
      const code = r.getAttribute('data-code') || '';
      const name = r.getAttribute('data-name') || '';
      if (!term || code.includes(term) || name.includes(term)) {
        r.style.display = '';
      } else {
        r.style.display = 'none';
      }
    });
  }

  // Modal Thêm
  function openAddModal() {
    document.getElementById('addModal').style.display = 'flex';
  }
  function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
  }

  // Modal Sửa
  function openEditModal(id, code, name, level) {
    document.getElementById('editPosId').value = id;
    document.getElementById('editPosCode').value = code;
    document.getElementById('editPosName').value = name;
    document.getElementById('editPosLevel').value = level;
    document.getElementById('editModal').style.display = 'flex';
  }
  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  // Đóng Modal khi bấm ngoài vùng backdrop
  window.onclick = function(e) {
    if (e.target.classList.contains('modal-backdrop')) {
      e.target.style.display = 'none';
    }
  }
</script>
</body>
</html>

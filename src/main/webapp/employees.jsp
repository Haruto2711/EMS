<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> employeeList = (List<Map<String, Object>>) request.getAttribute("employeeList");
    Integer totalEmp   = (Integer) request.getAttribute("totalEmp");
    Integer activeEmp  = (Integer) request.getAttribute("activeEmp");
    List<Map<String, Object>> deptsList = (List<Map<String, Object>>) request.getAttribute("deptsList");
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý nhân viên</title>
  <link rel="stylesheet" href="css/ems.css"/>
  <link rel="stylesheet" href="css/users.css"/>
  <link rel="stylesheet" href="css/employees.css"/>
</head>
<body>

<aside class="sidebar">
  <a href="home" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Tổng quan</div>
    <a href="home" class="nav-link">Trang chủ</a>
    <div class="nav-section-label">Quản lý</div>
    <a href="users"     class="nav-link">Tài khoản</a>
    <a href="employees" class="nav-link active">Nhân viên</a>
    <a href="#"         class="nav-link">Phân quyền</a>
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
    <button class="btn-logout" onclick="window.location='login'">Đăng xuất</button>
  </div>
</aside>

<div class="main-content">
  <div class="topbar">
    <span class="topbar-left">Quản lý nhân viên</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">

    <!-- Page Header -->
    <div class="emp-page-header">
      <div>
        <h1 class="emp-page-title">Thông tin nhân viên</h1>
        <p class="emp-page-subtitle">Danh sách hồ sơ nhân viên trong hệ thống</p>
      </div>
    </div>

    <!-- Stats -->
    <div class="emp-stats-row">
      <div class="stat-card" style="border-left: 4px solid #3b82f6;">
        <div class="stat-label">TỔNG NHÂN VIÊN</div>
        <div class="stat-value"><%= totalEmp %></div>
      </div>
      <div class="stat-card" style="border-left: 4px solid #10b981;">
        <div class="stat-label">ĐANG HOẠT ĐỘNG</div>
        <div class="stat-value"><%= activeEmp %></div>
      </div>
    </div>

    <!-- Main Card -->
    <div class="card">
      <div class="card-header" style="display:flex; align-items:center; gap:8px; font-weight:700; font-size:15px; color:#111827; border-bottom:1px solid #f3f4f6; padding:14px 18px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0d9488" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
        Danh sách nhân viên
      </div>

      <!-- Filter bar -->
      <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="Tìm kiếm tên / mã nhân viên..." oninput="filterTable()"/>
        <select id="filterDept" onchange="filterTable()">
          <option value="">Tất cả phòng ban</option>
          <% if (deptsList != null) { for (Map<String,Object> d : deptsList) { %>
            <option value="<%= d.get("name") %>"><%= d.get("name") %></option>
          <% }} %>
        </select>
        <select id="filterStatus" onchange="filterTable()">
          <option value="">Tất cả trạng thái</option>
          <option value="active">Đang làm</option>
          <option value="locked">Nghỉ</option>
        </select>
      </div>

      <!-- Table -->
      <div class="emp-table-wrap">
        <table class="emp-table" id="empTable">
          <thead>
            <tr>
              <th>Mã NV</th>
              <th>Họ và tên</th>
              <th>Phòng ban</th>
              <th>Chức vụ</th>
              <th>Email</th>
              <th>Số điện thoại</th>
              <th>Trạng thái</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody id="empTableBody">
          <%
            if (employeeList != null && !employeeList.isEmpty()) {
              for (Map<String, Object> emp : employeeList) {
                Boolean status = (Boolean) emp.get("userStatus");
                boolean isActive = (status != null && status);
                String phone = (String) emp.get("phone");
                if (phone == null || phone.isEmpty()) phone = "—";
          %>
            <tr class="emp-row"
                data-name="<%= emp.get("fullName") %>"
                data-code="<%= emp.get("employeeCode") %>"
                data-dept="<%= emp.get("departmentName") != null ? emp.get("departmentName") : "" %>"
                data-status="<%= isActive ? "active" : "locked" %>">
              <td><span class="emp-code"><%= emp.get("employeeCode") %></span></td>
              <td>
                <div class="emp-name"><%= emp.get("fullName") %></div>
                <div class="emp-email-sub"><%= emp.get("emailCompany") %></div>
              </td>
              <td><%= emp.get("departmentName") != null ? emp.get("departmentName") : "—" %></td>
              <td><%= emp.get("positionName")   != null ? emp.get("positionName")   : "—" %></td>
              <td><%= emp.get("emailCompany") %></td>
              <td><%= phone %></td>
              <td>
                <span class="<%= isActive ? "badge-active" : "badge-locked" %>">
                  <%= isActive ? "Đang làm" : "Nghỉ" %>
                </span>
              </td>
              <td>
                <a href="javascript:void(0)"
                   onclick="openEditEmpModal(<%= emp.get("userId") %>, '<%= emp.get("fullName") %>', '<%= emp.get("emailCompany") %>', '<%= emp.get("phone") != null ? emp.get("phone") : "" %>')"
                   style="color:#0d9488; text-decoration:none; font-weight:600; margin-right:12px;">Sửa</a>
                <form action="employees" method="post" style="display:inline;">
                  <input type="hidden" name="action" value="toggleStatus"/>
                  <input type="hidden" name="userId" value="<%= emp.get("userId") %>"/>
                  <input type="hidden" name="currentStatus" value="<%= isActive %>"/>
                  <button type="submit" style="background:none; border:none; color:#dc2626; cursor:pointer; font-size:13.5px; font-weight:600; padding:0; font-family:inherit;">
                    <%= isActive ? "Ẩn" : "Hiện" %>
                  </button>
                </form>
              </td>
            </tr>
          <%
              }
            } else {
          %>
            <tr>
              <td colspan="8" class="emp-empty">Không có nhân viên nào.</td>
            </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<!-- Modal Sửa thông tin nhân viên -->
<div class="modal-backdrop" id="editEmpModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); backdrop-filter:blur(4px); z-index:1000; align-items:center; justify-content:center;">
  <div class="modal-content" style="background:#fff; border-radius:12px; width:440px; max-width:94vw; box-shadow:0 20px 60px rgba(0,0,0,0.15);">
    <div class="modal-header" style="padding:18px 22px; border-bottom:1px solid #f3f4f6; display:flex; justify-content:space-between; align-items:center;">
      <span class="modal-title" style="font-weight:700; font-size:16px; color:#111827;">Chỉnh sửa thông tin nhân viên</span>
      <button onclick="closeEditEmpModal()" style="background:none; border:none; font-size:20px; cursor:pointer; color:#6b7280; line-height:1;">&times;</button>
    </div>
    <form action="employees" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="userId" id="editEmpUserId"/>
      <div class="modal-body" style="padding:20px 22px; display:flex; flex-direction:column; gap:14px;">
        <div class="form-group">
          <label class="form-label" style="font-size:13px; font-weight:600; color:#374151; margin-bottom:5px; display:block;">Họ và tên</label>
          <input type="text" name="fullName" id="editEmpFullName" class="form-input" required
                 style="width:100%; padding:9px 12px; border:1px solid #e5e7eb; border-radius:8px; font-size:13.5px; outline:none; box-sizing:border-box;"/>
        </div>
        <div class="form-group">
          <label class="form-label" style="font-size:13px; font-weight:600; color:#374151; margin-bottom:5px; display:block;">Email công ty</label>
          <input type="email" name="email" id="editEmpEmail" class="form-input" required
                 style="width:100%; padding:9px 12px; border:1px solid #e5e7eb; border-radius:8px; font-size:13.5px; outline:none; box-sizing:border-box;"/>
        </div>
        <div class="form-group">
          <label class="form-label" style="font-size:13px; font-weight:600; color:#374151; margin-bottom:5px; display:block;">Số điện thoại</label>
          <input type="text" name="phone" id="editEmpPhone" class="form-input"
                 style="width:100%; padding:9px 12px; border:1px solid #e5e7eb; border-radius:8px; font-size:13.5px; outline:none; box-sizing:border-box;"/>
        </div>
      </div>
      <div style="padding:14px 22px; border-top:1px solid #f3f4f6; display:flex; justify-content:flex-end; gap:10px;">
        <button type="button" onclick="closeEditEmpModal()"
                style="padding:9px 18px; border:1px solid #e5e7eb; border-radius:8px; background:#fff; font-size:13.5px; cursor:pointer; color:#374151;">Hủy</button>
        <button type="submit"
                style="padding:9px 18px; border:none; border-radius:8px; background:#0d9488; color:#fff; font-size:13.5px; font-weight:600; cursor:pointer;">Lưu thay đổi</button>
      </div>
    </form>
  </div>
</div>

<script>
  (function() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('topbar-date').textContent =
      p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  })();

  function filterTable() {
    var search  = document.getElementById('searchInput').value.toLowerCase();
    var dept    = document.getElementById('filterDept').value.toLowerCase();
    var status  = document.getElementById('filterStatus').value.toLowerCase();
    document.querySelectorAll('#empTableBody .emp-row').forEach(function(row) {
      var matchSearch = !search || row.dataset.name.toLowerCase().includes(search) || row.dataset.code.toLowerCase().includes(search);
      var matchDept   = !dept   || row.dataset.dept.toLowerCase() === dept;
      var matchStatus = !status || row.dataset.status === status;
      row.style.display = (matchSearch && matchDept && matchStatus) ? '' : 'none';
    });
  }

  function openEditEmpModal(userId, fullName, email, phone) {
    document.getElementById('editEmpUserId').value  = userId;
    document.getElementById('editEmpFullName').value = fullName;
    document.getElementById('editEmpEmail').value   = email;
    document.getElementById('editEmpPhone').value   = phone;
    var modal = document.getElementById('editEmpModal');
    modal.style.display = 'flex';
  }

  function closeEditEmpModal() {
    document.getElementById('editEmpModal').style.display = 'none';
  }

  // Đóng modal khi click ra ngoài
  document.getElementById('editEmpModal').addEventListener('click', function(e) {
    if (e.target === this) closeEditEmpModal();
  });
</script>
</body>
</html>

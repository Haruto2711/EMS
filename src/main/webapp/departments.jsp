<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> departmentsList = (List<Map<String, Object>>) request.getAttribute("departmentsList");
    List<Map<String, Object>> headCandidatesList = (List<Map<String, Object>>) request.getAttribute("headCandidatesList");
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
%>
<%
    Integer totalDepts = (Integer) request.getAttribute("totalDepts");
    Integer assignedHeadCount = (Integer) request.getAttribute("assignedHeadCount");
    if (totalDepts == null) totalDepts = departmentsList != null ? departmentsList.size() : 0;
    if (assignedHeadCount == null) assignedHeadCount = 0;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý phòng ban</title>
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
    <a href="departments" class="nav-link active">Phòng ban</a>
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
    <span class="topbar-left">Quản lý phòng ban</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">

    <!-- Page Header -->
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
      <div>
        <h1 style="font-size: 24px; font-weight: 700; color: #111827; margin-bottom: 4px;">Quản lý phòng ban</h1>
        <p style="font-size: 14px; color: #4b5563;">Danh sách các phòng ban và cơ cấu nhân sự trong công ty</p>
      </div>
      <button class="btn-add-acc" onclick="openAddModal()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        Thêm phòng ban
      </button>
    </div>

    <!-- Stats Section -->
    <div class="stats-row" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 24px;">
      <div class="stat-card" style="border-left: 4px solid #3b82f6;">
        <div class="stat-label">TỔNG PHÒNG BAN</div>
        <div class="stat-value"><%= totalDepts %></div>
      </div>
      <div class="stat-card" style="border-left: 4px solid #10b981;">
        <div class="stat-label">ĐÃ CÓ TRƯỞNG PHÒNG</div>
        <div class="stat-value"><%= assignedHeadCount %></div>
      </div>
    </div>

    <!-- Main Card -->
    <div class="card">
      <div class="card-header">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0d9488" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="2" width="16" height="20" rx="2" ry="2"></rect><line x1="9" y1="22" x2="9" y2="22.01"></line><line x1="15" y1="22" x2="15" y2="22.01"></line><line x1="9" y1="6" x2="9" y2="6.01"></line><line x1="15" y1="6" x2="15" y2="6.01"></line><line x1="9" y1="10" x2="9" y2="10.01"></line><line x1="15" y1="10" x2="15" y2="10.01"></line><line x1="9" y1="14" x2="9" y2="14.01"></line><line x1="15" y1="14" x2="15" y2="14.01"></line><line x1="9" y1="18" x2="9" y2="18.01"></line><line x1="15" y1="18" x2="15" y2="18.01"></line></svg>
        <span>Danh sách phòng ban</span>
      </div>

      <!-- Filter / Search Bar -->
      <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="Tìm kiếm theo mã, tên phòng hoặc trưởng phòng..." oninput="filterTable()"/>
      </div>

      <!-- Table -->
      <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 13.5px;" id="deptTable">
          <thead>
            <tr style="border-bottom: 1.5px solid #f3f4f6; color: #6b7280; text-transform: uppercase; font-size: 11px; font-weight: 700; letter-spacing: 0.5px;">
              <th style="padding: 14px 16px;">Mã phòng</th>
              <th style="padding: 14px 16px;">Tên phòng ban</th>
              <th style="padding: 14px 16px;">Trưởng phòng</th>
              <th style="padding: 14px 16px;">Số nhân sự</th>
              <th style="padding: 14px 16px;">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (departmentsList != null && !departmentsList.isEmpty()) {
                for (Map<String, Object> dept : departmentsList) {
                  int id = (Integer) dept.get("id");
                  String code = (String) dept.get("code");
                  String name = (String) dept.get("name");
                  Integer headId = (Integer) dept.get("headAccountId");
                  String headName = (String) dept.get("headName");
                  int totalEmp = (Integer) dept.get("totalEmployees");
            %>
            <tr class="dept-row" data-code="<%= code != null ? code.toLowerCase() : "" %>" data-name="<%= name != null ? name.toLowerCase() : "" %>" data-head="<%= headName != null ? headName.toLowerCase() : "" %>" style="border-bottom: 1px solid #f3f4f6; transition: background 0.1s;" onmouseover="this.style.background='#f9fafb'" onmouseout="this.style.background='transparent'">
              <td style="padding: 12px 16px;">
                <span class="dept-code-tag"><%= code != null ? code : "" %></span>
              </td>
              <td style="padding: 12px 16px; font-weight: 600; color: #111827;">
                <%= name != null ? name : "" %>
              </td>
              <td style="padding: 12px 16px;">
                <% if (headName != null && !headName.isEmpty()) { %>
                  <span style="font-weight: 500; color: #111827;"><%= headName %></span>
                <% } else { %>
                  <span class="badge-unassigned">Chưa bổ nhiệm</span>
                <% } %>
              </td>
              <td style="padding: 12px 16px;">
                <span class="badge-headcount <%= totalEmp == 0 ? "empty" : "" %>">
                  <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                  <%= totalEmp %> nhân sự
                </span>
              </td>
              <td style="padding: 12px 16px;">
                <a href="javascript:void(0)" onclick="openEditModal(<%= id %>, '<%= code %>', '<%= name %>', <%= headId != null ? headId : "''" %>)" style="color: #0d9488; text-decoration: none; font-weight: 600; margin-right: 12px;">Sửa</a>
                <a href="javascript:void(0)" onclick="openDeleteModal(<%= id %>, '<%= name %>', <%= totalEmp %>)" style="color: #dc2626; text-decoration: none; font-weight: 600;">Xóa</a>
              </td>
            </tr>
            <%
                }
              } else {
            %>
            <tr>
              <td colspan="5" style="text-align: center; color: #9ca3af; padding: 40px;">
                Chưa có phòng ban nào trong hệ thống
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
     MODAL 1: THÊM PHÒNG BAN MỚI
     ========================================== -->
<div class="modal-backdrop" id="addModal">
  <div class="modal-content">
    <div class="modal-header">
      <div class="modal-title">Thêm phòng ban mới</div>
      <button class="modal-close" onclick="closeAddModal()">&times;</button>
    </div>
    <form action="departments" method="post">
      <input type="hidden" name="action" value="create"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Mã phòng ban <span style="color:red;">*</span></label>
          <input type="text" name="code" class="form-input" placeholder="Ví dụ: MKT, IT, HR, ACC..." required/>
        </div>
        <div class="form-group">
          <label class="form-label">Tên phòng ban <span style="color:red;">*</span></label>
          <input type="text" name="name" class="form-input" placeholder="Ví dụ: Phòng Marketing, Phòng Kỹ thuật..." required/>
        </div>
        <div class="form-group">
          <label class="form-label">Bổ nhiệm Trưởng phòng</label>
          <select name="headAccountId" class="form-input">
            <option value="">-- Chưa bổ nhiệm --</option>
            <% if (headCandidatesList != null) { for (Map<String, Object> emp : headCandidatesList) { %>
              <option value="<%= emp.get("accountId") %>">
                <%= emp.get("fullName") %> (<%= emp.get("employeeCode") %>) - <%= emp.get("deptName") != null ? emp.get("deptName") : "Chưa có PB" %>
              </option>
            <% }} %>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeAddModal()">Hủy</button>
        <button type="submit" class="btn-primary">Thêm phòng ban</button>
      </div>
    </form>
  </div>
</div>

<!-- ==========================================
     MODAL 2: CHỈNH SỬA PHÒNG BAN
     ========================================== -->
<div class="modal-backdrop" id="editModal">
  <div class="modal-content">
    <div class="modal-header">
      <div class="modal-title">Chỉnh sửa phòng ban</div>
      <button class="modal-close" onclick="closeEditModal()">&times;</button>
    </div>
    <form action="departments" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" id="editDeptId"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Mã phòng ban</label>
          <input type="text" id="editDeptCode" class="form-input" readonly style="background: #f3f4f6; cursor: not-allowed;"/>
        </div>
        <div class="form-group">
          <label class="form-label">Tên phòng ban <span style="color:red;">*</span></label>
          <input type="text" name="name" id="editDeptName" class="form-input" required/>
        </div>
        <div class="form-group">
          <label class="form-label">Trưởng phòng</label>
          <select name="headAccountId" id="editHeadAccountId" class="form-input">
            <option value="">-- Chưa bổ nhiệm --</option>
            <% if (headCandidatesList != null) { for (Map<String, Object> emp : headCandidatesList) { %>
              <option value="<%= emp.get("accountId") %>">
                <%= emp.get("fullName") %> (<%= emp.get("employeeCode") %>) - <%= emp.get("deptName") != null ? emp.get("deptName") : "Chưa có PB" %>
              </option>
            <% }} %>
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

<!-- ==========================================
     MODAL 3: XÁC NHẬN XÓA PHÒNG BAN
     ========================================== -->
<div class="modal-backdrop" id="deleteModal">
  <div class="modal-content">
    <div class="modal-header">
      <div class="modal-title">Xác nhận xóa phòng ban</div>
      <button class="modal-close" onclick="closeDeleteModal()">&times;</button>
    </div>
    <form action="departments" method="post" id="deleteForm">
      <input type="hidden" name="action" value="delete"/>
      <input type="hidden" name="id" id="deleteDeptId"/>
      <div class="modal-body">
        <p id="deleteMessage" style="font-size: 14px; color: #374151; line-height: 1.5;"></p>
        <div id="deleteWarning" style="display: none; background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 12px; border-radius: 6px; font-size: 13px; margin-top: 12px;">
          ⚠️ <strong>Cảnh báo:</strong> Phòng ban này hiện đang có nhân viên trực thuộc. Bạn không thể xóa cho đến khi chuyển hết nhân sự sang phòng ban khác!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Đóng</button>
        <button type="submit" class="btn-primary" id="btnConfirmDelete" style="background: #dc2626;">Xóa phòng ban</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Topbar date
  (function() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('topbar-date').textContent =
      p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  })();

  // Filter Table Search
  function filterTable() {
    var query = document.getElementById('searchInput').value.toLowerCase().trim();
    var rows = document.querySelectorAll('#deptTable tbody tr.dept-row');
    rows.forEach(function(row) {
      var code = row.getAttribute('data-code') || '';
      var name = row.getAttribute('data-name') || '';
      var head = row.getAttribute('data-head') || '';
      if (code.indexOf(query) !== -1 || name.indexOf(query) !== -1 || head.indexOf(query) !== -1) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  }

  // Modal Add
  function openAddModal() {
    document.getElementById('addModal').style.display = 'flex';
  }
  function closeAddModal() {
    document.getElementById('addModal').style.display = 'none';
  }

  // Modal Edit
  function openEditModal(id, code, name, headId) {
    document.getElementById('editDeptId').value = id;
    document.getElementById('editDeptCode').value = code;
    document.getElementById('editDeptName').value = name;
    document.getElementById('editHeadAccountId').value = headId ? headId : '';
    document.getElementById('editModal').style.display = 'flex';
  }
  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  // Modal Delete
  function openDeleteModal(id, name, totalEmp) {
    document.getElementById('deleteDeptId').value = id;
    var msg = document.getElementById('deleteMessage');
    var warning = document.getElementById('deleteWarning');
    var btnDelete = document.getElementById('btnConfirmDelete');

    if (totalEmp > 0) {
      msg.innerHTML = 'Bạn đang muốn xóa phòng ban <strong>' + name + '</strong>.';
      warning.style.display = 'block';
      btnDelete.style.display = 'none';
    } else {
      msg.innerHTML = 'Bạn có chắc chắn muốn xóa phòng ban <strong>' + name + '</strong>? Thao tác này không thể hoàn tác.';
      warning.style.display = 'none';
      btnDelete.style.display = 'inline-block';
    }
    document.getElementById('deleteModal').style.display = 'flex';
  }
  function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
  }

  // Click outside to close modals
  window.onclick = function(event) {
    var addM = document.getElementById('addModal');
    var editM = document.getElementById('editModal');
    var delM = document.getElementById('deleteModal');
    if (event.target === addM) addM.style.display = 'none';
    if (event.target === editM) editM.style.display = 'none';
    if (event.target === delM) delM.style.display = 'none';
  };
</script>
</body>
</html>

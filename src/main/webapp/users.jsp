<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> usersList = (List<Map<String, Object>>) request.getAttribute("usersList");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    Integer activeCount = (Integer) request.getAttribute("activeCount");
    Integer lockedCount = (Integer) request.getAttribute("lockedCount");
    List<String> rolesList = (List<String>) request.getAttribute("rolesList");
    List<Map<String, Object>> deptsList = (List<Map<String, Object>>) request.getAttribute("deptsList");
    List<Map<String, Object>> positionsList = (List<Map<String, Object>>) request.getAttribute("positionsList");
    String fullName = (String) request.getAttribute("fullName");
    String deptName = (String) request.getAttribute("deptName");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý tài khoản</title>
  <link rel="stylesheet" href="css/ems.css"/>
  <style>
    /* Custom style matching image 2 */
    .user-avatar-circle {
      width: 32px;
      height: 32px;
      background: #dbeafe;
      color: #1e40af;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 11px;
      font-weight: 600;
      flex-shrink: 0;
    }
    
    .badge-role-select {
      background: #eff6ff;
      color: #2563eb;
      padding: 4px 12px;
      border-radius: 9999px;
      font-size: 12px;
      font-weight: 600;
      text-transform: lowercase;
      border: none;
      outline: none;
      cursor: pointer;
      appearance: none;
      -webkit-appearance: none;
      text-align-last: center;
      display: inline-block;
      min-width: 80px;
    }
    .badge-role-select:hover {
      background: #dbeafe;
    }

    .badge-active {
      background: #ecfdf5;
      color: #065f46;
      padding: 4px 12px;
      border-radius: 9999px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
      border: none;
      cursor: pointer;
    }
    .badge-active:hover {
      background: #d1fae5;
    }

    .badge-locked {
      background: #fef2f2;
      color: #991b1b;
      padding: 4px 12px;
      border-radius: 9999px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
      border: none;
      cursor: pointer;
    }
    .badge-locked:hover {
      background: #fee2fee2;
    }

    /* Modal Styling */
    .modal-backdrop {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0, 0, 0, 0.4);
      backdrop-filter: blur(4px);
      z-index: 1000;
      align-items: center;
      justify-content: center;
    }
    .modal-content {
      background: #fff;
      border-radius: 12px;
      width: 100%;
      max-width: 500px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      overflow: hidden;
      animation: modalFadeIn 0.2s ease-out;
    }
    @keyframes modalFadeIn {
      from { transform: translateY(20px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .modal-header {
      padding: 16px 20px;
      border-bottom: 1px solid #f3f4f6;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .modal-title {
      font-size: 16px;
      font-weight: 700;
      color: #111827;
    }
    .modal-close {
      background: none;
      border: none;
      font-size: 20px;
      color: #9ca3af;
      cursor: pointer;
    }
    .modal-body {
      padding: 20px;
      max-height: 70vh;
      overflow-y: auto;
    }
    .form-group {
      margin-bottom: 16px;
    }
    .form-label {
      display: block;
      font-size: 12.5px;
      font-weight: 600;
      color: #374151;
      margin-bottom: 6px;
    }
    .form-input {
      width: 100%;
      padding: 8px 12px;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 13.5px;
      color: #1f2937;
      outline: none;
      box-sizing: border-box;
    }
    .form-input:focus {
      border-color: #0d9488;
      box-shadow: 0 0 0 2px rgba(13, 148, 136, 0.2);
    }
    .modal-footer {
      padding: 12px 20px;
      border-top: 1px solid #f3f4f6;
      background: #f9fafb;
      display: flex;
      justify-content: flex-end;
      gap: 8px;
    }
    .btn-secondary {
      background: #fff;
      border: 1px solid #d1d5db;
      padding: 8px 16px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      color: #374151;
      cursor: pointer;
    }
    .btn-secondary:hover { background: #f9fafb; }
    .btn-primary {
      background: #0d9488;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      color: #fff;
      cursor: pointer;
    }
    .btn-primary:hover { background: #0f766e; }

    .btn-add-acc {
      background: #0d9488;
      color: white;
      border: none;
      border-radius: 6px;
      padding: 8px 14px;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: background 0.1s;
    }
    .btn-add-acc:hover {
      background: #0f766e;
    }
  </style>
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
    <div class="nav-section-label">Quản trị</div>
    <a href="users" class="nav-link active">Tài khoản</a>
    <a href="#" class="nav-link">Phân quyền</a>
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
    <span class="topbar-left">Quản trị người dùng</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
      <div>
        <h1 style="font-size: 24px; font-weight: 700; color: #111827; margin-bottom: 4px;">Quản lý người dùng</h1>
        <p style="font-size: 14px; color: #4b5563;">Xem và phân quyền người dùng trong hệ thống</p>
      </div>
      <button class="btn-add-acc" onclick="openAddModal()">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        Thêm tài khoản
      </button>
    </div>

    <!-- Stats Section -->
    <div class="stats-row" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 24px;">
      <div class="stat-card" style="border-left: 4px solid #3b82f6;">
        <div class="stat-label">
          TỔNG NGƯỜI DÙNG
        </div>
        <div class="stat-value"><%= totalCount %></div>
      </div>
      <div class="stat-card" style="border-left: 4px solid #10b981;">
        <div class="stat-label">
          HOẠT ĐỘNG
        </div>
        <div class="stat-value"><%= activeCount %></div>
      </div>
    </div>

    <!-- Main Card User List -->
    <div class="card">
      <div class="card-header" style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 15px; color: #111827; border-bottom: 1px solid #f3f4f6; padding: 14px 18px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
        Danh sách người dùng
      </div>
      
      <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; text-align: left; font-size: 13.5px;">
          <thead>
            <tr style="border-bottom: 1.5px solid #f3f4f6; color: #6b7280; text-transform: uppercase; font-size: 11px; font-weight: 700; letter-spacing: 0.5px;">
              <th style="padding: 14px 16px;">Người dùng</th>
              <th style="padding: 14px 16px;">Email</th>
              <th style="padding: 14px 16px;">Vai trò</th>
              <th style="padding: 14px 16px;">Trạng thái</th>
            </tr>
          </thead>
          <tbody>
            <%
              if (usersList != null && !usersList.isEmpty()) {
                for (Map<String, Object> u : usersList) {
                  String name = (String) u.get("fullName");
                  String username = (String) u.get("username");
                  
                  Boolean status = (Boolean) u.get("accountStatus");
                  boolean isCurrentStatus = (status != null && status);
            %>
                  <tr style="border-bottom: 1px solid #f3f4f6; transition: background 0.1s;" onmouseover="this.style.background='#f9fafb'" onmouseout="this.style.background='transparent'">
                    <td style="padding: 12px 16px;">
                      <div style="font-weight: 600; color: #111827;"><%= name %></div>
                      <div style="font-size: 12px; color: #6b7280;">@<%= username %></div>
                    </td>
                    <td style="padding: 12px 16px; color: #4b5563;"><%= u.get("emailCompany") %></td>
                    <td style="padding: 12px 16px;">
                      <!-- Styled Dropdown Pill Badge for Role Update -->
                      <form action="users" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="updateRole"/>
                        <input type="hidden" name="accountId" value="<%= u.get("accountId") %>"/>
                        <select name="roleName" class="badge-role-select" onchange="this.form.submit()" title="Click để đổi vai trò">
                          <%
                            if (rolesList != null) {
                              for (String r : rolesList) {
                                boolean isSel = r.equalsIgnoreCase((String) u.get("roleName"));
                          %>
                                <option value="<%= r %>" <%= isSel ? "selected" : "" %>><%= r.toLowerCase() %></option>
                          <%
                              }
                            }
                          %>
                        </select>
                      </form>
                    </td>
                    <td style="padding: 12px 16px;">
                      <!-- Interactive Pill Badge for Lock/Unlock Action -->
                      <form action="users" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="toggleStatus"/>
                        <input type="hidden" name="accountId" value="<%= u.get("accountId") %>"/>
                        <input type="hidden" name="currentStatus" value="<%= isCurrentStatus %>"/>
                        <button type="submit" class="<%= isCurrentStatus ? "badge-active" : "badge-locked" %>" title="Click để thay đổi trạng thái">
                          <%= isCurrentStatus ? "Hoạt động" : "Bị khóa" %>
                        </button>
                      </form>
                    </td>
                  </tr>
            <%
                }
              } else {
            %>
              <tr>
                <td colspan="4" style="padding: 30px; text-align: center; color: #9ca3af;">Không có người dùng nào được tìm thấy.</td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Modal Backgroun Add Account -->
<div class="modal-backdrop" id="addModal">
  <div class="modal-content">
    <div class="modal-header">
      <span class="modal-title">Thêm tài khoản mới</span>
      <button class="modal-close" onclick="closeAddModal()">&times;</button>
    </div>
    <form action="users" method="post">
      <input type="hidden" name="action" value="create"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Tên tài khoản (Username)</label>
          <input type="text" name="username" class="form-input" required placeholder="nhap_username"/>
        </div>
        <div class="form-group">
          <label class="form-label">Mật khẩu</label>
          <input type="password" name="password" class="form-input" required placeholder="Mật khẩu"/>
        </div>
        <div class="form-group">
          <label class="form-label">Họ và tên</label>
          <input type="text" name="fullName" class="form-input" required placeholder="Nguyen Van A"/>
        </div>
        <div class="form-group">
          <label class="form-label">Email công ty</label>
          <input type="email" name="email" class="form-input" required placeholder="email@company.com"/>
        </div>
        <div class="form-group">
          <label class="form-label">Vai trò</label>
          <select name="role" class="form-input" style="height: 38px;">
            <%
              if (rolesList != null) {
                for (String r : rolesList) {
            %>
                  <option value="<%= r %>"><%= r %></option>
            <%
                }
              }
            %>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Phòng ban</label>
          <select name="departmentId" class="form-input" style="height: 38px;">
            <%
              if (deptsList != null) {
                for (Map<String, Object> d : deptsList) {
            %>
                  <option value="<%= d.get("id") %>"><%= d.get("name") %></option>
            <%
                }
              }
            %>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Chức vụ</label>
          <select name="positionId" class="form-input" style="height: 38px;">
            <%
              if (positionsList != null) {
                for (Map<String, Object> p : positionsList) {
            %>
                  <option value="<%= p.get("id") %>"><%= p.get("name") %></option>
            <%
                }
              }
            %>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn-secondary" onclick="closeAddModal()">Hủy</button>
        <button type="submit" class="btn-primary">Tạo tài khoản</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Date rendering
  const dateSpan = document.getElementById("topbar-date");
  const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
  dateSpan.textContent = new Date().toLocaleDateString('vi-VN', options);

  // Modal actions
  function openAddModal() {
    document.getElementById("addModal").style.display = "flex";
  }
  function closeAddModal() {
    document.getElementById("addModal").style.display = "none";
  }

  // Close modal when clicking outside content
  window.onclick = function(event) {
    const modal = document.getElementById("addModal");
    if (event.target == modal) {
      closeAddModal();
    }
  }
</script>
</body>
</html>

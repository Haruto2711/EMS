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
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quản lý tài khoản</title>
  <link rel="stylesheet" href="css/ems.css"/>
  <link rel="stylesheet" href="css/users.css"/>
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
    <a href="users"       class="nav-link active">Tài khoản</a>
    <a href="employees"   class="nav-link">Nhân viên</a>
    <a href="departments" class="nav-link">Phòng ban</a>
    <a href="positions"   class="nav-link">Chức vụ</a>
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

<div class="main-content">
  <div class="topbar">
    <span class="topbar-left">Quản trị / Tài khoản</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
      <div class="flash-alert" style="background: #ecfdf5; border: 1px solid #a7f3d0; color: #065f46; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13.5px; display: flex; align-items: center; gap: 8px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        <span><%= successMessage %></span>
      </div>
    <% } %>
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
      <div class="flash-alert" style="background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13.5px; display: flex; align-items: center; gap: 8px;">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <span><%= errorMessage %></span>
      </div>
    <% } %>
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
              <th style="padding: 14px 16px;">Thao tác</th>
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
                      <span class="badge-role">
                        <%= ((String) u.get("roleName") != null ? (String) u.get("roleName") : "employee").toLowerCase() %>
                      </span>
                    </td>
                    <td style="padding: 12px 16px;">
                      <span class="<%= isCurrentStatus ? "badge-active" : "badge-locked" %>">
                        <%= isCurrentStatus ? "Hoạt động" : "Bị khóa" %>
                      </span>
                    </td>
                    <td style="padding: 12px 16px;">
                      <%
                        String phoneVal = (String) u.get("phone");
                        if (phoneVal == null) phoneVal = "";
                      %>
                      <a href="javascript:void(0)" onclick="openEditModal(<%= u.get("accountId") %>, '<%= username %>', '<%= name.replace("'", "\\'") %>', '<%= u.get("emailCompany") %>', '<%= phoneVal.replace("'", "\\'") %>', '<%= u.get("roleName") %>', <%= u.get("departmentId") %>, <%= u.get("positionId") %>)" style="color: #0d9488; text-decoration: none; font-weight: 600; margin-right: 12px;">Sửa</a>
                      <form action="users" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="toggleStatus"/>
                        <input type="hidden" name="accountId" value="<%= u.get("accountId") %>"/>
                        <input type="hidden" name="currentStatus" value="<%= isCurrentStatus %>"/>
                        <button type="submit" style="background: none; border: none; color: #dc2626; cursor: pointer; font-size: 13.5px; font-weight: 600; padding: 0; font-family: inherit;">
                          <%= isCurrentStatus ? "Ẩn" : "Hiện" %>
                        </button>
                      </form>
                    </td>
                  </tr>
            <%
                }
              } else {
            %>
              <tr>
                <td colspan="5" style="padding: 30px; text-align: center; color: #9ca3af;">Không có người dùng nào được tìm thấy.</td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Modal Edit Account -->
<div class="modal-backdrop" id="editModal">
  <div class="modal-content">
    <div class="modal-header">
      <span class="modal-title">Chỉnh sửa tài khoản</span>
      <button class="modal-close" onclick="closeEditModal()">&times;</button>
    </div>
    <form action="users" method="post">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="accountId" id="editAccountId"/>
      <div class="modal-body">
        <div class="form-group">
          <label class="form-label">Tên tài khoản (Username)</label>
          <input type="text" id="editUsername" class="form-input" readonly style="background: #f3f4f6; color: #6b7280; cursor: not-allowed;"/>
        </div>
        <div class="form-group">
          <label class="form-label">Họ và tên</label>
          <input type="text" name="fullName" id="editFullName" class="form-input" required/>
        </div>
        <div class="form-group">
          <label class="form-label">Email công ty</label>
          <input type="email" name="email" id="editEmail" class="form-input" required oninput="validateEditForm()"/>
          <div id="editEmailMsg" style="font-size: 12px; margin-top: 4px;"></div>
        </div>
        <div class="form-group">
          <label class="form-label">Số điện thoại</label>
          <input type="tel" name="phone" id="editPhone" class="form-input" placeholder="0912345678" oninput="validateEditForm()"/>
          <div id="editPhoneMsg" style="font-size: 12px; margin-top: 4px;"></div>
        </div>
        <div class="form-group">
          <label class="form-label">Vai trò</label>
          <select name="role" id="editRole" class="form-input" style="height: 38px;">
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
          <select name="departmentId" id="editDept" class="form-input" style="height: 38px;">
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
          <select name="positionId" id="editPos" class="form-input" style="height: 38px;">
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
        <button type="button" class="btn-secondary" onclick="closeEditModal()">Hủy</button>
        <button type="submit" id="editSubmitBtn" class="btn-primary">Lưu thay đổi</button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Background Add Account -->
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
          <input type="text" name="username" id="addUsername" class="form-input" required placeholder="nhap_username" oninput="validateAddForm()"/>
          <div id="addUsernameMsg" style="font-size: 12px; margin-top: 4px;"></div>
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
          <input type="email" name="email" id="addEmail" class="form-input" required placeholder="email@company.com" oninput="validateAddForm()"/>
          <div id="addEmailMsg" style="font-size: 12px; margin-top: 4px;"></div>
        </div>
        <div class="form-group">
          <label class="form-label">Số điện thoại</label>
          <input type="tel" name="phone" id="addPhone" class="form-input" placeholder="0912345678" oninput="validateAddForm()"/>
          <div id="addPhoneMsg" style="font-size: 12px; margin-top: 4px;"></div>
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
        <button type="submit" id="addSubmitBtn" class="btn-primary">Tạo tài khoản</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Dữ liệu tài khoản hiện có để kiểm tra trùng lặp thời gian thực (Real-time check)
  const EXISTING_USERS = [
    <%
      if (usersList != null) {
        boolean firstU = true;
        for (Map<String, Object> u : usersList) {
          if (!firstU) out.print(",");
          firstU = false;
          String un = (String) u.get("username");
          String em = (String) u.get("emailCompany");
          String ph = (String) u.get("phone");
          Integer accId = (Integer) u.get("accountId");
          out.print("{id:" + accId + ",username:'" + (un != null ? un.replace("'", "\\'") : "") + "',email:'" + (em != null ? em.replace("'", "\\'") : "") + "',phone:'" + (ph != null ? ph.replace("'", "\\'") : "") + "'}");
        }
      }
    %>
  ];

  // Date rendering
  const dateSpan = document.getElementById("topbar-date");
  const options = { day: '2-digit', month: '2-digit', year: 'numeric' };
  dateSpan.textContent = new Date().toLocaleDateString('vi-VN', options);

  // Helper hiển thị thông báo hợp lệ / lỗi
  function setFieldStatus(inputEl, msgEl, isValid, message) {
    if (isValid === true) {
      inputEl.style.borderColor = "#10b981";
      msgEl.innerHTML = '<span style="color: #059669; font-weight: 500;">✓ ' + message + '</span>';
    } else if (isValid === false) {
      inputEl.style.borderColor = "#dc2626";
      msgEl.innerHTML = '<span style="color: #dc2626; font-weight: 500;">' + message + '</span>';
    } else {
      inputEl.style.borderColor = "";
      msgEl.innerHTML = "";
    }
  }

  // Kiểm tra thời gian thực khi THÊM tài khoản
  function validateAddForm() {
    const un = (document.getElementById("addUsername").value || "").trim().toLowerCase();
    const em = (document.getElementById("addEmail").value || "").trim().toLowerCase();
    const ph = (document.getElementById("addPhone").value || "").trim();

    const unInput = document.getElementById("addUsername");
    const unMsg = document.getElementById("addUsernameMsg");
    const emInput = document.getElementById("addEmail");
    const emMsg = document.getElementById("addEmailMsg");
    const phInput = document.getElementById("addPhone");
    const phMsg = document.getElementById("addPhoneMsg");
    const submitBtn = document.getElementById("addSubmitBtn");

    let hasError = false;

    // 1. Check Username
    if (un.length > 0) {
      const isUnDup = EXISTING_USERS.some(u => u.username.toLowerCase() === un);
      if (isUnDup) {
        setFieldStatus(unInput, unMsg, false, "Tên tài khoản này đã tồn tại!");
        hasError = true;
      } else {
        setFieldStatus(unInput, unMsg, true, "Tên tài khoản hợp lệ");
      }
    } else {
      setFieldStatus(unInput, unMsg, null, "");
    }

    // 2. Check Email
    if (em.length > 0) {
      const isEmDup = EXISTING_USERS.some(u => u.email.toLowerCase() === em);
      if (isEmDup) {
        setFieldStatus(emInput, emMsg, false, "Email công ty này đã tồn tại!");
        hasError = true;
      } else if (!em.includes("@") || !em.includes(".")) {
        setFieldStatus(emInput, emMsg, false, "Định dạng email chưa đúng!");
        hasError = true;
      } else {
        setFieldStatus(emInput, emMsg, true, "Email hợp lệ");
      }
    } else {
      setFieldStatus(emInput, emMsg, null, "");
    }

    // 3. Check Phone
    if (ph.length > 0) {
      const isPhDup = EXISTING_USERS.some(u => u.phone && u.phone === ph);
      if (isPhDup) {
        setFieldStatus(phInput, phMsg, false, "Số điện thoại này đã được sử dụng!");
        hasError = true;
      } else if (!/^[0-9]{9,11}$/.test(ph)) {
        setFieldStatus(phInput, phMsg, false, "Số điện thoại phải từ 9 - 11 chữ số!");
        hasError = true;
      } else {
        setFieldStatus(phInput, phMsg, true, "Số điện thoại hợp lệ");
      }
    } else {
      setFieldStatus(phInput, phMsg, null, "");
    }

    // Vô hiệu hóa nút tạo nếu có lỗi
    submitBtn.disabled = hasError;
    submitBtn.style.opacity = hasError ? "0.5" : "1";
    submitBtn.style.cursor = hasError ? "not-allowed" : "pointer";
  }

  // Kiểm tra thời gian thực khi SỬA tài khoản
  function validateEditForm() {
    const currentId = parseInt(document.getElementById("editAccountId").value);
    const em = (document.getElementById("editEmail").value || "").trim().toLowerCase();
    const ph = (document.getElementById("editPhone").value || "").trim();

    const emInput = document.getElementById("editEmail");
    const emMsg = document.getElementById("editEmailMsg");
    const phInput = document.getElementById("editPhone");
    const phMsg = document.getElementById("editPhoneMsg");
    const submitBtn = document.getElementById("editSubmitBtn");

    let hasError = false;

    // 1. Check Email (loại trừ tài khoản hiện tại)
    if (em.length > 0) {
      const isEmDup = EXISTING_USERS.some(u => u.id !== currentId && u.email.toLowerCase() === em);
      if (isEmDup) {
        setFieldStatus(emInput, emMsg, false, "Email này đã được dùng bởi tài khoản khác!");
        hasError = true;
      } else if (!em.includes("@") || !em.includes(".")) {
        setFieldStatus(emInput, emMsg, false, "Định dạng email chưa đúng!");
        hasError = true;
      } else {
        setFieldStatus(emInput, emMsg, true, "Email hợp lệ");
      }
    } else {
      setFieldStatus(emInput, emMsg, null, "");
    }

    // 2. Check Phone (loại trừ tài khoản hiện tại)
    if (ph.length > 0) {
      const isPhDup = EXISTING_USERS.some(u => u.id !== currentId && u.phone && u.phone === ph);
      if (isPhDup) {
        setFieldStatus(phInput, phMsg, false, "Số điện thoại đã được dùng bởi tài khoản khác!");
        hasError = true;
      } else if (!/^[0-9]{9,11}$/.test(ph)) {
        setFieldStatus(phInput, phMsg, false, "Số điện thoại phải từ 9 - 11 chữ số!");
        hasError = true;
      } else {
        setFieldStatus(phInput, phMsg, true, "Số điện thoại hợp lệ");
      }
    } else {
      setFieldStatus(phInput, phMsg, null, "");
    }

    submitBtn.disabled = hasError;
    submitBtn.style.opacity = hasError ? "0.5" : "1";
    submitBtn.style.cursor = hasError ? "not-allowed" : "pointer";
  }

  // Modal actions
  function openAddModal() {
    // Reset form fields and validation messages
    document.getElementById("addUsername").value = "";
    document.getElementById("addEmail").value = "";
    document.getElementById("addPhone").value = "";
    setFieldStatus(document.getElementById("addUsername"), document.getElementById("addUsernameMsg"), null, "");
    setFieldStatus(document.getElementById("addEmail"), document.getElementById("addEmailMsg"), null, "");
    setFieldStatus(document.getElementById("addPhone"), document.getElementById("addPhoneMsg"), null, "");
    document.getElementById("addSubmitBtn").disabled = false;
    document.getElementById("addSubmitBtn").style.opacity = "1";
    document.getElementById("addSubmitBtn").style.cursor = "pointer";
    document.getElementById("addModal").style.display = "flex";
  }

  function closeAddModal() {
    document.getElementById("addModal").style.display = "none";
  }

  // Close modal when clicking outside content
  window.onclick = function(event) {
    const addModal = document.getElementById("addModal");
    const editModal = document.getElementById("editModal");
    if (event.target == addModal) {
      closeAddModal();
    }
    if (event.target == editModal) {
      closeEditModal();
    }
  }

  function openEditModal(accountId, username, fullName, email, phone, role, departmentId, positionId) {
    document.getElementById("editAccountId").value = accountId;
    document.getElementById("editUsername").value = username;
    document.getElementById("editFullName").value = fullName;
    document.getElementById("editEmail").value = email;
    document.getElementById("editPhone").value = phone || '';
    document.getElementById("editRole").value = role;
    document.getElementById("editDept").value = departmentId;
    document.getElementById("editPos").value = positionId;

    setFieldStatus(document.getElementById("editEmail"), document.getElementById("editEmailMsg"), null, "");
    setFieldStatus(document.getElementById("editPhone"), document.getElementById("editPhoneMsg"), null, "");
    document.getElementById("editSubmitBtn").disabled = false;
    document.getElementById("editSubmitBtn").style.opacity = "1";
    document.getElementById("editSubmitBtn").style.cursor = "pointer";

    document.getElementById("editModal").style.display = "flex";
  }

  function closeEditModal() {
    document.getElementById("editModal").style.display = "none";
  }

  // Tự động ẩn thông báo sau đúng 2 giây
  setTimeout(function() {
    var alerts = document.querySelectorAll('.flash-alert');
    alerts.forEach(function(alert) {
      alert.style.transition = 'opacity 0.4s ease, transform 0.4s ease, max-height 0.4s ease, margin-bottom 0.4s ease';
      alert.style.opacity = '0';
      alert.style.transform = 'translateY(-8px)';
      alert.style.maxHeight = '0';
      alert.style.marginBottom = '0';
      alert.style.paddingTop = '0';
      alert.style.paddingBottom = '0';
      alert.style.overflow = 'hidden';
      setTimeout(function() {
        alert.remove();
      }, 400);
    });
  }, 2000);
</script>
</body>
</html>

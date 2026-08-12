<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ems.dto.BaseSalaryDTO" %>
<%@ page import="com.ems.dto.SalarySummaryDTO" %>
<%@ page import="com.ems.model.Departments" %>
<%@ page import="com.ems.model.Positions" %>
<%
    List<BaseSalaryDTO> baseSalaries = (List<BaseSalaryDTO>) request.getAttribute("baseSalaries");
    SalarySummaryDTO summary = (SalarySummaryDTO) request.getAttribute("summary");
    List<Departments> departments = (List<Departments>) request.getAttribute("departments");
    List<Positions> positions = (List<Positions>) request.getAttribute("positions");
    
    Integer totalEmployeesCount = (Integer) request.getAttribute("totalEmployeesCount");
    if (totalEmployeesCount == null) totalEmployeesCount = (summary != null ? summary.getTotalEmployees() : 0);
    
    Integer totalFilteredItems = (Integer) request.getAttribute("totalFilteredItems");
    if (totalFilteredItems == null) totalFilteredItems = (baseSalaries != null ? baseSalaries.size() : 0);
    
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;
    
    Integer pageSize = (Integer) request.getAttribute("pageSize");
    if (pageSize == null) pageSize = 5;
    
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;
    
    String searchStr = (String) request.getAttribute("search");
    if (searchStr == null) searchStr = "";
    
    Integer selectedDeptId = (Integer) request.getAttribute("selectedDepartmentId");
    Integer selectedPosId = (Integer) request.getAttribute("selectedPositionId");
    String sortByVal = (String) request.getAttribute("sortBy");
    String sortOrderVal = (String) request.getAttribute("sortOrder");

    int startItem = totalFilteredItems > 0 ? (currentPage - 1) * pageSize + 1 : 0;
    int endItem = Math.min(currentPage * pageSize, totalFilteredItems);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Lương hợp đồng & Người phụ thuộc – EMS</title>
  <link rel="stylesheet" href="ems.css"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <style>
    /* Specific styles for Base Salary page body */
    .bs-header {
      margin-bottom: 24px;
    }
    .bs-header h1 {
      font-size: 24px;
      font-weight: 700;
      color: #0f172a;
      letter-spacing: -0.4px;
      margin-bottom: 4px;
    }
    .bs-header p {
      font-size: 13.5px;
      color: #64748b;
    }

    /* Top 3 Summary Cards */
    .bs-stats-row {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .bs-stat-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 18px 22px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.02);
    }
    .bs-stat-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 8px;
      font-weight: 500;
    }
    .bs-stat-value {
      font-size: 26px;
      font-weight: 700;
      color: #0f172a;
      letter-spacing: -0.5px;
    }

    /* Filter Toolbar Box */
    .bs-filter-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 14px 18px;
      margin-bottom: 20px;
    }
    .bs-filter-form {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }
    .bs-search-wrapper {
      position: relative;
      flex: 1;
      min-width: 260px;
    }
    .bs-search-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      font-size: 14px;
      pointer-events: none;
    }
    .bs-input {
      width: 100%;
      height: 38px;
      padding: 0 14px 0 38px;
      background: #f8fafc;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13.5px;
      color: #1e293b;
      outline: none;
      transition: all 0.15s;
    }
    .bs-input:focus {
      background: #ffffff;
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    }
    .bs-btn-search {
      height: 38px;
      padding: 0 20px;
      background: #2563eb;
      color: #ffffff;
      border: none;
      border-radius: 8px;
      font-size: 13.5px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 7px;
      transition: background 0.15s;
    }
    .bs-btn-search:hover {
      background: #1d4ed8;
    }
    .bs-filter-label {
      font-size: 13px;
      color: #475569;
      font-weight: 500;
      margin-left: 6px;
    }
    .bs-select {
      height: 38px;
      padding: 0 28px 0 12px;
      background: #f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%20%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E") no-repeat right 8px center/14px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13px;
      color: #1e293b;
      outline: none;
      cursor: pointer;
      appearance: none;
    }
    .bs-select:focus {
      background-color: #ffffff;
      border-color: #2563eb;
    }

    /* Main Table Container */
    .bs-table-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 1px 3px rgba(0,0,0,0.02);
    }
    .bs-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
    }
    .bs-table th {
      background: #ffffff;
      color: #3b82f6;
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      padding: 14px 20px;
      border-bottom: 1px solid #e2e8f0;
      white-space: nowrap;
    }
    .bs-table th .sort-caret {
      font-size: 10px;
      margin-left: 3px;
      opacity: 0.7;
    }
    .bs-table td {
      padding: 14px 20px;
      font-size: 13.5px;
      color: #1e293b;
      border-bottom: 1px solid #f1f5f9;
      vertical-align: middle;
    }
    .bs-table tr:last-child td {
      border-bottom: none;
    }
    .bs-table tr:hover td {
      background: #fafafa;
    }

    /* Table cells specific formatting */
    .emp-code-text {
      color: #94a3b8;
      font-size: 13px;
      font-weight: 500;
    }
    .emp-user-cell {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .emp-avatar-circle {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #ffffff;
      font-weight: 700;
      font-size: 13px;
      flex-shrink: 0;
    }
    .emp-name-text {
      font-weight: 600;
      color: #0f172a;
    }
    .dept-badge {
      display: inline-block;
      padding: 3px 12px;
      background: #e2e8f0;
      color: #475569;
      border-radius: 9999px;
      font-size: 12px;
      font-weight: 500;
    }
    .pos-text {
      color: #334155;
      font-size: 13.5px;
    }
    .salary-text {
      font-weight: 700;
      color: #0f172a;
      font-size: 14px;
    }
    .npt-badge {
      width: 24px;
      height: 24px;
      background: #2563eb;
      color: #ffffff;
      border-radius: 50%;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: 700;
    }
    .btn-edit-outline {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 16px;
      background: #ffffff;
      border: 1px solid #3b82f6;
      border-radius: 9999px;
      color: #2563eb;
      font-size: 12.5px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.15s;
      text-decoration: none;
    }
    .btn-edit-outline:hover {
      background: #eff6ff;
      border-color: #2563eb;
    }

    /* Pagination Footer Bar */
    .bs-pagination-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 20px;
      background: #ffffff;
      border-top: 1px solid #f1f5f9;
      font-size: 13px;
      color: #64748b;
    }
    .bs-pagination-info {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .bs-page-size-select {
      height: 30px;
      padding: 0 20px 0 10px;
      background: #f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%20%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E") no-repeat right 6px center/12px;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      font-size: 12px;
      color: #334155;
      outline: none;
      cursor: pointer;
      appearance: none;
    }
    .bs-pagination-controls {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .bs-page-btn {
      min-width: 32px;
      height: 32px;
      padding: 0 8px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 500;
      color: #334155;
      background: transparent;
      border: 1px solid transparent;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.15s;
    }
    .bs-page-btn:hover {
      background: #f1f5f9;
    }
    .bs-page-btn.active {
      background: #2563eb;
      color: #ffffff;
      font-weight: 600;
    }
    .bs-page-nav-btn {
      width: 32px;
      height: 32px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      font-size: 13px;
      color: #64748b;
      background: #ffffff;
      border: 1px solid #cbd5e1;
      cursor: pointer;
      text-decoration: none;
    }
    .bs-page-nav-btn:hover {
      background: #f8fafc;
      color: #1e293b;
    }
    .bs-page-nav-btn.disabled {
      opacity: 0.4;
      pointer-events: none;
    }

    /* Modal Styling (Image 2) */
    .modal-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(15, 23, 42, 0.45);
      backdrop-filter: blur(2px);
      z-index: 1000;
      display: none;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .modal-card {
      background: #ffffff;
      border-radius: 14px;
      width: 100%;
      max-width: 480px;
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
      padding: 24px;
      position: relative;
      animation: modalFadeIn 0.2s ease-out;
    }
    @keyframes modalFadeIn {
      from { opacity: 0; transform: translateY(-10px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .modal-close-btn {
      position: absolute;
      top: 20px;
      right: 20px;
      background: transparent;
      border: none;
      font-size: 18px;
      color: #94a3b8;
      cursor: pointer;
      padding: 4px;
      line-height: 1;
      border-radius: 6px;
    }
    .modal-close-btn:hover {
      color: #475569;
      background: #f1f5f9;
    }
    .modal-title {
      font-size: 18px;
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 2px;
    }
    .modal-subtitle {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 18px;
    }
    .modal-info-box {
      background: #f8fafc;
      border-radius: 8px;
      padding: 12px 16px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
    }
    .modal-info-item label {
      display: block;
      font-size: 12px;
      color: #64748b;
      margin-bottom: 2px;
    }
    .modal-info-item span {
      font-size: 14px;
      font-weight: 700;
      color: #0f172a;
    }

    .modal-form-group {
      margin-bottom: 18px;
    }
    .modal-form-group label {
      display: block;
      font-size: 13.5px;
      font-weight: 500;
      color: #334155;
      margin-bottom: 8px;
    }
    .currency-input-wrapper {
      position: relative;
    }
    .currency-input-wrapper input {
      width: 100%;
      height: 42px;
      padding: 0 36px 0 14px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 500;
      color: #0f172a;
      outline: none;
    }
    .currency-input-wrapper input:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    }
    .currency-suffix {
      position: absolute;
      right: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #64748b;
      font-size: 14px;
      font-weight: 500;
      pointer-events: none;
    }

    /* Stepper Controls */
    .stepper-control {
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }
    .stepper-btn {
      width: 36px;
      height: 36px;
      background: #ffffff;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      color: #475569;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      transition: all 0.12s;
    }
    .stepper-btn:hover {
      background: #f8fafc;
      border-color: #94a3b8;
      color: #1e293b;
    }
    .stepper-input {
      width: 60px;
      height: 36px;
      text-align: center;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 600;
      color: #0f172a;
      outline: none;
    }

    /* Modal Footer Buttons */
    .modal-footer {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 26px;
    }
    .btn-modal-cancel {
      padding: 9px 20px;
      background: #ffffff;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 13.5px;
      font-weight: 500;
      color: #374151;
      cursor: pointer;
      transition: background 0.12s;
    }
    .btn-modal-cancel:hover {
      background: #f8fafc;
    }
    .btn-modal-save {
      padding: 9px 20px;
      background: #2563eb;
      border: none;
      border-radius: 8px;
      font-size: 13.5px;
      font-weight: 600;
      color: #ffffff;
      cursor: pointer;
      transition: background 0.12s;
    }
    .btn-modal-save:hover {
      background: #1d4ed8;
    }
  </style>
</head>
<body>

<!-- SIDEBAR (Using home_manager.jsp layout) -->
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
    <a href="base-salaries" class="nav-link active">Quản lý lương</a>
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
    <span class="topbar-left">Trang chủ / Quản lý lương cơ bản</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <!-- PAGE BODY (Image 1 UI) -->
  <div class="page-body">
    <!-- Header Section -->
    <div class="bs-header">
      <h1>Lương hợp đồng &amp; Người phụ thuộc</h1>
      <p>Thiết lập mức lương cơ bản (Base Salary) và số người phụ thuộc cho từng nhân viên</p>
    </div>

    <!-- Summary Metrics Grid -->
    <div class="bs-stats-row">
      <div class="bs-stat-card">
        <div class="bs-stat-label">Tổng nhân viên</div>
        <div class="bs-stat-value"><%= totalEmployeesCount %></div>
      </div>

      <div class="bs-stat-card">
        <div class="bs-stat-label">Kết quả lọc</div>
        <div class="bs-stat-value"><%= totalFilteredItems %></div>
      </div>

      <div class="bs-stat-card">
        <div class="bs-stat-label">Tổng quỹ lương (lọc)</div>
        <div class="bs-stat-value"><%= summary != null ? summary.getFormattedTotalBudget() : "0" %> đ</div>
      </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="bs-filter-card">
      <form action="base-salaries" method="GET" class="bs-filter-form" id="filterForm">
        
        <!-- Search Input -->
        <div class="bs-search-wrapper">
          <svg class="bs-search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input type="text" name="search" class="bs-input" placeholder="Tìm tên hoặc mã nhân viên..." value="<%= searchStr %>"/>
        </div>

        <!-- Search Button -->
        <button type="submit" class="bs-btn-search">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          Tìm kiếm
        </button>

        <!-- Department Filter -->
        <span class="bs-filter-label">Phòng ban</span>
        <select name="departmentId" class="bs-select" onchange="document.getElementById('filterForm').submit()">
          <option value="">Tất cả</option>
          <% if (departments != null) {
              for (Departments dept : departments) {
                  boolean isSelected = selectedDeptId != null && selectedDeptId.equals(dept.getId());
          %>
              <option value="<%= dept.getId() %>" <%= isSelected ? "selected" : "" %>>
                <%= dept.getName() %>
              </option>
          <%  }
          } %>
        </select>

        <!-- Position Filter -->
        <span class="bs-filter-label">Chức vụ</span>
        <select name="positionId" class="bs-select" onchange="document.getElementById('filterForm').submit()">
          <option value="">Tất cả</option>
          <% if (positions != null) {
              for (Positions pos : positions) {
                  boolean isSelected = selectedPosId != null && selectedPosId.equals(pos.getId());
          %>
              <option value="<%= pos.getId() %>" <%= isSelected ? "selected" : "" %>>
                <%= pos.getName() %>
              </option>
          <%  }
          } %>
        </select>
        
        <!-- Hidden Page preservation -->
        <input type="hidden" name="page" value="1"/>
        <input type="hidden" name="pageSize" value="<%= pageSize %>"/>
      </form>
    </div>

    <!-- Data Table -->
    <div class="bs-table-card">
      <table class="bs-table">
        <thead>
          <tr>
            <th>MÃ NV <span class="sort-caret">^</span></th>
            <th>HỌ VÀ TÊN <span class="sort-caret">^</span></th>
            <th>PHÒNG BAN <span class="sort-caret">^</span></th>
            <th>CHỨC VỤ <span class="sort-caret">^</span></th>
            <th>LƯƠNG CƠ BẢN <span class="sort-caret">^</span></th>
            <th>SỐ NPT <span class="sort-caret">^</span></th>
            <th>HÀNH ĐỘNG</th>
          </tr>
        </thead>
        <tbody>
          <% 
            if (baseSalaries != null && !baseSalaries.isEmpty()) {
                String[] colors = {"#f87171", "#fb923c", "#fbbf24", "#34d399", "#60a5fa", "#a78bfa", "#f472b6"};
                for (BaseSalaryDTO item : baseSalaries) {
                    String fullName = item.getFullName() != null ? item.getFullName() : "";
                    String firstChar = (!fullName.trim().isEmpty()) ? fullName.trim().substring(0, 1).toUpperCase() : "N";
                    int colorIdx = Math.abs(fullName.hashCode()) % colors.length;
                    String avatarColor = colors[colorIdx];
                    
                    String code = item.getEmployeeCode() != null ? item.getEmployeeCode() : "";
                    String dept = item.getDepartmentName() != null ? item.getDepartmentName() : "Chưa phân công";
                    String pos = item.getPositionName() != null ? item.getPositionName() : "Chưa phân công";
                    String formattedSalary = item.getFormattedBaseSalary() + " đ";
                    double rawSalary = item.getBaseSalary() != null ? item.getBaseSalary().doubleValue() : 0;
                    int npt = item.getDependentsCount();
          %>
              <tr>
                <td class="emp-code-text"><%= code %></td>
                <td>
                  <div class="emp-user-cell">
                    <div class="emp-avatar-circle" style="background-color: <%= avatarColor %>;">
                      <%= firstChar %>
                    </div>
                    <span class="emp-name-text"><%= fullName %></span>
                  </div>
                </td>
                <td>
                  <span class="dept-badge"><%= dept %></span>
                </td>
                <td class="pos-text"><%= pos %></td>
                <td class="salary-text"><%= formattedSalary %></td>
                <td>
                  <span class="npt-badge"><%= npt %></span>
                </td>
                <td>
                  <button type="button" class="btn-edit-outline" 
                          onclick="openEditModal(<%= item.getUserId() %>, '<%= code %>', '<%= fullName.replace("'", "\\'") %>', '<%= dept.replace("'", "\\'") %>', '<%= pos.replace("'", "\\'") %>', <%= rawSalary %>, <%= npt %>)">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M12 20h9"></path>
                      <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                    </svg>
                    Chỉnh sửa
                  </button>
                </td>
              </tr>
          <% 
                }
            } else { 
          %>
              <tr>
                <td colspan="7" style="text-align: center; padding: 40px; color: #64748b;">
                  Không tìm thấy dữ liệu nhân viên nào phù hợp.
                </td>
              </tr>
          <% } %>
        </tbody>
      </table>

      <!-- Pagination Footer -->
      <div class="bs-pagination-bar">
        <div class="bs-pagination-info">
          <span>Hiển thị <strong><%= startItem %>-<%= endItem %></strong> / <%= totalFilteredItems %> nhân viên</span>
          <span>Mỗi trang
            <select class="bs-page-size-select" onchange="changePageSize(this.value)">
              <option value="5" <%= pageSize == 5 ? "selected" : "" %>>5</option>
              <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10</option>
              <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20</option>
            </select>
          </span>
        </div>

        <div class="bs-pagination-controls">
          <!-- Previous page button -->
          <a href="<%= buildPageUrl(searchStr, selectedDeptId, selectedPosId, currentPage - 1, pageSize) %>" 
             class="bs-page-nav-btn <%= currentPage <= 1 ? "disabled" : "" %>">&lt;</a>

          <!-- Page numbers -->
          <% for (int p = 1; p <= totalPages; p++) { %>
              <a href="<%= buildPageUrl(searchStr, selectedDeptId, selectedPosId, p, pageSize) %>" 
                 class="bs-page-btn <%= p == currentPage ? "active" : "" %>"><%= p %></a>
          <% } %>

          <!-- Next page button -->
          <a href="<%= buildPageUrl(searchStr, selectedDeptId, selectedPosId, currentPage + 1, pageSize) %>" 
             class="bs-page-nav-btn <%= currentPage >= totalPages ? "disabled" : "" %>">&gt;</a>
        </div>
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<!-- EDIT MODAL FORM (Image 2 UI) -->
<div class="modal-overlay" id="salaryModal">
  <div class="modal-card">
    <button type="button" class="modal-close-btn" onclick="closeEditModal()">✕</button>
    
    <div class="modal-title">Chỉnh sửa thông tin lương</div>
    <div class="modal-subtitle" id="modalSubtitle">NV001 · Nguyễn Văn An</div>

    <!-- Read-only Dept & Pos -->
    <div class="modal-info-box">
      <div class="modal-info-item">
        <label>Phòng ban</label>
        <span id="modalDept">Kỹ thuật</span>
      </div>
      <div class="modal-info-item">
        <label>Chức vụ</label>
        <span id="modalPos">Trưởng nhóm</span>
      </div>
    </div>

    <!-- Form -->
    <form action="base-salaries" method="POST" id="editForm">
      <input type="hidden" name="userId" id="editUserId" value=""/>
      <input type="hidden" name="search" value="<%= searchStr %>"/>
      <% if (selectedDeptId != null) { %><input type="hidden" name="departmentId" value="<%= selectedDeptId %>"/><% } %>
      <% if (selectedPosId != null) { %><input type="hidden" name="positionId" value="<%= selectedPosId %>"/><% } %>
      <input type="hidden" name="page" value="<%= currentPage %>"/>

      <!-- Base Salary Input -->
      <div class="modal-form-group">
        <label for="editBaseSalary">Lương cơ bản (Base Salary)</label>
        <div class="currency-input-wrapper">
          <input type="number" id="editBaseSalary" name="baseSalary" required step="100000" min="0" value="22000000"/>
          <span class="currency-suffix">đ</span>
        </div>
      </div>

      <!-- Dependents Stepper Input -->
      <div class="modal-form-group">
        <label>Số người phụ thuộc (NPT)</label>
        <div class="stepper-control">
          <button type="button" class="stepper-btn" onclick="changeNPT(-1)">-</button>
          <input type="number" id="editDependentsCount" name="dependentsCount" class="stepper-input" value="2" min="0" readonly/>
          <button type="button" class="stepper-btn" onclick="changeNPT(1)">+</button>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="modal-footer">
        <button type="button" class="btn-modal-cancel" onclick="closeEditModal()">Huỷ</button>
        <button type="submit" class="btn-modal-save">Lưu thay đổi</button>
      </div>
    </form>
  </div>
</div>

<%!
  // Helper to construct pagination URLs cleanly
  private String buildPageUrl(String search, Integer deptId, Integer posId, int page, int pageSize) {
      StringBuilder sb = new StringBuilder("base-salaries?page=").append(page).append("&pageSize=").append(pageSize);
      if (search != null && !search.trim().isEmpty()) {
          try {
              sb.append("&search=").append(java.net.URLEncoder.encode(search, "UTF-8"));
          } catch (Exception ignored) {}
      }
      if (deptId != null && deptId > 0) {
          sb.append("&departmentId=").append(deptId);
      }
      if (posId != null && posId > 0) {
          sb.append("&positionId=").append(posId);
      }
      return sb.toString();
  }
%>

<script>
  // Topbar date script
  function tick() {
    var now = new Date();
    var p = function(n){ return String(n).padStart(2,'0'); };
    var el = document.getElementById('topbar-date');
    if (el) {
      el.textContent = p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
    }
  }
  tick();

  // Modal Functions
  function openEditModal(userId, code, name, dept, pos, salary, dependents) {
    document.getElementById('editUserId').value = userId;
    document.getElementById('modalSubtitle').textContent = code + ' · ' + name;
    document.getElementById('modalDept').textContent = dept || 'Chưa phân công';
    document.getElementById('modalPos').textContent = pos || 'Chưa phân công';
    document.getElementById('editBaseSalary').value = Math.round(salary);
    document.getElementById('editDependentsCount').value = dependents || 0;
    
    var modal = document.getElementById('salaryModal');
    modal.style.display = 'flex';
  }

  function closeEditModal() {
    var modal = document.getElementById('salaryModal');
    modal.style.display = 'none';
  }

  // Stepper function
  function changeNPT(delta) {
    var input = document.getElementById('editDependentsCount');
    var val = parseInt(input.value) || 0;
    val = Math.max(0, val + delta);
    input.value = val;
  }

  // Change page size function
  function changePageSize(newSize) {
    var url = '<%= buildPageUrl(searchStr, selectedDeptId, selectedPosId, 1, 5) %>';
    url = url.replace('pageSize=5', 'pageSize=' + newSize);
    window.location.href = url;
  }

  // Close modal when clicking outside modal-card
  window.onclick = function(event) {
    var modal = document.getElementById('salaryModal');
    if (event.target === modal) {
      closeEditModal();
    }
  };
</script>

</body>
</html>

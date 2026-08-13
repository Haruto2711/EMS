<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ems.dto.TimesheetPeriodDTO" %>
<%
    List<TimesheetPeriodDTO> periods = (List<TimesheetPeriodDTO>) request.getAttribute("periods");
    Integer totalFilteredItems = (Integer) request.getAttribute("totalFilteredItems");
    if (totalFilteredItems == null) totalFilteredItems = (periods != null ? periods.size() : 0);
    
    Integer totalPeriodsCount = (Integer) request.getAttribute("totalPeriodsCount");
    if (totalPeriodsCount == null) totalPeriodsCount = totalFilteredItems;
    
    Integer activePeriodsCount = (Integer) request.getAttribute("activePeriodsCount");
    if (activePeriodsCount == null) activePeriodsCount = 0;
    
    Integer lockedPeriodsCount = (Integer) request.getAttribute("lockedPeriodsCount");
    if (lockedPeriodsCount == null) lockedPeriodsCount = 0;

    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;
    
    Integer pageSize = (Integer) request.getAttribute("pageSize");
    if (pageSize == null) pageSize = 5;
    
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;
    
    String searchStr = (String) request.getAttribute("search");
    if (searchStr == null) searchStr = "";
    
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    if (selectedStatus == null) selectedStatus = "";

    String toastMessage = (String) request.getAttribute("toastMessage");
    String toastType = (String) request.getAttribute("toastType");

    int startItem = totalFilteredItems > 0 ? (currentPage - 1) * pageSize + 1 : 0;
    int endItem = Math.min(currentPage * pageSize, totalFilteredItems);
%>
<%!
    private String buildPageUrl(String search, String status, int page, int pageSize) {
        StringBuilder sb = new StringBuilder("pay-periods?page=").append(page).append("&pageSize=").append(pageSize);
        if (search != null && !search.trim().isEmpty()) {
            try {
                sb.append("&search=").append(java.net.URLEncoder.encode(search.trim(), "UTF-8"));
            } catch (Exception ignored) {}
        }
        if (status != null && !status.trim().isEmpty()) {
            sb.append("&status=").append(status);
        }
        return sb.toString();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Quản lý Kỳ Lương – EMS</title>
  <link rel="stylesheet" href="ems.css"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  
  <style>
    /* Specific styles for Pay Period Management page */
    .pp-header {
      margin-bottom: 24px;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
    }
    .pp-header h1 {
      font-size: 24px;
      font-weight: 700;
      color: #0f172a;
      letter-spacing: -0.4px;
      margin-bottom: 4px;
    }
    .pp-header p {
      font-size: 13.5px;
      color: #64748b;
    }

    /* Primary Add Button */
    .btn-create-period {
      height: 42px;
      padding: 0 20px;
      background: #2563eb;
      color: #ffffff;
      border: none;
      border-radius: 9999px;
      font-size: 13.5px;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      transition: all 0.2s ease;
      box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
    }
    .btn-create-period:hover {
      background: #1d4ed8;
      box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3);
      transform: translateY(-1px);
    }

    /* Top 3 Summary Cards */
    .pp-stats-row {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
      margin-bottom: 24px;
    }
    .pp-stat-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      padding: 20px 24px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.02);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .pp-stat-label {
      font-size: 13px;
      color: #64748b;
      margin-bottom: 6px;
      font-weight: 500;
    }
    .pp-stat-value {
      font-size: 28px;
      font-weight: 700;
      color: #0f172a;
      letter-spacing: -0.5px;
    }
    .pp-stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .icon-blue-bg { background: #eff6ff; color: #2563eb; }
    .icon-green-bg { background: #f0fdf4; color: #16a34a; }
    .icon-amber-bg { background: #fffbeb; color: #d97706; }

    /* Filter Toolbar Box */
    .pp-filter-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 14px 18px;
      margin-bottom: 20px;
    }
    .pp-filter-form {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }
    .pp-search-wrapper {
      position: relative;
      flex: 1;
      min-width: 260px;
    }
    .pp-search-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      font-size: 14px;
      pointer-events: none;
    }
    .pp-input {
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
    .pp-input:focus {
      background: #ffffff;
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    }
    .pp-btn-search {
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
    .pp-btn-search:hover {
      background: #1d4ed8;
    }
    .pp-filter-label {
      font-size: 13px;
      color: #475569;
      font-weight: 500;
      margin-left: 6px;
    }
    .pp-select {
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
    .pp-select:focus {
      background-color: #ffffff;
      border-color: #2563eb;
    }

    /* Main Table Container */
    .pp-table-card {
      background: #ffffff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 1px 3px rgba(0,0,0,0.02);
    }
    .pp-table {
      width: 100%;
      border-collapse: collapse;
      text-align: left;
    }
    .pp-table th {
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
    .pp-table td {
      padding: 16px 20px;
      font-size: 13.5px;
      color: #1e293b;
      border-bottom: 1px solid #f1f5f9;
      vertical-align: middle;
    }
    .pp-table tr:last-child td {
      border-bottom: none;
    }
    .pp-table tr:hover td {
      background: #fafafa;
    }

    .period-id-text {
      color: #94a3b8;
      font-size: 13px;
      font-weight: 600;
    }
    .period-name-text {
      font-weight: 700;
      color: #0f172a;
      font-size: 14.5px;
    }
    .date-text {
      color: #334155;
      font-weight: 500;
    }
    .days-badge {
      display: inline-block;
      padding: 3px 10px;
      background: #f1f5f9;
      color: #475569;
      border-radius: 9999px;
      font-size: 12px;
      font-weight: 600;
    }

    /* Badges */
    .badge-status-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 4px 12px;
      border-radius: 9999px;
      font-size: 12.5px;
      font-weight: 600;
    }
    .badge-active {
      background: #dcfce7;
      color: #15803d;
    }
    .badge-active .status-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: #16a34a;
    }
    .badge-locked {
      background: #f1f5f9;
      color: #64748b;
    }
    .badge-locked .status-dot {
      width: 7px;
      height: 7px;
      border-radius: 50%;
      background: #94a3b8;
    }

    /* Action Buttons */
    .action-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .btn-action-view {
      padding: 6px 12px;
      background: #eff6ff;
      color: #2563eb;
      border: 1px solid #bfdbfe;
      border-radius: 6px;
      font-size: 12.5px;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.15s;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .btn-action-view:hover {
      background: #dbeafe;
    }
    .btn-action-toggle {
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12.5px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.15s;
      border: 1px solid transparent;
      display: inline-flex;
      align-items: center;
      gap: 4px;
    }
    .btn-lock {
      background: #fffbe6;
      color: #d97706;
      border-color: #fde68a;
    }
    .btn-lock:hover {
      background: #fef3c7;
    }
    .btn-unlock {
      background: #f0fdf4;
      color: #16a34a;
      border-color: #bbf7d0;
    }
    .btn-unlock:hover {
      background: #dcfce7;
    }
    .btn-action-edit {
      padding: 6px 12px;
      background: #ffffff;
      color: #475569;
      border: 1px solid #cbd5e1;
      border-radius: 6px;
      font-size: 12.5px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.15s;
    }
    .btn-action-edit:hover {
      background: #f8fafc;
      color: #0f172a;
    }
    .btn-action-delete {
      padding: 6px 10px;
      background: #ffffff;
      color: #ef4444;
      border: 1px solid #fca5a5;
      border-radius: 6px;
      font-size: 12.5px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.15s;
    }
    .btn-action-delete:hover {
      background: #fef2f2;
      border-color: #f87171;
    }

    /* Pagination Footer Bar */
    .pp-pagination-bar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 20px;
      background: #ffffff;
      border-top: 1px solid #f1f5f9;
      font-size: 13px;
      color: #64748b;
    }
    .pp-pagination-info {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .pp-page-size-select {
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
    .pp-pagination-controls {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .pp-page-btn {
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
    .pp-page-btn:hover {
      background: #f1f5f9;
    }
    .pp-page-btn.active {
      background: #2563eb;
      color: #ffffff;
      font-weight: 600;
    }
    .pp-page-nav-btn {
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
    .pp-page-nav-btn:hover {
      background: #f8fafc;
      color: #1e293b;
    }
    .pp-page-nav-btn.disabled {
      opacity: 0.4;
      pointer-events: none;
    }

    /* Modal Styling */
    .modal-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(15, 23, 42, 0.45);
      backdrop-filter: blur(3px);
      z-index: 1000;
      display: none;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .modal-card {
      background: #ffffff;
      border-radius: 16px;
      width: 100%;
      max-width: 500px;
      box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
      padding: 26px;
      position: relative;
      animation: modalFadeIn 0.2s ease-out;
    }
    @keyframes modalFadeIn {
      from { opacity: 0; transform: translateY(-12px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .modal-close-btn {
      position: absolute;
      top: 22px;
      right: 22px;
      background: transparent;
      border: none;
      font-size: 20px;
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
      font-size: 19px;
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 4px;
    }
    .modal-subtitle {
      font-size: 13.5px;
      color: #64748b;
      margin-bottom: 22px;
    }

    .modal-form-group {
      margin-bottom: 18px;
    }
    .modal-form-group label {
      display: block;
      font-size: 13.5px;
      font-weight: 600;
      color: #334155;
      margin-bottom: 8px;
    }
    .modal-form-group input[type="text"],
    .modal-form-group input[type="date"],
    .modal-form-group select {
      width: 100%;
      height: 42px;
      padding: 0 14px;
      border: 1px solid #cbd5e1;
      border-radius: 8px;
      font-size: 14px;
      color: #0f172a;
      outline: none;
      background: #ffffff;
      box-sizing: border-box;
    }
    .modal-form-group input:focus,
    .modal-form-group select:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    }
    .modal-date-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }

    .checkbox-label {
      display: flex;
      align-items: center;
      gap: 10px;
      cursor: pointer;
      font-size: 13.5px;
      color: #334155;
      font-weight: 500;
      user-select: none;
    }
    .checkbox-label input[type="checkbox"] {
      width: 18px;
      height: 18px;
      accent-color: #2563eb;
      cursor: pointer;
    }

    .modal-footer {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      margin-top: 26px;
      padding-top: 16px;
      border-top: 1px solid #f1f5f9;
    }
    .btn-modal-cancel {
      padding: 10px 20px;
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
      padding: 10px 22px;
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
    .btn-modal-danger {
      padding: 10px 22px;
      background: #ef4444;
      border: none;
      border-radius: 8px;
      font-size: 13.5px;
      font-weight: 600;
      color: #ffffff;
      cursor: pointer;
      transition: background 0.12s;
    }
    .btn-modal-danger:hover {
      background: #dc2626;
    }

    /* Toast Notification */
    .toast-container {
      position: fixed;
      top: 24px;
      right: 24px;
      z-index: 2000;
    }
    .toast {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 14px 20px;
      border-radius: 10px;
      background: #ffffff;
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
      border-left: 5px solid #2563eb;
      animation: toastSlide 0.3s ease-out;
      font-size: 14px;
      font-weight: 500;
      color: #1e293b;
      min-width: 300px;
    }
    .toast-success { border-left-color: #16a34a; }
    .toast-error { border-left-color: #ef4444; }
    @keyframes toastSlide {
      from { transform: translateX(100%); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
  </style>
</head>
<body>

<!-- TOAST ALERT CONTAINER -->
<% if (toastMessage != null && !toastMessage.trim().isEmpty()) { %>
<div class="toast-container" id="toastBox">
  <div class="toast <%= "error".equals(toastType) ? "toast-error" : "toast-success" %>">
    <% if ("error".equals(toastType)) { %>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
    <% } else { %>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
    <% } %>
    <span><%= toastMessage %></span>
  </div>
</div>
<% } %>

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
    <span class="topbar-left"><a href="home_manager.jsp" style="color:inherit;text-decoration:none;">Trang chủ</a> / <a href="salary-management" style="color:inherit;text-decoration:none;">Quản lý lương</a> / Quản lý kỳ lương</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <!-- PAGE BODY -->
  <div class="page-body">
    <!-- Header Section -->
    <div class="pp-header">
      <div>
        <h1>Quản lý Kỳ Lương (Pay Periods)</h1>
        <p>Thiết lập, cập nhật ngày bắt đầu - kết thúc và quản lý trạng thái khóa/mở kỳ lương nhân sự</p>
      </div>
      <button type="button" class="btn-create-period" onclick="openCreateModal()">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"></line>
          <line x1="5" y1="12" x2="19" y2="12"></line>
        </svg>
        Tạo kỳ lương mới
      </button>
    </div>

    <!-- Summary Metrics Grid -->
    <div class="pp-stats-row">
      <div class="pp-stat-card">
        <div>
          <div class="pp-stat-label">Tổng số kỳ lương</div>
          <div class="pp-stat-value"><%= totalPeriodsCount %></div>
        </div>
        <div class="pp-stat-icon icon-blue-bg">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
            <line x1="16" y1="2" x2="16" y2="6"></line>
            <line x1="8" y1="2" x2="8" y2="6"></line>
            <line x1="3" y1="10" x2="21" y2="10"></line>
          </svg>
        </div>
      </div>

      <div class="pp-stat-card">
        <div>
          <div class="pp-stat-label">Kỳ lương đang mở</div>
          <div class="pp-stat-value"><%= activePeriodsCount %></div>
        </div>
        <div class="pp-stat-icon icon-green-bg">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            <polyline points="22 4 12 14.01 9 11.01"></polyline>
          </svg>
        </div>
      </div>

      <div class="pp-stat-card">
        <div>
          <div class="pp-stat-label">Kỳ lương đã khóa</div>
          <div class="pp-stat-value"><%= lockedPeriodsCount %></div>
        </div>
        <div class="pp-stat-icon icon-amber-bg">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
          </svg>
        </div>
      </div>
    </div>

    <!-- Filter & Search Toolbar -->
    <div class="pp-filter-card">
      <form action="pay-periods" method="GET" class="pp-filter-form" id="filterForm">
        
        <!-- Search Input -->
        <div class="pp-search-wrapper">
          <svg class="pp-search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input type="text" name="search" class="pp-input" placeholder="Tìm theo tên kỳ lương (VD: Tháng 08/2026)..." value="<%= searchStr %>"/>
        </div>

        <!-- Search Button -->
        <button type="submit" class="pp-btn-search">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          Tìm kiếm
        </button>

        <!-- Status Filter -->
        <span class="pp-filter-label">Trạng thái</span>
        <select name="status" class="pp-select" onchange="document.getElementById('filterForm').submit()">
          <option value="">Tất cả trạng thái</option>
          <option value="active" <%= "active".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Đang mở</option>
          <option value="locked" <%= "locked".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Đã khóa</option>
        </select>

        <!-- Hidden Page preservation -->
        <input type="hidden" name="page" value="1"/>
        <input type="hidden" name="pageSize" value="<%= pageSize %>"/>
      </form>
    </div>

    <!-- Data Table Card -->
    <div class="pp-table-card">
      <table class="pp-table">
        <thead>
          <tr>
            <th>MÃ KỲ</th>
            <th>TÊN KỲ LƯƠNG</th>
            <th>NGÀY BẮT ĐẦU</th>
            <th>NGÀY KẾT THÚC</th>
            <th>SỐ NGÀY</th>
            <th>TRẠNG THÁI</th>
            <th style="text-align: right; padding-right: 24px;">HÀNH ĐỘNG</th>
          </tr>
        </thead>
        <tbody>
          <% 
            if (periods != null && !periods.isEmpty()) {
                for (TimesheetPeriodDTO p : periods) {
                    boolean isLocked = p.isLocked();
          %>
              <tr>
                <td class="period-id-text">#<%= p.getId() %></td>
                <td>
                  <span class="period-name-text"><%= p.getName() %></span>
                </td>
                <td class="date-text"><%= p.getFormattedStartDate() %></td>
                <td class="date-text"><%= p.getFormattedEndDate() %></td>
                <td>
                  <span class="days-badge"><%= p.getTotalDays() %> ngày</span>
                </td>
                <td>
                  <span class="badge-status-pill <%= p.getStatusBadgeClass() %>">
                    <span class="status-dot"></span>
                    <%= p.getStatus() %>
                  </span>
                </td>
                <td>
                  <div class="action-group" style="justify-content: flex-end;">
                    
                    <!-- Link to view payslips of this period -->
                    <a href="manager-payslips?periodId=<%= p.getId() %>" class="btn-action-view" title="Xem bảng lương kỳ này">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                      </svg>
                      Xem bảng lương
                    </a>

                    <!-- Toggle Lock/Unlock button -->
                    <form action="pay-periods" method="POST" style="display:inline;" id="toggleForm_<%= p.getId() %>">
                      <input type="hidden" name="action" value="toggle-lock"/>
                      <input type="hidden" name="id" value="<%= p.getId() %>"/>
                      <input type="hidden" name="search" value="<%= searchStr %>"/>
                      <input type="hidden" name="status" value="<%= selectedStatus %>"/>
                      <input type="hidden" name="page" value="<%= currentPage %>"/>
                      <input type="hidden" name="pageSize" value="<%= pageSize %>"/>
                      
                      <% if (isLocked) { %>
                        <button type="button" class="btn-action-toggle btn-unlock" onclick="confirmToggleLock(<%= p.getId() %>, '<%= p.getName().replace("'", "\\'") %>', false)">
                          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/></svg>
                          Mở khóa
                        </button>
                      <% } else { %>
                        <button type="button" class="btn-action-toggle btn-lock" onclick="confirmToggleLock(<%= p.getId() %>, '<%= p.getName().replace("'", "\\'") %>', true)">
                          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                          Chốt sổ
                        </button>
                      <% } %>
                    </form>

                    <!-- Edit button -->
                    <button type="button" class="btn-action-edit" onclick="openEditModal(<%= p.getId() %>, '<%= p.getName().replace("'", "\\'") %>', '<%= p.getStartDate() %>', '<%= p.getEndDate() %>', <%= isLocked %>)">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                      Sửa
                    </button>

                    <!-- Delete button -->
                    <button type="button" class="btn-action-delete" onclick="openDeleteModal(<%= p.getId() %>, '<%= p.getName().replace("'", "\\'") %>')">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    </button>

                  </div>
                </td>
              </tr>
          <% 
                }
            } else { 
          %>
              <tr>
                <td colspan="7" style="text-align: center; padding: 40px; color: #64748b;">
                  Không tìm thấy kỳ lương nào phù hợp.
                </td>
              </tr>
          <% } %>
        </tbody>
      </table>

      <!-- Pagination Footer -->
      <div class="pp-pagination-bar">
        <div class="pp-pagination-info">
          <span>Hiển thị <strong><%= startItem %>-<%= endItem %></strong> / <%= totalFilteredItems %> kỳ lương</span>
          <span>Mỗi trang
            <select class="pp-page-size-select" onchange="changePageSize(this.value)">
              <option value="5" <%= pageSize == 5 ? "selected" : "" %>>5</option>
              <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10</option>
              <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20</option>
            </select>
          </span>
        </div>

        <div class="pp-pagination-controls">
          <% if (currentPage > 1) { %>
            <a href="<%= buildPageUrl(searchStr, selectedStatus, currentPage - 1, pageSize) %>" class="pp-page-nav-btn">&lt;</a>
          <% } else { %>
            <span class="pp-page-nav-btn disabled">&lt;</span>
          <% } %>

          <% for (int p = 1; p <= totalPages; p++) { %>
            <% if (p == currentPage) { %>
              <span class="pp-page-btn active"><%= p %></span>
            <% } else { %>
              <a href="<%= buildPageUrl(searchStr, selectedStatus, p, pageSize) %>" class="pp-page-btn"><%= p %></a>
            <% } %>
          <% } %>

          <% if (currentPage < totalPages) { %>
            <a href="<%= buildPageUrl(searchStr, selectedStatus, currentPage + 1, pageSize) %>" class="pp-page-nav-btn">&gt;</a>
          <% } else { %>
            <span class="pp-page-nav-btn disabled">&gt;</span>
          <% } %>
        </div>
      </div>
    </div>
  </div>

  <!-- FOOTER -->
  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>


<!-- MODAL: TẠO KỲ LƯƠNG MỚI -->
<div class="modal-overlay" id="createModal">
  <div class="modal-card">
    <button type="button" class="modal-close-btn" onclick="closeCreateModal()">✕</button>
    <div class="modal-title">Tạo kỳ lương mới</div>
    <div class="modal-subtitle">Điền thông tin tên và chu kỳ thời gian cho kỳ lương nhân viên</div>

    <form action="pay-periods" method="POST" id="createForm">
      <input type="hidden" name="action" value="create"/>
      <input type="hidden" name="search" value="<%= searchStr %>"/>
      <input type="hidden" name="status" value="<%= selectedStatus %>"/>
      <input type="hidden" name="page" value="1"/>
      <input type="hidden" name="pageSize" value="<%= pageSize %>"/>

      <div class="modal-form-group">
        <label>Tên kỳ lương <span style="color:#ef4444;">*</span></label>
        <input type="text" name="name" id="createName" placeholder="VD: Kỳ lương Tháng 09/2026" required/>
      </div>

      <div class="modal-form-group modal-date-grid">
        <div>
          <label>Ngày bắt đầu <span style="color:#ef4444;">*</span></label>
          <input type="date" name="startDate" id="createStartDate" required/>
        </div>
        <div>
          <label>Ngày kết thúc <span style="color:#ef4444;">*</span></label>
          <input type="date" name="endDate" id="createEndDate" required/>
        </div>
      </div>

      <div class="modal-form-group" style="margin-top:10px;">
        <label class="checkbox-label">
          <input type="checkbox" name="isLocked" value="true"/>
          <span>Chốt/Khóa kỳ lương này ngay sau khi tạo</span>
        </label>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn-modal-cancel" onclick="closeCreateModal()">Hủy</button>
        <button type="submit" class="btn-modal-save">Tạo kỳ lương</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL: CHỈNH SỬA KỲ LƯƠNG -->
<div class="modal-overlay" id="editModal">
  <div class="modal-card">
    <button type="button" class="modal-close-btn" onclick="closeEditModal()">✕</button>
    <div class="modal-title">Chỉnh sửa kỳ lương</div>
    <div class="modal-subtitle">Cập nhật tên và khoảng thời gian cho kỳ lương #<span id="editDisplayId"></span></div>

    <form action="pay-periods" method="POST" id="editForm">
      <input type="hidden" name="action" value="update"/>
      <input type="hidden" name="id" id="editId"/>
      <input type="hidden" name="search" value="<%= searchStr %>"/>
      <input type="hidden" name="status" value="<%= selectedStatus %>"/>
      <input type="hidden" name="page" value="<%= currentPage %>"/>
      <input type="hidden" name="pageSize" value="<%= pageSize %>"/>

      <div class="modal-form-group">
        <label>Tên kỳ lương <span style="color:#ef4444;">*</span></label>
        <input type="text" name="name" id="editName" required/>
      </div>

      <div class="modal-form-group modal-date-grid">
        <div>
          <label>Ngày bắt đầu <span style="color:#ef4444;">*</span></label>
          <input type="date" name="startDate" id="editStartDate" required/>
        </div>
        <div>
          <label>Ngày kết thúc <span style="color:#ef4444;">*</span></label>
          <input type="date" name="endDate" id="editEndDate" required/>
        </div>
      </div>

      <div class="modal-form-group" style="margin-top:10px;">
        <label class="checkbox-label">
          <input type="checkbox" name="isLocked" id="editIsLocked" value="true"/>
          <span>Khóa kỳ lương (Không cho phép chỉnh sửa bảng lương)</span>
        </label>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn-modal-cancel" onclick="closeEditModal()">Hủy</button>
        <button type="submit" class="btn-modal-save">Cập nhật</button>
      </div>
    </form>
  </div>
</div>


<!-- MODAL: XÁC NHẬN XÓA KỲ LƯƠNG -->
<div class="modal-overlay" id="deleteModal">
  <div class="modal-card">
    <button type="button" class="modal-close-btn" onclick="closeDeleteModal()">✕</button>
    <div class="modal-title" style="color:#ef4444;">Xác nhận xóa kỳ lương</div>
    <div class="modal-subtitle" style="margin-bottom:16px;">Bạn có chắc chắn muốn xóa kỳ lương <strong id="deletePeriodName" style="color:#0f172a;"></strong>? Hành động này không thể hoàn tác.</div>

    <form action="pay-periods" method="POST" id="deleteForm">
      <input type="hidden" name="action" value="delete"/>
      <input type="hidden" name="id" id="deleteId"/>
      <input type="hidden" name="search" value="<%= searchStr %>"/>
      <input type="hidden" name="status" value="<%= selectedStatus %>"/>
      <input type="hidden" name="page" value="<%= currentPage %>"/>
      <input type="hidden" name="pageSize" value="<%= pageSize %>"/>

      <div class="modal-footer">
        <button type="button" class="btn-modal-cancel" onclick="closeDeleteModal()">Hủy bỏ</button>
        <button type="submit" class="btn-modal-danger">Xóa kỳ lương</button>
      </div>
    </form>
  </div>
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

  // Toast Auto Fade Out
  setTimeout(function() {
    var toastBox = document.getElementById('toastBox');
    if (toastBox) {
      toastBox.style.opacity = '0';
      toastBox.style.transition = 'opacity 0.5s ease';
      setTimeout(function() { toastBox.remove(); }, 500);
    }
  }, 4000);

  function changePageSize(newSize) {
    var url = new URL(window.location.href);
    url.searchParams.set('pageSize', newSize);
    url.searchParams.set('page', '1');
    window.location.href = url.toString();
  }

  // Create Modal Controls
  function openCreateModal() {
    var now = new Date();
    var y = now.getFullYear();
    var m = String(now.getMonth() + 1).padStart(2, '0');
    
    // Auto suggest next month name if current day is late in month
    document.getElementById('createName').value = 'Kỳ lương Tháng ' + m + '/' + y;
    
    // Default dates
    var firstDay = y + '-' + m + '-01';
    var lastDayObj = new Date(y, now.getMonth() + 1, 0);
    var lastDay = y + '-' + m + '-' + String(lastDayObj.getDate()).padStart(2, '0');
    
    document.getElementById('createStartDate').value = firstDay;
    document.getElementById('createEndDate').value = lastDay;

    document.getElementById('createModal').style.display = 'flex';
  }

  function closeCreateModal() {
    document.getElementById('createModal').style.display = 'none';
  }

  // Edit Modal Controls
  function openEditModal(id, name, startDate, endDate, isLocked) {
    document.getElementById('editId').value = id;
    document.getElementById('editDisplayId').textContent = id;
    document.getElementById('editName').value = name;
    document.getElementById('editStartDate').value = startDate;
    document.getElementById('editEndDate').value = endDate;
    document.getElementById('editIsLocked').checked = (isLocked === true || isLocked === 'true');
    document.getElementById('editModal').style.display = 'flex';
  }

  function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
  }

  // Delete Modal Controls
  function openDeleteModal(id, name) {
    document.getElementById('deleteId').value = id;
    document.getElementById('deletePeriodName').textContent = name;
    document.getElementById('deleteModal').style.display = 'flex';
  }

  function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
  }

  // Toggle Lock Confirm
  function confirmToggleLock(id, name, shouldLock) {
    var msg = shouldLock 
      ? 'Bạn có chắc chắn muốn CHỐT / KHÓA ' + name + '? Sau khi khóa, dữ liệu bảng lương sẽ được bảo lưu chắc chắn.' 
      : 'Bạn có chắc chắn muốn MỞ KHÓA ' + name + '?';
    if (confirm(msg)) {
      document.getElementById('toggleForm_' + id).submit();
    }
  }

  // Close modals when clicking outside
  window.onclick = function(event) {
    var createM = document.getElementById('createModal');
    var editM = document.getElementById('editModal');
    var deleteM = document.getElementById('deleteModal');
    if (event.target === createM) closeCreateModal();
    if (event.target === editM) closeEditModal();
    if (event.target === deleteM) closeDeleteModal();
  }
</script>

</body>
</html>

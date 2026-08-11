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
    
    String searchStr = (String) request.getAttribute("search");
    if (searchStr == null) searchStr = "";
    
    Integer selectedDeptId = (Integer) request.getAttribute("selectedDepartmentId");
    Integer selectedPosId = (Integer) request.getAttribute("selectedPositionId");
    String sortByVal = (String) request.getAttribute("sortBy");
    String sortOrderVal = (String) request.getAttribute("sortOrder");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Base Salary Directory | EMS</title>
    <!-- Google Fonts & Font Awesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --primary-light: #eeeffe;
            --secondary: #06b6d4;
            --success: #10b981;
            --success-light: #d1fae5;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #0f172a;
            --slate-800: #1e293b;
            --slate-700: #334155;
            --slate-600: #475569;
            --slate-500: #64748b;
            --slate-400: #94a3b8;
            --slate-300: #cbd5e1;
            --slate-200: #e2e8f0;
            --slate-100: #f1f5f9;
            --slate-50: #f8fafc;
            --card-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.04), 0 8px 10px -6px rgba(15, 23, 42, 0.04);
            --card-shadow-hover: 0 20px 25px -5px rgba(79, 70, 229, 0.1), 0 8px 10px -6px rgba(79, 70, 229, 0.04);
            --transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #f4f6fb;
            color: var(--slate-800);
            line-height: 1.5;
            min-height: 100vh;
        }

        /* Top Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--slate-200);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 0.875rem 2rem;
        }

        .navbar-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .brand-title {
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--dark);
            letter-spacing: -0.02em;
        }

        .brand-badge {
            background: var(--primary-light);
            color: var(--primary);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.2rem 0.5rem;
            border-radius: 6px;
            text-transform: uppercase;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-pill {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--slate-100);
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--slate-700);
        }

        .user-avatar {
            width: 28px;
            height: 28px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
        }

        /* Main Layout */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* Header Section */
        .page-header {
            margin-bottom: 2rem;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
        }

        .page-header-text h1 {
            font-size: 1.75rem;
            font-weight: 800;
            color: var(--dark);
            letter-spacing: -0.02em;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .page-header-text p {
            color: var(--slate-500);
            font-size: 0.95rem;
            margin-top: 0.25rem;
        }

        .header-actions {
            display: flex;
            gap: 0.75rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.625rem 1.25rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.875rem;
            cursor: pointer;
            transition: var(--transition);
            border: 1px solid transparent;
            text-decoration: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: white;
            color: var(--slate-700);
            border-color: var(--slate-200);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        .btn-secondary:hover {
            background-color: var(--slate-50);
            border-color: var(--slate-300);
            color: var(--dark);
        }

        /* Stat Cards Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .stat-card:hover {
            box-shadow: var(--card-shadow-hover);
            transform: translateY(-2px);
            border-color: rgba(79, 70, 229, 0.3);
        }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
        }

        .stat-icon.blue {
            background: #e0f2fe;
            color: #0284c7;
        }

        .stat-icon.emerald {
            background: #d1fae5;
            color: #059669;
        }

        .stat-icon.indigo {
            background: #e0e7ff;
            color: #4338ca;
        }

        .stat-icon.purple {
            background: #f3e8ff;
            color: #7e22ce;
        }

        .stat-info .stat-label {
            font-size: 0.8125rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--slate-500);
        }

        .stat-info .stat-value {
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--dark);
            margin-top: 0.15rem;
            letter-spacing: -0.02em;
        }

        /* Filter Toolbar Card */
        .filter-card {
            background: white;
            border-radius: 16px;
            padding: 1.25rem;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .filter-form {
            display: grid;
            grid-template-columns: 2fr 1.2fr 1.2fr 1.2fr auto;
            gap: 1rem;
            align-items: end;
        }

        @media (max-width: 1024px) {
            .filter-form {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 640px) {
            .filter-form {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .form-label {
            font-size: 0.8125rem;
            font-weight: 700;
            color: var(--slate-700);
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 0.875rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--slate-400);
            font-size: 0.9rem;
        }

        .form-control {
            width: 100%;
            padding: 0.625rem 0.875rem 0.625rem 2.4rem;
            border: 1px solid var(--slate-300);
            border-radius: 10px;
            font-family: inherit;
            font-size: 0.875rem;
            color: var(--slate-800);
            background-color: var(--slate-50);
            transition: var(--transition);
        }

        select.form-control {
            padding-left: 0.875rem;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%20%2364748b'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            background-color: white;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.12);
        }

        .filter-btn-group {
            display: flex;
            gap: 0.5rem;
        }

        /* Main Data Card */
        .table-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--slate-200);
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .table-header-bar {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--slate-200);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: white;
        }

        .table-title-group {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .table-title {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark);
        }

        .results-count {
            background: var(--slate-100);
            color: var(--slate-600);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 0.25rem 0.6rem;
            border-radius: 9999px;
        }

        /* Table Design */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.875rem;
        }

        .data-table th {
            background: var(--slate-50);
            color: var(--slate-600);
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--slate-200);
            white-space: nowrap;
        }

        .data-table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle;
            color: var(--slate-700);
            transition: var(--transition);
        }

        .data-table tbody tr {
            transition: var(--transition);
        }

        .data-table tbody tr:hover {
            background-color: #f8fafc;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Table Element Components */
        .employee-profile {
            display: flex;
            align-items: center;
            gap: 0.875rem;
        }

        .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            font-weight: 700;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 8px rgba(99, 102, 241, 0.25);
            flex-shrink: 0;
        }

        .emp-name {
            font-weight: 700;
            color: var(--dark);
            font-size: 0.925rem;
        }

        .emp-code {
            font-size: 0.775rem;
            color: var(--slate-500);
            font-family: monospace;
            font-weight: 600;
        }

        .code-badge {
            display: inline-block;
            background: var(--slate-100);
            color: var(--slate-700);
            font-family: monospace;
            font-weight: 700;
            font-size: 0.8rem;
            padding: 0.25rem 0.55rem;
            border-radius: 6px;
            border: 1px solid var(--slate-200);
        }

        .badge-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .badge-dept {
            background: #e0f2fe;
            color: #0369a1;
        }

        .badge-pos {
            background: #f3e8ff;
            color: #6b21a8;
        }

        .salary-amount {
            font-size: 1.05rem;
            font-weight: 800;
            color: #047857;
            letter-spacing: -0.01em;
        }

        .salary-unit {
            font-size: 0.75rem;
            font-weight: 700;
            color: #059669;
            margin-left: 0.15rem;
        }

        .status-dot {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
        }

        .dot.active {
            background-color: var(--success);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.2);
        }

        .dot.inactive {
            background-color: var(--slate-400);
        }

        /* Empty State */
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
        }

        .empty-icon {
            width: 72px;
            height: 72px;
            background: var(--slate-100);
            color: var(--slate-400);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1.25rem auto;
        }

        .empty-state h3 {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: var(--slate-500);
            font-size: 0.9rem;
            max-width: 400px;
            margin: 0 auto;
        }

        /* Footer */
        .footer {
            margin-top: 3rem;
            padding: 1.5rem 0;
            border-top: 1px solid var(--slate-200);
            text-align: center;
            color: var(--slate-500);
            font-size: 0.85rem;
        }

        /* Utility classes */
        .text-right {
            text-align: right;
        }
    </style>
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="navbar-container">
            <a href="base-salaries" class="brand">
                <div class="brand-icon">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>
                <span class="brand-title">EMS System</span>
                <span class="brand-badge">HR Portal</span>
            </a>
            <div class="nav-actions">
                <div class="user-pill">
                    <div class="user-avatar">HR</div>
                    <span>Administrator</span>
                </div>
            </div>
        </div>
    </nav>

    <main class="container">
        <!-- Page Header -->
        <header class="page-header">
            <div class="page-header-text">
                <h1>
                    <i class="fa-solid fa-money-bill-wave" style="color: var(--primary);"></i>
                    Quản lý Lương Cơ Bản (Base Salary)
                </h1>
                <p>Danh sách và thông tin chi tiết mức lương cơ bản của cán bộ nhân viên</p>
            </div>
            <div class="header-actions">
                <button class="btn btn-secondary" onclick="window.print()">
                    <i class="fa-solid fa-print"></i> In danh sách
                </button>
            </div>
        </header>

        <!-- Metric Summary Cards -->
        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-label">Tổng nhân viên</div>
                    <div class="stat-value"><%= summary != null ? summary.getTotalEmployees() : 0 %></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon emerald">
                    <i class="fa-solid fa-calculator"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-label">Lương TB (Average)</div>
                    <div class="stat-value">
                        <%= summary != null ? summary.getFormattedAverageSalary() : "0" %>
                        <span style="font-size: 0.85rem; font-weight: 700; color: var(--slate-500);">VNĐ</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon indigo">
                    <i class="fa-solid fa-wallet"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-label">Tổng ngân sách lương</div>
                    <div class="stat-value">
                        <%= summary != null ? summary.getFormattedTotalBudget() : "0" %>
                        <span style="font-size: 0.85rem; font-weight: 700; color: var(--slate-500);">VNĐ</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
                <div class="stat-info">
                    <div class="stat-label">Cao nhất / Thấp nhất</div>
                    <div class="stat-value" style="font-size: 1.15rem;">
                        <%= summary != null ? summary.getFormattedMaxSalary() : "0" %>
                        /
                        <%= summary != null ? summary.getFormattedMinSalary() : "0" %>
                    </div>
                </div>
            </div>
        </section>

        <!-- Filter & Search Toolbar -->
        <section class="filter-card">
            <form action="base-salaries" method="GET" class="filter-form" id="filterForm">
                
                <!-- Search Input -->
                <div class="form-group">
                    <label class="form-label" for="search">
                        <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm nhân viên
                    </label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" id="search" name="search" class="form-control"
                               placeholder="Nhập tên, mã NV hoặc email..."
                               value="<%= searchStr %>">
                    </div>
                </div>

                <!-- Department Filter -->
                <div class="form-group">
                    <label class="form-label" for="departmentId">
                        <i class="fa-solid fa-sitemap"></i> Phòng ban
                    </label>
                    <select id="departmentId" name="departmentId" class="form-control" onchange="document.getElementById('filterForm').submit()">
                        <option value="">-- Tất cả phòng ban --</option>
                        <% if (departments != null) {
                            for (Departments dept : departments) {
                                boolean isSelected = selectedDeptId != null && selectedDeptId.equals(dept.getId());
                        %>
                            <option value="<%= dept.getId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= dept.getName() %> (<%= dept.getCode() %>)
                            </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <!-- Position Filter -->
                <div class="form-group">
                    <label class="form-label" for="positionId">
                        <i class="fa-solid fa-briefcase"></i> Chức vụ
                    </label>
                    <select id="positionId" name="positionId" class="form-control" onchange="document.getElementById('filterForm').submit()">
                        <option value="">-- Tất cả chức vụ --</option>
                        <% if (positions != null) {
                            for (Positions pos : positions) {
                                boolean isSelected = selectedPosId != null && selectedPosId.equals(pos.getId());
                        %>
                            <option value="<%= pos.getId() %>" <%= isSelected ? "selected" : "" %>>
                                <%= pos.getName() %> (<%= pos.getCode() %>)
                            </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <!-- Sort Field -->
                <div class="form-group">
                    <label class="form-label" for="sortBy">
                        <i class="fa-solid fa-arrow-down-short-wide"></i> Sắp xếp theo
                    </label>
                    <select id="sortBy" name="sortBy" class="form-control" onchange="document.getElementById('filterForm').submit()">
                        <option value="code" <%= "code".equalsIgnoreCase(sortByVal) ? "selected" : "" %>>Mã nhân viên</option>
                        <option value="name" <%= "name".equalsIgnoreCase(sortByVal) ? "selected" : "" %>>Họ và tên</option>
                        <option value="salary" <%= "salary".equalsIgnoreCase(sortByVal) ? "selected" : "" %>>Mức lương cơ bản</option>
                        <option value="department" <%= "department".equalsIgnoreCase(sortByVal) ? "selected" : "" %>>Phòng ban</option>
                        <option value="position" <%= "position".equalsIgnoreCase(sortByVal) ? "selected" : "" %>>Chức vụ</option>
                    </select>
                </div>

                <!-- Sort Order hidden / submit -->
                <input type="hidden" id="sortOrder" name="sortOrder" value="<%= sortOrderVal != null ? sortOrderVal : "ASC" %>">

                <!-- Buttons -->
                <div class="filter-btn-group">
                    <button type="submit" class="btn btn-primary" title="Áp dụng lọc">
                        <i class="fa-solid fa-filter"></i> Lọc
                    </button>
                    <a href="base-salaries" class="btn btn-secondary" title="Đặt lại bộ lọc">
                        <i class="fa-solid fa-rotate-left"></i>
                    </a>
                </div>
            </form>
        </section>

        <!-- Data Table -->
        <section class="table-card">
            <div class="table-header-bar">
                <div class="table-title-group">
                    <span class="table-title">Danh sách Lương Cơ Bản Nhân Viên</span>
                    <span class="results-count"><%= baseSalaries != null ? baseSalaries.size() : 0 %> kết quả</span>
                </div>
                
                <!-- Sort direction switcher -->
                <div>
                    <button type="button" class="btn btn-secondary" style="padding: 0.4rem 0.8rem; font-size: 0.8rem;"
                            onclick="toggleSortOrder()">
                        <i class="fa-solid <%= "DESC".equalsIgnoreCase(sortOrderVal) ? "fa-arrow-down-z-a" : "fa-arrow-up-a-z" %>"></i>
                        Thứ tự: <%= "DESC".equalsIgnoreCase(sortOrderVal) ? "Giảm dần" : "Tăng dần" %>
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <% if (baseSalaries != null && !baseSalaries.isEmpty()) { %>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã NV</th>
                                <th>Nhân viên</th>
                                <th>Phòng ban</th>
                                <th>Chức vụ</th>
                                <th>Email / SĐT</th>
                                <th class="text-right">Lương Cơ Bản (Base Salary)</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                int index = 1;
                                for (BaseSalaryDTO item : baseSalaries) { 
                                    String firstChar = (item.getFullName() != null && !item.getFullName().trim().isEmpty()) 
                                            ? item.getFullName().trim().substring(0, 1).toUpperCase() : "N";
                                    boolean isActive = item.getStatus() != null && item.getStatus();
                            %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td>
                                        <span class="code-badge"><%= item.getEmployeeCode() != null ? item.getEmployeeCode() : "" %></span>
                                    </td>
                                    <td>
                                        <div class="employee-profile">
                                            <div class="avatar-circle">
                                                <%= firstChar %>
                                            </div>
                                            <div>
                                                <div class="emp-name"><%= item.getFullName() != null ? item.getFullName() : "" %></div>
                                                <div class="emp-code">
                                                    <%= item.getGender() != null ? (item.getGender() ? "Nam" : "Nữ") : "Chưa cập nhật" %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge-tag badge-dept">
                                            <i class="fa-solid fa-building"></i>
                                            <%= item.getDepartmentName() != null ? item.getDepartmentName() : "Chưa phân công" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge-tag badge-pos">
                                            <i class="fa-solid fa-user-tag"></i>
                                            <%= item.getPositionName() != null ? item.getPositionName() : "Chưa phân công" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.85rem;">
                                            <i class="fa-regular fa-envelope" style="color: var(--slate-400);"></i> <%= item.getEmailCompany() != null ? item.getEmailCompany() : "" %><br>
                                            <% if (item.getPhone() != null && !item.getPhone().trim().isEmpty()) { %>
                                                <i class="fa-solid fa-phone" style="color: var(--slate-400); font-size: 0.75rem;"></i> <%= item.getPhone() %>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        <span class="salary-amount">
                                            <%= item.getFormattedBaseSalary() %>
                                        </span>
                                        <span class="salary-unit">VNĐ</span>
                                    </td>
                                    <td>
                                        <div class="status-dot">
                                            <span class="dot <%= isActive ? "active" : "inactive" %>"></span>
                                            <span style="color: <%= isActive ? "var(--slate-800)" : "var(--slate-400)" %>">
                                                <%= isActive ? "Đang làm việc" : "Nghỉ việc" %>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fa-solid fa-folder-open"></i>
                        </div>
                        <h3>Không tìm thấy dữ liệu</h3>
                        <p>Không tìm thấy bản ghi lương cơ bản nào phù hợp với bộ lọc tìm kiếm của bạn.</p>
                        <div style="margin-top: 1rem;">
                            <a href="base-salaries" class="btn btn-primary">
                                <i class="fa-solid fa-rotate-left"></i> Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2026 EMS - Employee Management System | View Base Salaries Module</p>
        </footer>
    </main>

    <script>
        function toggleSortOrder() {
            const sortOrderInput = document.getElementById('sortOrder');
            if (sortOrderInput.value === 'ASC') {
                sortOrderInput.value = 'DESC';
            } else {
                sortOrderInput.value = 'ASC';
            }
            document.getElementById('filterForm').submit();
        }
    </script>
</body>
</html>

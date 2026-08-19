<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
      <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

        <%@ page import="java.util.List" %>
          <%@ page import="com.ems.dto.ManagerPayslipDTO" %>
            <%@ page import="com.ems.model.Departments" %>
              <%@ page import="com.ems.model.Timesheetperiods" %>
                <% List<Timesheetperiods> periods = (List<Timesheetperiods>) request.getAttribute("periods");
                    List<Departments> departments = (List<Departments>) request.getAttribute("departments");
                        List<ManagerPayslipDTO> payslips = (List<ManagerPayslipDTO>) request.getAttribute("payslips");

                            Integer selectedPeriodId = (Integer) request.getAttribute("selectedPeriodId");
                            Integer selectedDeptId = (Integer) request.getAttribute("selectedDepartmentId");
                            String searchStr = (String) request.getAttribute("search");
                            if (searchStr == null) searchStr = "";

                            Integer totalEmployees = (Integer) request.getAttribute("totalEmployees");
                            if (totalEmployees == null) totalEmployees = 0;

                            String formattedTotalGross = (String) request.getAttribute("formattedTotalGross");
                            if (formattedTotalGross == null) formattedTotalGross = "0";

                            String formattedTotalNet = (String) request.getAttribute("formattedTotalNet");
                            if (formattedTotalNet == null) formattedTotalNet = "0";

                            String formattedTotalDeductions = (String) request.getAttribute("formattedTotalDeductions");
                            if (formattedTotalDeductions == null) formattedTotalDeductions = "0";

                            String currentPeriodName = "Chưa chọn kỳ lương";
                            if (periods != null && selectedPeriodId != null) {
                            for (Timesheetperiods tp : periods) {
                            if (tp.getId().equals(selectedPeriodId)) {
                            currentPeriodName = tp.getName();
                            break;
                            }
                            }
                            }
                            %>
                            <!DOCTYPE html>
                            <html lang="vi">

                            <head>
                              <meta charset="UTF-8" />
                              <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                              <title>Bảng lương theo kỳ – EMS Manager</title>
                              <link rel="stylesheet" href="css/ems.css" />
                              <link rel="stylesheet" href="css/manager-payslip-list.css" />
                              <link rel="preconnect" href="https://fonts.googleapis.com">
                              <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                              <link
                                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
                            </head>

                            <%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

                              <body>
                                <!-- MAIN CONTENT WRAPPER -->
                                <div class="main-content">
                                  <!-- TOPBAR -->
                                  <div class="topbar">
                                    <span class="topbar-left"><a href="home_manager.jsp"
                                        style="color:inherit;text-decoration:none;">Trang chủ</a> / <a
                                        href="salary-management" style="color:inherit;text-decoration:none;">Quản lý
                                        lương</a> / Bảng lương theo kỳ</span>
                                    <span class="topbar-right" id="topbar-date"></span>
                                  </div>

                                  <!-- PAGE BODY -->
                                  <div class="page-body">
                                    <!-- Header Section -->
                                    <div class="ps-header">
                                      <h1>Bảng lương theo kỳ (Manager View)</h1>
                                      <p>Xem và quản lý tất cả bảng lương đã tính toán của nhân viên theo từng kỳ lương
                                      </p>
                                    </div>

                                    <!-- Filter & Period Selector Card -->
                                    <div class="ps-filter-card">
                                      <form action="manager-payslips" method="GET" class="ps-filter-form"
                                        id="periodForm">

                                        <!-- Period Dropdown Box -->
                                        <div class="ps-period-select-wrapper">
                                          <span class="ps-period-label">📅 Chọn kỳ lương:</span>
                                          <select name="periodId" class="ps-period-select"
                                            onchange="document.getElementById('periodForm').submit()">
                                            <% if (periods !=null) { for (Timesheetperiods p : periods) { boolean
                                              isSel=selectedPeriodId !=null && selectedPeriodId.equals(p.getId()); %>
                                              <option value="<%= p.getId() %>" <%=isSel ? "selected" : "" %>>
                                                <%= p.getName() %> (<%= p.getStartdate() %> - <%= p.getEnddate() %>)
                                              </option>
                                              <% } } %>
                                          </select>
                                        </div>

                                        <!-- Search Input -->
                                        <div class="ps-search-wrapper">
                                          <svg class="ps-search-icon" width="16" height="16" viewBox="0 0 24 24"
                                            fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                          </svg>
                                          <input type="text" name="search" class="ps-input"
                                            placeholder="Tìm tên hoặc mã nhân viên..." value="<%= searchStr %>" />
                                        </div>

                                        <!-- Department Filter -->
                                        <select name="departmentId" class="ps-select"
                                          onchange="document.getElementById('periodForm').submit()">
                                          <option value="">Tất cả phòng ban</option>
                                          <% if (departments !=null) { for (Departments d : departments) { boolean
                                            isSelected=selectedDeptId !=null && selectedDeptId.equals(d.getId()); %>
                                            <option value="<%= d.getId() %>" <%=isSelected ? "selected" : "" %>>
                                              <%= d.getName() %>
                                            </option>
                                            <% } } %>
                                        </select>

                                        <!-- Search Button -->
                                        <button type="submit" class="ps-btn-search">
                                          <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <circle cx="11" cy="11" r="8"></circle>
                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                          </svg>
                                          Lọc dữ liệu
                                        </button>
                                      </form>
                                    </div>

                                    <!-- Summary Metrics (4 Cards) -->
                                    <div class="ps-stats-row">
                                      <div class="ps-stat-card">
                                        <div class="ps-stat-label">Tổng số nhân viên</div>
                                        <div class="ps-stat-value">
                                          <%= totalEmployees %>
                                        </div>
                                      </div>
                                      <div class="ps-stat-card">
                                        <div class="ps-stat-label">Tổng lương Gross</div>
                                        <div class="ps-stat-value">
                                          <%= formattedTotalGross %> đ
                                        </div>
                                      </div>
                                      <div class="ps-stat-card">
                                        <div class="ps-stat-label">Tổng khấu trừ (BH+Thuế)</div>
                                        <div class="ps-stat-value">
                                          <%= formattedTotalDeductions %> đ
                                        </div>
                                      </div>
                                      <div class="ps-stat-card">
                                        <div class="ps-stat-label">Tổng thực lĩnh (Net)</div>
                                        <div class="ps-stat-value highlight-net">
                                          <%= formattedTotalNet %> đ
                                        </div>
                                      </div>
                                    </div>

                                    <!-- Table Card -->
                                    <div class="ps-table-card">
                                      <table class="ps-table">
                                        <thead>
                                          <tr>
                                            <th>MÃ NV</th>
                                            <th>HỌ VÀ TÊN</th>
                                            <th>PHÒNG BAN</th>
                                            <th>LƯƠNG CƠ BẢN</th>
                                            <th>PHỤ CẤP &amp; OT</th>
                                            <th>KHOẢN TRỪ (BH+THUẾ)</th>
                                            <th>THỰC LĨNH (NET)</th>
                                            <th>TRẠNG THÁI</th>
                                            <th>HÀNH ĐỘNG</th>
                                          </tr>
                                        </thead>
                                        <tbody>
                                          <% if (payslips !=null && !payslips.isEmpty()) { String[]
                                            colors={"#f87171", "#fb923c" , "#fbbf24" , "#34d399" , "#60a5fa" , "#a78bfa"
                                            , "#f472b6" }; for (ManagerPayslipDTO item : payslips) { String
                                            fullName=item.getFullName() !=null ? item.getFullName() : "" ; String
                                            firstChar=(!fullName.trim().isEmpty()) ? fullName.trim().substring(0,
                                            1).toUpperCase() : "N" ; int colorIdx=Math.abs(fullName.hashCode()) %
                                            colors.length; String avatarColor=colors[colorIdx]; String
                                            st=item.getStatus() !=null ? item.getStatus() : "Draft" ; String
                                            stClass="status-draft" ; String stText="Tạm tính" ; if
                                            ("Approved".equalsIgnoreCase(st)) { stClass="status-approved" ;
                                            stText="Đã duyệt" ; } else if ("Paid".equalsIgnoreCase(st)) {
                                            stClass="status-paid" ; stText="Đã thanh toán" ; } %>
                                            <tr>
                                              <td style="color:#94a3b8; font-weight:500;">
                                                <%= item.getEmployeeCode() %>
                                              </td>
                                              <td>
                                                <div class="emp-user-cell">
                                                  <div class="emp-avatar-circle"
                                                    style="background-color: <%= avatarColor %>;">
                                                    <%= firstChar %>
                                                  </div>
                                                  <span class="emp-name-text">
                                                    <%= fullName %>
                                                  </span>
                                                </div>
                                              </td>
                                              <td><span class="dept-badge">
                                                  <%= item.getDepartmentName() !=null ? item.getDepartmentName() : "N/A"
                                                    %>
                                                </span></td>
                                              <td style="font-weight:600;">
                                                <%= item.getFormattedBaseSalary() %> đ
                                              </td>
                                              <td style="color:#16a34a; font-weight:500;">+ <%=
                                                  item.getFormattedTotalAdditions() %> đ</td>
                                              <td style="color:#dc2626; font-weight:500;">- <%=
                                                  item.getFormattedTotalDeductions() %> đ</td>
                                              <td class="net-salary-text">
                                                <%= item.getFormattedNetAmount() %> đ
                                              </td>
                                              <td><span class="status-badge <%= stClass %>">
                                                  <%= stText %>
                                                </span></td>
                                              <td>
                                                <button type="button" class="btn-view-detail"
                                                  onclick="openPayslipModal('<%= item.getEmployeeCode() %>', '<%= fullName.replace("'", "\\'") %>', '<%= (item.getDepartmentName() != null ? item.getDepartmentName() : "").replace("'", "\\'") %>', '<%= (item.getPositionName() != null ? item.getPositionName() : "").replace("'", "\\'") %>', '<%= item.getPeriodName() %>', '<%= item.getFormattedBaseSalary() %>', '<%= item.getFormattedOtSalary() %>', '<%= item.getFormattedAllowances() %>', '<%= item.getFormattedGrossAmount() %>', '<%= item.getFormattedInsuranceDeduction() %>', '<%= item.getFormattedDependentDeduction() %>', '<%= item.getFormattedTaxDeduction() %>', '<%= item.getFormattedTotalDeductions() %>', '<%= item.getFormattedNetAmount() %>')">
                                                  👁 Chi tiết
                                                </button>
                                              </td>
                                            </tr>
                                            <% } } else { %>
                                              <tr>
                                                <td colspan="9"
                                                  style="text-align: center; padding: 40px; color: #64748b;">
                                                  Chưa có dữ liệu bảng lương được tính toán cho kỳ lương này.
                                                </td>
                                              </tr>
                                              <% } %>
                                        </tbody>
                                      </table>
                                    </div>
                                  </div>

                                  <!-- FOOTER -->
                                  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
                                </div>

                                <!-- PAYSLIP RECEIPT DETAIL MODAL -->
                                <div class="modal-overlay" id="payslipModal">
                                  <div class="payslip-modal-card">
                                    <button type="button" class="modal-close-btn"
                                      onclick="closePayslipModal()">✕</button>

                                    <div class="payslip-receipt-header">
                                      <div class="receipt-brand">EMS HRMS · FPT UNIVERSITY</div>
                                      <div class="receipt-title">PHIẾU LƯƠNG CHI TIẾT</div>
                                      <div class="receipt-subtitle" id="modalPeriodTitle">Kỳ lương Tháng 08/2026</div>
                                    </div>

                                    <!-- Info Grid -->
                                    <div class="receipt-info-grid">
                                      <div><label>Nhân viên:</label> <span id="modalEmpName">NV001 · Nguyễn Văn
                                          An</span></div>
                                      <div><label>Phòng ban:</label> <span id="modalEmpDept">Kỹ thuật</span></div>
                                      <div><label>Chức vụ:</label> <span id="modalEmpPos">Trưởng nhóm</span></div>
                                      <div><label>Ngày lập:</label> <span>Hôm nay</span></div>
                                    </div>

                                    <!-- Breakdown Grid -->
                                    <div class="breakdown-grid">
                                      <!-- Earnings Box -->
                                      <div class="breakdown-box">
                                        <div class="breakdown-box-title title-add">THU NHẬP (EARNINGS)</div>
                                        <div class="breakdown-row"><span>Lương cơ bản</span><span id="modalBaseSal">0
                                            đ</span></div>
                                        <div class="breakdown-row"><span>Lương làm thêm (OT)</span><span
                                            id="modalOtSal">0 đ</span></div>
                                        <div class="breakdown-row"><span>Phụ cấp</span><span id="modalAllow">0 đ</span>
                                        </div>
                                        <div class="breakdown-row total-row"><span>TỔNG GROSS</span><span
                                            id="modalGross">0 đ</span></div>
                                      </div>

                                      <!-- Deductions Box -->
                                      <div class="breakdown-box">
                                        <div class="breakdown-box-title title-sub">KHẤU TRỪ (DEDUCTIONS)</div>
                                        <div class="breakdown-row"><span>Bảo hiểm (BHXH, BHYT)</span><span
                                            id="modalIns">0 đ</span></div>
                                        <div class="breakdown-row"><span>Người phụ thuộc</span><span id="modalDep">0
                                            đ</span></div>
                                        <div class="breakdown-row"><span>Thuế TNCN</span><span id="modalTax">0 đ</span>
                                        </div>
                                        <div class="breakdown-row total-row"><span>TỔNG KHẤU TRỪ</span><span
                                            id="modalTotalSub">0 đ</span></div>
                                      </div>
                                    </div>

                                    <!-- Net Pay Banner -->
                                    <div class="net-banner">
                                      <div class="net-banner-label">THỰC LĨNH (NET PAY)</div>
                                      <div class="net-banner-val" id="modalNetPay">0 VNĐ</div>
                                    </div>

                                    <!-- Modal Footer -->
                                    <div class="modal-footer"
                                      style="display:flex; justify-content: flex-end; gap:10px;">
                                      <button type="button" class="btn-modal-cancel" onclick="window.print()">🖨 In
                                        phiếu lương</button>
                                      <button type="button" class="btn-modal-save"
                                        onclick="closePayslipModal()">Đóng</button>
                                    </div>
                                  </div>
                                </div>

                                <script>
                                  function tick() {
                                    var now = new Date();
                                    var p = function (n) { return String(n).padStart(2, '0'); };
                                    var el = document.getElementById('topbar-date');
                                    if (el) {
                                      el.textContent = p(now.getDate()) + '/' + p(now.getMonth() + 1) + '/' + now.getFullYear();
                                    }
                                  }
                                  tick();

                                  function openPayslipModal(code, name, dept, pos, period, baseSal, otSal, allow, gross, ins, dep, tax, totalSub, net) {
                                    document.getElementById('modalPeriodTitle').textContent = period;
                                    document.getElementById('modalEmpName').textContent = code + ' · ' + name;
                                    document.getElementById('modalEmpDept').textContent = dept || 'N/A';
                                    document.getElementById('modalEmpPos').textContent = pos || 'N/A';

                                    document.getElementById('modalBaseSal').textContent = baseSal + ' đ';
                                    document.getElementById('modalOtSal').textContent = otSal + ' đ';
                                    document.getElementById('modalAllow').textContent = allow + ' đ';
                                    document.getElementById('modalGross').textContent = gross + ' đ';

                                    document.getElementById('modalIns').textContent = ins + ' đ';
                                    document.getElementById('modalDep').textContent = dep + ' đ (Miễn trừ)';
                                    document.getElementById('modalTax').textContent = tax + ' đ';
                                    document.getElementById('modalTotalSub').textContent = totalSub + ' đ';

                                    document.getElementById('modalNetPay').textContent = net + ' VNĐ';

                                    document.getElementById('payslipModal').style.display = 'flex';
                                  }

                                  function closePayslipModal() {
                                    document.getElementById('payslipModal').style.display = 'none';
                                  }

                                  window.onclick = function (event) {
                                    var modal = document.getElementById('payslipModal');
                                    if (event.target === modal) {
                                      closePayslipModal();
                                    }
                                  };
                                </script>

                              </body>

                            </html>
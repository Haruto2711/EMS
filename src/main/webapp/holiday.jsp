<%@ page contentType="text/html;charset=UTF-8" %>

  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Ngày lễ – EMS</title>
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ems.css">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/css/holiday.css">
          <!-- Font Awesome for icons -->
          <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        </head>

        <body>

          <%@include file="/WEB-INF/jspf/sidebar.jsp" %>

            <div class="main-content">

              <!-- Topbar -->
              <div class="topbar">
                <div>
                  <div class="topbar-title">🗓 Quản lý ngày lễ</div>
                  <div class="topbar-breadcrumb">EMS &rsaquo; Quản lý &rsaquo; Ngày lễ</div>
                </div>
                <div class="topbar-right">Năm <strong>${year}</strong></div>
              </div>

              <!-- Page body -->
              <div class="page-body">

                <!-- Error alert -->
                <c:if test="${not empty errorMsg}">
                  <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    ${errorMsg}
                  </div>
                </c:if>

                <!-- Page header -->
                <div class="hol-page-header">
                  <div class="hol-page-header-text">
                    <h1><i class="fa-solid fa-calendar-day" style="color:var(--primary);font-size:1.2rem;"></i> Thiết
                      lập hệ số công ngày lễ</h1>
                    <p>Cấu hình các ngày nghỉ lễ và hệ số lương tương ứng cho năm <strong>${year}</strong></p>
                  </div>

                  <!-- Year navigator -->
                  <div class="year-nav">
                    <a class="year-nav-btn" href="${pageContext.request.contextPath}/holiday?year=${year - 1}"
                      title="Năm trước">
                      <i class="fa-solid fa-chevron-left"></i>
                    </a>
                    <div class="year-chip">
                      <i class="fa-regular fa-calendar"></i>
                      ${year}
                    </div>
                    <a class="year-nav-btn" href="${pageContext.request.contextPath}/holiday?year=${year + 1}"
                      title="Năm sau">
                      <i class="fa-solid fa-chevron-right"></i>
                    </a>
                  </div>
                </div>

                <!-- Holiday card -->
                <div class="holiday-card">

                  <!-- Card header -->
                  <div class="holiday-card-header">
                    <div class="holiday-card-header-left">
                      <div class="holiday-card-icon"><i class="fa-solid fa-umbrella-beach"></i></div>
                      <div>
                        <div class="holiday-card-title">Danh sách ngày nghỉ lễ</div>
                        <div class="holiday-card-subtitle">
                          <c:choose>
                            <c:when test="${not empty holidays}">${fn:length(holidays)} ngày lễ được thiết lập</c:when>
                            <c:otherwise>Chưa có ngày lễ nào</c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Holiday table -->
                  <table class="holiday-table">
                    <thead>
                      <tr>
                        <th>#</th>
                        <th>Tên ngày nghỉ</th>
                        <th>Thời gian</th>
                        <th>Đối tượng</th>
                        <th>Hệ số lương</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="h" items="${holidays}" varStatus="st">
                        <tr>
                          <!-- STT -->
                          <td class="stt-cell">${st.index + 1}</td>

                          <!-- Name -->
                          <td>
                            <span class="holiday-name">${h.holidayName}</span>
                            <c:if test="${h.recurType == 'FIXED_SOLAR'}">
                              <span class="hol-badge badge-passed" style="margin-left:6px;font-size:0.7rem;">
                                <i class="fa-solid fa-sun"></i> Dương lịch cố định
                              </span>
                            </c:if>
                            <c:if test="${h.recurType == 'LUNAR'}">
                              <span class="hol-badge badge-upcoming" style="margin-left:6px;font-size:0.7rem;">
                                <i class="fa-solid fa-moon"></i> Âm lịch
                              </span>
                            </c:if>
                          </td>

                          <!-- Date range -->
                          <td>
                            <c:choose>
                              <c:when test="${h.recurType == 'FIXED_SOLAR'}">
                                <span class="date-fixed">
                                  <i class="fa-regular fa-calendar"></i>
                                  ${h.startDate}
                                  <c:if test="${h.startDate != h.endDate}">
                                    &rarr; ${h.endDate}
                                  </c:if>
                                </span>
                              </c:when>
                              <c:otherwise>
                                <form method="post" action="${pageContext.request.contextPath}/holiday">
                                  <input type="hidden" name="action" value="saveDates">
                                  <input type="hidden" name="year" value="${year}">
                                  <input type="hidden" name="templateId" value="${h.templateId}">
                                  <div class="date-form">
                                    <input type="date" class="date-input-sm" name="startDate" value="${h.startDateIso}"
                                      required>
                                    <span style="color:var(--slate-400);font-size:0.8rem;">→</span>
                                    <input type="date" class="date-input-sm" name="endDate" value="${h.endDateIso}"
                                      required>
                                    <button type="submit" class="btn-save-sm">
                                      <i class="fa-solid fa-floppy-disk"></i> Lưu
                                    </button>
                                    <c:if test="${h.startDate == ''}">
                                      <span class="badge-missing">
                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                        Chưa có dữ liệu ${year}
                                      </span>
                                    </c:if>
                                  </div>
                                </form>
                              </c:otherwise>
                            </c:choose>
                          </td>

                          <!-- Target -->
                          <td>
                            <span class="hol-badge badge-ongoing">
                              <i class="fa-solid fa-users"></i> Toàn công ty
                            </span>
                          </td>

                          <!-- Coefficient -->
                          <td>
                            <form method="post" action="${pageContext.request.contextPath}/holiday">
                              <input type="hidden" name="action" value="saveCoefficient">
                              <input type="hidden" name="year" value="${year}">
                              <input type="hidden" name="templateId" value="${h.templateId}">
                              <div class="coef-form">
                                <input type="number" step="0.1" min="0" class="coef-input" name="coefficient"
                                  value="${h.coefficient}" ${h.coefficientLocked ? 'readonly' : '' }>
                                <label class="lock-label">
                                  <input type="checkbox" name="locked" ${h.coefficientLocked ? 'checked' : '' }
                                    onchange="this.form.submit()">
                                  Cố định
                                </label>
                                <button type="submit" class="btn-save-sm">
                                  <i class="fa-solid fa-floppy-disk"></i> Lưu
                                </button>
                              </div>
                            </form>
                          </td>
                        </tr>
                      </c:forEach>

                      <c:if test="${empty holidays}">
                        <tr>
                          <td colspan="5">
                            <div class="no-results">
                              <div class="no-results-icon"><i class="fa-regular fa-calendar-xmark"></i></div>
                              <h3>Chưa có ngày lễ nào</h3>
                              <p>Thêm ngày nghỉ lễ mới bằng biểu mẫu bên dưới.</p>
                            </div>
                          </td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>

                  <!-- Card footer -->
                  <div class="hol-card-footer">
                    <span>
                      Tổng cộng:
                      <strong>${not empty holidays ? fn:length(holidays) : 0}</strong> ngày lễ trong năm ${year}
                      </strong>
                    </span>
                    <span style="color:var(--slate-400);font-size:0.78rem;">
                      <i class="fa-solid fa-circle-info"></i>
                      Hệ số 1.0 = lương bình thường, hệ số cao hơn = phụ cấp ngày lễ
                    </span>
                  </div>

                </div><!-- /holiday-card -->

                <!-- Add new holiday panel -->
                <div class="add-panel">
                  <div class="add-panel-title">
                    <i class="fa-solid fa-plus-circle"></i>
                    Thêm ngày nghỉ lễ mới
                  </div>
                  <form method="post" action="${pageContext.request.contextPath}/holiday">
                    <input type="hidden" name="action" value="createTemplate">
                    <input type="hidden" name="year" value="${year}">
                    <div class="add-panel-form">
                      <input type="text" name="name" placeholder="Tên ngày nghỉ lễ" required>

                      <select name="recurType" id="recurTypeSelect" onchange="toggleFixedFields()">
                        <option value="FIXED_SOLAR">📅 Cố định theo dương lịch</option>
                        <option value="LUNAR">🌙 Theo âm lịch (nhập tay mỗi năm)</option>
                      </select>

                      <span id="fixedFields" class="fixed-field-label">
                        Tháng:
                        <input type="number" name="fixedMonth" min="1" max="12" placeholder="MM">
                        Ngày:
                        <input type="number" name="fixedDay" min="1" max="31" placeholder="DD">
                      </span>

                      <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-plus"></i> Thêm
                      </button>
                    </div>
                  </form>
                </div>

              </div><!-- /page-body -->

              <!-- Footer -->
              <footer>EMS &copy; 2025 &mdash; Employee Management System</footer>

            </div><!-- /main-content -->

            <script>
              function toggleFixedFields() {
                var type = document.getElementById('recurTypeSelect').value;
                document.getElementById('fixedFields').style.display =
                  (type === 'FIXED_SOLAR') ? 'inline-flex' : 'none';
              }
              toggleFixedFields();
            </script>

        </body>

        </html>
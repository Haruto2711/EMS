<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ngày Nghỉ Lễ | EMS</title>
  <meta name="description" content="Quản lý danh sách ngày nghỉ lễ theo quy định nhà nước">
  <link rel="stylesheet" href="ems.css"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ── Sidebar ── -->
<aside class="sidebar">
  <a href="home_manager.jsp" class="sidebar-brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </a>
  <nav class="nav-group">
    <div class="nav-section-label">Menu chính</div>
    <a href="home_manager.jsp" class="nav-link">Trang chủ</a>
    <div class="nav-section-label">Quản lý</div>
    <a href="work-schedule" class="nav-link">Lịch làm việc</a>
    <a href="holiday" class="nav-link active">Quản lý ngày nghỉ lễ</a>
    <a href="#" class="nav-link">Điểm danh phòng ban</a>
    <a href="base-salaries" class="nav-link">Quản lý lương</a>
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

<!-- ── Main content ── -->
<div class="main-content">
  <div class="topbar">
    <span class="topbar-left">Quản lý ngày nghỉ lễ</span>
    <span class="topbar-right" id="topbar-date"></span>
  </div>

  <div class="page-body">
    <!-- Page header -->
    <div class="hol-page-header">
      <div class="hol-page-header-text">
        <h1>
          <i class="fa-regular fa-calendar-heart" style="color:var(--primary);"></i>
          Danh sách ngày nghỉ lễ
        </h1>
        <p>Cập nhật ngày nghỉ lễ theo quy định nhà nước năm 2026.</p>
      </div>
      <button id="btnOpenModal" class="btn btn-primary" onclick="openModal()">
        <i class="fa-solid fa-plus"></i>
        Thêm ngày nghỉ
      </button>
    </div>

    <!-- Error alert -->
    <c:if test="${not empty errorMsg}">
      <div class="alert-error">
        <i class="fa-solid fa-circle-exclamation"></i>
        <span>${errorMsg}</span>
      </div>
    </c:if>

    <!-- ── Toolbar tìm kiếm / sắp xếp ── -->
    <form id="searchForm" method="get" action="${pageContext.request.contextPath}/holiday" class="hol-toolbar">
      <div class="hol-search-wrap">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input type="text"
               id="searchInput"
               name="search"
               class="hol-search-input"
               placeholder="Tìm kiếm theo tên ngày nghỉ..."
               value="${fn:escapeXml(keyword)}">
      </div>

      <select name="sort" id="sortSelect" class="hol-select" title="Sắp xếp theo tên">
        <option value="ASC"  <c:if test="${sort == 'ASC'}">selected</c:if>>
          <i class="fa-solid fa-arrow-up-a-z"></i> Tên A → Z
        </option>
        <option value="DESC" <c:if test="${sort == 'DESC'}">selected</c:if>>
          <i class="fa-solid fa-arrow-down-z-a"></i> Tên Z → A
        </option>
      </select>

      <select name="pageSize" id="pageSizeSelect" class="hol-select" title="Số hàng mỗi trang">
        <option value="5"  <c:if test="${pageSize == 5}">selected</c:if>>5 / trang</option>
        <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10 / trang</option>
        <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20 / trang</option>
      </select>

      <button type="submit" class="btn-search" id="btnSearch">
        <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
      </button>

      <a href="${pageContext.request.contextPath}/holiday" class="btn-reset" id="btnReset" title="Xoá bộ lọc">
        <i class="fa-solid fa-rotate-left"></i> Đặt lại
      </a>
    </form>

    <!-- ── Nội dung chính ── -->
    <c:choose>

      <%-- Chưa có ngày nghỉ nào trong hệ thống --%>
      <c:when test="${totalRecords == 0 && (empty keyword || keyword == '')}">
        <div class="empty-card">
          <div class="empty-icon">
            <i class="fa-regular fa-calendar-xmark"></i>
          </div>
          <h2>Chưa có ngày nghỉ lễ</h2>
          <p>Chưa có ngày nghỉ lễ nào được thêm vào hệ thống. Nhấn nút bên dưới để bắt đầu thêm.</p>
          <button class="btn btn-primary" onclick="openModal()">
            <i class="fa-solid fa-plus"></i>
            Thêm ngày nghỉ
          </button>
        </div>
      </c:when>

      <c:otherwise>
        <div class="holiday-card">
          <div style="overflow-x:auto;">
            <c:choose>

              <%-- Không tìm thấy kết quả tìm kiếm --%>
              <c:when test="${empty holidays}">
                <div class="no-results">
                  <div class="no-results-icon">
                    <i class="fa-regular fa-calendar-xmark"></i>
                  </div>
                  <h3>Không tìm thấy kết quả</h3>
                  <p>Không có ngày nghỉ nào phù hợp với từ khoá
                    "<strong>${fn:escapeXml(keyword)}</strong>".</p>
                  <a href="${pageContext.request.contextPath}/holiday" class="btn-reset" style="display:inline-flex;margin:0 auto;">
                    <i class="fa-solid fa-rotate-left"></i> Xoá bộ lọc
                  </a>
                </div>
              </c:when>

              <%-- Hiển thị bảng dữ liệu --%>
              <c:otherwise>
                <table class="holiday-table" id="holidayTable">
                  <thead>
                  <tr>
                    <th style="width:60px;">STT</th>
                    <th>
                      Tên Ngày Nghỉ
                      <c:choose>
                        <c:when test="${sort == 'ASC'}">
                          <i class="fa-solid fa-arrow-up-a-z" style="color:#6366f1;font-size:0.8rem;margin-left:4px;"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="fa-solid fa-arrow-down-z-a" style="color:#6366f1;font-size:0.8rem;margin-left:4px;"></i>
                        </c:otherwise>
                      </c:choose>
                    </th>
                    <th>Ngày</th>
                    <th class="center">Số Ngày</th>
                    <th class="center">Trạng Thái</th>
                    <th class="center">Thao tác</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="h" items="${holidays}" varStatus="loop">
                    <c:set var="rowNum" value="${(currentPage - 1) * pageSize + loop.index + 1}"/>
                    <tr data-start="${h.startdate}" data-end="${h.enddate}">
                      <td class="stt-cell"><fmt:formatNumber value="${rowNum}" pattern="00"/></td>
                      <td><span class="holiday-name">${fn:escapeXml(h.holidayname)}</span></td>
                      <td>
                        <c:set var="sd" value="${h.startdate}"/>
                        <c:set var="ed" value="${h.enddate}"/>
                        <c:set var="sdFmt" value="${fn:substring(sd,8,10)}/${fn:substring(sd,5,7)}/${fn:substring(sd,0,4)}"/>
                        <c:set var="edFmt" value="${fn:substring(ed,8,10)}/${fn:substring(ed,5,7)}/${fn:substring(ed,0,4)}"/>
                        <span class="date-range">
                          <i class="fa-regular fa-calendar"></i>
                          <c:choose>
                            <c:when test="${sd == ed}">${sdFmt}</c:when>
                            <c:otherwise>${fn:substring(sd,8,10)}/${fn:substring(sd,5,7)}&ndash;${edFmt}</c:otherwise>
                          </c:choose>
                        </span>
                      </td>
                      <td class="center">
                        <span class="days-badge">
                          <strong>${h.totalDays}</strong> ngày
                        </span>
                      </td>
                      <td class="center">
                        <span class="hol-badge status-badge">...</span>
                      </td>
                      <td class="center">
                        <button class="btn-action"
                                onclick="editHoliday('${h.id}','${fn:escapeXml(h.holidayname)}','${h.startdate}','${h.enddate}')"
                                title="Chỉnh sửa">
                          <i class="fa-solid fa-pen-to-square"></i>
                        </button>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Card footer: tổng kết -->
          <div class="hol-card-footer">
            <span>
              Tổng: <strong>${totalRecords}</strong> ngày nghỉ
              <c:if test="${not empty keyword && keyword != ''}">
                &nbsp;&mdash;&nbsp;
                <span class="hol-keyword-tag">
                  <i class="fa-solid fa-filter"></i> ${fn:escapeXml(keyword)}
                </span>
              </c:if>
            </span>
            <c:if test="${not empty holidays}">
              <span>
                Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
              </span>
            </c:if>
          </div>

          <!-- ── Phân trang ── -->
          <c:if test="${totalPages > 1}">
            <div class="hol-pagination">
              <div class="hol-page-info">
                Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong>
                &ndash;
                <strong>${(currentPage - 1) * pageSize + fn:length(holidays)}</strong>
                trong tổng số <strong>${totalRecords}</strong> kết quả
              </div>

              <div class="hol-page-btns">
                <%-- Trang đầu & Trước --%>
                <c:choose>
                  <c:when test="${currentPage <= 1}">
                    <span class="hol-page-btn disabled" title="Trang đầu"><i class="fa-solid fa-angles-left"></i></span>
                    <span class="hol-page-btn disabled" title="Trang trước"><i class="fa-solid fa-angle-left"></i></span>
                  </c:when>
                  <c:otherwise>
                    <a class="hol-page-btn" title="Trang đầu"
                       href="${pageContext.request.contextPath}/holiday?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=1">
                      <i class="fa-solid fa-angles-left"></i>
                    </a>
                    <a class="hol-page-btn" title="Trang trước"
                       href="${pageContext.request.contextPath}/holiday?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${currentPage - 1}">
                      <i class="fa-solid fa-angle-left"></i>
                    </a>
                  </c:otherwise>
                </c:choose>

                <%-- Số trang (hiển thị tối đa 5 trang quanh trang hiện tại) --%>
                <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}"/>
                <c:set var="endPage"   value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}"/>
                <c:forEach var="p" begin="${startPage}" end="${endPage}">
                  <c:choose>
                    <c:when test="${p == currentPage}">
                      <span class="hol-page-btn active">${p}</span>
                    </c:when>
                    <c:otherwise>
                      <a class="hol-page-btn"
                         href="${pageContext.request.contextPath}/holiday?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${p}">
                        ${p}
                      </a>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>

                <%-- Tiếp & Trang cuối --%>
                <c:choose>
                  <c:when test="${currentPage >= totalPages}">
                    <span class="hol-page-btn disabled" title="Trang tiếp"><i class="fa-solid fa-angle-right"></i></span>
                    <span class="hol-page-btn disabled" title="Trang cuối"><i class="fa-solid fa-angles-right"></i></span>
                  </c:when>
                  <c:otherwise>
                    <a class="hol-page-btn" title="Trang tiếp"
                       href="${pageContext.request.contextPath}/holiday?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${currentPage + 1}">
                      <i class="fa-solid fa-angle-right"></i>
                    </a>
                    <a class="hol-page-btn" title="Trang cuối"
                       href="${pageContext.request.contextPath}/holiday?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${totalPages}">
                      <i class="fa-solid fa-angles-right"></i>
                    </a>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </c:if>

        </div><%-- /holiday-card --%>
      </c:otherwise>
    </c:choose>
  </div>

  <footer>© 2026 Hệ thống Quản lý Nhân sự (EMS) · FPT University SWP391</footer>
</div>

<!-- ── Modal thêm/sửa ngày nghỉ ── -->
<div class="modal-overlay" id="holidayModal">
  <div class="modal holiday-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">

    <div class="modal-header">
      <div class="modal-header-left">
        <div class="modal-header-icon">
          <i class="fa-regular fa-calendar-plus" id="modalIcon"></i>
        </div>
        <div>
          <div class="modal-title" id="modalTitle">Thêm ngày nghỉ lễ</div>
          <div class="modal-subtitle" id="modalSubtitle">Điền thông tin ngày nghỉ lễ mới</div>
        </div>
      </div>
      <button class="modal-close" onclick="closeModal()" aria-label="Đóng">
        <i class="fa-solid fa-xmark"></i>
      </button>
    </div>

    <div class="modal-body modal-body-padded">
      <form id="holidayForm" action="${pageContext.request.contextPath}/holiday" method="post" novalidate>
        <!-- Action phân biệt Create / Update -->
        <input type="hidden" name="action" id="formAction" value="create">
        <!-- Field ẩn lưu trữ ID khi sửa -->
        <input type="hidden" name="id" id="holidayId" value="">

        <div class="form-group">
          <label class="form-label" for="fieldName">Tên ngày lễ</label>
          <input type="text" id="fieldName" name="name" class="form-control"
                 placeholder="Ví dụ: Tết Dương Lịch" required maxlength="200">
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label" for="fieldStartDate">Ngày bắt đầu</label>
            <input type="date" id="fieldStartDate" name="startDate" class="form-control" required>
          </div>
          <div class="form-group">
            <label class="form-label" for="fieldEndDate">Ngày kết thúc</label>
            <input type="date" id="fieldEndDate" name="endDate" class="form-control" required>
            <div class="form-hint" id="daysPreview"></div>
          </div>
        </div>
      </form>
    </div>

    <div class="modal-footer">
      <button type="button" class="btn btn-secondary" onclick="closeModal()">
        <i class="fa-solid fa-xmark"></i> Hủy bỏ
      </button>
      <button type="button" class="btn btn-success" onclick="submitHoliday()" id="btnSubmit">
        <i class="fa-solid fa-floppy-disk"></i> Lưu ngày nghỉ
      </button>
    </div>
  </div>
</div>

<!-- ── Toast ── -->
<div class="toast" id="toast">
  <i class="fa-solid fa-circle-check"></i>
  <span id="toastMsg">Thao tác thành công!</span>
</div>

<script>
  /* Topbar date */
  (function() {
    var now = new Date(), p = function(n){ return String(n).padStart(2,'0'); };
    document.getElementById('topbar-date').textContent =
            p(now.getDate())+'/'+p(now.getMonth()+1)+'/'+now.getFullYear();
  })();

  /* ── Tự động submit khi thay đổi sort hoặc pageSize ── */
  document.getElementById('sortSelect').addEventListener('change', function() {
    document.getElementById('searchForm').submit();
  });
  document.getElementById('pageSizeSelect').addEventListener('change', function() {
    document.getElementById('searchForm').submit();
  });

  /* ── Render trạng thái (Sắp / Đang / Đã diễn ra) ── */
  function parseLocalDate(str) {
    var parts = str.split('-');
    return new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
  }

  function renderStatuses() {
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    document.querySelectorAll('#holidayTable tbody tr[data-start]').forEach(function(row) {
      var start = parseLocalDate(row.getAttribute('data-start'));
      var end   = parseLocalDate(row.getAttribute('data-end'));
      end.setHours(23, 59, 59, 999);
      var badge = row.querySelector('.status-badge');
      if (!badge) return;
      if (today < start) {
        badge.className = 'hol-badge badge-upcoming status-badge';
        badge.innerHTML = '<i class="fa-regular fa-clock"></i> Sắp diễn ra';
      } else if (today > end) {
        badge.className = 'hol-badge badge-passed status-badge';
        badge.innerHTML = '<i class="fa-solid fa-check"></i> Đã diễn ra';
      } else {
        badge.className = 'hol-badge badge-ongoing status-badge';
        badge.innerHTML = '<i class="fa-solid fa-circle-dot"></i> Đang diễn ra';
      }
    });
  }

  /* ── Preview số ngày nghỉ ── */
  function updateDaysPreview() {
    var startVal = document.getElementById('fieldStartDate').value;
    var endVal   = document.getElementById('fieldEndDate').value;
    var hint     = document.getElementById('daysPreview');
    if (startVal && endVal) {
      var days = Math.round((new Date(endVal) - new Date(startVal)) / 86400000) + 1;
      if (days >= 1) {
        hint.textContent = '\u2192 ' + days + ' ngày nghỉ';
        hint.style.color = 'var(--success)';
      } else {
        hint.textContent = 'Ngày kết thúc phải từ ngày bắt đầu trở đi';
        hint.style.color = 'var(--danger)';
      }
    } else {
      hint.textContent = '';
    }
  }

  document.getElementById('fieldStartDate').addEventListener('change', function() {
    var endField = document.getElementById('fieldEndDate');
    endField.min = this.value;
    if (endField.value && endField.value < this.value) endField.value = this.value;
    updateDaysPreview();
  });
  document.getElementById('fieldEndDate').addEventListener('change', updateDaysPreview);

  /* ── Mở modal "Thêm mới" ── */
  function openModal() {
    document.getElementById('formAction').value = 'create';
    document.getElementById('holidayId').value = '';
    document.getElementById('fieldName').value = '';
    document.getElementById('fieldStartDate').value = '';
    document.getElementById('fieldEndDate').value = '';
    document.getElementById('daysPreview').textContent = '';

    document.getElementById('modalIcon').className = 'fa-regular fa-calendar-plus';
    document.getElementById('modalTitle').textContent = 'Thêm ngày nghỉ lễ';
    document.getElementById('modalSubtitle').textContent = 'Điền thông tin ngày nghỉ lễ mới';
    document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Lưu ngày nghỉ';

    document.getElementById('holidayModal').classList.add('open');
    document.body.style.overflow = 'hidden';
    setTimeout(function() { document.getElementById('fieldName').focus(); }, 100);
  }

  /* ── Mở modal "Chỉnh sửa" ── */
  function editHoliday(id, name, startDate, endDate) {
    document.getElementById('formAction').value = 'update';
    document.getElementById('holidayId').value = id;
    document.getElementById('fieldName').value = name;
    document.getElementById('fieldStartDate').value = startDate;
    document.getElementById('fieldEndDate').value = endDate;
    updateDaysPreview();

    document.getElementById('modalIcon').className = 'fa-solid fa-pen-to-square';
    document.getElementById('modalTitle').textContent = 'Chỉnh sửa ngày nghỉ lễ';
    document.getElementById('modalSubtitle').textContent = 'Cập nhật thông tin của ngày nghỉ lễ đã chọn';
    document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Cập nhật';

    document.getElementById('holidayModal').classList.add('open');
    document.body.style.overflow = 'hidden';
    setTimeout(function() { document.getElementById('fieldName').focus(); }, 100);
  }

  /* ── Đóng modal ── */
  function closeModal() {
    document.getElementById('holidayModal').classList.remove('open');
    document.body.style.overflow = '';
  }

  document.getElementById('holidayModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
  });

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeModal();
  });

  /* ── Submit form modal ── */
  function submitHoliday() {
    var name      = document.getElementById('fieldName').value.trim();
    var startDate = document.getElementById('fieldStartDate').value;
    var endDate   = document.getElementById('fieldEndDate').value;

    if (!name) {
      document.getElementById('fieldName').focus();
      document.getElementById('fieldName').style.borderColor = 'var(--danger)';
      return;
    }
    if (!startDate) {
      document.getElementById('fieldStartDate').focus();
      document.getElementById('fieldStartDate').style.borderColor = 'var(--danger)';
      return;
    }
    if (!endDate) {
      document.getElementById('fieldEndDate').focus();
      document.getElementById('fieldEndDate').style.borderColor = 'var(--danger)';
      return;
    }
    if (endDate < startDate) {
      document.getElementById('fieldEndDate').style.borderColor = 'var(--danger)';
      document.getElementById('daysPreview').textContent = 'Ngày kết thúc phải từ ngày bắt đầu trở đi';
      document.getElementById('daysPreview').style.color = 'var(--danger)';
      return;
    }
    document.getElementById('btnSubmit').disabled = true;
    document.getElementById('holidayForm').submit();
  }

  /* ── Toast thông báo ── */
  (function() {
    var params = new URLSearchParams(window.location.search);
    if (params.get('saved') === '1') {
      document.getElementById('toastMsg').textContent = 'Ngày nghỉ lễ đã được thêm thành công!';
      showToast();
      window.history.replaceState({}, '', window.location.pathname +
        (params.toString().replace(/saved=1&?/, '') ? '?' + params.toString().replace(/saved=1&?/, '') : ''));
    } else if (params.get('updated') === '1') {
      document.getElementById('toastMsg').textContent = 'Cập nhật ngày nghỉ lễ thành công!';
      showToast();
      window.history.replaceState({}, '', window.location.pathname +
        (params.toString().replace(/updated=1&?/, '') ? '?' + params.toString().replace(/updated=1&?/, '') : ''));
    }
  })();

  function showToast() {
    var t = document.getElementById('toast');
    t.classList.add('show');
    setTimeout(function() { t.classList.remove('show'); }, 3500);
  }

  renderStatuses();
</script>
</body>
</html>
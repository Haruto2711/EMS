<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo | EMS</title>
    <meta name="description" content="Danh sách thông báo của bạn">
    <link rel="stylesheet" href="css/ems.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/notification.css"/>
</head>
<body>

<%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

<div class="main-content">
    <div class="topbar">
        <span class="topbar-left">Thông báo</span>
        <span class="topbar-right" id="topbar-date"></span>
    </div>

    <div class="page-body">
        <!-- Page header -->
        <div class="noti-header">
            <h1>
                <i class="fa-regular fa-bell" style="color:var(--primary);"></i>
                Thông Báo
            </h1>
            <p>Xem lại toàn bộ thông báo hệ thống đã gửi đến bạn.</p>
        </div>

        <!-- Toolbar: search + sort + pageSize -->
        <div class="noti-filter-card">
            <form class="noti-filter-form" method="get"
                  action="${pageContext.request.contextPath}/notification">

                <div class="noti-search-wrapper">
                    <i class="fa-solid fa-magnifying-glass noti-search-icon"></i>
                    <input type="text" name="search" class="noti-input"
                           placeholder="Tìm theo tiêu đề thông báo..."
                           value="${fn:escapeXml(keyword)}">
                </div>

                <button type="submit" class="noti-btn-search">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>

                <c:if test="${not empty keyword}">
                    <a class="noti-btn-reset"
                       href="${pageContext.request.contextPath}/notification">
                        <i class="fa-solid fa-xmark"></i> Xoá lọc
                    </a>
                </c:if>

                <span class="noti-filter-label">Sắp xếp</span>
                <select name="sort" class="noti-select" onchange="this.form.submit()">
                    <option value="ASC" ${sort == 'ASC' ? 'selected' : ''}>Tiêu đề A → Z</option>
                    <option value="DESC" ${sort == 'DESC' ? 'selected' : ''}>Tiêu đề Z → A</option>
                </select>

                <!-- Giữ pageSize khi bấm tìm kiếm / đổi sort -->
                <input type="hidden" name="pageSize" value="${pageSize}">
            </form>
        </div>

        <!-- Danh sách thông báo -->
        <div class="noti-list-card">
            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="noti-empty">
                        <i class="fa-regular fa-bell-slash"></i>
                        <h3>Không có thông báo nào</h3>
                        <p>
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    Không tìm thấy thông báo nào khớp với "${fn:escapeXml(keyword)}".
                                </c:when>
                                <c:otherwise>
                                    Bạn chưa có thông báo nào.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${notifications}">
                        <div class="noti-row ${n.isread ? '' : 'is-unread'}">
                            <div class="noti-icon">
                                <i class="fa-regular fa-bell"></i>
                            </div>
                            <div class="noti-body">
                                <div class="noti-title-row">
                                    <c:if test="${!n.isread}">
                                        <span class="noti-unread-dot"></span>
                                    </c:if>
                                    <span class="noti-title-text">${fn:escapeXml(n.title)}</span>
                                </div>
                                <div class="noti-message-text">${fn:escapeXml(n.message)}</div>
                                <c:if test="${not empty n.createdat}">
                                    <div class="noti-time-text">
                                        <i class="fa-regular fa-clock"></i>
                                            ${fn:replace(fn:substring(n.createdat, 0, 16), 'T', ' ')}
                                    </div>
                                </c:if>
                            </div>
                            <span class="noti-status-badge ${n.isread ? 'status-read' : 'status-unread'}">
                                <c:choose>
                                    <c:when test="${n.isread}">Đã đọc</c:when>
                                    <c:otherwise>Chưa đọc</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <!-- Pagination -->
            <c:if test="${not empty notifications}">
                <div class="noti-pagination-bar">
                    <div class="noti-pagination-info">
                        <span>Tổng số: <strong>${totalRecords}</strong> thông báo</span>
                        <form method="get" action="${pageContext.request.contextPath}/notification">
                            <input type="hidden" name="search" value="${fn:escapeXml(keyword)}">
                            <input type="hidden" name="sort" value="${sort}">
                            <input type="hidden" name="page" value="1">
                            <select name="pageSize" class="noti-page-size-select" onchange="this.form.submit()">
                                <option value="5"  ${pageSize == 5  ? 'selected' : ''}>5 / trang</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 / trang</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 / trang</option>
                            </select>
                        </form>
                    </div>

                    <div class="noti-pagination-controls">
                        <!-- Prev -->
                        <c:choose>
                            <c:when test="${currentPage <= 1}">
                                <span class="noti-page-nav-btn disabled"><i class="fa-solid fa-chevron-left"></i></span>
                            </c:when>
                            <c:otherwise>
                                <a class="noti-page-nav-btn"
                                   href="${pageContext.request.contextPath}/notification?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${currentPage - 1}">
                                    <i class="fa-solid fa-chevron-left"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}">
                                    <span class="noti-page-btn active">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="noti-page-btn"
                                       href="${pageContext.request.contextPath}/notification?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${p}">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next -->
                        <c:choose>
                            <c:when test="${currentPage >= totalPages}">
                                <span class="noti-page-nav-btn disabled"><i class="fa-solid fa-chevron-right"></i></span>
                            </c:when>
                            <c:otherwise>
                                <a class="noti-page-nav-btn"
                                   href="${pageContext.request.contextPath}/notification?search=${fn:escapeXml(keyword)}&sort=${sort}&pageSize=${pageSize}&page=${currentPage + 1}">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>

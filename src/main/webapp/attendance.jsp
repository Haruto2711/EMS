<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>WorkSync - Xem trước dữ liệu chấm công</title>
    <%@ include file="/WEB-INF/jspf/head.jsp" %>
</head>
<body class="bg-[#F8FAFC] text-slate-700 min-h-screen flex flex-col justify-between relative">

<div>
    <%@ include file="/WEB-INF/jspf/header.jsp" %>

    <div class="flex min-h-[calc(100vh-105px)]">
        <%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

        <main class="flex-1 p-8 max-w-7xl">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-8 gap-4">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-slate-900 font-serif-heading">Xem trước dữ liệu chấm công</h1>
                    <p class="text-sm text-slate-500 mt-1">
                        Đã đọc <strong class="text-slate-700">${sessionScope.previewList.size()}</strong> dòng từ file Excel. Kiểm tra lại trước khi lưu.
                    </p>
                </div>
                <a href="upload.jsp" class="border border-slate-300 hover:bg-slate-50 text-slate-600 font-medium px-4 py-2.5 rounded-lg flex items-center space-x-2 text-sm transition self-start sm:self-auto">
                    <i data-lucide="rotate-ccw" class="w-4 h-4"></i>
                    <span>Upload lại</span>
                </a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="mb-6 flex items-start space-x-2.5 bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-xl">
                    <i data-lucide="alert-circle" class="w-4 h-4 mt-0.5 shrink-0"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="bg-[#F3F6FD] text-slate-600 text-xs uppercase tracking-wide">
                                <th class="px-5 py-3 text-left font-semibold">Ngày</th>
                                <th class="px-5 py-3 text-left font-semibold">Mã NV</th>
                                <th class="px-5 py-3 text-left font-semibold">Họ và Tên</th>
                                <th class="px-5 py-3 text-left font-semibold">Phòng ban</th>
                                <th class="px-5 py-3 text-left font-semibold">Check in</th>
                                <th class="px-5 py-3 text-left font-semibold">Check out</th>
                                <th class="px-5 py-3 text-left font-semibold">Đi muộn</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100">
                            <c:forEach var="r" items="${sessionScope.previewList}">
                                <tr class="hover:bg-slate-50 transition">
                                    <td class="px-5 py-3 text-slate-700">${r.date}</td>
                                    <td class="px-5 py-3 font-medium text-slate-800">${r.employeeCode}</td>
                                    <td class="px-5 py-3 text-slate-700">${r.fullName}</td>
                                    <td class="px-5 py-3 text-slate-500">${r.department}</td>
                                    <td class="px-5 py-3 text-slate-700">${r.checkIn}</td>
                                    <td class="px-5 py-3 text-slate-700">${r.checkOut}</td>
                                    <td class="px-5 py-3">
                                        <c:choose>
                                            <c:when test="${r.lateMinutes > 0}">
                                                <span class="inline-flex items-center space-x-1 bg-red-50 text-red-600 text-xs font-semibold px-2.5 py-1 rounded-full">
                                                    <i data-lucide="alarm-clock" class="w-3 h-3"></i>
                                                    <span>${r.lateMinutes} phút</span>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center space-x-1 bg-emerald-50 text-emerald-600 text-xs font-semibold px-2.5 py-1 rounded-full">
                                                    <i data-lucide="check" class="w-3 h-3"></i>
                                                    <span>Đúng giờ</span>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="flex items-center space-x-3 mt-6">
                <form action="confirm" method="post">
                    <button type="submit" class="bg-[#1E3A8A] hover:bg-[#182E6E] text-white font-medium px-5 py-2.5 rounded-lg flex items-center space-x-2 text-sm shadow transition">
                        <i data-lucide="check-circle-2" class="w-4 h-4"></i>
                        <span>Xác nhận lưu vào hệ thống</span>
                    </button>
                </form>
                <a href="upload.jsp" class="text-slate-500 hover:text-slate-700 text-sm font-medium px-3 py-2.5 transition">Hủy</a>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jsp" %>
</body>
</html>

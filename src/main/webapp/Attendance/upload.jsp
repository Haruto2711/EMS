<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>WorkSync - Chấm công nhân viên</title>
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
                    <h1 class="text-2xl md:text-3xl font-bold text-slate-900 font-serif-heading">Chấm công nhân viên</h1>
                    <p class="text-sm text-slate-500 mt-1">Upload file Excel để nhập và xem dữ liệu chấm công theo ngày.</p>
                </div>
                <label for="excelFile" class="bg-[#1E3A8A] hover:bg-[#182E6E] text-white font-medium px-4 py-2.5 rounded-lg flex items-center space-x-2 text-sm shadow-sm transition self-start sm:self-auto cursor-pointer">
                    <i data-lucide="upload" class="w-4 h-4"></i>
                    <span>Upload file Excel</span>
                </label>

                <a href="${pageContext.request.contextPath}/export-excel"
                           class="bg-emerald-600 hover:bg-emerald-700 text-white font-medium px-4 py-2.5 rounded-lg flex items-center space-x-2 text-sm shadow-sm transition">
                            <i data-lucide="download" class="w-4 h-4"></i>
                            <span>Export Excel</span>
                        </a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="mb-6 flex items-start space-x-2.5 bg-red-50 border border-red-200 text-red-700 text-sm px-4 py-3 rounded-xl">
                    <i data-lucide="alert-circle" class="w-4 h-4 mt-0.5 shrink-0"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <form id="uploadForm" action="upload" method="post" enctype="multipart/form-data">
                <input type="file" id="excelFile" name="excelFile" accept=".xlsx,.xls"
                       class="hidden" onchange="document.getElementById('uploadForm').submit();" />

                <label for="excelFile"
                       class="bg-[#F3F6FD]/60 border-2 border-dashed border-[#CDD8EE] rounded-2xl p-12 md:p-20 flex flex-col items-center justify-center text-center min-h-[440px] shadow-sm cursor-pointer hover:bg-[#EEF3FC] transition block">

                    <div class="w-20 h-20 rounded-full bg-[#E8EEF9] flex items-center justify-center mb-5 text-[#5E7BB1]">
                        <i data-lucide="upload" class="w-8 h-8"></i>
                    </div>

                    <h2 class="text-lg font-bold text-slate-800 mb-1">Chưa có dữ liệu chấm công</h2>
                    <p class="text-sm text-slate-500 mb-6">Nhấn để chọn file Excel (.xlsx) chấm công nhân viên</p>

                    <span class="bg-[#1E3A8A] hover:bg-[#182E6E] text-white font-medium px-5 py-2.5 rounded-lg inline-flex items-center space-x-2 text-sm shadow transition">
                        <i data-lucide="upload" class="w-4 h-4"></i>
                        <span>Chọn file Excel</span>
                    </span>

                    <p class="text-xs text-slate-400 mt-6">Cột yêu cầu: Ngày | Mã nhân viên | Họ và Tên | Phòng ban | Check in | Check out</p>
                </label>
            </form>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jsp" %>
</body>
</html>

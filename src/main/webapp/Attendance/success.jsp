<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>WorkSync - Lưu thành công</title>
    <%@ include file="/WEB-INF/jspf/head.jsp" %>
</head>
<body class="bg-[#F8FAFC] text-slate-700 min-h-screen flex flex-col justify-between relative">

<div>
    <%@ include file="/WEB-INF/jspf/header.jsp" %>

    <div class="flex min-h-[calc(100vh-105px)]">
        <%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

        <main class="flex-1 p-8 max-w-7xl">
            <div class="mb-8">
                <h1 class="text-2xl md:text-3xl font-bold text-slate-900 font-serif-heading">Chấm công nhân viên</h1>
                <p class="text-sm text-slate-500 mt-1">Kết quả xử lý dữ liệu vừa upload.</p>
            </div>

            <div class="bg-[#F3F6FD]/60 border-2 border-dashed border-[#CDD8EE] rounded-2xl p-12 md:p-20 flex flex-col items-center justify-center text-center min-h-[440px] shadow-sm">

                <div class="w-20 h-20 rounded-full bg-emerald-100 flex items-center justify-center mb-5 text-emerald-600">
                    <i data-lucide="check-circle-2" class="w-8 h-8"></i>
                </div>

                <h2 class="text-lg font-bold text-slate-800 mb-1">Lưu dữ liệu thành công</h2>
                <p class="text-sm text-slate-500 mb-6">
                    Đã lưu <strong class="text-slate-700">${requestScope.savedCount}</strong> bản ghi chấm công vào hệ thống.
                </p>

                <a href="upload.jsp" class="bg-[#1E3A8A] hover:bg-[#182E6E] text-white font-medium px-5 py-2.5 rounded-lg flex items-center space-x-2 text-sm shadow transition">
                    <i data-lucide="upload" class="w-4 h-4"></i>
                    <span>Upload file khác</span>
                </a>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jsp" %>
</body>
</html>

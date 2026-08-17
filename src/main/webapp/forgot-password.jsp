<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Quên mật khẩu</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="css/login.css"/>
</head>
<body>
<div class="card">
  <div class="brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </div>
  <div class="form-title">Quên mật khẩu</div>
  <div class="form-sub">Nhập thông tin tài khoản để đặt lại mật khẩu</div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%= request.getAttribute("error") %></div>
  <% } %>

  <form action="forgot-password" method="post">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required autocomplete="username"/>
    

    <label for="password">Mật khẩu mới</label>
    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu mới" required autocomplete="new-password"/>
    
    <label for="confirmPassword">Xác nhận mật khẩu mới</label>
    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required autocomplete="new-password"/>
    
    <button type="submit">Đặt lại mật khẩu</button>
  </form>

  <a href="login" class="back-link">Quay lại Đăng nhập</a>

  <hr/>
  <div class="footer-note">Hệ thống Quản lý Nhân sự · FPT University SWP391</div>
</div>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Đăng nhập</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="css/login.css"/>
</head>
<body>
<div class="card">
  <div class="brand">
    <div class="brand-dot">E</div>
    <span class="brand-name">EMS</span>
  </div>
  <div class="form-title">Đăng nhập</div>
  <div class="form-sub">Nhập thông tin tài khoản để tiếp tục</div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%= request.getAttribute("error") %></div>
  <% } %>
  <% if (request.getAttribute("success") != null) { %>
    <div class="success" style="background: #ecfdf5; border: 1px solid #a7f3d0; color: #047857; font-size: 13px; padding: 10px 13px; border-radius: 7px; margin-bottom: 16px;"><%= request.getAttribute("success") %></div>
  <% } %>

  <form action="login" method="post">
    <label for="username">Tên đăng nhập</label>
    <input type="text" id="username" name="username" placeholder="Nhập tên đăng nhập" required autocomplete="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"/>
    <label for="password">Mật khẩu</label>
    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required autocomplete="current-password"/>
    <a href="forgot-password" style="display: block; text-align: right; font-size: 13px; color: #2563eb; text-decoration: none; margin-top: -8px; margin-bottom: 16px;">Quên mật khẩu?</a>
    <button type="submit">Đăng nhập</button>
  </form>

  <hr/>
  <div class="footer-note">Hệ thống Quản lý Nhân sự · FPT University SWP391</div>
</div>
</body>
</html>

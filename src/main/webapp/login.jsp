<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMS – Đăng nhập</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', sans-serif;
      background: #f4f6f8;
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
    }
    .card {
      background: #fff;
      width: 400px;
      padding: 40px 36px 36px;
      border-radius: 12px;
      border: 1px solid #e5e7eb;
      box-shadow: 0 4px 16px rgba(0,0,0,0.07);
    }
    .brand {
      display: flex; align-items: center; gap: 10px; margin-bottom: 28px;
    }
    .brand-dot {
      width: 32px; height: 32px; background: #2563eb; border-radius: 8px;
      display: flex; align-items: center; justify-content: center;
      font-size: 14px; font-weight: 800; color: #fff;
    }
    .brand-name { font-size: 18px; font-weight: 700; color: #111; }
    .form-title { font-size: 20px; font-weight: 700; color: #111; margin-bottom: 4px; }
    .form-sub   { font-size: 13px; color: #6b7280; margin-bottom: 24px; }
    label {
      display: block; font-size: 13px; font-weight: 500;
      color: #374151; margin-bottom: 5px;
    }
    input {
      width: 100%; padding: 10px 13px;
      border: 1px solid #d1d5db; border-radius: 7px;
      font-size: 14px; color: #111; outline: none;
      font-family: 'Inter', sans-serif;
      transition: border-color 0.15s, box-shadow 0.15s;
      margin-bottom: 16px; background: #fff;
    }
    input:focus {
      border-color: #2563eb;
      box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
    }
    button[type="submit"] {
      width: 100%; padding: 11px;
      background: #2563eb; color: #fff;
      border: none; border-radius: 7px;
      font-size: 14px; font-weight: 600;
      cursor: pointer; font-family: 'Inter', sans-serif;
      transition: background 0.15s;
      margin-top: 4px;
    }
    button[type="submit"]:hover { background: #1d4ed8; }
    .error {
      background: #fef2f2; border: 1px solid #fecaca;
      color: #b91c1c; font-size: 13px;
      padding: 10px 13px; border-radius: 7px; margin-bottom: 16px;
    }
    .footer-note {
      font-size: 12px; color: #9ca3af;
      text-align: center; margin-top: 22px;
    }
    hr { border: none; border-top: 1px solid #f3f4f6; margin: 22px 0 0; }
  </style>
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

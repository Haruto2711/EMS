<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

```
<title>Submit Request | EMS</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
      rel="stylesheet">

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Plus Jakarta Sans', sans-serif;
        background: #f4f6fb;
        color: #1e293b;
        min-height: 100vh;
    }

    .navbar {
        background: white;
        border-bottom: 1px solid #e2e8f0;
        padding: 14px 32px;
    }

    .navbar-container {
        max-width: 1200px;
        margin: auto;

        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .brand {
        display: flex;
        align-items: center;
        gap: 12px;

        text-decoration: none;
        color: #0f172a;
    }

    .brand-icon {
        width: 40px;
        height: 40px;

        border-radius: 10px;

        display: flex;
        align-items: center;
        justify-content: center;

        color: white;

        background: linear-gradient(
            135deg,
            #4f46e5,
            #06b6d4
        );
    }

    .brand-title {
        font-size: 20px;
        font-weight: 800;
    }

    .brand-badge {
        background: #eeeffe;
        color: #4f46e5;

        font-size: 11px;
        font-weight: 700;

        padding: 4px 7px;
        border-radius: 6px;
    }

    .user-pill {
        display: flex;
        align-items: center;
        gap: 8px;

        background: #f1f5f9;

        padding: 6px 12px;

        border-radius: 30px;

        font-size: 14px;
        font-weight: 600;
    }

    .avatar {
        width: 28px;
        height: 28px;

        border-radius: 50%;

        display: flex;
        align-items: center;
        justify-content: center;

        color: white;
        background: #4f46e5;

        font-size: 12px;
    }

    .container {
        max-width: 900px;
        margin: 0 auto;
        padding: 40px 20px;
    }

    .page-header {
        margin-bottom: 25px;
    }

    .page-header h1 {
        font-size: 28px;
        font-weight: 800;
        color: #0f172a;

        display: flex;
        align-items: center;
        gap: 12px;
    }

    .page-header h1 i {
        color: #4f46e5;
    }

    .page-header p {
        margin-top: 6px;
        color: #64748b;
        font-size: 14px;
    }

    .card {
        background: white;

        border: 1px solid #e2e8f0;
        border-radius: 16px;

        padding: 30px;

        box-shadow:
            0 10px 25px -5px rgba(15, 23, 42, .05);
    }

    .section-title {
        font-size: 17px;
        font-weight: 700;

        margin-bottom: 20px;

        color: #0f172a;

        display: flex;
        align-items: center;
        gap: 8px;
    }

    .section-title i {
        color: #4f46e5;
    }

    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 7px;
    }

    .full {
        grid-column: 1 / -1;
    }

    label {
        font-size: 13px;
        font-weight: 700;
        color: #334155;
    }

    label span {
        color: #ef4444;
    }

    input,
    select,
    textarea {
        width: 100%;

        padding: 12px 14px;

        border: 1px solid #cbd5e1;
        border-radius: 10px;

        font-family: inherit;
        font-size: 14px;

        color: #1e293b;

        background: #f8fafc;

        transition: .2s;
    }

    input:focus,
    select:focus,
    textarea:focus {
        outline: none;

        border-color: #4f46e5;

        background: white;

        box-shadow:
            0 0 0 3px rgba(79, 70, 229, .1);
    }

    textarea {
        min-height: 130px;
        resize: vertical;
    }

    .employee-info {
        display: grid;

        grid-template-columns:
            repeat(3, 1fr);

        gap: 12px;

        margin-bottom: 30px;
    }

    .info-box {
        padding: 14px;

        border-radius: 10px;

        background: #f8fafc;

        border: 1px solid #e2e8f0;
    }

    .info-label {
        color: #64748b;
        font-size: 12px;
        margin-bottom: 4px;
    }

    .info-value {
        color: #0f172a;
        font-weight: 700;
        font-size: 14px;
    }

    .notice {
        margin-top: 20px;

        padding: 14px 16px;

        border-radius: 10px;

        background: #eff6ff;

        border: 1px solid #bfdbfe;

        color: #1e40af;

        font-size: 13px;

        display: flex;
        gap: 10px;
    }

    .actions {
        margin-top: 30px;

        padding-top: 20px;

        border-top: 1px solid #e2e8f0;

        display: flex;
        justify-content: flex-end;

        gap: 10px;
    }

    .btn {
        padding: 11px 20px;

        border-radius: 10px;

        border: none;

        font-family: inherit;

        font-size: 14px;
        font-weight: 700;

        cursor: pointer;

        text-decoration: none;

        display: inline-flex;

        align-items: center;

        gap: 8px;
    }

    .btn-primary {
        color: white;
        background: #4f46e5;
    }

    .btn-primary:hover {
        background: #4338ca;
    }

    .btn-secondary {
        background: white;
        color: #475569;

        border: 1px solid #cbd5e1;
    }

    @media(max-width: 700px) {

        .form-grid {
            grid-template-columns: 1fr;
        }

        .full {
            grid-column: auto;
        }

        .employee-info {
            grid-template-columns: 1fr;
        }

        .navbar {
            padding: 14px 15px;
        }

        .brand-badge {
            display: none;
        }

        .card {
            padding: 20px;
        }

    }

</style>
```

</head>

<body>

<nav class="navbar">

```
<div class="navbar-container">

    <a href="#" class="brand">

        <div class="brand-icon">
            <i class="fa-solid fa-users"></i>
        </div>

        <span class="brand-title">
            EMS System
        </span>

        <span class="brand-badge">
            Employee Portal
        </span>

    </a>

    <div class="user-pill">

        <div class="avatar">
            NV
        </div>

        Nguyễn Văn Nam

    </div>

</div>
```

</nav>

<main class="container">

```
<div class="page-header">

    <h1>
        <i class="fa-solid fa-file-circle-plus"></i>

        Gửi đơn từ
    </h1>

    <p>
        Tạo và gửi yêu cầu đến quản lý để được phê duyệt
    </p>

</div>


<div class="card">

    <div class="section-title">

        <i class="fa-solid fa-user"></i>

        Thông tin nhân viên

    </div>


    <div class="employee-info">

        <div class="info-box">

            <div class="info-label">
                Mã nhân viên
            </div>

            <div class="info-value">
                EMP001
            </div>

        </div>


        <div class="info-box">

            <div class="info-label">
                Họ và tên
            </div>

            <div class="info-value">
                Nguyễn Văn Nam
            </div>

        </div>


        <div class="info-box">

            <div class="info-label">
                Phòng ban
            </div>

            <div class="info-value">
                IT Department
            </div>

        </div>

    </div>


    <div class="section-title">

        <i class="fa-solid fa-file-pen"></i>

        Thông tin đơn

    </div>


    <form action="request-submit" method="post">

        <div class="form-grid">


            <div class="form-group">

                <label>
                    Loại đơn <span>*</span>
                </label>

                <select name="requestTypeId" required>

                    <option value="">
                        -- Chọn loại đơn --
                    </option>

                    <option value="1">
                        Nghỉ phép
                    </option>

                    <option value="2">
                        Nghỉ ốm
                    </option>

                    <option value="3">
                        Làm việc từ xa
                    </option>

                    <option value="4">
                        Đi công tác
                    </option>

                    <option value="5">
                        Tăng ca
                    </option>

                </select>

            </div>


            <div class="form-group">

                <label>
                    Tiêu đề <span>*</span>
                </label>

                <input
                    type="text"
                    name="title"
                    placeholder="Nhập tiêu đề đơn"
                    maxlength="100"
                    required>

            </div>


            <div class="form-group">

                <label>
                    Từ ngày <span>*</span>
                </label>

                <input
                    type="datetime-local"
                    name="startDate"
                    required>

            </div>


            <div class="form-group">

                <label>
                    Đến ngày <span>*</span>
                </label>

                <input
                    type="datetime-local"
                    name="endDate"
                    required>

            </div>


            <div class="form-group">

                <label>
                    Giá trị / Số ngày
                </label>

                <input
                    type="number"
                    name="value"
                    step="0.5"
                    min="0"
                    placeholder="Ví dụ: 1.0">

            </div>


            <div class="form-group">

                <label>
                    Người phê duyệt
                </label>

                <input
                    type="text"
                    value="Manager - Trần Minh Long"
                    readonly>

            </div>


            <div class="form-group full">

                <label>
                    Lý do / Nội dung
                </label>

                <textarea
                    name="reason"
                    maxlength="255"
                    placeholder="Nhập lý do hoặc nội dung chi tiết của đơn..."></textarea>

            </div>

        </div>


        <div class="notice">

            <i class="fa-solid fa-circle-info"></i>

            <span>
                Sau khi gửi, đơn sẽ ở trạng thái
                <strong>Pending</strong>
                và được chuyển đến quản lý để phê duyệt.
            </span>

        </div>


        <div class="actions">

            <a
                href="requests"
                class="btn btn-secondary">

                <i class="fa-solid fa-arrow-left"></i>

                Quay lại

            </a>


            <button
                type="reset"
                class="btn btn-secondary">

                <i class="fa-solid fa-rotate-left"></i>

                Nhập lại

            </button>


            <button
                type="submit"
                class="btn btn-primary">

                <i class="fa-solid fa-paper-plane"></i>

                Gửi đơn

            </button>

        </div>

    </form>

</div>
```

</main>

</body>

</html>

<%--
  Created by IntelliJ IDEA.
  User: ADMIN
  Date: 11/22/2026
  Time: 3:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản Lý Bán Giày</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 1rem;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            padding: 2.25rem;
        }
        .brand-logo {
            max-height: 84px;
            width: auto;
            object-fit: contain;
            display: block;
            margin: 0 auto 0.75rem;
        }
        .btn-login {
            background-color: #2563eb;
            border: none;
            padding: 0.75rem;
            font-weight: 600;
        }
        .btn-login:hover {
            background-color: #1d4ed8;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="text-center mb-4">
        <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9" class="brand-logo">
        <h4 class="fw-bold text-dark mb-1">QUẢN LÝ BÁN GIÀY</h4>
        <p class="text-muted small mb-0">Đăng nhập hệ thống</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2 small" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
        </div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="alert alert-success py-2 small" role="alert">
            <i class="bi bi-check-circle-fill me-1"></i> ${message}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label fw-semibold small">Tên đăng nhập</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                <input type="text" class="form-control" id="username" name="username"
                       value="${param.username}" placeholder="Nhập tên đăng nhập..." required autofocus>
            </div>
        </div>

        <div class="mb-4">
            <label for="password" class="form-label fw-semibold small">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Nhập mật khẩu..." required>
                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                    <i class="bi bi-eye" id="eyeIcon"></i>
                </button>
            </div>
        </div>

        <button type="submit" class="btn btn-primary btn-login w-100 rounded-3">
            Đăng nhập
        </button>
    </form>
</div>

<script>
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');
    const eyeIcon = document.querySelector('#eyeIcon');

    togglePassword.addEventListener('click', function () {
        const isPass = password.getAttribute('type') === 'password';
        password.setAttribute('type', isPass ? 'text' : 'password');
        eyeIcon.classList.toggle('bi-eye');
        eyeIcon.classList.toggle('bi-eye-slash');
    });
</script>

</body>
</html>

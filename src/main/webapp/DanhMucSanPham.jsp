<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để gõ tiếng Việt không bị lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL chuẩn Jakarta EE --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi để phân quyền --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục Sản Phẩm - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; } /* Tính gọn viền và padding vào kích thước thẻ */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6; /* Màu nền xám xanh nhạt */
            color: #132232;
            display: flex; /* Chia 2 cột: menu trái và nội dung phải */
            min-height: 100vh;
        }

        /* Sidebar menu dọc bên trái */
        .sidebar {
            width: 245px;
            background-color: #132232; /* Màu xanh đen đậm đồng bộ hệ thống */
            color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }
        .sidebar-brand {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
        }
        .logo-box {
            background-color: #ffffff; /* Nền trắng để logo AH9 nổi rõ */
            border-radius: 12px;
            padding: 8px 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .logo-box img {
            height: 54px;
            width: auto;
            display: block;
            object-fit: contain;
        }
        .sidebar-brand .logo-text {
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 1px;
        }
        .sidebar-brand .sub-text {
            font-size: 12px;
            color: #9fb3c8;
            margin-top: 3px;
        }
        .menu-list {
            list-style: none;
            padding: 12px 0;
            margin: 0;
            flex: 1;
        }
        .menu-list a,
        .menu-dropdown-btn {
            width: 100%;
            background: transparent;
            border: none;
            text-align: left;
            font-family: inherit;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 22px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border-left: 3px solid transparent;
            transition: 0.2s;
        }
        .menu-list a:hover,
        .menu-list a.active,
        .menu-dropdown-btn:hover,
        .menu-dropdown-btn.open {
            background-color: rgba(37, 99, 235, 0.22);
            color: #ffffff;
            border-left-color: #2563eb;
        }
        .menu-arrow {
            font-size: 11px;
            transition: transform 0.25s ease;
        }
        .menu-dropdown-btn.open .menu-arrow {
            transform: rotate(180deg);
        }
        .submenu-list {
            list-style: none;
            margin: 0;
            padding: 0;
            max-height: 0;
            overflow: hidden;
            background-color: rgba(0, 0, 0, 0.18);
            transition: max-height 0.3s ease;
        }
        .submenu-list.open {
            max-height: 260px;
        }
        .submenu-list a {
            padding: 10px 22px 10px 36px;
            font-size: 13px;
            font-weight: 500;
            color: #cbd5e1;
        }
        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 13px;
            line-height: 1.5;
        }
        .sidebar-footer .role-badge {
            color: #9fb3c8;
            font-size: 12px;
        }
        .sidebar-footer .logout-link {
            display: inline-block;
            margin-top: 8px;
            color: #60a5fa;
            text-decoration: none;
            font-weight: bold;
        }

        /* Nội dung chính bên phải */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
        }
        .topbar {
            background-color: #ffffff;
            padding: 14px 28px;
            border-bottom: 1px solid #dce3ec;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .topbar h2 {
            margin: 0;
            font-size: 18px;
            color: #132232;
        }
        .container {
            max-width: 1200px;
            width: 100%;
            margin: 24px auto;
            padding: 0 24px;
        }

        /* Khung form thêm/sửa & tìm kiếm */
        .card-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            margin-bottom: 20px;
        }
        .card-box h3 {
            margin: 0 0 14px;
            font-size: 16px;
            color: #132232;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 6px;
            color: #334155;
        }
        .form-group input {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #132232;
        }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .toolbar input {
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            min-width: 240px;
        }
        .btn-primary {
            padding: 9px 16px;
            background-color: #2563eb; /* Nút xanh dương chủ đạo */
            color: #ffffff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary:hover {
            background-color: #1d4ed8;
        }
        .btn-secondary {
            padding: 9px 14px;
            background-color: #e2e8f0;
            color: #132232;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-action {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            margin-right: 4px;
            display: inline-block;
        }
        .btn-edit {
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        /* Bảng danh sách danh mục */
        .table-wrap {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        thead th {
            background-color: #132232; /* Header bảng cùng tông xanh đen với sidebar */
            color: #ffffff;
            font-weight: 600;
        }
        tbody tr:hover {
            background-color: #f8fafc;
        }
        .empty-row {
            text-align: center;
            color: #64748b;
            padding: 28px !important;
        }
    </style>
</head>
<body>

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" /> <%-- Lấy chức vụ từ session đổi sang chữ thường --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" /> <%-- Kiểm tra có phải Quản lý không --%>

<aside class="sidebar">
    <div>
        <div class="sidebar-brand">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9 Shoes"> <%-- Ảnh logo trong webapp/img/AH9.png --%>
            </div>
            <div class="logo-text">AH9 SHOES</div>
            <div class="sub-text">QUẢN LÝ BÁN GIÀY</div>
        </div>
        <ul class="menu-list">
            <c:choose>
                <c:when test="${isQuanLy}"> <%-- Menu đầy đủ cho Quản lý --%>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=thongke">Thống kê doanh thu</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Trang bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/NhanVien">Nhân viên</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                    <li>
                        <button type="button" class="menu-dropdown-btn open" id="thuocTinhToggle">
                            <span>Thuộc tính sản phẩm</span>
                            <span class="menu-arrow">▼</span>
                        </button>
                        <ul class="submenu-list open" id="thuocTinhSubmenu">
                            <li><a href="${pageContext.request.contextPath}/DanhMucSanPham" class="active">Danh mục</a></li>
                            <li><a href="${pageContext.request.contextPath}/MauSac">Màu sắc</a></li>
                            <li><a href="${pageContext.request.contextPath}/Size">Size</a></li>
                            <li><a href="${pageContext.request.contextPath}/NhaCungCap">Nhà cung cấp</a></li>
                            <li><a href="${pageContext.request.contextPath}/ChatLieu">Chất liệu</a></li>
                        </ul>
                    </li>
                </c:when>
                <c:otherwise> <%-- Menu rút gọn cho Nhân viên --%>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
    <div class="sidebar-footer">
        <c:choose>
            <c:when test="${not empty sessionScope.userLogin}">
                <div>Nhân viên: <strong>${sessionScope.userLogin.hoTen}</strong></div>
                <div class="role-badge">Chức vụ: ${sessionScope.userLogin.tenChucVu}</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/logout">Đăng xuất →</a>
            </c:when>
            <c:otherwise>
                <div>Chưa đăng nhập</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/login">Đăng nhập →</a>
            </c:otherwise>
        </c:choose>
    </div>
</aside>

<div class="main-wrapper">
    <div class="topbar">
        <h2>Quản Lý Danh Mục Sản Phẩm</h2>
        <div><strong>Tổng danh mục:</strong> ${not empty listDanhMuc ? listDanhMuc.size() : 0}</div> <%-- Đếm số danh mục đang hiển thị --%>
    </div>

    <div class="container">
        <%-- Form thêm / cập nhật danh mục --%>
        <div class="card-box">
            <h3>${not empty danhMucEdit ? 'Cập Nhật Danh Mục' : 'Thêm Danh Mục Mới'}</h3> <%-- Đổi tiêu đề theo chế độ thêm hoặc sửa --%>
            <form action="${pageContext.request.contextPath}/DanhMucSanPham" method="POST"> <%-- Gửi dữ liệu về DanhMucSanPhamServlet --%>
                <input type="hidden" name="action" value="${not empty danhMucEdit ? 'update' : 'add'}"> <%-- Phân biệt thêm mới hay cập nhật --%>
                <c:if test="${not empty danhMucEdit}">
                    <input type="hidden" name="maDanhMuc" value="${danhMucEdit.maDanhMuc}"> <%-- Giữ mã danh mục khi sửa --%>
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Tên danh mục</label>
                        <input type="text" name="tenDanhMuc" value="${danhMucEdit.tenDanhMuc}" placeholder="Nhập tên danh mục..." required> <%-- Ô nhập tên danh mục --%>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="moTa" value="${danhMucEdit.moTa}" placeholder="Nhập mô tả danh mục..."> <%-- Ô nhập mô tả --%>
                    </div>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty danhMucEdit ? 'Lưu cập nhật' : 'Thêm danh mục'}
                </button>
                <c:if test="${not empty danhMucEdit}">
                    <a href="${pageContext.request.contextPath}/DanhMucSanPham" class="btn-secondary">Hủy</a> <%-- Thoát chế độ sửa --%>
                </c:if>
            </form>
        </div>

        <%-- Khung tìm kiếm và bảng danh sách danh mục --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Danh Mục</h3>
                <form action="${pageContext.request.contextPath}/DanhMucSanPham" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên hoặc mô tả..."> <%-- Tìm kiếm danh mục --%>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Danh Mục</th>
                        <th>Tên Danh Mục</th>
                        <th>Mô Tả</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listDanhMuc}">
                            <c:forEach items="${listDanhMuc}" var="danhMuc"> <%-- Lặp qua danh sách danh mục truyền từ Servlet --%>
                                <tr>
                                    <td>${danhMuc.maDanhMuc}</td> <%-- Mã danh mục --%>
                                    <td>${danhMuc.tenDanhMuc}</td> <%-- Tên danh mục --%>
                                    <td>${danhMuc.moTa}</td> <%-- Mô tả danh mục --%>
                                    <td>
                                        <a class="btn-action btn-edit" href="${pageContext.request.contextPath}/DanhMucSanPham?action=edit&id=${danhMuc.maDanhMuc}">Sửa</a> <%-- Nút sửa --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="empty-row">Chưa có dữ liệu danh mục sản phẩm.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<%-- an --%>
<script>
    const thuocTinhToggle = document.getElementById("thuocTinhToggle");
    const thuocTinhSubmenu = document.getElementById("thuocTinhSubmenu");
    if (thuocTinhToggle && thuocTinhSubmenu) {
        thuocTinhToggle.addEventListener("click", function () {
            thuocTinhToggle.classList.toggle("open");
            thuocTinhSubmenu.classList.toggle("open");
        });
    }
</script>
</body>
</html>
<%-- An --%>
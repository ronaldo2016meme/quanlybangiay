<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để gõ tiếng Việt không bị lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL chuẩn Jakarta EE --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi để phân quyền --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Mã Giảm Giá - AH9 Shoes</title>
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
        .menu-list a {
            display: block;
            padding: 12px 22px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border-left: 3px solid transparent;
            transition: 0.2s;
        }
        .menu-list a:hover,
        .menu-list a.active {
            background-color: rgba(37, 99, 235, 0.22);
            color: #ffffff;
            border-left-color: #2563eb;
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
            max-width: 1240px;
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
            display: grid; /* Chia lưới các ô nhập thông tin mã giảm giá */
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
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
        .form-group input, .form-group select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #132232;
            background: #ffffff;
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
            display: inline-block;
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        /* Bảng danh sách mã giảm giá */
        .table-wrap {
            overflow-x: auto; /* Cho phép cuộn ngang bảng nếu màn hình nhỏ vì có nhiều cột */
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        th, td {
            padding: 11px 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
            white-space: nowrap; /* Giữ từng cột gọn gàng không bị bẻ chữ lung tung */
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
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia" class="active">Mã giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/DanhMucSanPham">Danh mục</a></li>
                </c:when>
                <c:otherwise> <%-- Menu dành cho Nhân viên --%>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia" class="active">Mã giảm giá</a></li>
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
        <h2>Quản Lý Mã Giảm Giá</h2>
        <div><strong>Tổng mã giảm giá:</strong> ${not empty ListMaGiamGia ? ListMaGiamGia.size() : 0}</div> <%-- Đếm số mã giảm giá hiện có --%>
    </div>

    <div class="container">
        <%-- Form thêm / cập nhật mã giảm giá --%>
        <div class="card-box">
            <h3>${not empty maGiamGiaEdit ? 'Cập Nhật Mã Giảm Giá' : 'Thêm Mã Giảm Giá Mới'}</h3> <%-- Tự đổi tiêu đề khi đang sửa --%>
            <form action="${pageContext.request.contextPath}/MaGiamGia" method="POST"> <%-- Gửi dữ liệu về MaGiamGiaServlet --%>
                <input type="hidden" name="action" value="${not empty maGiamGiaEdit ? 'update' : 'add'}"> <%-- Phân biệt thêm mới hay cập nhật --%>
                <c:if test="${not empty maGiamGiaEdit}">
                    <input type="hidden" name="maMGG" value="${maGiamGiaEdit.maMGG}"> <%-- Giữ mã MGG khi cập nhật --%>
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Mã code</label>
                        <input type="text" name="maCode" value="${maGiamGiaEdit.maCode}" placeholder="VD: SALE10..." required> <%-- Nhập mã code --%>
                    </div>
                    <div class="form-group">
                        <label>Tên mã giảm giá</label>
                        <input type="text" name="tenMGG" value="${maGiamGiaEdit.tenMGG}" placeholder="VD: Giảm 10% khai trương..." required> <%-- Nhập tên mã --%>
                    </div>
                    <div class="form-group">
                        <label>Phần trăm giảm (%)</label>
                        <input type="number" name="phanTramGiam" value="${maGiamGiaEdit.phanTramGiam}" min="0" max="100" required> <%-- Nhập % giảm --%>
                    </div>
                    <div class="form-group">
                        <label>Ngày bắt đầu</label>
                        <input type="date" name="ngayBatDau" value="${maGiamGiaEdit.ngayBatDau}" required> <%-- Chọn ngày bắt đầu --%>
                    </div>
                    <div class="form-group">
                        <label>Ngày kết thúc</label>
                        <input type="date" name="ngayKetThuc" value="${maGiamGiaEdit.ngayKetThuc}" required> <%-- Chọn ngày kết thúc --%>
                    </div>
                    <div class="form-group">
                        <label>Số lượng</label>
                        <input type="number" name="soLuong" value="${maGiamGiaEdit.soLuong}" min="0" required> <%-- Tổng số lượng mã --%>
                    </div>
                    <div class="form-group">
                        <label>Số lượng tồn</label>
                        <input type="number" name="soLuongTon" value="${maGiamGiaEdit.soLuongTon}" min="0" required> <%-- Số lượng mã còn lại --%>
                    </div>
                    <div class="form-group">
                        <label>Trạng thái</label>
                        <select name="trangThai">
                            <option value="Đang áp dụng" ${maGiamGiaEdit.trangThai == 'Đang áp dụng' ? 'selected' : ''}>Đang áp dụng</option>
                            <option value="Ngừng áp dụng" ${maGiamGiaEdit.trangThai == 'Ngừng áp dụng' ? 'selected' : ''}>Ngừng áp dụng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Điều kiện</label>
                        <input type="text" name="dieuKien" value="${maGiamGiaEdit.dieuKien}" placeholder="VD: Đơn từ 500k..."> <%-- Điều kiện áp dụng --%>
                    </div>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty maGiamGiaEdit ? 'Lưu cập nhật' : 'Thêm mã giảm giá'}
                </button>
                <c:if test="${not empty maGiamGiaEdit}">
                    <a href="${pageContext.request.contextPath}/MaGiamGia" class="btn-secondary">Hủy</a> <%-- Thoát chế độ sửa --%>
                </c:if>
            </form>
        </div>

        <%-- Khung tìm kiếm và bảng danh sách mã giảm giá --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Mã Giảm Giá</h3>
                <form action="${pageContext.request.contextPath}/MaGiamGia" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm mã code hoặc tên..."> <%-- Ô tìm kiếm mã giảm giá --%>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã giảm giá</th>
                        <th>Mã code</th>
                        <th>Tên mã giảm giá</th>
                        <th>Phần trăm giảm</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Số lượng</th>
                        <th>Số lượng tồn</th>
                        <th>Trạng thái</th>
                        <th>Điều kiện</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty ListMaGiamGia}">
                            <c:forEach items="${ListMaGiamGia}" var="maGiamGia"> <%-- Lặp qua danh sách mã giảm giá truyền từ Servlet --%>
                                <tr>
                                    <td>${maGiamGia.maMGG}</td> <%-- Mã giảm giá --%>
                                    <td>${maGiamGia.maCode}</td> <%-- Mã code --%>
                                    <td>${maGiamGia.tenMGG}</td> <%-- Tên mã giảm giá --%>
                                    <td>${maGiamGia.phanTramGiam}%</td> <%-- Phần trăm giảm --%>
                                    <td>${maGiamGia.ngayBatDau}</td> <%-- Ngày bắt đầu --%>
                                    <td>${maGiamGia.ngayKetThuc}</td> <%-- Ngày kết thúc --%>
                                    <td>${maGiamGia.soLuong}</td> <%-- Số lượng --%>
                                    <td>${maGiamGia.soLuongTon}</td> <%-- Số lượng tồn --%>
                                    <td>${maGiamGia.trangThai}</td> <%-- Trạng thái --%>
                                    <td>${maGiamGia.dieuKien}</td> <%-- Điều kiện --%>
                                    <td>
                                        <a class="btn-action" href="${pageContext.request.contextPath}/MaGiamGia?action=edit&id=${maGiamGia.maMGG}">Sửa</a> <%-- Nút sửa mã giảm giá --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="11" class="empty-row">Chưa có dữ liệu mã giảm giá.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>
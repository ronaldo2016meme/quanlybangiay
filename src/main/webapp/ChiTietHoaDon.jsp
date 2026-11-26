<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Hóa Đơn - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6;
            color: #132232;
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 245px;
            background-color: #132232;
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
            background-color: #ffffff;
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
            gap: 12px;
            flex-wrap: wrap;
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
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
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
            background-color: #ffffff;
        }
        .btn-primary {
            padding: 9px 16px;
            background-color: #2563eb;
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
            white-space: nowrap;
        }
        .btn-edit {
            background-color: #dbeafe;
            color: #1d4ed8;
        }
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
            background-color: #132232;
            color: #ffffff;
            font-weight: 600;
            white-space: nowrap;
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

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" />
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" />

<aside class="sidebar">
    <div>
        <div class="sidebar-brand">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9 Shoes">
            </div>
            <div class="logo-text">AH9 SHOES</div>
            <div class="sub-text">QUẢN LÝ BÁN GIÀY</div>
        </div>
        <ul class="menu-list">
            <c:choose>
                <c:when test="${isQuanLy}">
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=thongke">Thống kê doanh thu</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Trang bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon" class="active">Bán hàng / Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/NhanVien">Nhân viên</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/DanhMuc">Danh mục</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon" class="active">Hóa đơn</a></li>
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
        <h2>
            Chi Tiết Hóa Đơn
            <c:if test="${not empty maHDFilter}"> - Hóa đơn #${maHDFilter}</c:if>
        </h2>
        <div style="display:flex; align-items:center; gap:14px;">
            <div><strong>Tổng dòng chi tiết:</strong> ${not empty listChiTietHoaDon ? listChiTietHoaDon.size() : 0}</div>
            <a href="${pageContext.request.contextPath}/HoaDon" class="btn-secondary">← Quay lại hóa đơn</a>
        </div>
    </div>

    <div class="container">
        <c:if test="${not empty cthdEdit}">
            <div class="card-box">
                <h3>Cập Nhật Chi Tiết Hóa Đơn #${cthdEdit.maCTHD}</h3>
                <form action="${pageContext.request.contextPath}/ChiTietHoaDon" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maCTHD" value="${cthdEdit.maCTHD}">

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Mã hóa đơn</label>
                            <input type="number" name="maHD"
                                   value="${cthdEdit.hoaDon.maHD}"
                                   readonly required>
                        </div>
                        <div class="form-group">
                            <label>Mã sản phẩm chi tiết</label>
                            <input type="number" name="maSPCT"
                                   value="${cthdEdit.sanPhamChiTiet.maSPCT}"
                                   placeholder="Nhập mã SPCT..." required>
                        </div>
                        <div class="form-group">
                            <label>Số lượng</label>
                            <input type="number" min="1" name="soLuong" id="soLuong"
                                   value="${cthdEdit.soLuong}"
                                   placeholder="1" oninput="tinhThanhTien()" required>
                        </div>
                        <div class="form-group">
                            <label>Đơn giá</label>
                            <input type="number" step="0.01" name="donGia" id="donGia"
                                   value="${cthdEdit.donGia}"
                                   placeholder="0" oninput="tinhThanhTien()" required>
                        </div>
                        <div class="form-group">
                            <label>Thành tiền</label>
                            <input type="number" step="0.01" name="thanhTien" id="thanhTien"
                                   value="${cthdEdit.thanhTien}"
                                   placeholder="Tự tính nếu để trống">
                        </div>
                    </div>

                    <button type="submit" class="btn-primary">Lưu cập nhật</button>
                    <a href="${pageContext.request.contextPath}/ChiTietHoaDon${not empty maHDFilter ? '?maHD='.concat(maHDFilter) : ''}" class="btn-secondary">Hủy</a>
                </form>
            </div>
        </c:if>

        <div class="card-box">
            <h3 style="margin: 0 0 14px;">
                Danh Sách Chi Tiết Hóa Đơn
                <c:if test="${not empty maHDFilter}"> (#${maHDFilter})</c:if>
            </h3>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Chi Tiết Hóa Đơn</th>
                        <th>Mã Hóa Đơn</th>
                        <th>Mã Sản Phẩm Chi tiết</th>
                        <th>Số Lượng</th>
                        <th>Đơn Giá</th>
                        <th>Thành Tiền</th>
                        <th>Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listChiTietHoaDon}">
                            <c:forEach items="${listChiTietHoaDon}" var="cthd">
                                <tr>
                                    <td>${cthd.maCTHD}</td>
                                    <td>${cthd.hoaDon.maHD}</td>
                                    <td>${cthd.sanPhamChiTiet.maSPCT}</td>
                                    <td>${cthd.soLuong}</td>
                                    <td>${cthd.donGia}</td>
                                    <td>${cthd.thanhTien}</td>
                                    <td>
                                        <a class="btn-action btn-edit" href="${pageContext.request.contextPath}/ChiTietHoaDon?action=edit&id=${cthd.maCTHD}&maHD=${maHDFilter}">Sửa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="empty-row">
                                    <c:choose>
                                        <c:when test="${empty maHDFilter}">
                                            Vui lòng chọn một hóa đơn ở trang Hóa Đơn để xem chi tiết.
                                        </c:when>
                                        <c:otherwise>
                                            Hóa đơn #${maHDFilter} chưa có dữ liệu chi tiết hóa đơn.
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function tinhThanhTien() {
        const sl = parseFloat(document.getElementById("soLuong").value) || 0;
        const dg = parseFloat(document.getElementById("donGia").value) || 0;
        const ttInput = document.getElementById("thanhTien");
        if (sl > 0 && dg > 0) {
            ttInput.value = (sl * dg).toFixed(2);
        }
    }
</script>

</body>
</html>
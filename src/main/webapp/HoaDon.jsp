<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hóa Đơn - AH9 Shoes</title>
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
        }
        .topbar h2 {
            margin: 0;
            font-size: 18px;
            color: #132232;
        }
        .container {
            max-width: 1320px;
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
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #132232;
            background-color: #ffffff;
        }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        .toolbar input,
        .toolbar select {
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            min-width: 190px;
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
        .btn-view {
            background-color: #e0f2fe;
            color: #0369a1;
        }
        .btn-edit {
            background-color: #dbeafe;
            color: #1d4ed8;
        }
        .badge-status {
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            display: inline-block;
            white-space: nowrap;
        }
        .badge-paid {
            background-color: #dcfce7;
            color: #166534;
        }
        .badge-pending {
            background-color: #fef3c7;
            color: #92400e;
        }
        .badge-cancel {
            background-color: #fee2e2;
            color: #991b1b;
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
            padding: 11px 12px;
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
        <h2>Quản Lý Hóa Đơn</h2>
        <div><strong>Tổng hóa đơn:</strong> ${not empty listHoaDon ? listHoaDon.size() : 0}</div>
    </div>

    <div class="container">
        <c:if test="${not empty hdEdit}">
            <div class="card-box">
                <h3>Cập Nhật Hóa Đơn #${hdEdit.maHD}</h3>
                <form action="${pageContext.request.contextPath}/HoaDon" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="maHD" value="${hdEdit.maHD}">

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Ngày lập</label>
                            <input type="date" name="ngayLap" value="${hdEdit.ngayLap}">
                        </div>
                        <div class="form-group">
                            <label>Họ tên</label>
                            <input type="text" name="hoTen" value="${hdEdit.hoTen}" placeholder="Nhập họ tên khách..." required>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="text" name="sdt" value="${hdEdit.sdt}" placeholder="Nhập số điện thoại...">
                        </div>
                        <div class="form-group">
                            <label>Phương thức thanh toán</label>
                            <select name="phuongThucThanhToan">
                                <option value="Tiền mặt" ${hdEdit.phuongThucThanhToan == 'Tiền mặt' ? 'selected' : ''}>Tiền mặt</option>
                                <option value="Chuyển khoản" ${hdEdit.phuongThucThanhToan == 'Chuyển khoản' ? 'selected' : ''}>Chuyển khoản</option>
                                <option value="Quẹt thẻ" ${hdEdit.phuongThucThanhToan == 'Quẹt thẻ' ? 'selected' : ''}>Quẹt thẻ</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Tổng tiền</label>
                            <input type="number" step="0.01" name="tongTien" value="${hdEdit.tongTien}" placeholder="0" required>
                        </div>
                        <div class="form-group">
                            <label>Tiền giảm</label>
                            <input type="number" step="0.01" name="tienGiam" value="${hdEdit.tienGiam}" placeholder="0">
                        </div>
                        <div class="form-group">
                            <label>Tiền thừa</label>
                            <input type="number" step="0.01" name="tienThua" value="${hdEdit.tienThua}" placeholder="0">
                        </div>
                        <div class="form-group">
                            <label>Mã nhân viên</label>
                            <input type="number" name="maNV" value="${hdEdit.nhanVien.maNV}" placeholder="Nhập mã NV...">
                        </div>
                        <div class="form-group">
                            <label>Mã khách hàng</label>
                            <input type="number" name="maKH" value="${hdEdit.khachHang.maKH}" placeholder="Nhập mã KH...">
                        </div>
                        <div class="form-group">
                            <label>Mã mã giảm giá</label>
                            <input type="number" name="maMGG" value="${hdEdit.maGiamGia.maMGG}" placeholder="Nhập mã MGG...">
                        </div>
                        <div class="form-group">
                            <label>Trạng thái hóa đơn</label>
                            <select name="trangThaiHoaDon">
                                <option value="Đã thanh toán" ${hdEdit.trangThaiHoaDon == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
                                <option value="Chờ thanh toán" ${hdEdit.trangThaiHoaDon == 'Chờ thanh toán' ? 'selected' : ''}>Chờ thanh toán</option>
                                <option value="Đã hủy" ${hdEdit.trangThaiHoaDon == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary">Lưu cập nhật</button>
                    <a href="${pageContext.request.contextPath}/HoaDon" class="btn-secondary">Hủy</a>
                </form>
            </div>
        </c:if>

        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Hóa Đơn</h3>
                <form action="${pageContext.request.contextPath}/HoaDon" method="GET" style="display:flex; gap:8px; flex-wrap:wrap; align-items:center;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm mã HD, họ tên, SĐT...">
                    <select name="trangThai">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="Đã thanh toán" ${param.trangThai == 'Đã thanh toán' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="Chờ thanh toán" ${param.trangThai == 'Chờ thanh toán' ? 'selected' : ''}>Chờ thanh toán</option>
                        <option value="Đã hủy" ${param.trangThai == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                    <c:if test="${not empty param.keyword or not empty param.trangThai}">
                        <a href="${pageContext.request.contextPath}/HoaDon" class="btn-secondary">Đặt lại</a>
                    </c:if>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Hóa Đơn</th>
                        <th>Ngày Lập</th>
                        <th>Họ Tên</th>
                        <th>Số Điện Thoại</th>
                        <th>Tổng Tiền</th>
                        <th>Tiền Giảm</th>
                        <th>Tiền Thừa</th>
                        <th>Phương Thức Thanh Toán</th>
                        <th>Mã Nhân Viên</th>
                        <th>Mã Khách Hàng</th>
                        <th>Mã Mã Giảm Giá</th>
                        <th>Trạng Thái Hóa Đơn</th>
                        <th>Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listHoaDon}">
                            <c:forEach items="${listHoaDon}" var="hd">
                                <tr>
                                    <td>${hd.maHD}</td>
                                    <td>${hd.ngayLap}</td>
                                    <td>${hd.hoTen}</td>
                                    <td>${hd.sdt}</td>
                                    <td>${hd.tongTien}</td>
                                    <td>${hd.tienGiam}</td>
                                    <td>${hd.tienThua}</td>
                                    <td>${hd.phuongThucThanhToan}</td>
                                    <td>${hd.nhanVien.maNV}</td>
                                    <td>${hd.khachHang.maKH}</td>
                                    <td>${hd.maGiamGia.maMGG}</td>
                                    <td>
                                        <span class="badge-status ${hd.trangThaiHoaDon == 'Đã thanh toán' ? 'badge-paid' : (hd.trangThaiHoaDon == 'Đã hủy' ? 'badge-cancel' : 'badge-pending')}">
                                                ${hd.trangThaiHoaDon}
                                        </span>
                                    </td>
                                    <td>
                                        <a class="btn-action btn-view" href="${pageContext.request.contextPath}/ChiTietHoaDon?maHD=${hd.maHD}">Chi tiết</a>
                                        <a class="btn-action btn-edit" href="${pageContext.request.contextPath}/HoaDon?action=edit&id=${hd.maHD}">Sửa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="13" class="empty-row">Chưa có dữ liệu hóa đơn.</td>
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
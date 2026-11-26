<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khách Hàng - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6;
            color: #132232;
            display: flex; /* Chia trang làm 2 cột: thanh menu trái và nội dung phải */
            min-height: 100vh; /* Cao hết màn hình */
        }

        /* Thanh menu dọc bên trái */
        .sidebar {
            width: 245px;
            background-color: #132232;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Đẩy thông tin người đăng nhập xuống cuối menu */
            flex-shrink: 0; /* Không cho menu bị bóp nhỏ lại */
        }
        .sidebar-brand {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1); /* Kẻ đường mờ dưới logo */
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
            list-style: none; /* Bỏ dấu chấm tròn mặc định của thẻ ul */
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
            text-decoration: none; /* Bỏ gạch chân link */
            font-size: 14px;
            font-weight: 600;
            border-left: 3px solid transparent; /* Viền trái ẩn để lúc hover không bị giật chữ */
            transition: 0.2s; /* Đổi màu mượt khi rê chuột */
        }
        .menu-list a:hover,
        .menu-list a.active,
        .menu-dropdown-btn:hover,
        .menu-dropdown-btn.open {
            background-color: rgba(37, 99, 235, 0.22); /* Tô nền xanh nhạt cho mục đang chọn */
            color: #ffffff;
            border-left-color: #2563eb; /* Hiện vạch xanh bên trái mục đang chọn */
        }
        .menu-arrow {
            font-size: 11px;
            transition: transform 0.25s ease;
        }
        .menu-dropdown-btn.open .menu-arrow {
            transform: rotate(180deg); /* Xoay mũi tên khi bấm mở */
        }

        /* Danh sách con dạng thanh trượt / vuốt lên xuống */
        .submenu-list {
            list-style: none;
            margin: 0;
            padding: 0;
            max-height: 0; /* Mặc định thu gọn */
            overflow-y: auto; /* Vuốt lên / xuống được khi mở danh sách con */
            background-color: rgba(0, 0, 0, 0.22);
            transition: max-height 0.3s ease; /* Hiệu ứng trượt mượt */
        }
        .submenu-list.open {
            max-height: 165px; /* Giới hạn chiều cao để có thanh vuốt lên/xuống gọn gàng */
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

        /* Phần nội dung bên phải */
        .main-wrapper {
            flex: 1; /* Chiếm phần diện tích còn lại bên phải */
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
            max-width: 1200px;
            width: 100%;
            margin: 24px auto; /* Căn giữa khung nội dung */
            padding: 0 24px;
        }

        /* Khung form và bảng */
        .card-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06); /* Đổ bóng nhẹ cho đẹp */
            margin-bottom: 20px;
        }
        .card-box h3 {
            margin: 0 0 14px;
            font-size: 16px;
            color: #132232;
        }
        .form-grid {
            display: grid; /* Chia lưới các ô nhập thông tin khách hàng */
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
            background-color: #2563eb; /* Nút màu xanh dương */
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
            background-color: #1d4ed8; /* Đậm màu hơn khi rê chuột */
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

        /* Bảng danh sách khách hàng */
        .table-wrap {
            overflow-x: auto; /* Cho cuộn ngang nếu màn hình hẹp */
        }
        table {
            width: 100%;
            border-collapse: collapse; /* Gộp viền bảng cho gọn */
            font-size: 14px;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        thead th {
            background-color: #132232; /* Phần đầu bảng màu xanh đen giống menu */
            color: #ffffff;
            font-weight: 600;
        }
        tbody tr:hover {
            background-color: #f8fafc; /* Đổi màu nhẹ khi di chuột qua từng dòng */
        }
        .empty-row {
            text-align: center;
            color: #64748b;
            padding: 28px !important;
        }
    </style>
</head>
<body>

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" /> <%-- Lấy chức vụ từ session đổi sang chữ thường để kiểm tra --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" /> <%-- Nếu là quản lý thì isQuanLy = true --%>

<aside class="sidebar"> <%-- Menu bên trái --%>
    <div>
        <div class="sidebar-brand">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9 Shoes"> <%-- Gọi ảnh logo AH9 --%>
            </div>
            <div class="logo-text">AH9 SHOES</div>
            <div class="sub-text">QUẢN LÝ BÁN GIÀY</div>
        </div>
        <ul class="menu-list">
            <c:choose> <%-- Kiểm tra quyền để hiện đúng danh sách menu --%>
                <c:when test="${isQuanLy}"> <%-- Nếu là Quản lý thì hiện đầy đủ các mục --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/index.jsp?view=thongke"
                           class="${activeView == 'thongke' ? 'active' : ''}">Thống kê doanh thu</a> <%-- Bấm vào để xem thống kê --%>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/BanHang"
                           class="${activeView == 'banhang' ? 'active' : ''}">Trang bán hàng</a> <%-- Bấm vào để xem danh sách giày bán --%>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li> <%-- Sang trang quản lý hóa đơn --%>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li> <%-- Sang trang quản lý khách hàng --%>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li> <%-- Sang trang quản lý sản phẩm --%>
                    <li><a href="${pageContext.request.contextPath}/NhanVien">Nhân viên</a></li> <%-- Sang trang quản lý nhân viên --%>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li> <%-- Sang trang quản lý mã giảm giá --%>
                    <li>
                        <button type="button" class="menu-dropdown-btn" id="thuocTinhToggle">
                            <span>Thuộc tính sản phẩm</span>
                            <span class="menu-arrow">▼</span>
                        </button>
                        <ul class="submenu-list" id="thuocTinhSubmenu">
                            <li><a href="${pageContext.request.contextPath}/DanhMucSanPham">Danh mục</a></li>
                            <li><a href="${pageContext.request.contextPath}/MauSac">Màu sắc</a></li>
                            <li><a href="${pageContext.request.contextPath}/Size">Size</a></li>
                            <li><a href="${pageContext.request.contextPath}/NhaCungCap">Nhà cung cấp</a></li>
                            <li><a href="${pageContext.request.contextPath}/ChatLieu">Chất liệu</a></li>
                        </ul>
                    </li>
                </c:when>

                <c:otherwise> <%-- Nếu là Nhân viên thì ẩn thống kê, nhân viên, danh mục; chỉ hiện các mục bán hàng --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/index.jsp?view=banhang"
                           class="${activeView == 'banhang' ? 'active' : ''}">Bán hàng</a>
                    </li>
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
            <c:when test="${not empty sessionScope.userLogin}"> <%-- Có người đăng nhập thì hiện tên + chức vụ + nút đăng xuất --%>
                <div>Nhân viên: <strong>${sessionScope.userLogin.hoTen}</strong></div>
                <div class="role-badge">Chức vụ: ${sessionScope.userLogin.tenChucVu}</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/logout">Đăng xuất →</a>
            </c:when>
            <c:otherwise> <%-- Chưa đăng nhập thì hiện link đăng nhập --%>
                <div>Chưa đăng nhập</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/login">Đăng nhập →</a>
            </c:otherwise>
        </c:choose>
    </div>
</aside>

<div class="main-wrapper">
    <div class="topbar">
        <h2>Quản Lý Khách Hàng</h2>
        <div><strong>Tổng khách hàng:</strong> ${not empty ListKhachHang ? ListKhachHang.size() : 0}</div> <%-- Đếm tổng số khách hàng --%>
    </div>

    <div class="container">
        <%-- Form thêm mới hoặc sửa khách hàng --%>
        <div class="card-box">
            <h3>${not empty khachHangEdit ? 'Cập Nhật Khách Hàng' : 'Thêm Khách Hàng Mới'}</h3> <%-- Có khách hàng cần sửa thì hiện "Cập Nhật", không thì hiện "Thêm" --%>
            <form action="${pageContext.request.contextPath}/KhachHang" method="POST"> <%-- Gửi dữ liệu dạng POST về KhachHangServlet --%>
                <input type="hidden" name="action" value="${not empty khachHangEdit ? 'update' : 'add'}"> <%-- Báo cho Servlet biết đang thêm hay sửa --%>
                <c:if test="${not empty khachHangEdit}">
                    <input type="hidden" name="maKH" value="${khachHangEdit.maKH}"> <%-- Giữ mã khách hàng khi bấm lưu sửa --%>
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ tên</label>
                        <input type="text" name="hoTen" value="${khachHangEdit.hoTen}" placeholder="Nhập họ tên khách hàng..." required> <%-- Ô nhập họ tên --%>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="sdt" value="${khachHangEdit.sdt}" placeholder="Nhập số điện thoại..." required> <%-- Ô nhập số điện thoại --%>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="diaChi" value="${khachHangEdit.diaChi}" placeholder="Nhập địa chỉ..."> <%-- Ô nhập địa chỉ --%>
                    </div>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty khachHangEdit ? 'Lưu cập nhật' : 'Thêm khách hàng'}
                </button>
                <c:if test="${not empty khachHangEdit}">
                    <a href="${pageContext.request.contextPath}/KhachHang" class="btn-secondary">Hủy</a> <%-- Bấm hủy để quay lại chế độ thêm mới --%>
                </c:if>
            </form>
        </div>

        <%-- Ô tìm kiếm và bảng khách hàng --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Khách Hàng</h3>
                <form action="${pageContext.request.contextPath}/KhachHang" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;"> <%-- Gửi từ khóa tìm kiếm bằng GET --%>
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên hoặc SĐT..."> <%-- Giữ lại từ khóa sau khi bấm tìm --%>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã khách hàng</th>
                        <th>Họ tên</th>
                        <th>Số điện thoại</th>
                        <th>Địa chỉ</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty ListKhachHang}"> <%-- Nếu có danh sách khách hàng thì lặp từng người ra bảng --%>
                            <c:forEach items="${ListKhachHang}" var="khachHang">
                                <tr>
                                    <td>${khachHang.maKH}</td> <%-- In mã khách hàng --%>
                                    <td>${khachHang.hoTen}</td> <%-- In họ tên --%>
                                    <td>${khachHang.sdt}</td> <%-- In số điện thoại --%>
                                    <td>${khachHang.diaChi}</td> <%-- In địa chỉ --%>
                                    <td>
                                        <a class="btn-action btn-edit" href="${pageContext.request.contextPath}/KhachHang?action=edit&id=${khachHang.maKH}">Sửa</a> <%-- Gửi id sang Servlet để đổ dữ liệu lên form sửa --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise> <%-- Nếu chưa có khách hàng nào thì hiện dòng thông báo --%>
                            <tr>
                                <td colspan="5" class="empty-row">Chưa có dữ liệu khách hàng.</td>
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
    // Bấm vào "Thuộc tính sản phẩm" để trượt mở/đóng danh sách con (có thể vuốt lên/xuống bên trong)
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
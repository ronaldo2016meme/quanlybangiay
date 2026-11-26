<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo UTF-8 để gõ tiếng Việt không lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL cơ bản --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- Thư viện định dạng tiền tệ --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi --%>
<%
    // Kiểm tra đăng nhập, nếu chưa đăng nhập thì chuyển về /login
    if (session.getAttribute("userLogin") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - Quản Lý Bán Giày</title>
    <style>
        * { box-sizing: border-box; } /* Tính cả viền và padding cho khung không bị lệch */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6;
            color: #132232;
            display: flex;
            min-height: 100vh;
        }

        /* Thanh menu dọc bên trái có thể vuốt lên / xuống */
        .sidebar {
            width: 245px;
            background-color: #132232;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
            height: 100vh;
            position: sticky;
            top: 0;
            overflow-y: auto;
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

        /* Danh sách con dạng thanh trượt / vuốt lên xuống */
        .submenu-list {
            list-style: none;
            margin: 0;
            padding: 0;
            max-height: 0;
            overflow-y: auto;
            background-color: rgba(0, 0, 0, 0.22);
            transition: max-height 0.3s ease;
        }
        .submenu-list.open {
            max-height: 165px;
        }
        .submenu-list a {
            padding: 10px 22px 10px 36px;
            font-size: 13px;
            font-weight: 500;
            color: #cbd5e1;
        }

        .sidebar::-webkit-scrollbar,
        .submenu-list::-webkit-scrollbar {
            width: 5px;
        }
        .sidebar::-webkit-scrollbar-thumb,
        .submenu-list::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.25);
            border-radius: 6px;
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

        /* Phần nội dung chính bên phải */
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
            max-width: 1200px;
            width: 100%;
            margin: 24px auto;
            padding: 0 24px;
        }

        /* Các thẻ thống kê doanh thu */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }
        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 18px 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            border-top: 4px solid #2563eb;
        }
        .stat-label {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 8px;
        }
        .stat-value {
            font-size: 22px;
            font-weight: 800;
            color: #132232;
        }
        .stat-sub {
            font-size: 12px;
            color: #2563eb;
            margin-top: 6px;
        }
        .panel-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            margin-bottom: 20px;
        }
        .panel-box h3 {
            margin: 0 0 12px;
            font-size: 16px;
            color: #132232;
        }
        .alert-deny {
            background: #ffffff;
            border-left: 4px solid #dc2626;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            color: #991b1b;
            font-weight: 600;
        }

        /* Thanh tìm kiếm & danh sách giày */
        .toolbar {
            background: #ffffff;
            padding: 16px;
            border-radius: 12px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 12px;
            flex-wrap: wrap;
        }
        .toolbar input, .toolbar select {
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            color: #132232;
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
        }
        .btn-primary:hover {
            background-color: #1d4ed8;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 18px;
        }
        .product-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .product-title {
            font-size: 16px;
            font-weight: bold;
            margin: 0 0 8px;
            color: #132232;
        }
        .product-meta {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 12px;
            line-height: 1.5;
        }
        .price {
            font-size: 17px;
            font-weight: bold;
            color: #2563eb;
            margin-bottom: 12px;
        }
        .btn-buy {
            display: block;
            text-align: center;
            background-color: #2563eb;
            color: #ffffff;
            text-decoration: none;
            padding: 10px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 14px;
        }
        .btn-buy:hover {
            background-color: #1d4ed8;
        }
        .empty-box {
            background: #ffffff;
            padding: 36px;
            border-radius: 12px;
            text-align: center;
            color: #64748b;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
        }
    </style>
</head>
<body>

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" /> <%-- Lấy chức vụ từ session và đưa về chữ thường --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" /> <%-- Kiểm tra có phải Quản lý không --%>
<c:set var="activeView" value="${empty param.view ? (isQuanLy ? 'thongke' : 'banhang') : param.view}" /> <%-- Màn hình đang mở trên index.jsp --%>

<aside class="sidebar"> <%-- Cột menu bên trái đồng bộ toàn hệ thống --%>
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
                    <li>
                        <a href="${pageContext.request.contextPath}/index.jsp?view=thongke"
                           class="${activeView == 'thongke' ? 'active' : ''}">Thống kê doanh thu</a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/BanHang"
                           class="${activeView == 'banhang' ? 'active' : ''}">Trang bán hàng</a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/NhanVien">Nhân viên</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
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

                <c:otherwise> <%-- Menu dành cho Nhân viên --%>
                    <li>
                        <a href="${pageContext.request.contextPath}/index.jsp?view=banhang"
                           class="${activeView == 'banhang' ? 'active' : ''}">Bán hàng</a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/MauSac">Màu sắc</a></li>
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
<div class="main-wrapper"> <%-- Phần nội dung bên phải --%>
    <div class="topbar">
        <h2>
            <c:choose>
                <c:when test="${activeView == 'thongke' and isQuanLy}">Thống Kê Doanh Thu</c:when>
                <c:otherwise>Trang Chủ Bán Hàng</c:otherwise>
            </c:choose>
        </h2>
        <div>
            <c:choose>
                <c:when test="${activeView == 'thongke' and isQuanLy}">
                    <span>Quyền xem: <strong>Quản lý</strong></span>
                </c:when>
                <c:otherwise>
                    <strong>Số mẫu hiển thị:</strong> ${not empty sanPhams ? sanPhams.size() : 0}
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="container">
        <c:choose>
            <c:when test="${param.view == 'thongke' and not isQuanLy}">
                <div class="alert-deny">
                    Chỉ tài khoản chức vụ Quản lý mới được phép xem Thống kê doanh thu.
                </div>
            </c:when>
            <c:when test="${activeView == 'thongke' and isQuanLy}">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-label">Doanh thu hôm nay</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${not empty doanhThuHomNay ? doanhThuHomNay : 0}" type="number" groupingUsed="true"/> đ
                        </div>
                        <div class="stat-sub">Cập nhật theo hóa đơn đã thanh toán</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Doanh thu tháng này</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${not empty doanhThuThang ? doanhThuThang : 0}" type="number" groupingUsed="true"/> đ
                        </div>
                        <div class="stat-sub">Tổng doanh thu trong tháng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Tổng hóa đơn</div>
                        <div class="stat-value">
                                ${not empty tongHoaDon ? tongHoaDon : 0}
                        </div>
                        <div class="stat-sub">Đơn hàng đã ghi nhận</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">Tổng sản phẩm</div>
                        <div class="stat-value">
                                ${not empty sanPhams ? sanPhams.size() : 0}
                        </div>
                        <div class="stat-sub">Mẫu giày trong hệ thống</div>
                    </div>
                </div>

                <div class="panel-box">
                    <h3>Báo cáo doanh thu hệ thống</h3>
                </div>
            </c:when>

            <c:otherwise>
                <div class="toolbar">
                    <form action="${pageContext.request.contextPath}/index.jsp" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                        <input type="hidden" name="view" value="banhang">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên giày...">
                        <select name="maDanhMuc">
                            <option value="">-- Tất cả danh mục --</option>
                            <c:forEach items="${danhMucs}" var="dm">
                                <option value="${dm.maDanhMuc}" ${param.maDanhMuc == dm.maDanhMuc ? 'selected' : ''}>
                                        ${dm.tenDanhMuc}
                                </option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn-primary">Tìm kiếm</button>
                    </form>
                </div>
                <c:choose>
                    <c:when test="${not empty sanPhams}">
                        <div class="grid">
                            <c:forEach items="${sanPhams}" var="sp">
                                <div class="product-card">
                                    <div>
                                        <div class="product-title">${sp.tenSanPham}</div>
                                        <div class="product-meta">
                                            Danh mục: ${sp.danhMuc.tenDanhMuc}<br>
                                            Trạng thái: ${sp.trangThai}
                                        </div>
                                    </div>
                                    <div>
                                        <div class="price">
                                            <fmt:formatNumber value="${sp.giaBan}" type="number" groupingUsed="true"/> đ
                                        </div>
                                        <a class="btn-buy" href="${pageContext.request.contextPath}/HoaDon?action=chonSanPham&maSP=${sp.maSanPham}">
                                            Thêm vào đơn hàng
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-box">
                            Chưa có dữ liệu sản phẩm để hiển thị trên trang chủ. Bạn có thể chọn các mục ở menu bên trái để thao tác.
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<script>
    // Bấm vào "Thuộc tính sản phẩm" để trượt mở/đóng danh sách con (vuốt lên/xuống được bên trong)
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
<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Cấu hình UTF-8 để hiển thị tiếng Việt chuẩn --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thẻ điều kiện và vòng lặp JSTL --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Hàm xử lý chuỗi như toLowerCase, contains --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- Định dạng tiền tệ theo dấu phân cách hàng nghìn --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bán Hàng - AH9 Shoes</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; } /* Tính cả border và padding vào kích thước phần tử */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6;
            color: #132232;
            display: flex; /* Bố cục 2 cột: sidebar trái + vùng làm việc phải */
            min-height: 100vh;
        }
        .sidebar {
            width: 245px;
            background-color: #132232; /* Tông xanh đen chủ đạo */
            color: #ffffff;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
            height: 100vh;
            position: sticky; /* Giữ sidebar cố định khi cuộn nội dung */
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
        }
        .logo-box img {
            height: 54px;
            width: auto;
            display: block;
            object-fit: contain;
        }
        .sidebar-brand .logo-text { font-size: 18px; font-weight: 800; letter-spacing: 1px; }
        .sidebar-brand .sub-text { font-size: 12px; color: #9fb3c8; margin-top: 3px; }
        .menu-list { list-style: none; padding: 12px 0; margin: 0; flex: 1; }
        .menu-list a, .menu-dropdown-btn {
            width: 100%; background: transparent; border: none; text-align: left;
            font-family: inherit; cursor: pointer; display: flex; align-items: center;
            justify-content: space-between; padding: 12px 22px; color: #cbd5e1;
            text-decoration: none; font-size: 14px; font-weight: 600;
            border-left: 3px solid transparent; transition: 0.2s;
        }
        .menu-list a:hover, .menu-list a.active, .menu-dropdown-btn:hover, .menu-dropdown-btn.open {
            background-color: rgba(37, 99, 235, 0.22); /* Điểm nhấn xanh dương #2563eb */
            color: #ffffff;
            border-left-color: #2563eb;
        }
        .menu-arrow { font-size: 11px; transition: transform 0.25s ease; }
        .menu-dropdown-btn.open .menu-arrow { transform: rotate(180deg); }
        .submenu-list {
            list-style: none; margin: 0; padding: 0; max-height: 0; overflow-y: auto;
            background-color: rgba(0, 0, 0, 0.22); transition: max-height 0.3s ease;
        }
        .submenu-list.open { max-height: 165px; } /* Mở menu con dạng trượt dọc có thanh cuộn */
        .submenu-list a { padding: 10px 22px 10px 36px; font-size: 13px; font-weight: 500; color: #cbd5e1; }
        .sidebar-footer {
            padding: 16px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 13px;
            line-height: 1.5;
        }
        .role-badge { color: #9fb3c8; font-size: 12px; }
        .logout-link { display: inline-block; margin-top: 8px; color: #60a5fa; text-decoration: none; font-weight: bold; }

        .main-wrapper { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .topbar {
            background-color: #ffffff; padding: 14px 28px; border-bottom: 1px solid #dce3ec;
            display: flex; justify-content: space-between; align-items: center; gap: 12px;
        }
        .topbar h2 { margin: 0; font-size: 18px; }
        .container { max-width: 1360px; width: 100%; margin: 20px auto; padding: 0 24px; }
        .pos-grid { display: grid; grid-template-columns: 1.45fr 1fr; gap: 20px; align-items: start; } /* Cột danh sách rộng hơn cột giỏ hàng */
        .card-box {
            background: #ffffff; border-radius: 12px; padding: 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
        }
        .search-bar { display: flex; gap: 8px; margin-bottom: 14px; }
        .search-bar input {
            flex: 1; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 13px;
        }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th, td { padding: 10px 8px; border-bottom: 1px solid #e2e8f0; text-align: left; }
        th { background-color: #132232; color: #ffffff; font-weight: 600; }
        .btn-primary {
            padding: 7px 12px; background-color: #2563eb; color: #ffffff; border: none;
            border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 12px;
        }
        .btn-primary:hover:not(:disabled) { background-color: #1d4ed8; }
        .btn-primary:disabled { background-color: #94a3b8; cursor: not-allowed; }
        .btn-danger {
            padding: 5px 10px; background-color: #dc2626; color: #ffffff; border: none;
            border-radius: 6px; cursor: pointer; font-size: 12px;
        }
        .qty-input { width: 58px; padding: 5px 6px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 12px; }
        .total-row {
            margin-top: 14px; padding-top: 12px; border-top: 1px solid #e2e8f0;
            display: flex; justify-content: space-between; align-items: center;
            font-size: 16px; font-weight: 700; color: #132232;
        }
        .alert-ok {
            background: #dcfce7; border: 1px solid #86efac; color: #166534;
            padding: 10px 14px; border-radius: 8px; margin-bottom: 14px; font-size: 13px; font-weight: 600;
        }
        .alert-err {
            background: #fee2e2; border: 1px solid #fca5a5; color: #991b1b;
            padding: 10px 14px; border-radius: 8px; margin-bottom: 14px; font-size: 13px; font-weight: 600;
        }
        @media (max-width: 980px) { .pos-grid { grid-template-columns: 1fr; } } /* Chuyển 1 cột trên màn hình hẹp */
    </style>
</head>
<body>
<%-- Xác định quyền Quản lý từ chức vụ nhân viên trong session --%>
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
                <%-- Menu đầy đủ dành cho tài khoản Quản lý --%>
                <c:when test="${isQuanLy}">
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=thongke">Thống kê doanh thu</a></li>
                    <li><a href="${pageContext.request.contextPath}/BanHang" class="active">Trang bán hàng</a></li>
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
                <%-- Menu thu gọn dành cho Nhân viên bán hàng --%>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/BanHang" class="active">Bán hàng</a></li>
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
        <h2>Bán Hàng Tại Quầy</h2>
    </div>
    <div class="container">
        <%-- Thông báo phản hồi sau khi redirect từ action="checkout" --%>
        <c:if test="${param.paid == '1'}">
            <div class="alert-ok">Thanh toán thành công, đã tạo hóa đơn và cập nhật tồn kho!</div>
        </c:if>
        <c:if test="${param.error == '1'}">
            <div class="alert-err">Thanh toán thất bại (kiểm tra lại tồn kho hoặc dữ liệu hóa đơn).</div>
        </c:if>

        <div class="pos-grid">
            <%-- Cột trái: tìm kiếm và chọn biến thể giày để thêm vào giỏ --%>
            <div class="card-box">
                <form action="${pageContext.request.contextPath}/BanHang" method="GET" class="search-bar">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên giày, màu sắc, size...">
                    <button type="submit" class="btn-primary">Tìm</button>
                </form>

                <table>
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Size / Màu</th>
                        <th>Giá bán</th>
                        <th>Tồn</th>
                        <th>Mua</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listBienThe}" var="bt">
                        <tr>
                            <td><strong>${bt.sanPham.tenSP}</strong></td>
                            <td>Size ${bt.size.tenSize} - ${bt.mauSac.tenMau}</td>
                            <td><fmt:formatNumber value="${bt.giaBan}" type="number" groupingUsed="true"/> ₫</td>
                            <td>${bt.soLuongTon}</td>
                            <td>
                                    <%-- Gửi action=addToCart kèm maSPCT và số lượng chọn mua --%>
                                <form action="${pageContext.request.contextPath}/BanHang" method="POST" style="display:flex;gap:4px;">
                                    <input type="hidden" name="action" value="addToCart">
                                    <input type="hidden" name="maSPCT" value="${bt.maSPCT}">
                                    <input type="number" name="soLuong" value="1" min="1" max="${bt.soLuongTon}" class="qty-input" ${bt.soLuongTon <= 0 ? 'disabled' : ''}>
                                    <button type="submit" class="btn-primary" ${bt.soLuongTon <= 0 ? 'disabled' : ''}>+</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- Cột phải: giỏ hàng tạm trong session và form thanh toán xuất hóa đơn --%>
            <div class="card-box">
                <h3 style="margin-top:0;">Giỏ Hàng</h3>
                <table>
                    <thead>
                    <tr>
                        <th>Mặt hàng</th>
                        <th>SL</th>
                        <th>Thành tiền</th>
                        <th>Xóa</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${gioHang}" var="item">
                        <tr>
                            <td>
                                <strong>${item.sanPhamChiTiet.sanPham.tenSP}</strong><br>
                                <small>Size ${item.sanPhamChiTiet.size.tenSize} - ${item.sanPhamChiTiet.mauSac.tenMau}</small>
                            </td>
                            <td>
                                    <%-- Tự gửi form cập nhật số lượng ngay khi đổi giá trị trong ô input --%>
                                <form action="${pageContext.request.contextPath}/BanHang" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="updateQty">
                                    <input type="hidden" name="maSPCT" value="${item.sanPhamChiTiet.maSPCT}">
                                    <input type="number" name="soLuong" value="${item.soLuong}" min="0" max="${item.sanPhamChiTiet.soLuongTon}" class="qty-input" onchange="this.form.submit()">
                                </form>
                            </td>
                            <td><fmt:formatNumber value="${item.thanhTien}" type="number" groupingUsed="true"/> ₫</td>
                            <td>
                                    <%-- Xóa dòng mặt hàng khỏi giỏ --%>
                                <form action="${pageContext.request.contextPath}/BanHang" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="removeItem">
                                    <input type="hidden" name="maSPCT" value="${item.sanPhamChiTiet.maSPCT}">
                                    <button type="submit" class="btn-danger">×</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty gioHang}">
                        <tr><td colspan="4" style="text-align:center;color:#64748b;">Giỏ hàng đang trống</td></tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- Form xác nhận thanh toán và lưu hóa đơn vào database --%>
                <form action="${pageContext.request.contextPath}/BanHang" method="POST" style="margin-top:14px;">
                    <input type="hidden" name="action" value="checkout">
                    <div style="margin-bottom:10px;">
                        <label style="font-size:12px;font-weight:600;display:block;margin-bottom:4px;">Mã khách hàng (tùy chọn)</label>
                        <input type="number" name="maKH" min="1" placeholder="Để trống nếu khách lẻ" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:8px;font-size:13px;">
                    </div>
                    <div class="total-row">
                        <span>Tổng cộng:</span>
                        <span style="color:#2563eb;"><fmt:formatNumber value="${tongTien}" type="number" groupingUsed="true"/> ₫</span>
                    </div>
                    <button type="submit" class="btn-primary" style="width:100%;padding:11px;margin-top:14px;font-size:14px;" ${empty gioHang ? 'disabled' : ''}>
                        Thanh Toán &amp; Xuất Hóa Đơn
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Mở/đóng danh sách con "Thuộc tính sản phẩm" dạng trượt dọc khi bấm nút
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
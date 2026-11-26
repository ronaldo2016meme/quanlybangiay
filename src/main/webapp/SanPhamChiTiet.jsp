<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để hiển thị tiếng Việt không lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL Core dùng cho các thẻ c:choose, c:when, c:otherwise, c:forEach, c:set, c:if --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện JSTL Functions dùng để xử lý chuỗi (chuyển chữ thường, kiểm tra quyền) --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Sản Phẩm - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; } /* Tính cả border và padding vào width/height để không bị tràn khung */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6; /* Nền xám xanh nhạt đồng bộ với hệ thống */
            color: #132232;
            display: flex; /* Chia bố cục 2 cột: sidebar bên trái và nội dung chính bên phải */
            min-height: 100vh;
        }
        /* ================= SIDEBAR MENU BÊN TRÁI ================= */
        /* Thanh menu dọc bên trái có thể vuốt lên / xuống */
        .sidebar {
            width: 245px; /* Độ rộng cố định của menu trái */
            background-color: #132232; /* Màu xanh đen đậm giống trang đăng nhập */
            color: #ffffff;
            display: flex;
            flex-direction: column; /* Xếp các mục từ trên xuống dưới */
            justify-content: space-between; /* Đẩy thông tin nhân viên & nút đăng xuất xuống đáy */
            flex-shrink: 0; /* Giữ nguyên độ rộng menu, không bị co lại */
            height: 100vh; /* Chiều cao bằng màn hình */
            position: sticky; /* Giữ menu cố định khi cuộn phần nội dung bên phải */
            top: 0;
            overflow-y: auto; /* Cho phép vuốt lên/xuống thanh menu khi mở nhiều mục */
        }
        .sidebar-brand {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1); /* Đường kẻ mờ ngăn cách logo với menu */
            text-align: center;
        }
        .logo-box {
            background-color: #ffffff; /* Nền trắng để logo AH9 nổi rõ trên nền tối */
            border-radius: 12px;
            padding: 8px 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .logo-box img {
            height: 54px; /* Chỉnh chiều cao logo cho vừa khung */
            width: auto;
            display: block;
            object-fit: contain; /* Giữ nguyên hình logo không bị méo */
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
        /* Làm thanh vuốt nhỏ gọn cho đẹp */
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
        /* ================= NỘI DUNG CHÍNH BÊN PHẢI ================= */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-width: 0; /* Tránh lỗi flex item tràn chiều ngang */
        }
        .topbar {
            background-color: #ffffff;
            padding: 14px 28px;
            border-bottom: 1px solid #dce3ec;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .topbar h2 {
            margin: 0;
            font-size: 18px;
            color: #132232;
        }
        .container {
            max-width: 1280px;
            width: 100%;
            margin: 24px auto;
            padding: 0 24px;
        }
        .card-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06);
        }
        .alert-success {
            background-color: #dcfce7;
            border: 1px solid #86efac;
            color: #166534;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        /* Lưới 2 cột: bên trái là ảnh giày, bên phải là thông tin & chọn size/màu */
        .detail-layout {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 28px;
            align-items: start;
        }
        .shoe-img-box {
            width: 100%;
            aspect-ratio: 1 / 1; /* Giữ khung ảnh vuông cân đối */
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 16px;
            overflow: hidden;
        }
        .shoe-img-box img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain; /* Hiển thị trọn vẹn đôi giày không bị cắt */
            display: block;
        }
        .product-name {
            margin: 0 0 8px;
            font-size: 22px;
            font-weight: 700;
            color: #132232;
        }
        .product-sub {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 12px;
        }
        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: #2563eb;
            margin-bottom: 6px;
        }
        .sub-price {
            font-size: 13px;
            color: #64748b;
            margin-bottom: 14px;
        }
        .product-desc {
            font-size: 14px;
            line-height: 1.55;
            color: #334155;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 18px;
        }
        /* Style các nút chọn Size và Màu sắc */
        .option-block {
            margin-bottom: 18px;
        }
        .option-label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #132232;
            margin-bottom: 8px;
        }
        .option-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .option-btn {
            padding: 8px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background-color: #ffffff;
            color: #132232;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.15s;
        }
        .option-btn:hover:not(:disabled) {
            border-color: #2563eb;
            color: #2563eb;
        }
        .option-btn.active {
            background-color: #2563eb; /* Nút đang được chọn */
            border-color: #2563eb;
            color: #ffffff;
        }
        .option-btn:disabled,
        .option-btn.sold-out {
            background-color: #f1f5f9; /* Làm mờ và gạch ngang khi hết hàng */
            border-color: #e2e8f0;
            color: #94a3b8;
            cursor: not-allowed;
            text-decoration: line-through;
        }
        .stock-info {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
            line-height: 1.5;
        }
        .stock-ok { color: #15803d; } /* Màu xanh khi còn hàng */
        .stock-out { color: #dc2626; } /* Màu đỏ khi hết hàng */
        /* Khung form thêm & sửa biến thể cho Quản lý */
        .edit-variant-box {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #e2e8f0;
        }
        .edit-variant-title {
            font-size: 14px;
            font-weight: 700;
            color: #132232;
            margin-bottom: 10px;
        }
        .edit-variant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
            margin-bottom: 12px;
        }
        .edit-field label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 4px;
        }
        .edit-field input,
        .edit-field select {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 13px;
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
            font-size: 13px;
        }
        .btn-primary:hover:not(:disabled) {
            background-color: #1d4ed8;
        }
        .btn-primary:disabled {
            background-color: #94a3b8;
            cursor: not-allowed;
        }
        .btn-secondary {
            padding: 8px 14px;
            background-color: #e2e8f0;
            color: #132232;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
        }
        .empty-box {
            text-align: center;
            color: #64748b;
            padding: 28px;
        }
        @media (max-width: 860px) {
            .detail-layout {
                grid-template-columns: 1fr; /* Trên màn hình nhỏ chuyển sang 1 cột */
            }
        }
    </style>
</head>
<body>
<%-- Lấy tên chức vụ của tài khoản đang đăng nhập và chuyển về chữ thường để kiểm tra quyền --%>
<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" />
<%-- Xác định người dùng hiện tại có phải Quản lý / Admin hay không --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" />
<aside class="sidebar">
    <div>
        <div class="sidebar-brand">
            <div class="logo-box">
                <%-- Hiển thị logo AH9 từ thư mục webapp/img/AH9.png --%>
                <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9 Shoes">
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
                        <a href="${pageContext.request.contextPath}/BanHang"
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
            <%-- Hiển thị thông tin nhân viên nếu đã đăng nhập vào session --%>
            <c:when test="${not empty sessionScope.userLogin}">
                <div>Nhân viên: <strong>${sessionScope.userLogin.hoTen}</strong></div>
                <div class="role-badge">Chức vụ: ${sessionScope.userLogin.tenChucVu}</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/logout">Đăng xuất →</a>
            </c:when>
            <%-- Hiển thị nút đăng nhập nếu chưa có session userLogin --%>
            <c:otherwise>
                <div>Chưa đăng nhập</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/login">Đăng nhập →</a>
            </c:otherwise>
        </c:choose>
    </div>
</aside>
<div class="main-wrapper">
    <div class="topbar">
        <h2>Chi Tiết Sản Phẩm</h2>
        <%-- Nút quay lại trang danh sách sản phẩm --%>
        <a href="${pageContext.request.contextPath}/SanPham" class="btn-secondary">← Quay lại danh sách sản phẩm</a>
    </div>
    <div class="container">
        <div class="card-box">
            <c:if test="${param.added == '1'}">
                <div class="alert-success">Thêm biến thể sản phẩm chi tiết thành công!</div>
            </c:if>
            <c:if test="${param.updated == '1'}">
                <div class="alert-success">Cập nhật biến thể sản phẩm thành công!</div>
            </c:if>
            <%-- Lấy mã sản phẩm từ tham số ?maSP=... trên URL và tìm đối tượng SanPham tương ứng trong listSanPhamChiTiet --%>
            <c:set var="targetMaSP" value="${fn:trim(param.maSP)}" />
            <c:set var="sanPhamChon" value="${null}" />
            <c:forEach items="${listSanPhamChiTiet}" var="item">
                <c:if test="${empty sanPhamChon and not empty item.sanPham and fn:trim(item.sanPham.maSP) == targetMaSP}">
                    <c:set var="sanPhamChon" value="${item.sanPham}" />
                </c:if>
            </c:forEach>
            <c:choose>
                <%-- Chỉ hiển thị khi tìm thấy sản phẩm khớp với maSP được bấm chọn --%>
                <c:when test="${not empty sanPhamChon}">
                    <div class="detail-layout">
                            <%-- Khung ảnh giày, src sẽ được JS cập nhật khi người dùng chọn màu khác --%>
                        <div class="shoe-img-box">
                            <img id="shoeImage"
                                 src="${pageContext.request.contextPath}/img/${sanPhamChon.anh}"
                                 alt="${sanPhamChon.tenSP}">
                        </div>
                        <div>
                                <%-- Thông tin cơ bản của sản phẩm đang xem --%>
                            <h1 class="product-name">${sanPhamChon.tenSP}</h1>
                            <div class="product-sub">
                                Mã SP: <strong>${sanPhamChon.maSP}</strong> |
                                Danh mục: <strong>${sanPhamChon.danhMucSanPham.tenDanhMuc}</strong> |
                                Chất liệu: <strong>${sanPhamChon.chatLieu.tenChatLieu}</strong>
                            </div>
                                <%-- Giá bán và giá nhập/ngày tạo của biến thể đang chọn --%>
                            <div class="product-price" id="priceDisplay">Liên hệ</div>
                            <div class="sub-price" id="importPriceDisplay"></div>
                                <%-- Mô tả sản phẩm --%>
                            <div class="product-desc">${sanPhamChon.moTa}</div>
                                <%-- Khu vực render các nút chọn Size (39 - 44) bằng JavaScript --%>
                            <div class="option-block">
                                <span class="option-label">Chọn Size:</span>
                                <div class="option-list" id="sizeList"></div>
                            </div>
                                <%-- Khu vực render các nút chọn Màu (Đỏ, Xanh, Đen, Trắng, Vàng Gold...) bằng JavaScript --%>
                            <div class="option-block">
                                <span class="option-label">Chọn Màu:</span>
                                <div class="option-list" id="colorList"></div>
                            </div>
                                <%-- Hiển thị trạng thái còn hàng / hết hàng và số lượng tồn --%>
                            <div class="stock-info" id="stockStatus"></div>

                                <%-- Form thêm biến thể mới & form sửa biến thể đang chọn (chỉ hiển thị cho Quản lý) --%>
                            <c:if test="${isQuanLy}">
                                <form action="${pageContext.request.contextPath}/SanPhamChiTiet" method="POST" id="addVariantForm" class="edit-variant-box">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="maSP" value="${sanPhamChon.maSP}">
                                    <div class="edit-variant-title">
                                        Thêm Biến Thể Mới (#${sanPhamChon.maSP})
                                    </div>
                                    <div class="edit-variant-grid">
                                        <div class="edit-field">
                                            <label for="addMaSize">Size</label>
                                            <select name="maSize" id="addMaSize" required>
                                                <c:forEach items="${listSize}" var="sz">
                                                    <option value="${sz.maSize}">Size ${sz.tenSize}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="edit-field">
                                            <label for="addMaMau">Màu sắc</label>
                                            <select name="maMau" id="addMaMau" required>
                                                <c:forEach items="${listMauSac}" var="ms">
                                                    <option value="${ms.maMau}">${ms.tenMau}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="edit-field">
                                            <label for="addGiaBan">Giá bán (₫)</label>
                                            <input type="number" name="giaBan" id="addGiaBan" min="0" step="any" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="addGiaNhap">Giá nhập (₫)</label>
                                            <input type="number" name="giaNhap" id="addGiaNhap" min="0" step="any" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="addSoLuongTon">Tồn kho</label>
                                            <input type="number" name="soLuongTon" id="addSoLuongTon" min="0" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="addTrangThai">Trạng thái</label>
                                            <select name="trangThai" id="addTrangThai">
                                                <option value="Còn hàng">Còn hàng</option>
                                                <option value="Hết hàng">Hết hàng</option>
                                                <option value="Ngừng bán">Ngừng bán</option>
                                            </select>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn-primary">Thêm biến thể</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/SanPhamChiTiet" method="POST" id="editVariantForm" class="edit-variant-box">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="maSP" value="${sanPhamChon.maSP}">
                                    <input type="hidden" name="maSPCT" id="editMaSPCT">
                                    <div class="edit-variant-title">
                                        Sửa Biến Thể Đang Chọn (<span id="editVariantCodeLabel">-</span>)
                                    </div>
                                    <div class="edit-variant-grid">
                                        <div class="edit-field">
                                            <label for="editMaSize">Size</label>
                                            <select name="maSize" id="editMaSize">
                                                <c:forEach items="${listSize}" var="sz">
                                                    <option value="${sz.maSize}">Size ${sz.tenSize}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="edit-field">
                                            <label for="editMaMau">Màu sắc</label>
                                            <select name="maMau" id="editMaMau">
                                                <c:forEach items="${listMauSac}" var="ms">
                                                    <option value="${ms.maMau}">${ms.tenMau}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="edit-field">
                                            <label for="editGiaBan">Giá bán (₫)</label>
                                            <input type="number" name="giaBan" id="editGiaBan" min="0" step="any" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="editGiaNhap">Giá nhập (₫)</label>
                                            <input type="number" name="giaNhap" id="editGiaNhap" min="0" step="any" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="editSoLuongTon">Tồn kho</label>
                                            <input type="number" name="soLuongTon" id="editSoLuongTon" min="0" required>
                                        </div>
                                        <div class="edit-field">
                                            <label for="editTrangThai">Trạng thái</label>
                                            <select name="trangThai" id="editTrangThai">
                                                <option value="Còn hàng">Còn hàng</option>
                                                <option value="Hết hàng">Hết hàng</option>
                                                <option value="Ngừng bán">Ngừng bán</option>
                                            </select>
                                        </div>
                                    </div>
                                    <button type="submit" id="saveVariantBtn" class="btn-primary">Lưu sửa biến thể</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                    <script>
                        // Đường dẫn gốc tới thư mục chứa ảnh trong webapp/img/
                        const imgBasePath = "${pageContext.request.contextPath}/img/";
                        // Ảnh mặc định của sản phẩm đang xem
                        const defaultImage = "${sanPhamChon.anh}";
                        // Tên sản phẩm hiện tại (chữ thường) để nhận diện đúng dòng giày khi đổi màu
                        const productNameLower = "${fn:toLowerCase(sanPhamChon.tenSP)}";
                        // Quy đổi mã size (1..6) sang size 39..44.
                        // Nếu maSize trong DB đã là "39".."44" thì giữ nguyên số đó.
                        const sizeNameMap = {
                            "1": "39",
                            "2": "40",
                            "3": "41",
                            "4": "42",
                            "5": "43",
                            "6": "44"
                        };
                        // Quy đổi mã màu trong DB sang tên màu tiếng Việt khớp với bảng MauSac của bạn
                        const colorNameMap = {
                            "1": "Đỏ",
                            "2": "Xanh",
                            "3": "Đen",
                            "4": "Trắng",
                            "5": "Vàng Gold"
                        };
                        // Bảng ảnh chuẩn theo từng dòng giày trong webapp/img/ — mỗi dòng chỉ dùng đúng ảnh của chính nó
                        const productImageSets = [
                            {
                                match: () => productNameLower.includes("mercurial") || productNameLower.includes("cr7"),
                                colors: {
                                    "vàng gold": "mercurial_cr7_gold.jpg",
                                    "vang gold": "mercurial_cr7_gold.jpg",
                                    "vàng": "mercurial_cr7_gold.jpg",
                                    "vang": "mercurial_cr7_gold.jpg",
                                    "đỏ": "mercurial_cr7_red.jpg",
                                    "do": "mercurial_cr7_red.jpg"
                                }
                            },
                            {
                                match: () => productNameLower.includes("tiempo"),
                                colors: {
                                    "đen": "tiempo_tf_black.jpg",
                                    "den": "tiempo_tf_black.jpg",
                                    "trắng": "tiempo_tf_white.jpg",
                                    "trang": "tiempo_tf_white.jpg"
                                }
                            },
                            {
                                match: () => productNameLower.includes("runfalcon"),
                                colors: {
                                    "đen": "adidas_runfalcon_black.jpg",
                                    "den": "adidas_runfalcon_black.jpg",
                                    "trắng": "adidas_runfalcon_white.jpg",
                                    "trang": "adidas_runfalcon_white.jpg"
                                }
                            },
                            {
                                match: () => productNameLower.includes("samba"),
                                colors: {
                                    "đen": "adidas_samba_OG_black.jpg",
                                    "den": "adidas_samba_OG_black.jpg",
                                    "đỏ": "adidas_samba_OG_red.jpg",
                                    "do": "adidas_samba_OG_red.jpg",
                                    "trắng": "adidas_samba_OG_white.jpg",
                                    "trang": "adidas_samba_OG_white.jpg"
                                }
                            },
                            {
                                match: () => productNameLower.includes("hali1"),
                                colors: {
                                    "xanh": "puma_hali1_blue.jpg",
                                    "trắng": "puma_hali1_white.jpg",
                                    "trang": "puma_hali1_white.jpg"
                                }
                            }
                        ];
                        // Chuyển danh sách biến thể thuộc đúng sản phẩm đang bấm từ JSTL sang mảng JS
                        const variants = [
                            <c:set var="firstItem" value="${true}" />
                            <c:forEach items="${listSanPhamChiTiet}" var="spct">
                            <c:if test="${not empty spct.sanPham and fn:trim(spct.sanPham.maSP) == targetMaSP}">
                            <c:if test="${not firstItem}">,</c:if>
                            {
                                id: "${spct.maSPCT}", // Mã biến thể SPCT
                                maSP: "${spct.sanPham.maSP}", // Mã sản phẩm cha
                                maMau: "${spct.mauSac.maMau}", // Mã màu trong DB
                                maSize: "${spct.size.maSize}", // Mã size trong DB
                                giaBan: ${spct.giaBan != null ? spct.giaBan : 0}, // Giá bán
                                giaNhap: ${spct.giaNhap != null ? spct.giaNhap : 0}, // Giá nhập
                                soLuongTon: ${spct.soLuongTon != null ? spct.soLuongTon : 0}, // Số lượng tồn kho
                                ngayTao: "${spct.ngayTao}", // Ngày tạo
                                trangThai: "${spct.trangThai}", // Trạng thái biến thể
                                image: "${sanPhamChon.anh}" // Ảnh gốc của sản phẩm đang chọn
                            }
                            <c:set var="firstItem" value="${false}" />
                            </c:if>
                            </c:forEach>
                        ].map(v => {
                            const rawSize = String(v.maSize || "").trim();
                            // Nếu rawSize nằm trong 39..44 thì dùng luôn, ngược lại map từ 1..6 sang 39..44
                            const tenSize = /^39|40|41|42|43|44$/.test(rawSize)
                                ? rawSize
                                : (sizeNameMap[rawSize] || rawSize);
                            const tenMau = colorNameMap[String(v.maMau || "").trim()] || String(v.maMau || "").trim();
                            return { ...v, tenSize, tenMau };
                        });
                        // Tham chiếu tới các phần tử DOM cần thao tác
                        const sizeListEl = document.getElementById("sizeList");
                        const colorListEl = document.getElementById("colorList");
                        const shoeImageEl = document.getElementById("shoeImage");
                        const priceDisplayEl = document.getElementById("priceDisplay");
                        const importPriceDisplayEl = document.getElementById("importPriceDisplay");
                        const stockStatusEl = document.getElementById("stockStatus");
                        // Lưu tên size (39..44) và tên màu (Đỏ, Trắng...) đang chọn hiện tại
                        let currentSize = null;
                        let currentColor = null;
                        // Kiểm tra biến thể có hết hàng / ngừng bán hay không
                        function isOutOfStock(v) {
                            const st = (v.trangThai || "").toLowerCase();
                            return v.soLuongTon <= 0 || st.includes("hết hàng") || st.includes("het hang") || st.includes("ngừng");
                        }
                        // Định dạng số tiền sang kiểu VNĐ (VD: 3.200.000 ₫)
                        function formatVND(amount) {
                            if (!amount || amount <= 0) return "Liên hệ";
                            return Number(amount).toLocaleString("vi-VN") + " ₫";
                        }
                        // Lấy ảnh đúng màu của dòng giày hiện tại; nếu không có ảnh màu riêng thì dùng ảnh gốc sản phẩm
                        function getColorImageSrc(v) {
                            const fallbackFile = (v && v.image ? v.image : defaultImage) || "";
                            if (!v || !v.tenMau) {
                                return imgBasePath + fallbackFile;
                            }
                            const colorKey = v.tenMau.toLowerCase().trim();
                            const matchedSet = productImageSets.find(set => set.match());
                            if (matchedSet && matchedSet.colors[colorKey]) {
                                return imgBasePath + matchedSet.colors[colorKey];
                            }
                            return imgBasePath + fallbackFile;
                        }
                        // Gán ảnh an toàn: luôn bật hiển thị và tự quay về ảnh gốc nếu file màu không tồn tại
                        function setShoeImage(src) {
                            if (!shoeImageEl) return;
                            shoeImageEl.style.display = "block";
                            shoeImageEl.onerror = function () {
                                const fallbackSrc = imgBasePath + defaultImage;
                                if (defaultImage && !shoeImageEl.src.endsWith(fallbackSrc)) {
                                    shoeImageEl.onerror = null;
                                    shoeImageEl.src = fallbackSrc;
                                } else {
                                    shoeImageEl.style.display = "none";
                                }
                            };
                            shoeImageEl.src = src;
                        }
                        // Vẽ danh sách các nút chọn Size (39 đến 44)
                        function renderSizes() {
                            const sizes = [...new Set(variants.map(v => v.tenSize))];
                            sizeListEl.innerHTML = "";
                            if (sizes.length === 0) {
                                sizeListEl.innerHTML = "<span style='color:#64748b;font-size:13px;'>Chưa có size</span>";
                                return;
                            }
                            sizes.forEach(sz => {
                                const btn = document.createElement("button");
                                btn.type = "button";
                                btn.className = "option-btn";
                                btn.textContent = "Size " + sz;
                                // Nếu tất cả biến thể của size này đều hết hàng thì khóa nút size
                                const sizeVariants = variants.filter(v => v.tenSize === sz);
                                const allSoldOut = sizeVariants.every(isOutOfStock);
                                if (allSoldOut) {
                                    btn.disabled = true;
                                    btn.classList.add("sold-out");
                                }
                                if (sz === currentSize && !allSoldOut) {
                                    btn.classList.add("active");
                                }
                                // Khi bấm chọn size: cập nhật size hiện tại, vẽ lại màu & thông tin biến thể
                                btn.addEventListener("click", () => {
                                    if (allSoldOut) return;
                                    currentSize = sz;
                                    renderSizes();
                                    renderColors();
                                    updateSelection();
                                });
                                sizeListEl.appendChild(btn);
                            });
                        }
                        // Vẽ danh sách các nút chọn Màu sắc (Đỏ, Xanh, Đen, Trắng, Vàng Gold...)
                        function renderColors() {
                            const colors = [...new Set(variants.map(v => v.tenMau))];
                            colorListEl.innerHTML = "";
                            if (colors.length === 0) {
                                colorListEl.innerHTML = "<span style='color:#64748b;font-size:13px;'>Chưa có màu</span>";
                                return;
                            }
                            colors.forEach(col => {
                                const btn = document.createElement("button");
                                btn.type = "button";
                                btn.className = "option-btn";
                                btn.textContent = "Màu " + col;
                                // Tìm biến thể khớp với size đang chọn + màu này
                                const matched = currentSize
                                    ? variants.find(v => v.tenSize === currentSize && v.tenMau === col)
                                    : variants.find(v => v.tenMau === col);
                                // Không tồn tại biến thể hoặc hết hàng thì khóa không cho chọn
                                const soldOut = !matched || isOutOfStock(matched);
                                if (soldOut) {
                                    btn.disabled = true;
                                    btn.classList.add("sold-out");
                                }
                                if (col === currentColor && !soldOut) {
                                    btn.classList.add("active");
                                }
                                // Khi bấm chọn màu khác: chuyển sang ảnh giày của màu đó và cập nhật thông tin
                                btn.addEventListener("click", () => {
                                    if (soldOut) return;
                                    currentColor = col;
                                    setShoeImage(getColorImageSrc(matched));
                                    renderColors();
                                    updateSelection();
                                });
                                colorListEl.appendChild(btn);
                            });
                        }
                        // Đồng bộ dữ liệu biến thể đang chọn vào form sửa (nếu có quyền Quản lý)
                        function syncEditForm(variant) {
                            const editMaSPCTEl = document.getElementById("editMaSPCT");
                            if (!editMaSPCTEl) return;
                            const editVariantCodeLabelEl = document.getElementById("editVariantCodeLabel");
                            const editMaSizeEl = document.getElementById("editMaSize");
                            const editMaMauEl = document.getElementById("editMaMau");
                            const editGiaBanEl = document.getElementById("editGiaBan");
                            const editGiaNhapEl = document.getElementById("editGiaNhap");
                            const editSoLuongTonEl = document.getElementById("editSoLuongTon");
                            const editTrangThaiEl = document.getElementById("editTrangThai");
                            const saveVariantBtnEl = document.getElementById("saveVariantBtn");
                            if (variant) {
                                editMaSPCTEl.value = variant.id || "";
                                if (editVariantCodeLabelEl) editVariantCodeLabelEl.textContent = "SPCT #" + (variant.id || "");
                                if (editMaSizeEl) editMaSizeEl.value = String(variant.maSize || "").trim();
                                if (editMaMauEl) editMaMauEl.value = String(variant.maMau || "").trim();
                                if (editGiaBanEl) editGiaBanEl.value = variant.giaBan != null ? variant.giaBan : 0;
                                if (editGiaNhapEl) editGiaNhapEl.value = variant.giaNhap != null ? variant.giaNhap : 0;
                                if (editSoLuongTonEl) editSoLuongTonEl.value = variant.soLuongTon != null ? variant.soLuongTon : 0;
                                if (editTrangThaiEl) editTrangThaiEl.value = variant.trangThai || "Còn hàng";
                                if (saveVariantBtnEl) saveVariantBtnEl.disabled = false;
                            } else {
                                editMaSPCTEl.value = "";
                                if (editVariantCodeLabelEl) editVariantCodeLabelEl.textContent = "Chưa khớp biến thể";
                                if (saveVariantBtnEl) saveVariantBtnEl.disabled = true;
                            }
                        }
                        // Cập nhật ảnh, giá, giá nhập/ngày tạo và trạng thái tồn kho theo (currentSize, currentColor)
                        function updateSelection() {
                            const exactMatch = variants.find(v => v.tenSize === currentSize && v.tenMau === currentColor) || null;
                            if (exactMatch) {
                                setShoeImage(getColorImageSrc(exactMatch));
                                priceDisplayEl.textContent = "Giá bán: " + formatVND(exactMatch.giaBan);
                                importPriceDisplayEl.textContent = exactMatch.giaNhap > 0
                                    ? ("Giá nhập: " + formatVND(exactMatch.giaNhap) + (exactMatch.ngayTao ? " | Ngày tạo: " + exactMatch.ngayTao : ""))
                                    : "";
                            } else {
                                setShoeImage(imgBasePath + defaultImage);
                                priceDisplayEl.textContent = "Liên hệ";
                                importPriceDisplayEl.textContent = "";
                            }
                            if (!exactMatch || isOutOfStock(exactMatch)) {
                                // Trạng thái hết hàng hoặc không có biến thể: báo đỏ, không thể chọn
                                stockStatusEl.className = "stock-info stock-out";
                                stockStatusEl.textContent = "Trạng thái: Hết hàng (không thể chọn)";
                            } else {
                                // Trạng thái còn hàng: hiển thị thông tin biến thể và số lượng tồn kho
                                stockStatusEl.className = "stock-info stock-ok";
                                stockStatusEl.textContent =
                                    "Size " + exactMatch.tenSize + " - Màu " + exactMatch.tenMau +
                                    " | Trạng thái: " + (exactMatch.trangThai || "Còn hàng") +
                                    " | Tồn kho: " + exactMatch.soLuongTon;
                            }
                            syncEditForm(exactMatch);
                        }
                        // Tự động chọn biến thể đầu tiên còn hàng khi mở trang
                        const firstAvailable = variants.find(v => !isOutOfStock(v));
                        if (firstAvailable) {
                            currentSize = firstAvailable.tenSize;
                            currentColor = firstAvailable.tenMau;
                        } else if (variants.length > 0) {
                            currentSize = variants[0].tenSize;
                            currentColor = variants[0].tenMau;
                        }
                        renderSizes();
                        renderColors();
                        updateSelection();
                    </script>
                </c:when>
                <c:otherwise>
                    <div class="empty-box">Không tìm thấy thông tin chi tiết cho sản phẩm này.</div>
                </c:otherwise>
            </c:choose>
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
<%-- An --%>
</body>
</html>
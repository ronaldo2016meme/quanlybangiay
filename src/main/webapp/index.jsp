<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để gõ tiếng Việt không bị lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL cơ bản để dùng c:if, c:choose, c:forEach, c:set --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> <%-- Thư viện định dạng số tiền cho đẹp --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi (đổi chữ thường, kiểm tra chứa chữ) --%>
<%
    // Kiểm tra nếu chưa đăng nhập thì đá về trang /login
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
        * { box-sizing: border-box; } /* Tính gọn viền và khoảng cách vào kích thước thẻ cho đỡ lệch khung */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6; /* Màu nền xám nhạt cho phần nội dung bên phải */
            color: #132232;
            display: flex; /* Chia trang làm 2 cột: menu trái và nội dung phải */
            min-height: 100vh; /* Kéo dài hết chiều cao màn hình */
        }

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

        /* Phần nội dung chính bên phải */
        .main-wrapper {
            flex: 1; /* Chiếm hết phần diện tích còn lại bên phải */
            display: flex;
            flex-direction: column;
        }
        .topbar {
            background-color: #ffffff;
            padding: 14px 28px;
            border-bottom: 1px solid #dce3ec;
            display: flex;
            justify-content: space-between; /* Đẩy tiêu đề sang trái, thông tin phụ sang phải */
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

        /* Các thẻ thống kê doanh thu */
        .stats-grid {
            display: grid; /* Chia lưới đều cho 4 ô thống kê */
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); /* Tự động xếp cột vừa màn hình */
            gap: 18px; /* Khoảng cách giữa các ô */
            margin-bottom: 22px;
        }
        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 18px 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06); /* Đổ bóng nhẹ cho nổi khối */
            border-top: 4px solid #2563eb; /* Viền xanh dương phía trên mỗi thẻ */
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
            border-left: 4px solid #dc2626; /* Viền đỏ báo lỗi không đủ quyền */
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
            background-color: #2563eb; /* Nút màu xanh dương */
            color: #ffffff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
        }
        .btn-primary:hover {
            background-color: #1d4ed8; /* Đậm hơn chút khi di chuột vào */
        }
        .grid {
            display: grid; /* Chia lưới hiển thị các mẫu giày */
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
            justify-content: space-between; /* Giữ nút mua luôn thẳng hàng ở đáy card */
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

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" /> <%-- Lấy chức vụ của người đăng nhập từ session rồi đổi sang chữ thường để dễ so sánh --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" /> <%-- Kiểm tra nếu chức vụ là quản lý thì gán biến isQuanLy = true --%>

<c:set var="activeView" value="${empty param.view ? (isQuanLy ? 'thongke' : 'banhang') : param.view}" /> <%-- Nếu mới đăng nhập chưa bấm gì: quản lý mở trang thống kê, nhân viên mở trang bán hàng --%>

<aside class="sidebar"> <%-- Cột menu bên trái --%>
    <div>
        <div class="sidebar-brand">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/img/AH9.png" alt="Logo AH9 Shoes"> <%-- Lấy ảnh logo trong thư mục webapp/img/AH9.png --%>
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
                        <a href="${pageContext.request.contextPath}/index.jsp?view=banhang"
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
            <c:when test="${not empty sessionScope.userLogin}"> <%-- Nếu đã đăng nhập thì hiện tên + chức vụ + nút đăng xuất --%>
                <div>Nhân viên: <strong>${sessionScope.userLogin.hoTen}</strong></div> <%-- In họ tên từ object userLogin trong session --%>
                <div class="role-badge">Chức vụ: ${sessionScope.userLogin.tenChucVu}</div> <%-- In chức vụ --%>
                <a class="logout-link" href="${pageContext.request.contextPath}/logout">Đăng xuất →</a> <%-- Gọi servlet /logout để xóa session --%>
            </c:when>
            <c:otherwise> <%-- Nếu chưa đăng nhập thì hiện link quay lại trang login --%>
                <div>Chưa đăng nhập</div>
                <a class="logout-link" href="${pageContext.request.contextPath}/login">Đăng nhập →</a>
            </c:otherwise>
        </c:choose>
    </div>
</aside>

<div class="main-wrapper"> <%-- Phần khung bên phải --%>
    <div class="topbar">
        <h2>
            <c:choose>
                <c:when test="${activeView == 'thongke' and isQuanLy}">Thống Kê Doanh Thu</c:when> <%-- Đổi tiêu đề thanh trên cùng theo màn hình đang mở --%>
                <c:otherwise>Trang Chủ Bán Hàng</c:otherwise>
            </c:choose>
        </h2>
        <div>
            <c:choose>
                <c:when test="${activeView == 'thongke' and isQuanLy}">
                    <span>Quyền xem: <strong>Quản lý</strong></span>
                </c:when>
                <c:otherwise>
                    <strong>Số mẫu hiển thị:</strong> ${not empty sanPhams ? sanPhams.size() : 0} <%-- Đếm tổng số giày đang có trong danh sách --%>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="container">
        <c:choose>
            <c:when test="${param.view == 'thongke' and not isQuanLy}"> <%-- Nếu nhân viên cố tình gõ ?view=thongke lên URL thì chặn lại --%>
                <div class="alert-deny">
                    Chỉ tài khoản chức vụ Quản lý mới được phép xem Thống kê doanh thu.
                </div>
            </c:when>

            <c:when test="${activeView == 'thongke' and isQuanLy}"> <%-- Màn hình thống kê chỉ hiển thị cho Quản lý --%>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-label">Doanh thu hôm nay</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${not empty doanhThuHomNay ? doanhThuHomNay : 0}" type="number" groupingUsed="true"/> đ <%-- Nếu chưa có dữ liệu thì hiện 0, có thì format dấu phẩy hàng nghìn --%>
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

            <c:otherwise> <%-- Màn hình bán hàng: ô tìm kiếm + danh sách sản phẩm --%>
                <div class="toolbar">
                    <form action="${pageContext.request.contextPath}/index.jsp" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                        <input type="hidden" name="view" value="banhang"> <%-- Giữ trạng thái đang ở tab bán hàng sau khi bấm tìm --%>
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên giày..."> <%-- Giữ lại chữ vừa gõ trong ô tìm kiếm --%>
                        <select name="maDanhMuc">
                            <option value="">-- Tất cả danh mục --</option>
                            <c:forEach items="${danhMucs}" var="dm"> <%-- Đổ danh sách danh mục giày vào thẻ select --%>
                                <option value="${dm.maDanhMuc}" ${param.maDanhMuc == dm.maDanhMuc ? 'selected' : ''}> <%-- Tự chọn lại danh mục vừa lọc --%>
                                        ${dm.tenDanhMuc}
                                </option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn-primary">Tìm kiếm</button>
                    </form>
                </div>

                <c:choose>
                    <c:when test="${not empty sanPhams}"> <%-- Nếu có danh sách giày thì lặp ra từng thẻ --%>
                        <div class="grid">
                            <c:forEach items="${sanPhams}" var="sp">
                                <div class="product-card">
                                    <div>
                                        <div class="product-title">${sp.tenSanPham}</div> <%-- Tên mẫu giày --%>
                                        <div class="product-meta">
                                            Danh mục: ${sp.danhMuc.tenDanhMuc}<br> <%-- Lấy tên danh mục thông qua quan hệ đối tượng --%>
                                            Trạng thái: ${sp.trangThai}
                                        </div>
                                    </div>
                                    <div>
                                        <div class="price">
                                            <fmt:formatNumber value="${sp.giaBan}" type="number" groupingUsed="true"/> đ <%-- Định dạng giá tiền --%>
                                        </div>
                                        <a class="btn-buy" href="${pageContext.request.contextPath}/HoaDon?action=chonSanPham&maSP=${sp.maSanPham}"> <%-- Bấm mua thì gửi mã sản phẩm sang Servlet Hóa đơn --%>
                                            Thêm vào đơn hàng
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise> <%-- Nếu chưa truyền dữ liệu sanPhams sang thì hiện thông báo này --%>
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
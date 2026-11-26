<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Dùng UTF-8 để gõ tiếng Việt không bị lỗi dấu --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Gọi thư viện JSTL chuẩn Jakarta EE --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Gọi thư viện xử lý chuỗi để kiểm tra chức vụ --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Màu Sắc - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; } /* Tính cả viền và padding cho khung đỡ bị lệch */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6; /* Màu nền xám nhạt cho phần nội dung bên phải */
            color: #132232;
            display: flex; /* Chia trang làm 2 cột: menu trái và nội dung phải */
            min-height: 100vh; /* Cao hết màn hình */
        }

        /* Thanh menu dọc bên trái */
        .sidebar {
            width: 245px; /* Độ rộng cố định của menu trái */
            background-color: #132232; /* Màu xanh đen đậm đồng bộ toàn hệ thống */
            color: #ffffff;
            display: flex;
            flex-direction: column; /* Xếp các mục từ trên xuống dưới */
            justify-content: space-between; /* Đẩy thông tin nhân viên & đăng xuất xuống đáy */
            flex-shrink: 0; /* Không cho menu bị bóp nhỏ lại */
        }
        .sidebar-brand {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1); /* Kẻ đường mờ dưới logo */
            text-align: center;
        }
        .logo-box {
            background-color: #ffffff; /* Nền trắng để logo AH9 nổi bật trên nền tối */
            border-radius: 12px;
            padding: 8px 12px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        .logo-box img {
            height: 54px; /* Chiều cao logo */
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
            list-style: none; /* Bỏ dấu chấm đầu dòng */
            padding: 12px 0;
            margin: 0;
            flex: 1;
        }
        .menu-list a {
            display: block; /* Cho link rộng hết hàng để dễ bấm */
            padding: 12px 22px;
            color: #cbd5e1;
            text-decoration: none; /* Bỏ gạch chân link */
            font-size: 14px;
            font-weight: 600;
            border-left: 3px solid transparent; /* Viền trái ẩn để lúc rê chuột không bị giật */
            transition: 0.2s; /* Đổi màu mượt hơn */
        }
        .menu-list a:hover,
        .menu-list a.active {
            background-color: rgba(37, 99, 235, 0.22); /* Tô nền xanh nhạt cho mục đang mở */
            color: #ffffff;
            border-left-color: #2563eb; /* Vạch xanh nổi bật bên trái mục đang chọn */
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
            justify-content: space-between; /* Tiêu đề bên trái, tổng số màu bên phải */
            align-items: center;
        }
        .topbar h2 {
            margin: 0;
            font-size: 18px;
            color: #132232;
        }
        .container {
            max-width: 1100px;
            width: 100%;
            margin: 24px auto; /* Căn giữa khung nội dung */
            padding: 0 24px;
        }

        /* Khung form và bảng */
        .card-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 14px rgba(19, 34, 50, 0.06); /* Đổ bóng nhẹ cho nổi khối */
            margin-bottom: 20px;
        }
        .card-box h3 {
            margin: 0 0 14px;
            font-size: 16px;
            color: #132232;
        }
        .form-row {
            display: flex; /* Xếp ô nhập tên màu và nút bấm nằm ngang */
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .form-group {
            flex: 1;
            min-width: 220px;
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

        /* Bảng danh sách màu sắc */
        .table-wrap {
            overflow-x: auto; /* Cho cuộn ngang nếu màn hình nhỏ */
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
            background-color: #132232; /* Đầu bảng màu xanh đen giống menu */
            color: #ffffff;
            font-weight: 600;
        }
        tbody tr:hover {
            background-color: #f8fafc; /* Đổi màu nhẹ khi rê chuột qua từng dòng */
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
            <c:choose>
                <c:when test="${isQuanLy}"> <%-- Quản lý thì thấy đủ menu --%>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=thongke">Thống kê doanh thu</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp?view=banhang">Trang bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/NhanVien">Nhân viên</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/DanhMucSanPham">Danh mục</a></li>
                    <li><a href="${pageContext.request.contextPath}/MauSac" class="active">Màu sắc</a></li> <%-- Đang ở trang màu sắc nên tô active --%>
                </c:when>
                <c:otherwise> <%-- Nhân viên thì chỉ thấy các mục bán hàng --%>
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

<div class="main-wrapper"> <%-- Nội dung bên phải --%>
    <div class="topbar">
        <h2>Quản Lý Màu Sắc</h2>
        <div><strong>Tổng màu sắc:</strong> ${not empty listMauSac ? listMauSac.size() : 0}</div> <%-- Đếm tổng số màu đang có --%>
    </div>

    <div class="container">
        <%-- Form chỉ dùng để thêm màu sắc mới --%>
        <div class="card-box">
            <h3>Thêm Màu Sắc Mới</h3>
            <form action="${pageContext.request.contextPath}/MauSac" method="POST"> <%-- Gửi dữ liệu thêm màu mới về MauSacServlet bằng POST --%>
                <input type="hidden" name="action" value="add"> <%-- Báo cho Servlet biết đây là thao tác thêm mới --%>
                <div class="form-row">
                    <div class="form-group">
                        <label>Tên màu</label>
                        <input type="text" name="tenMau" placeholder="VD: Đen, Trắng, Xanh navy..." required> <%-- Ô nhập tên màu mới, bắt buộc nhập --%>
                    </div>
                    <button type="submit" class="btn-primary">Thêm màu sắc</button> <%-- Nút bấm gửi form lưu màu mới --%>
                </div>
            </form>
        </div>

        <%-- Ô tìm kiếm và bảng màu sắc --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Màu Sắc</h3>
                <form action="${pageContext.request.contextPath}/MauSac" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;"> <%-- Gửi từ khóa tìm kiếm bằng GET --%>
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên màu..."> <%-- Giữ lại từ khóa người dùng vừa gõ --%>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã Màu</th>
                        <th>Tên Màu</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listMauSac}"> <%-- Nếu danh sách màu không rỗng thì lặp từng dòng hiển thị --%>
                            <c:forEach items="${listMauSac}" var="mauSac">
                                <tr>
                                    <td>${mauSac.maMau}</td> <%-- In mã màu --%>
                                    <td>${mauSac.tenMau}</td> <%-- In tên màu --%>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise> <%-- Nếu chưa có dữ liệu listMauSac thì hiện dòng thông báo --%>
                            <tr>
                                <td colspan="2" class="empty-row">Chưa có dữ liệu màu sắc.</td>
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


<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Dùng UTF-8 để hiển thị tiếng Việt không bị lỗi dấu --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Gọi thư viện JSTL để dùng c:if, c:choose, c:forEach --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Gọi thư viện xử lý chuỗi để kiểm tra chức vụ --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Viên - AH9 Shoes</title>
    <style>
        * { box-sizing: border-box; } /* Tính cả viền và padding cho khung không bị lệch */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #eef2f6; /* Màu nền xám nhạt cho phần nội dung bên phải */
            color: #132232;
            display: flex; /* Chia trang 2 cột: menu trái và nội dung phải */
            min-height: 100vh;
        }

        /* Thanh menu dọc bên trái có thể vuốt lên/xuống */
        .sidebar {
            width: 245px;
            background-color: #132232; /* Màu xanh đen đậm đồng bộ hệ thống */
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
            background-color: #ffffff; /* Nền trắng để logo AH9 nổi bật */
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
            max-width: 1280px;
            width: 100%;
            margin: 24px auto;
            padding: 0 24px;
        }

        /* Khung form và bảng */
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
        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #dc2626;
            padding: 10px 14px;
            border-radius: 8px;
            margin-bottom: 14px;
            font-size: 14px;
            font-weight: 600;
        }
        .form-grid {
            display: grid; /* Chia lưới các ô nhập thông tin nhân viên */
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        /* Bảng danh sách nhân viên */
        .table-wrap {
            overflow-x: auto; /* Cho cuộn ngang khi bảng nhiều cột */
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
            white-space: nowrap;
        }
        thead th {
            background-color: #132232;
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

<c:set var="chucVu" value="${fn:toLowerCase(sessionScope.userLogin.tenChucVu)}" /> <%-- Đổi chức vụ sang chữ thường để kiểm tra --%>
<c:set var="isQuanLy" value="${fn:contains(chucVu, 'quản lý') or fn:contains(chucVu, 'quan ly') or fn:contains(chucVu, 'admin')}" /> <%-- Kiểm tra có phải Quản lý không --%>

<aside class="sidebar"> <%-- Menu bên trái đồng bộ --%>
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
                    <li><a href="${pageContext.request.contextPath}/BanHang">Trang bán hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/HoaDon">Hóa đơn</a></li>
                    <li><a href="${pageContext.request.contextPath}/KhachHang">Khách hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/SanPham">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/NhanVien" class="active">Nhân viên</a></li>
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
                    <li><a href="${pageContext.request.contextPath}/BanHang">Bán hàng</a></li>
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
        <h2>Quản Lý Nhân Viên</h2>
        <div><strong>Tổng nhân viên:</strong> ${not empty ListNhanVien ? ListNhanVien.size() : 0}</div> <%-- Đếm số lượng nhân viên --%>
    </div>

    <div class="container">
        <div class="card-box">
            <h3>${not empty nhanVienEdit ? 'Cập Nhật Nhân Viên' : 'Thêm Nhân Viên Mới'}</h3>

            <%-- Hiện thông báo lỗi nếu Servlet kiểm tra thấy thiếu dữ liệu hoặc sai số lượng số SĐT/CCCD --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/NhanVien" method="POST"> <%-- Gửi dữ liệu về NhanVienServlet --%>
                <input type="hidden" name="action" value="${not empty nhanVienEdit ? 'update' : 'add'}">
                <c:if test="${not empty nhanVienEdit}">
                    <input type="hidden" name="maNV" value="${nhanVienEdit.maNV}">
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ tên *</label>
                        <input type="text" name="hoTen" value="${nhanVienEdit.hoTen}" required> <%-- Bắt buộc nhập họ tên --%>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh *</label>
                        <input type="date" name="ngaySinh" value="${nhanVienEdit.ngaySinh}" required> <%-- Bắt buộc chọn ngày sinh --%>
                    </div>
                    <div class="form-group">
                        <label>Giới tính *</label>
                        <select name="gioiTinh" required>
                            <option value="">-- Chọn giới tính --</option>
                            <option value="Nam" ${nhanVienEdit.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${nhanVienEdit.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Quốc tịch *</label>
                        <input type="text" name="quocTich" value="${nhanVienEdit.quocTich}" placeholder="Việt Nam" required> <%-- Bắt buộc nhập quốc tịch --%>
                    </div>
                    <div class="form-group">
                        <label>Quê quán *</label>
                        <input type="text" name="queQuan" value="${nhanVienEdit.queQuan}" required> <%-- Bắt buộc nhập quê quán --%>
                    </div>
                    <div class="form-group">
                        <label>Nơi thường trú *</label>
                        <input type="text" name="noiThuongTru" value="${nhanVienEdit.noiThuongTru}" required> <%-- Bắt buộc nhập nơi thường trú --%>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại (10 số) *</label>
                        <input type="text" name="SDT" value="${nhanVienEdit.SDT}"
                               pattern="[0-9]{10}" maxlength="10"
                               title="Số điện thoại phải gồm đúng 10 chữ số" required> <%-- Bắt buộc đúng 10 số --%>
                    </div>
                    <div class="form-group">
                        <label>Email (@shop.vn) *</label>
                        <input type="email" name="email" value="${nhanVienEdit.email}"
                               pattern="^[a-zA-Z0-9._-]+@shop\.vn$"
                               placeholder="vd: nhanvien@shop.vn"
                               title="Email phải có đuôi @shop.vn (VD: nhanvien@shop.vn)" required> <%-- Bắt buộc đuôi @shop.vn --%>
                    </div>
                    <div class="form-group">
                        <label>CCCD (12 số) *</label>
                        <input type="text" name="CCCD" value="${nhanVienEdit.CCCD}"
                               pattern="[0-9]{12}" maxlength="12"
                               title="CCCD phải gồm đúng 12 chữ số" required> <%-- Bắt buộc đúng 12 số --%>
                    </div>
                    <div class="form-group">
                        <label>Tên chức vụ *</label>
                        <select name="tenChucVu" required>
                            <option value="">-- Chọn chức vụ --</option>
                            <option value="Quản lý" ${nhanVienEdit.tenChucVu == 'Quản lý' ? 'selected' : ''}>Quản lý</option>
                            <option value="Nhân viên bán hàng" ${nhanVienEdit.tenChucVu == 'Nhân viên bán hàng' ? 'selected' : ''}>Nhân viên bán hàng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mã tài khoản *</label>
                        <input type="text" name="maTK" value="${nhanVienEdit.maTK}" required> <%-- Bắt buộc nhập mã tài khoản --%>
                    </div>
                    <div class="form-group">
                        <label>Tên đăng nhập *</label>
                        <input type="text" name="tenDangNhap" value="${nhanVienEdit.tenDangNhap}" required> <%-- Bắt buộc nhập tên đăng nhập --%>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu *</label>
                        <input type="text" name="mauKhau" value="${nhanVienEdit.mauKhau}" required> <%-- Bắt buộc nhập mật khẩu --%>
                    </div>

                    <c:choose>
                        <c:when test="${not empty nhanVienEdit}"> <%-- Khi sửa mới cho chọn trạng thái --%>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="trangThai">
                                    <option value="Đang làm việc" ${nhanVienEdit.trangThai == 'Đang làm việc' ? 'selected' : ''}>Đang làm việc</option>
                                    <option value="Nghỉ việc" ${nhanVienEdit.trangThai == 'Nghỉ việc' ? 'selected' : ''}>Nghỉ việc</option>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise> <%-- Khi thêm mới: không có trạng thái nghỉ việc, mặc định Đang làm việc --%>
                            <input type="hidden" name="trangThai" value="Đang làm việc">
                        </c:otherwise>
                    </c:choose>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty nhanVienEdit ? 'Lưu cập nhật' : 'Thêm nhân viên'}
                </button>
                <c:if test="${not empty nhanVienEdit}">
                    <a href="${pageContext.request.contextPath}/NhanVien" class="btn-secondary">Hủy</a>
                </c:if>
            </form>
        </div>

        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Nhân Viên</h3>
                <form action="${pageContext.request.contextPath}/NhanVien" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên, SĐT hoặc chức vụ...">
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã nhân viên</th>
                        <th>Họ tên</th>
                        <th>Ngày sinh</th>
                        <th>Giới tính</th>
                        <th>Quốc tịch</th>
                        <th>Quê quán</th>
                        <th>Nơi thường trú</th>
                        <th>Số điện thoại</th>
                        <th>Email</th>
                        <th>CCCD</th>
                        <th>Tên chức vụ</th>
                        <th>Mã tài khoản</th>
                        <th>Tên đăng nhập</th>
                        <th>Mật khẩu</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty ListNhanVien}">
                            <c:forEach items="${ListNhanVien}" var="nhanVien">
                                <tr>
                                    <td>${nhanVien.maNV}</td>
                                    <td>${nhanVien.hoTen}</td>
                                    <td>${nhanVien.ngaySinh}</td>
                                    <td>${nhanVien.gioiTinh}</td>
                                    <td>${nhanVien.quocTich}</td>
                                    <td>${nhanVien.queQuan}</td>
                                    <td>${nhanVien.noiThuongTru}</td>
                                    <td>${nhanVien.SDT}</td>
                                    <td>${nhanVien.email}</td>
                                    <td>${nhanVien.CCCD}</td>
                                    <td>${nhanVien.tenChucVu}</td>
                                    <td>${nhanVien.maTK}</td>
                                    <td>${nhanVien.tenDangNhap}</td>
                                    <td>${nhanVien.mauKhau}</td>
                                    <td>${nhanVien.trangThai}</td>
                                    <td>
                                        <a class="btn-action" href="${pageContext.request.contextPath}/NhanVien?action=edit&id=${nhanVien.maNV}">Sửa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="16" class="empty-row">Chưa có dữ liệu nhân viên.</td>
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
    // Bấm vào "Thuộc tính sản phẩm" để mở/đóng danh sách có thanh vuốt lên/xuống
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
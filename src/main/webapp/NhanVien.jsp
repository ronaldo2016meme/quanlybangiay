<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để gõ tiếng Việt không bị lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL chuẩn Jakarta EE --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi để phân quyền --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Nhân Viên - AH9 Shoes</title>
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
            max-width: 1280px;
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
            overflow-x: auto; /* Cho phép cuộn ngang vì bảng nhân viên có nhiều cột */
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
            white-space: nowrap; /* Giữ chữ trên 1 dòng gọn gàng */
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
                    <li><a href="${pageContext.request.contextPath}/NhanVien" class="active">Nhân viên</a></li>
                    <li><a href="${pageContext.request.contextPath}/MaGiamGia">Mã giảm giá</a></li>
                    <li><a href="${pageContext.request.contextPath}/DanhMucSanPham">Danh mục</a></li>
                </c:when>
                <c:otherwise> <%-- Menu dành cho Nhân viên --%>
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
        <div><strong>Tổng nhân viên:</strong> ${not empty ListNhanVien ? ListNhanVien.size() : 0}</div> <%-- Đếm tổng số nhân viên --%>
    </div>

    <div class="container">
        <%-- Form thêm / cập nhật nhân viên --%>
        <div class="card-box">
            <h3>${not empty nhanVienEdit ? 'Cập Nhật Nhân Viên' : 'Thêm Nhân Viên Mới'}</h3> <%-- Tự đổi tiêu đề khi đang sửa --%>
            <form action="${pageContext.request.contextPath}/NhanVien" method="POST"> <%-- Gửi dữ liệu về NhanVienServlet --%>
                <input type="hidden" name="action" value="${not empty nhanVienEdit ? 'update' : 'add'}"> <%-- Phân biệt thêm hay sửa --%>
                <c:if test="${not empty nhanVienEdit}">
                    <input type="hidden" name="maNV" value="${nhanVienEdit.maNV}"> <%-- Giữ mã nhân viên khi sửa --%>
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Họ tên</label>
                        <input type="text" name="hoTen" value="${nhanVienEdit.hoTen}" required> <%-- Họ tên nhân viên --%>
                    </div>
                    <div class="form-group">
                        <label>Ngày sinh</label>
                        <input type="date" name="ngaySinh" value="${nhanVienEdit.ngaySinh}"> <%-- Ngày sinh --%>
                    </div>
                    <div class="form-group">
                        <label>Giới tính</label>
                        <select name="gioiTinh">
                            <option value="Nam" ${nhanVienEdit.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${nhanVienEdit.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Quốc tịch</label>
                        <input type="text" name="quocTich" value="${nhanVienEdit.quocTich}" placeholder="Việt Nam"> <%-- Quốc tịch --%>
                    </div>
                    <div class="form-group">
                        <label>Quê quán</label>
                        <input type="text" name="queQuan" value="${nhanVienEdit.queQuan}"> <%-- Quê quán --%>
                    </div>
                    <div class="form-group">
                        <label>Nơi thường trú</label>
                        <input type="text" name="noiThuongTru" value="${nhanVienEdit.noiThuongTru}"> <%-- Nơi thường trú --%>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="SDT" value="${nhanVienEdit.SDT}"> <%-- Số điện thoại --%>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${nhanVienEdit.email}"> <%-- Email --%>
                    </div>
                    <div class="form-group">
                        <label>CCCD</label>
                        <input type="text" name="CCCD" value="${nhanVienEdit.CCCD}"> <%-- Căn cước công dân --%>
                    </div>
                    <div class="form-group">
                        <label>Tên chức vụ</label>
                        <select name="tenChucVu">
                            <option value="Quản lý" ${nhanVienEdit.tenChucVu == 'Quản lý' ? 'selected' : ''}>Quản lý</option>
                            <option value="Nhân viên bán hàng" ${nhanVienEdit.tenChucVu == 'Nhân viên bán hàng' ? 'selected' : ''}>Nhân viên bán hàng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mã tài khoản</label>
                        <input type="text" name="maTK" value="${nhanVienEdit.maTK}"> <%-- Mã tài khoản --%>
                    </div>
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input type="text" name="tenDangNhap" value="${nhanVienEdit.tenDangNhap}" required> <%-- Tên đăng nhập --%>
                    </div>
                    <div class="form-group">
                        <label>Mật khẩu</label>
                        <input type="text" name="mauKhau" value="${nhanVienEdit.mauKhau}" required> <%-- Giữ đúng tên thuộc tính mauKhau trong code gốc --%>
                    </div>

                    <c:choose>
                        <c:when test="${not empty nhanVienEdit}"> <%-- Khi sửa mới hiện ô chọn trạng thái (có thể đổi Đang làm việc / Nghỉ việc) --%>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="trangThai">
                                    <option value="Đang làm việc" ${nhanVienEdit.trangThai == 'Đang làm việc' ? 'selected' : ''}>Đang làm việc</option>
                                    <option value="Nghỉ việc" ${nhanVienEdit.trangThai == 'Nghỉ việc' ? 'selected' : ''}>Nghỉ việc</option>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise> <%-- Khi thêm mới: ẩn trạng thái nghỉ việc và mặc định gửi Đang làm việc --%>
                            <input type="hidden" name="trangThai" value="Đang làm việc">
                        </c:otherwise>
                    </c:choose>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty nhanVienEdit ? 'Lưu cập nhật' : 'Thêm nhân viên'}
                </button>
                <c:if test="${not empty nhanVienEdit}">
                    <a href="${pageContext.request.contextPath}/NhanVien" class="btn-secondary">Hủy</a> <%-- Thoát chế độ sửa --%>
                </c:if>
            </form>
        </div>

        <%-- Khung tìm kiếm và bảng danh sách nhân viên --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Nhân Viên</h3>
                <form action="${pageContext.request.contextPath}/NhanVien" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên, SĐT hoặc chức vụ..."> <%-- Ô tìm kiếm nhân viên --%>
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
                            <c:forEach items="${ListNhanVien}" var="nhanVien"> <%-- Lặp qua danh sách nhân viên truyền từ Servlet --%>
                                <tr>
                                    <td>${nhanVien.maNV}</td> <%-- Mã nhân viên --%>
                                    <td>${nhanVien.hoTen}</td> <%-- Họ tên --%>
                                    <td>${nhanVien.ngaySinh}</td> <%-- Ngày sinh --%>
                                    <td>${nhanVien.gioiTinh}</td> <%-- Giới tính --%>
                                    <td>${nhanVien.quocTich}</td> <%-- Quốc tịch --%>
                                    <td>${nhanVien.queQuan}</td> <%-- Quê quán --%>
                                    <td>${nhanVien.noiThuongTru}</td> <%-- Nơi thường trú --%>
                                    <td>${nhanVien.SDT}</td> <%-- Số điện thoại --%>
                                    <td>${nhanVien.email}</td> <%-- Email --%>
                                    <td>${nhanVien.CCCD}</td> <%-- CCCD --%>
                                    <td>${nhanVien.tenChucVu}</td> <%-- Tên chức vụ --%>
                                    <td>${nhanVien.maTK}</td> <%-- Mã tài khoản --%>
                                    <td>${nhanVien.tenDangNhap}</td> <%-- Tên đăng nhập --%>
                                    <td>${nhanVien.mauKhau}</td> <%-- Mật khẩu (đúng tên field mauKhau của bạn) --%>
                                    <td>${nhanVien.trangThai}</td> <%-- Trạng thái làm việc --%>
                                    <td>
                                        <a class="btn-action" href="${pageContext.request.contextPath}/NhanVien?action=edit&id=${nhanVien.maNV}">Sửa</a> <%-- Nút sửa nhân viên --%>
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

</body>
</html>
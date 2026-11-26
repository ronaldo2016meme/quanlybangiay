<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%-- Khai báo trang JSP dùng UTF-8 để gõ tiếng Việt không bị lỗi font --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Thư viện JSTL chuẩn Jakarta EE --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <%-- Thư viện xử lý chuỗi để phân quyền --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm - AH9 Shoes</title>
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

        /* Nội dung chính bên phải */
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
            display: grid; /* Chia lưới các ô nhập thông tin sản phẩm */
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
        .file-hint {
            display: block;
            margin-top: 4px;
            font-size: 12px;
            color: #64748b;
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
            margin-right: 4px;
        }

        /* Bảng danh sách sản phẩm */
        .table-wrap {
            overflow-x: auto; /* Cho phép cuộn ngang khi bảng nhiều cột */
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
            vertical-align: middle;
        }
        thead th {
            background-color: #132232; /* Header bảng cùng tông xanh đen với sidebar */
            color: #ffffff;
            font-weight: 600;
        }
        tbody tr:hover {
            background-color: #f8fafc;
        }
        .thumb-img {
            width: 44px;
            height: 44px;
            object-fit: contain;
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 2px;
            display: block;
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
        <h2>Quản Lý Sản Phẩm</h2>
        <div><strong>Tổng sản phẩm:</strong> ${not empty listSanPham ? listSanPham.size() : 0}</div> <%-- Đếm tổng số sản phẩm --%>
    </div>

    <div class="container">
        <%-- Form thêm / cập nhật sản phẩm (hỗ trợ upload file ảnh PNG / JPG) --%>
        <div class="card-box">
            <h3>${not empty sanPhamEdit ? 'Cập Nhật Sản Phẩm' : 'Thêm Sản Phẩm Mới'}</h3> <%-- Tự đổi tiêu đề khi đang sửa --%>
            <form action="${pageContext.request.contextPath}/SanPham" method="POST" enctype="multipart/form-data"> <%-- Gửi dữ liệu + file ảnh về SanPhamServlet --%>
                <input type="hidden" name="action" value="${not empty sanPhamEdit ? 'update' : 'add'}"> <%-- Phân biệt thêm hay sửa --%>
                <c:if test="${not empty sanPhamEdit}">
                    <input type="hidden" name="maSP" value="${sanPhamEdit.maSP}"> <%-- Giữ mã sản phẩm khi sửa --%>
                    <input type="hidden" name="anhCu" value="${sanPhamEdit.anh}"> <%-- Giữ ảnh cũ nếu không chọn file mới --%>
                </c:if>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Tên sản phẩm</label>
                        <input type="text" name="tenSP" value="${sanPhamEdit.tenSP}" required> <%-- Tên sản phẩm --%>
                    </div>
                    <div class="form-group">
                        <label>Ảnh sản phẩm (PNG / JPG)</label>
                        <input type="file" name="anhFile" accept=".png,.jpg,.jpeg,image/png,image/jpeg"> <%-- Chỉ cho chọn file ảnh PNG hoặc JPG --%>
                        <c:if test="${not empty sanPhamEdit and not empty sanPhamEdit.anh}">
                            <span class="file-hint">Ảnh hiện tại: <strong>${sanPhamEdit.anh}</strong></span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label>Danh mục</label>
                        <select name="maDanhMuc">
                            <c:forEach items="${listDanhMuc}" var="dm">
                                <option value="${dm.maDanhMuc}" ${sanPhamEdit.danhMucSanPham.maDanhMuc == dm.maDanhMuc ? 'selected' : ''}>
                                        ${dm.tenDanhMuc}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Chất liệu</label>
                        <select name="maChatLieu">
                            <c:forEach items="${listChatLieu}" var="cl">
                                <option value="${cl.maChatLieu}" ${sanPhamEdit.chatLieu.maChatLieu == cl.maChatLieu ? 'selected' : ''}>
                                        ${cl.tenChatLieu}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Nhà cung cấp</label>
                        <select name="maNCC">
                            <c:forEach items="${listNCC}" var="ncc">
                                <option value="${ncc.maNCC}" ${sanPhamEdit.nhaCungCap.maNCC == ncc.maNCC ? 'selected' : ''}>
                                        ${ncc.tenNCC}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="moTa" value="${sanPhamEdit.moTa}"> <%-- Mô tả sản phẩm --%>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sanPhamEdit}"> <%-- Khi sửa mới hiện ô chọn trạng thái --%>
                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="trangThai">
                                    <option value="Đang kinh doanh" ${sanPhamEdit.trangThai == 'Đang kinh doanh' ? 'selected' : ''}>Đang kinh doanh</option>
                                    <option value="Hết hàng" ${sanPhamEdit.trangThai == 'Hết hàng' ? 'selected' : ''}>Hết hàng</option>
                                    <option value="Ngừng kinh doanh" ${sanPhamEdit.trangThai == 'Ngừng kinh doanh' ? 'selected' : ''}>Ngừng kinh doanh</option>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise> <%-- Khi thêm mới: ẩn trạng thái và mặc định gửi Đang kinh doanh --%>
                            <input type="hidden" name="trangThai" value="Đang kinh doanh">
                        </c:otherwise>
                    </c:choose>
                </div>

                <button type="submit" class="btn-primary">
                    ${not empty sanPhamEdit ? 'Lưu cập nhật' : 'Thêm sản phẩm'}
                </button>
                <c:if test="${not empty sanPhamEdit}">
                    <a href="${pageContext.request.contextPath}/SanPham" class="btn-secondary">Hủy</a> <%-- Thoát chế độ sửa --%>
                </c:if>
            </form>
        </div>

        <%-- Khung tìm kiếm và bảng danh sách sản phẩm --%>
        <div class="card-box">
            <div class="toolbar" style="margin-bottom: 14px;">
                <h3 style="margin: 0;">Danh Sách Sản Phẩm</h3>
                <form action="${pageContext.request.contextPath}/SanPham" method="GET" style="display:flex; gap:8px; flex-wrap:wrap;">
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm tên sản phẩm hoặc danh mục..."> <%-- Ô tìm kiếm sản phẩm --%>
                    <button type="submit" class="btn-primary">Tìm kiếm</button>
                </form>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Mã SP</th>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Mô tả</th>
                        <th>Ngày tạo</th>
                        <th>Ngày cập nhật</th>
                        <th>Danh mục</th>
                        <th>Chất liệu</th>
                        <th>Nhà cung cấp</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listSanPham}">
                            <c:forEach items="${listSanPham}" var="sp"> <%-- Lặp qua danh sách sản phẩm truyền từ Servlet --%>
                                <tr>
                                    <td>${sp.maSP}</td> <%-- Mã sản phẩm --%>
                                    <td>
                                        <c:if test="${not empty sp.anh}">
                                            <img class="thumb-img" src="${pageContext.request.contextPath}/img/${sp.anh}" alt="${sp.tenSP}"
                                                 onerror="this.style.display='none'">
                                        </c:if>
                                    </td> <%-- Ảnh sản phẩm --%>
                                    <td>${sp.tenSP}</td> <%-- Tên sản phẩm --%>
                                    <td>${sp.moTa}</td> <%-- Mô tả --%>
                                    <td>${sp.ngayTao}</td> <%-- Ngày tạo --%>
                                    <td>${sp.ngayCapNhat}</td> <%-- Ngày cập nhật --%>
                                    <td>${sp.danhMucSanPham.tenDanhMuc}</td> <%-- Danh mục --%>
                                    <td>${sp.chatLieu.tenChatLieu}</td> <%-- Chất liệu --%>
                                    <td>${sp.nhaCungCap.tenNCC}</td> <%-- Nhà cung cấp --%>
                                    <td>${sp.trangThai}</td> <%-- Trạng thái --%>
                                    <td>
                                        <a class="btn-action" href="${pageContext.request.contextPath}/SanPhamChiTiet?maSP=${sp.maSP}">Chi tiết</a> <%-- Nút xem chi tiết sản phẩm --%>
                                        <a class="btn-action" href="${pageContext.request.contextPath}/SanPham?action=edit&id=${sp.maSP}">Sửa</a> <%-- Nút sửa sản phẩm --%>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="11" class="empty-row">Chưa có dữ liệu sản phẩm.</td>
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
<%-- an --%>
</body>
</html>
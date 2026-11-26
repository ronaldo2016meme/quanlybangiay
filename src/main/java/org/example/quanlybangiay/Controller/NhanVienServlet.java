package org.example.quanlybangiay.Controller; // Package chứa các Servlet điều hướng

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.NhanVien;
import org.example.quanlybangiay.Repository.NhanVienRepo;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;

@WebServlet(name = "NhanVienServlet", value = "/NhanVien") // Khai báo đường dẫn /NhanVien
public class NhanVienServlet extends HttpServlet {

    NhanVienRepo nhanVienRepo = new NhanVienRepo(); // Tạo đối tượng Repo để gọi hàm thao tác CSDL

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt khi nhận dữ liệu
        response.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt khi trả dữ liệu

        String action = request.getParameter("action"); // Lấy hành động trên URL (ví dụ ?action=edit)
        String keyword = request.getParameter("keyword"); // Lấy từ khóa tìm kiếm (nếu có)

        // Khi bấm nút Sửa thì lấy nhân viên theo id để đổ lên form sửa
        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    Integer maNV = Integer.parseInt(idParam);
                    NhanVien nvEdit = nhanVienRepo.getById(maNV);
                    request.setAttribute("nhanVienEdit", nvEdit);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        // Lấy danh sách nhân viên: có từ khóa thì tìm kiếm, không có thì lấy tất cả
        List<NhanVien> listNhanVien = (keyword != null && !keyword.trim().isEmpty())
                ? nhanVienRepo.searchNhanVien(keyword)
                : nhanVienRepo.getAllNhanVien();

        request.setAttribute("ListNhanVien", listNhanVien); // Gửi danh sách sang trang JSP
        request.getRequestDispatcher("NhanVien.jsp").forward(request, response); // Chuyển tới NhanVien.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Giữ tiếng Việt không bị lỗi font khi gửi form
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action"); // Biết đang thêm ("add") hay sửa ("update")

        // Lấy toàn bộ dữ liệu người dùng nhập từ form NhanVien.jsp
        String hoTen = request.getParameter("hoTen");
        String ngaySinhStr = request.getParameter("ngaySinh");
        String gioiTinh = request.getParameter("gioiTinh");
        String quocTich = request.getParameter("quocTich");
        String queQuan = request.getParameter("queQuan");
        String noiThuongTru = request.getParameter("noiThuongTru");
        String sdt = request.getParameter("SDT");
        String email = request.getParameter("email");
        String cccd = request.getParameter("CCCD");
        String tenChucVu = request.getParameter("tenChucVu");
        String maTKStr = request.getParameter("maTK");
        String tenDangNhap = request.getParameter("tenDangNhap");
        String mauKhau = request.getParameter("mauKhau");

        // Nếu là thêm nhân viên mới thì kiểm tra đủ các điều kiện
        if (!"update".equals(action)) {
            // 1. Tất cả các ô đều phải nhập
            if (isBlank(hoTen) || isBlank(ngaySinhStr) || isBlank(gioiTinh)
                    || isBlank(quocTich) || isBlank(queQuan) || isBlank(noiThuongTru)
                    || isBlank(sdt) || isBlank(email) || isBlank(cccd)
                    || isBlank(tenChucVu) || isBlank(maTKStr)
                    || isBlank(tenDangNhap) || isBlank(mauKhau)) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tất cả thông tin nhân viên!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }

            // 2. Kiểm tra phải đủ 18 tuổi tính đến ngày hiện tại
            try {
                LocalDate ngaySinh = LocalDate.parse(ngaySinhStr.trim());
                int tuoi = Period.between(ngaySinh, LocalDate.now()).getYears();
                if (ngaySinh.isAfter(LocalDate.now()) || tuoi < 18) {
                    request.setAttribute("errorMessage", "Nhân viên phải đủ 18 tuổi trở lên!");
                    request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                    request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Ngày sinh không hợp lệ!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }

            // 3. Số điện thoại phải đúng 10 chữ số
            if (!sdt.trim().matches("\\d{10}")) {
                request.setAttribute("errorMessage", "Số điện thoại phải gồm đúng 10 chữ số!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }

            // 4. Email phải đúng định dạng @shop.vn (ví dụ: ten@shop.vn)
            if (!email.trim().toLowerCase().matches("^[a-zA-Z0-9._-]+@shop\\.vn$")) {
                request.setAttribute("errorMessage", "Email phải đúng định dạng @shop.vn (VD: nv1@shop.vn)!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }

            // 5. CCCD phải đúng 12 chữ số
            if (!cccd.trim().matches("\\d{12}")) {
                request.setAttribute("errorMessage", "CCCD phải gồm đúng 12 chữ số!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }

            // 6. Không được trùng tên đăng nhập, SĐT, email hoặc CCCD
            if (nhanVienRepo.isTrungTenDangNhap(tenDangNhap, null)) {
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }
            if (nhanVienRepo.isTrungSDT(sdt, null)) {
                request.setAttribute("errorMessage", "Số điện thoại đã tồn tại trong hệ thống!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }
            if (nhanVienRepo.isTrungEmail(email, null)) {
                request.setAttribute("errorMessage", "Email đã tồn tại trong hệ thống!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }
            if (nhanVienRepo.isTrungCCCD(cccd, null)) {
                request.setAttribute("errorMessage", "CCCD đã tồn tại trong hệ thống!");
                request.setAttribute("ListNhanVien", nhanVienRepo.getAllNhanVien());
                request.getRequestDispatcher("NhanVien.jsp").forward(request, response);
                return;
            }
        }

        // Gán dữ liệu vào đối tượng NhanVien
        NhanVien nv = new NhanVien();
        nv.setHoTen(hoTen != null ? hoTen.trim() : null);

        if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
            nv.setNgaySinh(Date.valueOf(ngaySinhStr)); // Đổi chuỗi ngày sang java.sql.Date
        }

        nv.setGioiTinh(gioiTinh);
        nv.setQuocTich(quocTich != null ? quocTich.trim() : null);
        nv.setQueQuan(queQuan != null ? queQuan.trim() : null);
        nv.setNoiThuongTru(noiThuongTru != null ? noiThuongTru.trim() : null);
        nv.setSDT(sdt != null ? sdt.trim() : null);
        nv.setEmail(email != null ? email.trim().toLowerCase() : null);
        nv.setCCCD(cccd != null ? cccd.trim() : null);
        nv.setTenChucVu(tenChucVu);

        if (maTKStr != null && !maTKStr.trim().isEmpty()) {
            try {
                nv.setMaTK(Integer.parseInt(maTKStr.trim())); // Đổi mã tài khoản sang số nguyên
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        nv.setTenDangNhap(tenDangNhap != null ? tenDangNhap.trim() : null);
        nv.setMauKhau(mauKhau);

        if ("update".equals(action)) {
            // Cập nhật thông tin nhân viên đã có
            String maNVStr = request.getParameter("maNV");
            if (maNVStr != null && !maNVStr.isEmpty()) {
                nv.setMaNV(Integer.parseInt(maNVStr));
            }
            String trangThai = request.getParameter("trangThai");
            nv.setTrangThai((trangThai != null && !trangThai.isEmpty()) ? trangThai : "Đang làm việc");
            nhanVienRepo.updateNhanVien(nv);
        } else {
            // Thêm mới luôn mặc định trạng thái là "Đang làm việc"
            nv.setTrangThai("Đang làm việc");
            nhanVienRepo.addNhanVien(nv);
        }

        // Chuyển hướng về /NhanVien để tải lại danh sách mới nhất
        response.sendRedirect(request.getContextPath() + "/NhanVien");
    }

    // Hàm kiểm tra chuỗi rỗng hoặc chỉ có dấu cách
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
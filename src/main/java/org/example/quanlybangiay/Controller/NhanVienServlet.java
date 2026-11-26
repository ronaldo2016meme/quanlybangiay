package org.example.quanlybangiay.Controller; // Package Controller chứa các Servlet

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.NhanVien;
import org.example.quanlybangiay.Repository.NhanVienRepo;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "NhanVienServlet", value = "/NhanVien") // Đường dẫn /NhanVien
public class NhanVienServlet extends HttpServlet {

    NhanVienRepo nhanVienRepo = new NhanVienRepo(); // Khởi tạo Repo để thao tác dữ liệu

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Hỗ trợ tiếng Việt khi nhận dữ liệu
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action"); // Lấy hành động trên URL (nếu có)
        String keyword = request.getParameter("keyword"); // Lấy từ khóa tìm kiếm (nếu có)

        // Nếu người dùng bấm nút "Sửa" trên dòng nhân viên
        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    Integer maNV = Integer.parseInt(idParam);
                    NhanVien nvEdit = nhanVienRepo.getById(maNV); // Tìm nhân viên theo mã
                    request.setAttribute("nhanVienEdit", nvEdit); // Gửi sang JSP để đổ vào form sửa
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        // Lấy danh sách nhân viên (có tìm kiếm nếu nhập keyword, không thì lấy tất cả)
        List<NhanVien> listNhanVien;
        if (keyword != null && !keyword.trim().isEmpty()) {
            listNhanVien = nhanVienRepo.searchNhanVien(keyword);
        } else {
            listNhanVien = nhanVienRepo.getAllNhanVien();
        }

        request.setAttribute("ListNhanVien", listNhanVien); // Giữ đúng tên attribute ListNhanVien như code cũ của bạn
        request.getRequestDispatcher("NhanVien.jsp").forward(request, response); // Chuyển sang trang NhanVien.jsp
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Đảm bảo tiếng Việt khi submit form không bị lỗi dấu
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action"); // Kiểm tra là "add" hay "update"

        // Lấy các giá trị từ form trong NhanVien.jsp
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
        String trangThai = request.getParameter("trangThai");

        NhanVien nv = new NhanVien();
        nv.setHoTen(hoTen);
        if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
            nv.setNgaySinh(Date.valueOf(ngaySinhStr)); // Đổi chuỗi yyyy-MM-dd từ <input type="date"> sang java.sql.Date
        }
        nv.setGioiTinh(gioiTinh);
        nv.setQuocTich(quocTich);
        nv.setQueQuan(queQuan);
        nv.setNoiThuongTru(noiThuongTru);
        nv.setSDT(sdt);
        nv.setEmail(email);
        nv.setCCCD(cccd);
        nv.setTenChucVu(tenChucVu);

        // Nếu maTK nhập số thì ép kiểu Integer (nếu class NhanVien của bạn để String thì đổi sang nv.setMaTK(maTKStr))
        if (maTKStr != null && !maTKStr.trim().isEmpty()) {
            try {
                nv.setMaTK(Integer.parseInt(maTKStr.trim()));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        nv.setTenDangNhap(tenDangNhap);
        nv.setMauKhau(mauKhau);

        if ("update".equals(action)) {
            // Cập nhật nhân viên đã có
            String maNVStr = request.getParameter("maNV");
            if (maNVStr != null && !maNVStr.isEmpty()) {
                nv.setMaNV(Integer.parseInt(maNVStr));
            }
            // Khi sửa thì giữ trạng thái người dùng chọn, nếu rỗng thì mặc định "Đang làm việc"
            nv.setTrangThai((trangThai != null && !trangThai.isEmpty()) ? trangThai : "Đang làm việc");
            nhanVienRepo.updateNhanVien(nv);
        } else {
            // Thêm nhân viên mới: luôn mặc định trạng thái là "Đang làm việc"
            nv.setTrangThai("Đang làm việc");
            nhanVienRepo.addNhanVien(nv);
        }

        // Load lại danh sách sau khi thêm / sửa (dùng redirect để F5 không bị gửi lại form)
        response.sendRedirect(request.getContextPath() + "/NhanVien");
    }
}
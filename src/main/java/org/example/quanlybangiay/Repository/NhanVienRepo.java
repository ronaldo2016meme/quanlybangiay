package org.example.quanlybangiay.Repository; // Package chứa các class thao tác với CSDL bằng Hibernate

import org.example.quanlybangiay.Model.NhanVien; // Gọi class Model NhanVien
import org.example.quanlybangiay.Util.HibernateConfig; // Gọi class cấu hình kết nối Hibernate
import org.hibernate.Session; // Đối tượng mở phiên làm việc với CSDL
import org.hibernate.Transaction; // Đối tượng quản lý giao dịch khi thêm/sửa dữ liệu

import java.util.List;

public class NhanVienRepo {

    // 1. Lấy toàn bộ danh sách nhân viên
    public List<NhanVien> getAllNhanVien() {
        Session session = HibernateConfig.getFACTORY().openSession(); // Mở phiên làm việc mới
        try {
            return session.createQuery("FROM NhanVien", NhanVien.class).getResultList(); // Lấy tất cả nhân viên từ DB
        } finally {
            session.close(); // Đóng session sau khi dùng xong
        }
    }

    // 2. Tìm kiếm nhân viên theo họ tên, số điện thoại hoặc chức vụ
    public List<NhanVien> searchNhanVien(String keyword) {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = "FROM NhanVien nv WHERE LOWER(nv.hoTen) LIKE :kw " +
                    "OR LOWER(nv.SDT) LIKE :kw " +
                    "OR LOWER(nv.tenChucVu) LIKE :kw"; // Tìm gần đúng không phân biệt hoa thường
            var query = session.createQuery(hql, NhanVien.class);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%"); // Truyền từ khóa vào câu lệnh
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    // 3. Tìm 1 nhân viên theo mã nhân viên (dùng khi bấm nút Sửa)
    public NhanVien getById(Integer maNV) {
        if (maNV == null) {
            return null;
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            return session.find(NhanVien.class, maNV); // Tìm nhân viên theo khóa chính
        } finally {
            session.close();
        }
    }

    // 4. Thêm nhân viên mới (luôn mặc định trạng thái là "Đang làm việc")
    public void addNhanVien(NhanVien nv) {
        nv.setTrangThai("Đang làm việc"); // Ép mặc định trạng thái khi thêm mới
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction(); // Bắt đầu giao dịch lưu dữ liệu
        try {
            session.persist(nv); // Thêm bản ghi mới vào CSDL
            tx.commit(); // Xác nhận lưu thành công
        } catch (Exception e) {
            tx.rollback(); // Nếu có lỗi thì hoàn tác
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // 5. Cập nhật thông tin nhân viên
    public void updateNhanVien(NhanVien nv) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction();
        try {
            session.merge(nv); // Cập nhật dữ liệu nhân viên
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // 6. Kiểm tra trùng tên đăng nhập bằng vòng lặp Java (đổi getter nếu tên khác)
    public boolean isTrungTenDangNhap(String tenDangNhap, Integer excludeMaNV) {
        if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) {
            return false;
        }
        String target = tenDangNhap.trim().toLowerCase();
        for (NhanVien nv : getAllNhanVien()) {
            if (excludeMaNV != null && nv.getMaNV() != null && nv.getMaNV().equals(excludeMaNV)) {
                continue; // Bỏ qua chính nhân viên đang sửa
            }
            if (nv.getTenDangNhap() != null && nv.getTenDangNhap().trim().toLowerCase().equals(target)) {
                return true;
            }
        }
        return false;
    }

    // 7. Kiểm tra trùng số điện thoại
    public boolean isTrungSDT(String sdt, Integer excludeMaNV) {
        if (sdt == null || sdt.trim().isEmpty()) {
            return false;
        }
        String target = sdt.trim();
        for (NhanVien nv : getAllNhanVien()) {
            if (excludeMaNV != null && nv.getMaNV() != null && nv.getMaNV().equals(excludeMaNV)) {
                continue;
            }
            if (nv.getSDT() != null && nv.getSDT().trim().equals(target)) {
                return true;
            }
        }
        return false;
    }

    // 8. Kiểm tra trùng Email
    public boolean isTrungEmail(String email, Integer excludeMaNV) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String target = email.trim().toLowerCase();
        for (NhanVien nv : getAllNhanVien()) {
            if (excludeMaNV != null && nv.getMaNV() != null && nv.getMaNV().equals(excludeMaNV)) {
                continue;
            }
            if (nv.getEmail() != null && nv.getEmail().trim().toLowerCase().equals(target)) {
                return true;
            }
        }
        return false;
    }

    // 9. Kiểm tra trùng CCCD
    public boolean isTrungCCCD(String cccd, Integer excludeMaNV) {
        if (cccd == null || cccd.trim().isEmpty()) {
            return false;
        }
        String target = cccd.trim();
        for (NhanVien nv : getAllNhanVien()) {
            if (excludeMaNV != null && nv.getMaNV() != null && nv.getMaNV().equals(excludeMaNV)) {
                continue;
            }
            if (nv.getCCCD() != null && nv.getCCCD().trim().equals(target)) {
                return true;
            }
        }
        return false;
    }

    // 10. Hàm kiểm tra đăng nhập giữ nguyên như cũ
    public NhanVien dangNhap(String tenDangNhap, String matKhau) {
        if (tenDangNhap == null || matKhau == null) {
            return null;
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String sql = "SELECT * FROM NhanVien WHERE TenDangNhap = :user AND MauKhau = :pass";
            var query = session.createNativeQuery(sql, NhanVien.class);
            query.setParameter("user", tenDangNhap);
            query.setParameter("pass", matKhau);

            List<NhanVien> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            session.close();
        }
    }
}
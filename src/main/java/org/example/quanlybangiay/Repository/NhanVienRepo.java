package org.example.quanlybangiay.Repository; // Package Repository thao tác CSDL bằng Hibernate

import org.example.quanlybangiay.Model.NhanVien; // Model NhanVien
import org.example.quanlybangiay.Util.HibernateConfig; // Class cấu hình SessionFactory của Hibernate
import org.hibernate.Session; // Session làm việc với Hibernate
import org.hibernate.Transaction; // Transaction để lưu / cập nhật dữ liệu

import java.util.List;

public class NhanVienRepo {

    // Lấy toàn bộ danh sách nhân viên
    public List<NhanVien> getAllNhanVien() {
        Session session = HibernateConfig.getFACTORY().openSession(); // Mở session mới
        try {
            return session.createQuery("FROM NhanVien", NhanVien.class).getResultList(); // Lấy tất cả bản ghi NhanVien
        } finally {
            session.close(); // Luôn đóng session sau khi dùng xong
        }
    }

    // Tìm nhân viên theo từ khóa (họ tên, số điện thoại hoặc chức vụ)
    public List<NhanVien> searchNhanVien(String keyword) {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = "FROM NhanVien nv WHERE LOWER(nv.hoTen) LIKE :kw " +
                    "OR LOWER(nv.SDT) LIKE :kw " +
                    "OR LOWER(nv.tenChucVu) LIKE :kw"; // Câu lệnh HQL tìm kiếm gần đúng không phân biệt hoa thường
            var query = session.createQuery(hql, NhanVien.class);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%"); // Gắn tham số tìm kiếm
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    // Tìm 1 nhân viên theo mã nhân viên để đổ lên form sửa
    public NhanVien getById(Integer maNV) {
        if (maNV == null) {
            return null;
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            return session.find(NhanVien.class, maNV); // Tìm nhân viên theo khóa chính maNV
        } finally {
            session.close();
        }
    }

    // Thêm nhân viên mới (mặc định trạng thái là "Đang làm việc")
    public void addNhanVien(NhanVien nv) {
        nv.setTrangThai("Đang làm việc"); // Ép mặc định khi thêm mới luôn là Đang làm việc
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction(); // Bắt đầu giao dịch
        try {
            session.persist(nv); // Lưu nhân viên mới vào DB
            tx.commit(); // Xác nhận lưu
        } catch (Exception e) {
            tx.rollback(); // Nếu lỗi thì hoàn tác để không hỏng dữ liệu
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // Cập nhật thông tin nhân viên
    public void updateNhanVien(NhanVien nv) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction();
        try {
            session.merge(nv); // Cập nhật bản ghi theo khóa chính
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // Hàm kiểm tra đăng nhập giữ nguyên theo code của bạn
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
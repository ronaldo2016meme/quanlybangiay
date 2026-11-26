package org.example.quanlybangiay.Repository;

import org.example.quanlybangiay.Model.KhachHang;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KhachHangRepo {

    // Lấy toàn bộ khách hàng
    public List<KhachHang> getAllKhachHang() {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            return session.createQuery("FROM KhachHang", KhachHang.class).getResultList();
        } finally {
            session.close();
        }
    }

    // Tìm kiếm khách hàng theo họ tên hoặc SĐT
    public List<KhachHang> searchKhachHang(String keyword) {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = "FROM KhachHang kh WHERE LOWER(kh.hoTen) LIKE :kw OR LOWER(kh.sdt) LIKE :kw";
            var query = session.createQuery(hql, KhachHang.class);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    // Tìm 1 khách hàng theo ID để đổ lên form sửa
    public KhachHang getById(Integer maKH) {
        if (maKH == null) return null;
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            return session.find(KhachHang.class, maKH);
        } finally {
            session.close();
        }
    }

    // Thêm khách hàng mới
    public void addKhachHang(KhachHang kh) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction();
        try {
            session.persist(kh);
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }

    // Cập nhật thông tin khách hàng
    public void updateKhachHang(KhachHang kh) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = session.beginTransaction();
        try {
            session.merge(kh);
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }
    }
}
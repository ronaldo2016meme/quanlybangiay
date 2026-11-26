package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.SanPhamChiTiet;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class SanPhamChiTietRepo {
    public List<SanPhamChiTiet> getAllSanPhamChiTiet() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM SanPhamChiTiet");
        List<SanPhamChiTiet> listSanPhamChiTiet = query.getResultList();
        return listSanPhamChiTiet;
    }
    // Lấy 1 biến thể theo maSPCT (hỗ trợ cả kiểu Integer hoặc String)
    public SanPhamChiTiet getSanPhamChiTietById(Object id) {
        if (id == null) {
            return null;
        }
        String rawId = id.toString().trim();
        if (rawId.isEmpty()) {
            return null;
        }
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            try {
                Integer intId = Integer.parseInt(rawId);
                return session.get(SanPhamChiTiet.class, intId);
            } catch (NumberFormatException e) {
                return session.get(SanPhamChiTiet.class, rawId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Thêm biến thể sản phẩm chi tiết mới vào database
    public boolean addSanPhamChiTiet(SanPhamChiTiet spct) {
        if (spct == null) {
            return false;
        }
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.persist(spct);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật thông tin biến thể sản phẩm chi tiết vào database
    public boolean updateSanPhamChiTiet(SanPhamChiTiet spct) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.merge(spct);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
}

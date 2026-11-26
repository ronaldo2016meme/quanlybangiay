package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.SanPham;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class SanPhamRepo {
    public List<SanPham> getAllSanPham() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM SanPham");
        List<SanPham> listSanPham = query.getResultList();
        return listSanPham;
    }
    // Tìm kiếm sản phẩm theo tên sản phẩm hoặc tên danh mục
    public List<SanPham> searchSanPham(String keyword) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "FROM SanPham sp WHERE LOWER(sp.tenSP) LIKE :kw OR LOWER(sp.danhMucSanPham.tenDanhMuc) LIKE :kw";
            Query query = session.createQuery(hql, SanPham.class);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            return query.getResultList();
        }
    }

    // Lấy 1 sản phẩm theo mã (hỗ trợ cả mã kiểu int hoặc String nếu cần)
    public SanPham getSanPhamById(Object id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            if (id == null) return null;
            try {
                Integer intId = Integer.parseInt(id.toString().trim());
                return session.get(SanPham.class, intId);
            } catch (NumberFormatException e) {
                return session.get(SanPham.class, id.toString().trim());
            }
        }
    }

    // Thêm sản phẩm mới vào database
    public boolean addSanPham(SanPham sp) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.persist(sp);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
}

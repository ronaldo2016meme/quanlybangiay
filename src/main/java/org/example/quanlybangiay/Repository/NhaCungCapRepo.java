package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.NhaCungCap;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class NhaCungCapRepo {
    public List<NhaCungCap> getAllNhaCungCap() {
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            Query query = session.createQuery("FROM NhaCungCap ORDER BY maNCC DESC");
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    public NhaCungCap getNhaCungCapById(Integer id) {
        if (id == null) {
            return null;
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            return session.get(NhaCungCap.class, id);
        } finally {
            session.close();
        }
    }

    public List<NhaCungCap> searchNhaCungCap(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return getAllNhaCungCap();
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        try {
            String hql = "FROM NhaCungCap WHERE LOWER(tenNCC) LIKE :kw OR sdt LIKE :kw OR LOWER(email) LIKE :kw OR LOWER(diaChi) LIKE :kw ORDER BY maNCC DESC";
            Query query = session.createQuery(hql);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            return query.getResultList();
        } finally {
            session.close();
        }
    }

    public void addNhaCungCap(NhaCungCap ncc) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.persist(ncc);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void updateNhaCungCap(NhaCungCap ncc) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.merge(ncc);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
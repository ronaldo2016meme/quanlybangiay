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
        Query query = (Query) session.createQuery("FROM NhaCungCap ORDER BY maNCC DESC");
        List<NhaCungCap> listNhaCungCap = query.getResultList();
        session.close();
        return listNhaCungCap;
    }

    public NhaCungCap getNhaCungCapById(Integer id) {
        Session session = HibernateConfig.getFACTORY().openSession();
        NhaCungCap item = session.get(NhaCungCap.class, id);
        session.close();
        return item;
    }

    public List<NhaCungCap> searchNhaCungCap(String keyword) {
        Session session = HibernateConfig.getFACTORY().openSession();
        String hql = "FROM NhaCungCap WHERE LOWER(tenNCC) LIKE :kw OR sdt LIKE :kw OR LOWER(email) LIKE :kw OR LOWER(diaChi) LIKE :kw ORDER BY maNCC DESC";
        Query query = (Query) session.createQuery(hql);
        query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        List<NhaCungCap> listNhaCungCap = query.getResultList();
        session.close();
        return listNhaCungCap;
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
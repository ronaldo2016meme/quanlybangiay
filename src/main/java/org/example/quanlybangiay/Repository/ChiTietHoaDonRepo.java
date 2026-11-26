package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.ChiTietHoaDon;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Collections;
import java.util.List;

public class ChiTietHoaDonRepo {
    public List<ChiTietHoaDon> getByMaHD(Integer maHD) {
        if (maHD == null) {
            return Collections.emptyList();
        }
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM ChiTietHoaDon WHERE hoaDon.MaHD = :maHD ORDER BY maCTHD DESC");
        query.setParameter("maHD", maHD);
        List<ChiTietHoaDon> list = query.getResultList();
        session.close();
        return list;
    }

    public ChiTietHoaDon getChiTietHoaDonById(Integer id) {
        Session session = HibernateConfig.getFACTORY().openSession();
        ChiTietHoaDon item = session.get(ChiTietHoaDon.class, id);
        session.close();
        return item;
    }

    public void updateChiTietHoaDon(ChiTietHoaDon cthd) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.merge(cthd);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        } finally {
            session.close();
        }
    }
}
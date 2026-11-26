package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.HoaDon;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class HoaDonRepo {
    public List<HoaDon> getAllHoaDon() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM HoaDon ORDER BY MaHD DESC");
        List<HoaDon> listHoaDon = query.getResultList();
        session.close();
        return listHoaDon;
    }

    public HoaDon getHoaDonById(Integer id) {
        Session session = HibernateConfig.getFACTORY().openSession();
        HoaDon hoaDon = session.get(HoaDon.class, id);
        session.close();
        return hoaDon;
    }

    public List<HoaDon> searchHoaDon(String keyword, String trangThai) {
        Session session = HibernateConfig.getFACTORY().openSession();
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        boolean hasTrangThai = trangThai != null && !trangThai.isBlank();
        Integer maHDSearch = null;

        if (hasKeyword) {
            try {
                maHDSearch = Integer.parseInt(keyword.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        StringBuilder hql = new StringBuilder("FROM HoaDon WHERE 1=1");
        if (hasKeyword) {
            if (maHDSearch != null) {
                hql.append(" AND (maHD = :maHD OR LOWER(hoTen) LIKE :kw OR sdt LIKE :kw)");
            } else {
                hql.append(" AND (LOWER(hoTen) LIKE :kw OR sdt LIKE :kw)");
            }
        }
        if (hasTrangThai) {
            hql.append(" AND trangThaiHoaDon = :tt");
        }
        hql.append(" ORDER BY maHD DESC");

        Query query = session.createQuery(hql.toString());
        if (hasKeyword) {
            if (maHDSearch != null) {
                query.setParameter("maHD", maHDSearch);
            }
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        }
        if (hasTrangThai) {
            query.setParameter("tt", trangThai.trim());
        }

        List<HoaDon> listHoaDon = query.getResultList();
        session.close();
        return listHoaDon;
    }

    public void updateHoaDon(HoaDon hoaDon) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.merge(hoaDon);
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
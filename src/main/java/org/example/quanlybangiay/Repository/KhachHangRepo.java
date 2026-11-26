package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;

import org.example.quanlybangiay.Model.KhachHang;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class KhachHangRepo {
    public List<KhachHang> getAllKhachHang() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = (Query) session.createQuery("FROM KhachHang");
        List<KhachHang> ListKhachHang = query.getResultList();
        return ListKhachHang;
    }
}

// Hung
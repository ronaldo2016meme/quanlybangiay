package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.DanhMucSanPham;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;


public class DanhMucSanPhamRepo {
    public List<DanhMucSanPham> getAllDanhMucSanPham() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM DanhMucSanPham");
        List<DanhMucSanPham> listDanhMuc = query.getResultList();
        return listDanhMuc;
    }
}
//    an

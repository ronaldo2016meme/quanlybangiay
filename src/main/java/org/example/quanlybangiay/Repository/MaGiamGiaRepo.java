package org.example.quanlybangiay.Repository;


import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.MaGiamGia;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class MaGiamGiaRepo {
    public List<MaGiamGia> getAllMaGiamGia() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = (Query) session.createQuery("FROM MaGiamGia");
        List<MaGiamGia> ListMaGiamGia = query.getResultList();
        return ListMaGiamGia;
    }

}

// Hung

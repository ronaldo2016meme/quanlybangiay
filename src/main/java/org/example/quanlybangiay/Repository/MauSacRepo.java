package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.MauSac;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class MauSacRepo {
    public List<MauSac> getAllMauSac() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM MauSac");
        List<MauSac> listMauSac = query.getResultList();
        return listMauSac;
    }
}
//    an

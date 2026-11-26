package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.Size;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class SizeRepo {
    public List<Size> getAllSize(){
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM Size");
        List<Size> ListSize = query.getResultList();
        return ListSize;
    }
}
//    an

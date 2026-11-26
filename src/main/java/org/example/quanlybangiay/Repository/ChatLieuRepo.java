package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.ChatLieu;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ChatLieuRepo {
    public List<ChatLieu> getAllChatLieu() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = (Query) session.createQuery("FROM ChatLieu ORDER BY maChatLieu DESC");
        List<ChatLieu> listChatLieu = query.getResultList();
        session.close();
        return listChatLieu;
    }

    public ChatLieu getChatLieuById(Integer id) {
        Session session = HibernateConfig.getFACTORY().openSession();
        ChatLieu item = session.get(ChatLieu.class, id);
        session.close();
        return item;
    }

    public List<ChatLieu> searchChatLieu(String keyword) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = (Query) session.createQuery("FROM ChatLieu WHERE LOWER(tenChatLieu) LIKE :kw ORDER BY maChatLieu DESC");
        query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        List<ChatLieu> listChatLieu = query.getResultList();
        session.close();
        return listChatLieu;
    }

    public void addChatLieu(ChatLieu cl) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.persist(cl);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void updateChatLieu(ChatLieu cl) {
        Session session = HibernateConfig.getFACTORY().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.merge(cl);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
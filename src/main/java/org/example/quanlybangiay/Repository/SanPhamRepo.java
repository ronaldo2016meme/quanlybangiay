package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.MauSac;
import org.example.quanlybangiay.Model.SanPham;
import org.example.quanlybangiay.Model.SanPhamChiTiet;
import org.example.quanlybangiay.Model.Size;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;


import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

public class SanPhamRepo {
    public List<SanPham> getAllSanPham() {
        Session session = HibernateConfig.getFACTORY().openSession();
        Query query = session.createQuery("FROM SanPham");
        List<SanPham> listSanPham = query.getResultList();
        return listSanPham;
    }
    // Tìm kiếm sản phẩm theo tên sản phẩm hoặc tên danh mục
    public List<SanPham> searchSanPham(String keyword) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "FROM SanPham sp WHERE LOWER(sp.tenSP) LIKE :kw OR LOWER(sp.danhMucSanPham.tenDanhMuc) LIKE :kw";
            Query query = session.createQuery(hql, SanPham.class);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy 1 sản phẩm theo mã (hỗ trợ cả mã kiểu int hoặc String nếu cần)
    public SanPham getSanPhamById(Object id) {
        if (id == null) {
            return null;
        }
        String rawId = id.toString().trim();
        if (rawId.isEmpty()) {
            return null;
        }
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            try {
                Integer intId = Integer.parseInt(rawId);
                return session.get(SanPham.class, intId);
            } catch (NumberFormatException e) {
                return session.get(SanPham.class, rawId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Thêm sản phẩm mới và tự động thêm luôn sản phẩm chi tiết trong cùng 1 transaction
    public boolean addSanPham(SanPham sp, List<SanPhamChiTiet> chiTiets) {
        if (sp == null) {
            return false;
        }
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            if (sp.getNgayTao() == null) {
                sp.setNgayTao(LocalDateTime.now());
            }
            session.persist(sp);
            session.flush(); // Đảm bảo sp có maSP trước khi persist các SanPhamChiTiet

            if (chiTiets != null && !chiTiets.isEmpty()) {
                for (SanPhamChiTiet spct : chiTiets) {
                    if (spct != null) {
                        spct.setSanPham(sp);
                        session.persist(spct);
                    }
                }
            } else {
                // Nếu chưa truyền biến thể nào thì tự tạo 1 biến thể mặc định từ MauSac & Size đầu tiên có trong DB
                MauSac defaultMau = session.createQuery("FROM MauSac ORDER BY maMau ASC", MauSac.class)
                        .setMaxResults(1)
                        .uniqueResult();
                Size defaultSize = session.createQuery("FROM Size ORDER BY maSize ASC", Size.class)
                        .setMaxResults(1)
                        .uniqueResult();

                if (defaultMau != null && defaultSize != null) {
                    SanPhamChiTiet defaultSpct = new SanPhamChiTiet();
                    defaultSpct.setSanPham(sp);
                    defaultSpct.setMauSac(defaultMau);
                    defaultSpct.setSize(defaultSize);
                    defaultSpct.setGiaBan(0.0);
                    defaultSpct.setGiaNhap(0.0);
                    defaultSpct.setSoLuongTon(0);
                    defaultSpct.setTrangThai("Còn hàng");
                    session.persist(defaultSpct);
                }
            }

            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }

    // Giữ overload cũ để tương thích nếu nơi khác gọi addSanPham(sp)
    public boolean addSanPham(SanPham sp) {
        return addSanPham(sp, null);
    }

    // Cập nhật thông tin sản phẩm vào database
    public boolean updateSanPham(SanPham sp) {
        if (sp == null) {
            return false;
        }
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.merge(sp);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
}

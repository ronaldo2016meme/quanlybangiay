package org.example.quanlybangiay.Repository;

import jakarta.persistence.Query;
import org.example.quanlybangiay.Model.HoaDon;
import org.example.quanlybangiay.Model.ChiTietHoaDon;
import org.example.quanlybangiay.Model.SanPhamChiTiet;
import org.example.quanlybangiay.Util.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

public class BanHangRepo {

    // Lấy toàn bộ biến thể giày (kèm tên sản phẩm, size, màu, giá bán, tồn kho) để bày lên màn hình bán hàng
    public List<SanPhamChiTiet> getAllBienThe() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) { // Tự đóng Session sau khi xong để tránh rò rỉ kết nối
            Query query = session.createQuery("FROM SanPhamChiTiet ORDER BY maSPCT DESC");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // Trả về list rỗng an toàn nếu có lỗi truy vấn
        }
    }

    // Tìm biến thể theo tên sản phẩm, tên màu hoặc tên size (không phân biệt hoa/thường)
    public List<SanPhamChiTiet> searchBienThe(String keyword) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "FROM SanPhamChiTiet spct WHERE LOWER(spct.sanPham.tenSP) LIKE :kw "
                    + "OR LOWER(spct.mauSac.tenMau) LIKE :kw "
                    + "OR LOWER(spct.size.tenSize) LIKE :kw";
            Query query = session.createQuery(hql);
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Lấy 1 biến thể theo mã khóa chính để kiểm tra tồn kho và giá bán khi thêm vào giỏ
    public SanPhamChiTiet getBienTheById(int maSPCT) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.get(SanPhamChiTiet.class, maSPCT);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Thực hiện thanh toán: tạo hóa đơn + chi tiết hóa đơn + trừ tồn kho trong cùng 1 transaction
    public boolean thanhToan(HoaDon hoaDon, List<ChiTietHoaDon> chiTiets) {
        if (hoaDon == null || chiTiets == null || chiTiets.isEmpty()) {
            return false; // Không cho thanh toán nếu thiếu hóa đơn hoặc giỏ hàng rỗng
        }
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction(); // Bắt đầu giao dịch nguyên tử (all-or-nothing)

            if (hoaDon.getNgayLap() == null) {
                hoaDon.setNgayLap(LocalDateTime.now()); // Gán ngày lập hóa đơn nếu chưa có
            }
            session.persist(hoaDon);
            session.flush(); // Đẩy hóa đơn xuống để sinh khóa chính trước khi gắn vào HoaDonChiTiet

            double tongTien = 0.0;
            for (ChiTietHoaDon item : chiTiets) {
                // Đọc lại bản ghi mới nhất từ DB trong transaction để tránh lệch tồn kho
                SanPhamChiTiet spctDB = session.get(SanPhamChiTiet.class, item.getSanPhamChiTiet().getMaSPCT());
                if (spctDB == null) {
                    throw new IllegalStateException("Không tìm thấy biến thể sản phẩm");
                }

                int tonHienTai = spctDB.getSoLuongTon() != null ? spctDB.getSoLuongTon() : 0;
                int soLuongMua = item.getSoLuong();
                if (soLuongMua <= 0 || tonHienTai < soLuongMua) {
                    // Ném lỗi để kích hoạt rollback, tránh trừ âm tồn kho
                    throw new IllegalStateException("Không đủ tồn kho cho SPCT #" + spctDB.getMaSPCT());
                }

                // Trừ tồn kho và tự cập nhật trạng thái nếu vừa bán hết
                int tonMoi = tonHienTai - soLuongMua;
                spctDB.setSoLuongTon(tonMoi);
                if (tonMoi == 0) {
                    spctDB.setTrangThai("Hết hàng");
                }
                session.merge(spctDB);

                // Lấy đơn giá chuẩn từ DB và tính tổng tiền ở phía server
                double donGia = spctDB.getGiaBan() != null ? spctDB.getGiaBan() : 0.0;
                item.setHoaDon(hoaDon);
                item.setSanPhamChiTiet(spctDB);
                item.setDonGia(donGia);
                session.persist(item);

                tongTien += donGia * soLuongMua;
            }

            hoaDon.setTongTien(tongTien);
            session.merge(hoaDon);

            transaction.commit(); // Lưu toàn bộ thay đổi nếu mọi bước đều thành công
            return true;
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback(); // Hủy toàn bộ thay đổi nếu có bất kỳ lỗi nào xảy ra
            }
            e.printStackTrace();
            return false;
        }
    }
}
//an
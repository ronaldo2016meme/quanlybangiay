package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.quanlybangiay.Model.*;
import org.example.quanlybangiay.Repository.BanHangRepo;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@WebServlet(name = "BanHangServlet", value = "/BanHang")
public class BanHangServlet extends HttpServlet {

    private final BanHangRepo banHangRepo = new BanHangRepo();

    // Đối tượng đại diện cho 1 dòng mặt hàng trong giỏ hàng tạm ở session
    public static class GioHangItem {
        private SanPhamChiTiet sanPhamChiTiet;
        private int soLuong;

        public GioHangItem(SanPhamChiTiet sanPhamChiTiet, int soLuong) {
            this.sanPhamChiTiet = sanPhamChiTiet;
            this.soLuong = soLuong;
        }

        public SanPhamChiTiet getSanPhamChiTiet() {
            return sanPhamChiTiet;
        }

        public void setSanPhamChiTiet(SanPhamChiTiet sanPhamChiTiet) {
            this.sanPhamChiTiet = sanPhamChiTiet;
        }

        public int getSoLuong() {
            return soLuong;
        }

        public void setSoLuong(int soLuong) {
            this.soLuong = soLuong;
        }

        // Tự tính thành tiền của 1 dòng theo giá bán hiện tại * số lượng
        public double getThanhTien() {
            double gia = (sanPhamChiTiet != null && sanPhamChiTiet.getGiaBan() != null)
                    ? sanPhamChiTiet.getGiaBan() : 0.0;
            return gia * soLuong;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");

        // Nếu có từ khóa tìm kiếm thì lọc danh sách biến thể, ngược lại lấy tất cả
        List<SanPhamChiTiet> listBienThe = (keyword != null && !keyword.isBlank())
                ? banHangRepo.searchBienThe(keyword)
                : banHangRepo.getAllBienThe();

        // Lấy giỏ hàng hiện tại từ session để hiển thị sang JSP
        HttpSession session = request.getSession();
        List<GioHangItem> gioHang = getOrCreateCart(session);
        double tongTien = tinhTongTien(gioHang);

        request.setAttribute("listBienThe", listBienThe);
        request.setAttribute("gioHang", gioHang);
        request.setAttribute("tongTien", tongTien);
        request.setAttribute("activeView", "banhang");

        request.getRequestDispatcher("BanHang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<GioHangItem> gioHang = getOrCreateCart(session);

        // 1. Thêm biến thể vào giỏ hàng (giới hạn tối đa không vượt quá số lượng tồn kho)
        if ("addToCart".equals(action)) {
            int maSPCT = parseIntSafe(request.getParameter("maSPCT"));
            int soLuong = Math.max(1, parseIntSafe(request.getParameter("soLuong")));
            SanPhamChiTiet spct = banHangRepo.getBienTheById(maSPCT);
            int tonKho = (spct != null && spct.getSoLuongTon() != null) ? spct.getSoLuongTon() : 0;

            if (spct != null && tonKho > 0) {
                GioHangItem existing = findItem(gioHang, maSPCT);
                if (existing != null) {
                    existing.setSoLuong(Math.min(tonKho, existing.getSoLuong() + soLuong));
                } else {
                    gioHang.add(new GioHangItem(spct, Math.min(tonKho, soLuong)));
                }
            }
            response.sendRedirect(request.getContextPath() + "/BanHang"); // Redirect để tránh gửi lại form khi bấm F5
            return;
        }

        // 2. Cập nhật số lượng trên 1 dòng trong giỏ (nhập <= 0 thì xóa khỏi giỏ)
        if ("updateQty".equals(action)) {
            int maSPCT = parseIntSafe(request.getParameter("maSPCT"));
            int soLuong = parseIntSafe(request.getParameter("soLuong"));
            Iterator<GioHangItem> it = gioHang.iterator();
            while (it.hasNext()) {
                GioHangItem item = it.next();
                if (item.getSanPhamChiTiet().getMaSPCT() == maSPCT) {
                    if (soLuong <= 0) {
                        it.remove();
                    } else {
                        int tonKho = item.getSanPhamChiTiet().getSoLuongTon() != null
                                ? item.getSanPhamChiTiet().getSoLuongTon() : 0;
                        item.setSoLuong(Math.min(Math.max(1, tonKho), soLuong));
                    }
                    break;
                }
            }
            response.sendRedirect(request.getContextPath() + "/BanHang");
            return;
        }

        // 3. Xóa hẳn 1 mặt hàng khỏi giỏ hàng
        if ("removeItem".equals(action)) {
            int maSPCT = parseIntSafe(request.getParameter("maSPCT"));
            gioHang.removeIf(item -> item.getSanPhamChiTiet().getMaSPCT() == maSPCT);
            response.sendRedirect(request.getContextPath() + "/BanHang");
            return;
        }

        // 4. Thanh toán: tạo HoaDon + HoaDonChiTiet, trừ tồn kho rồi xóa giỏ hàng nếu thành công
        if ("checkout".equals(action) && !gioHang.isEmpty()) {
            HoaDon hd = new HoaDon();
            hd.setNgayLap(LocalDateTime.now());
            hd.setTrangThaiHoaDon("Đã thanh toán");

            // Gắn nhân viên đang đăng nhập từ session vào hóa đơn
            Object userObj = session.getAttribute("userLogin");
            if (userObj instanceof NhanVien nv) {
                hd.setNhanVien(nv);
            }

            // Nếu có nhập mã khách hàng thì gắn KhachHang; để trống xem như khách lẻ
            String maKHStr = request.getParameter("maKH");
            int maKH = parseIntSafe(maKHStr);
            if (maKH > 0) {
                KhachHang kh = new KhachHang();
                kh.setMaKH(maKH);
                hd.setKhachHang(kh);
            }

            List<ChiTietHoaDon> chiTiets = new ArrayList<>();
            for (GioHangItem item : gioHang) {
                ChiTietHoaDon hdct = new ChiTietHoaDon();
                hdct.setSanPhamChiTiet(item.getSanPhamChiTiet());
                hdct.setSoLuong(item.getSoLuong());
                hdct.setDonGia(item.getSanPhamChiTiet().getGiaBan());
                chiTiets.add(hdct);
            }

            boolean ok = banHangRepo.thanhToan(hd, chiTiets);
            if (ok) {
                gioHang.clear(); // Làm trống giỏ sau khi xuất hóa đơn thành công
                response.sendRedirect(request.getContextPath() + "/BanHang?paid=1");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/BanHang?error=1");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/BanHang");
    }

    // Lấy danh sách giỏ hàng trong session, nếu chưa có thì khởi tạo mới
    @SuppressWarnings("unchecked")
    private List<GioHangItem> getOrCreateCart(HttpSession session) {
        Object cartObj = session.getAttribute("gioHangBanHang");
        if (cartObj instanceof List<?> list) {
            return (List<GioHangItem>) list;
        }
        List<GioHangItem> newCart = new ArrayList<>();
        session.setAttribute("gioHangBanHang", newCart);
        return newCart;
    }

    // Tìm xem biến thể maSPCT đã nằm trong giỏ chưa để cộng dồn số lượng
    private GioHangItem findItem(List<GioHangItem> gioHang, int maSPCT) {
        for (GioHangItem item : gioHang) {
            if (item.getSanPhamChiTiet().getMaSPCT() == maSPCT) {
                return item;
            }
        }
        return null;
    }

    // Tính tổng tiền toàn bộ giỏ hàng
    private double tinhTongTien(List<GioHangItem> gioHang) {
        double sum = 0.0;
        for (GioHangItem item : gioHang) {
            sum += item.getThanhTien();
        }
        return sum;
    }

    // Ép kiểu số nguyên an toàn để tránh NumberFormatException khi input rỗng/lỗi
    private int parseIntSafe(String raw) {
        if (raw == null || raw.isBlank()) return 0;
        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
//an
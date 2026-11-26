package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.HoaDon;
import org.example.quanlybangiay.Model.KhachHang;
import org.example.quanlybangiay.Model.MaGiamGia;
import org.example.quanlybangiay.Model.NhanVien;
import org.example.quanlybangiay.Repository.HoaDonRepo;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet(name = "HoaDonServlet", value = "/HoaDon")
public class HoaDonServlet extends HttpServlet {
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");

        if ("edit".equals(action)) {
            Integer editId = parseInteger(idParam);
            if (editId != null) {
                req.setAttribute("hdEdit", hoaDonRepo.getHoaDonById(editId));
            }
        }

        String keyword = req.getParameter("keyword");
        String trangThai = req.getParameter("trangThai");
        if ((keyword != null && !keyword.isBlank()) || (trangThai != null && !trangThai.isBlank())) {
            req.setAttribute("listHoaDon", hoaDonRepo.searchHoaDon(keyword, trangThai));
        } else {
            req.setAttribute("listHoaDon", hoaDonRepo.getAllHoaDon());
        }

        req.getRequestDispatcher("HoaDon.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Integer maHD = parseInteger(req.getParameter("maHD"));

        if (maHD == null) {
            resp.sendRedirect(req.getContextPath() + "/HoaDon");
            return;
        }

        HoaDon existing = hoaDonRepo.getHoaDonById(maHD);

        HoaDon hd = new HoaDon();
        hd.setMaHD(maHD);
        hd.setHoTen(req.getParameter("hoTen"));
        hd.setSdt(req.getParameter("sdt"));
        hd.setPhuongThucThanhToan(req.getParameter("phuongThucThanhToan"));
        hd.setTrangThaiHoaDon(req.getParameter("trangThaiHoaDon"));

        hd.setTongTien(parseDouble(req.getParameter("tongTien"), 0.0));
        hd.setTienGiam(parseDouble(req.getParameter("tienGiam"), 0.0));
        hd.setTienThua(parseDouble(req.getParameter("tienThua"), 0.0));

        LocalDateTime ngayLap = parseLocalDateTime(req.getParameter("ngayLap"));
        if (ngayLap != null) {
            hd.setNgayLap(ngayLap);
        } else if (existing != null && existing.getNgayLap() != null) {
            hd.setNgayLap(existing.getNgayLap());
        } else {
            hd.setNgayLap(LocalDateTime.now());
        }

        Integer maNV = parseInteger(req.getParameter("maNV"));
        if (maNV != null) {
            NhanVien nv = new NhanVien();
            nv.setMaNV(maNV);
            hd.setNhanVien(nv);
        }

        Integer maKH = parseInteger(req.getParameter("maKH"));
        if (maKH != null) {
            KhachHang kh = new KhachHang();
            kh.setMaKH(maKH);
            hd.setKhachHang(kh);
        }

        Integer maMGG = parseInteger(req.getParameter("maMGG"));
        if (maMGG != null) {
            MaGiamGia mgg = new MaGiamGia();
            mgg.setMaMGG(maMGG);
            hd.setMaGiamGia(mgg);
        }

        hoaDonRepo.updateHoaDon(hd);
        resp.sendRedirect(req.getContextPath() + "/HoaDon");
    }

    private LocalDateTime parseLocalDateTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String trimmed = raw.trim();
        try {
            if (trimmed.length() == 10) {
                return LocalDate.parse(trimmed).atStartOfDay();
            }
            return LocalDateTime.parse(trimmed);
        } catch (DateTimeParseException e) {
            try {
                LocalDate date = LocalDate.parse(trimmed.substring(0, 10));
                return LocalDateTime.of(date, LocalTime.MIDNIGHT);
            } catch (Exception ignored) {
                return null;
            }
        }
    }

    private Double parseDouble(String val, Double defaultVal) {
        if (val == null || val.isBlank()) return defaultVal;
        try {
            return Double.parseDouble(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private Integer parseInteger(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
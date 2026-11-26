package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.ChiTietHoaDon;
import org.example.quanlybangiay.Model.HoaDon;
import org.example.quanlybangiay.Model.SanPhamChiTiet;
import org.example.quanlybangiay.Repository.ChiTietHoaDonRepo;

import java.io.IOException;
import java.util.Collections;

@WebServlet(name = "ChiTietHoaDonServlet", value = "/ChiTietHoaDon")
public class ChiTietHoaDonServlet extends HttpServlet {
    private final ChiTietHoaDonRepo repo = new ChiTietHoaDonRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String idParam = req.getParameter("id");
        Integer maHD = parseInteger(req.getParameter("maHD"));

        if ("edit".equals(action) && idParam != null && !idParam.isBlank()) {
            ChiTietHoaDon editItem = repo.getChiTietHoaDonById(Integer.parseInt(idParam.trim()));
            req.setAttribute("cthdEdit", editItem);
            if (maHD == null && editItem != null && editItem.getHoaDon() != null) {
                maHD = editItem.getHoaDon().getMaHD();
            }
        }

        req.setAttribute("maHDFilter", maHD);
        if (maHD == null) {
            req.setAttribute("listChiTietHoaDon", Collections.emptyList());
        } else {
            req.setAttribute("listChiTietHoaDon", repo.getByMaHD(maHD));
        }

        req.getRequestDispatcher("ChiTietHoaDon.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idStr = req.getParameter("maCTHD");
        Integer maHD = parseInteger(req.getParameter("maHD"));

        if (idStr == null || idStr.isBlank()) {
            String redirectUrl = req.getContextPath() + "/ChiTietHoaDon" + (maHD != null ? "?maHD=" + maHD : "");
            resp.sendRedirect(redirectUrl);
            return;
        }

        Integer maSPCT = parseInteger(req.getParameter("maSPCT"));
        int soLuong = parseInt(req.getParameter("soLuong"), 1);
        Double donGia = parseDouble(req.getParameter("donGia"), 0.0);

        Double thanhTienParam = parseDouble(req.getParameter("thanhTien"), null);
        Double thanhTien = (thanhTienParam != null)
                ? thanhTienParam
                : donGia * soLuong;

        ChiTietHoaDon cthd = new ChiTietHoaDon();
        cthd.setMaCTHD(Integer.parseInt(idStr.trim()));
        if (maHD != null) {
            HoaDon hd = new HoaDon();
            hd.setMaHD(maHD);
            cthd.setHoaDon(hd);
        }
        if (maSPCT != null) {
            SanPhamChiTiet spct = new SanPhamChiTiet();
            spct.setMaSPCT(maSPCT);
            cthd.setSanPhamChiTiet(spct);
        }
        cthd.setSoLuong(soLuong);
        cthd.setDonGia(donGia);
        cthd.setThanhTien(thanhTien);

        repo.updateChiTietHoaDon(cthd);

        String redirectUrl = req.getContextPath() + "/ChiTietHoaDon" + (maHD != null ? "?maHD=" + maHD : "");
        resp.sendRedirect(redirectUrl);
    }

    private Integer parseInteger(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseInt(String val, int defaultVal) {
        Integer parsed = parseInteger(val);
        return parsed != null ? parsed : defaultVal;
    }

    private Double parseDouble(String val, Double defaultVal) {
        if (val == null || val.isBlank()) return defaultVal;
        try {
            return Double.parseDouble(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
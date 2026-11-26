package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.MauSac;
import org.example.quanlybangiay.Model.SanPham;
import org.example.quanlybangiay.Model.SanPhamChiTiet;
import org.example.quanlybangiay.Model.Size;
import org.example.quanlybangiay.Repository.MauSacRepo;
import org.example.quanlybangiay.Repository.SanPhamChiTietRepo;
import org.example.quanlybangiay.Repository.SizeRepo;

@WebServlet(name = "SanPhamChiTietServlet", value = "/SanPhamChiTiet")
public class SanPhamChiTietServlet extends HttpServlet {
    SanPhamChiTietRepo sanPhamChiTietRepo = new SanPhamChiTietRepo();
    MauSacRepo mauSacRepo = new MauSacRepo();
    SizeRepo sizeRepo = new SizeRepo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String maSP = request.getParameter("maSP");
        request.setAttribute("maSP", maSP);

        List<SanPhamChiTiet> listSanPhamChiTiet = sanPhamChiTietRepo.getAllSanPhamChiTiet();
        request.setAttribute("listSanPhamChiTiet", listSanPhamChiTiet);
        request.setAttribute("listMauSac", mauSacRepo.getAllMauSac());
        request.setAttribute("listSize", sizeRepo.getAllSize());

        request.getRequestDispatcher("SanPhamChiTiet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String maSP = request.getParameter("maSP");

        if ("add".equals(action)) {
            String maMauStr = request.getParameter("maMau");
            String maSizeStr = request.getParameter("maSize");
            String giaBanStr = request.getParameter("giaBan");
            String giaNhapStr = request.getParameter("giaNhap");
            String soLuongTonStr = request.getParameter("soLuongTon");
            String trangThai = request.getParameter("trangThai");

            if (maSP != null && !maSP.isBlank()
                    && maMauStr != null && !maMauStr.isBlank()
                    && maSizeStr != null && !maSizeStr.isBlank()) {

                SanPham sp = new SanPham();
                sp.setMaSP(Integer.parseInt(maSP.trim()));

                MauSac mauSac = new MauSac();
                mauSac.setMaMau(Integer.parseInt(maMauStr.trim()));

                Size size = new Size();
                size.setMaSize(Integer.parseInt(maSizeStr.trim()));

                SanPhamChiTiet spct = new SanPhamChiTiet();
                spct.setSanPham(sp);
                spct.setMauSac(mauSac);
                spct.setSize(size);
                spct.setGiaBan((giaBanStr != null && !giaBanStr.isBlank()) ? Double.parseDouble(giaBanStr.trim()) : 0.0);
                spct.setGiaNhap((giaNhapStr != null && !giaNhapStr.isBlank()) ? Double.parseDouble(giaNhapStr.trim()) : 0.0);
                spct.setSoLuongTon((soLuongTonStr != null && !soLuongTonStr.isBlank()) ? Integer.parseInt(soLuongTonStr.trim()) : 0);
                spct.setTrangThai((trangThai != null && !trangThai.isBlank()) ? trangThai.trim() : "Còn hàng");

                sanPhamChiTietRepo.addSanPhamChiTiet(spct);
            }

            String redirectUrl = request.getContextPath() + "/SanPhamChiTiet"
                    + ((maSP != null && !maSP.isBlank()) ? ("?maSP=" + maSP.trim() + "&added=1") : "?added=1");
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("update".equals(action)) {
            String maSPCTStr = request.getParameter("maSPCT");
            String maMauStr = request.getParameter("maMau");
            String maSizeStr = request.getParameter("maSize");
            String giaBanStr = request.getParameter("giaBan");
            String giaNhapStr = request.getParameter("giaNhap");
            String soLuongTonStr = request.getParameter("soLuongTon");
            String trangThai = request.getParameter("trangThai");

            SanPhamChiTiet spct = sanPhamChiTietRepo.getSanPhamChiTietById(maSPCTStr);
            if (spct != null) {
                MauSac mauSac = new MauSac();
                mauSac.setMaMau(Integer.parseInt(maMauStr.trim()));
                spct.setMauSac(mauSac);

                Size size = new Size();
                size.setMaSize(Integer.parseInt(maSizeStr.trim()));
                spct.setSize(size);

                if (giaBanStr != null && !giaBanStr.isBlank()) {
                    spct.setGiaBan(Double.parseDouble(giaBanStr.trim()));
                }
                if (giaNhapStr != null && !giaNhapStr.isBlank()) {
                    spct.setGiaNhap(Double.parseDouble(giaNhapStr.trim()));
                }
                if (soLuongTonStr != null && !soLuongTonStr.isBlank()) {
                    spct.setSoLuongTon(Integer.parseInt(soLuongTonStr.trim()));
                }

                spct.setTrangThai((trangThai != null && !trangThai.isBlank()) ? trangThai.trim() : "Còn hàng");

                sanPhamChiTietRepo.updateSanPhamChiTiet(spct);
            }
        }

        String redirectUrl = request.getContextPath() + "/SanPhamChiTiet"
                + ((maSP != null && !maSP.isBlank()) ? ("?maSP=" + maSP.trim()) : "");
        response.sendRedirect(redirectUrl);
    }
}
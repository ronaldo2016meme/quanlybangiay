package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.KhachHang;
import org.example.quanlybangiay.Repository.KhachHangRepo;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "KhachHangServlet", value = "/KhachHang")
public class KhachHangServlet extends HttpServlet {

    KhachHangRepo khachHangRepo = new KhachHangRepo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");

        // Bấm Sửa -> lấy thông tin khách hàng gửi sang JSP
        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    Integer maKH = Integer.parseInt(idParam);
                    KhachHang khEdit = khachHangRepo.getById(maKH);
                    request.setAttribute("khachHangEdit", khEdit);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        // Lấy danh sách khách hàng
        List<KhachHang> listKhachHang = (keyword != null && !keyword.trim().isEmpty())
                ? khachHangRepo.searchKhachHang(keyword)
                : khachHangRepo.getAllKhachHang();

        request.setAttribute("ListKhachHang", listKhachHang);
        request.getRequestDispatcher("KhachHang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        KhachHang kh = new KhachHang();
        kh.setHoTen(request.getParameter("hoTen"));
        kh.setSdt(request.getParameter("sdt"));
        kh.setDiaChi(request.getParameter("diaChi"));

        if ("update".equals(action)) {
            // Cập nhật khách hàng
            String maKHStr = request.getParameter("maKH");
            if (maKHStr != null && !maKHStr.isEmpty()) {
                kh.setMaKH(Integer.parseInt(maKHStr));
            }
            khachHangRepo.updateKhachHang(kh);
        } else {
            // Thêm khách hàng mới
            khachHangRepo.addKhachHang(kh);
        }

        response.sendRedirect(request.getContextPath() + "/KhachHang");
    }
}
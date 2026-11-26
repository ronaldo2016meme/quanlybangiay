package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.DanhMucSanPham;
import org.example.quanlybangiay.Repository.DanhMucSanPhamRepo;

@WebServlet(name = "DanhMucSanPhamServletServlet", value = "/DanhMucSanPham")
public class DanhMucSanPhamServlet extends HttpServlet {
//    an
    DanhMucSanPhamRepo danhMucSanPhamRepo = new DanhMucSanPhamRepo();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<DanhMucSanPham> listDanhMuc = danhMucSanPhamRepo.getAllDanhMucSanPham();
        request.setAttribute("listDanhMuc", listDanhMuc);
        request.getRequestDispatcher("DanhMucSanPham.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
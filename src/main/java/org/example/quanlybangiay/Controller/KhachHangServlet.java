package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.KhachHang;
import org.example.quanlybangiay.Repository.KhachHangRepo;

@WebServlet(name = "KhachHangServletServlet", value = "/KhachHang")
public class KhachHangServlet extends HttpServlet {

    KhachHangRepo khachHangRepo = new KhachHangRepo();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<KhachHang> ListKhachHang = khachHangRepo.getAllKhachHang();
        request.setAttribute("ListKhachHang", ListKhachHang);
        request.getRequestDispatcher("KhachHang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}

// Hung
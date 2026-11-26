package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.MaGiamGia;
import org.example.quanlybangiay.Repository.MaGiamGiaRepo;

@WebServlet(name = "MaGiamGiaServletServlet", value = "/MaGiamGia")
public class MaGiamGiaServlet extends HttpServlet {

    MaGiamGiaRepo maGiamGiaRepo = new MaGiamGiaRepo();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MaGiamGia> ListMaGiamGia = maGiamGiaRepo.getAllMaGiamGia();
        request.setAttribute("ListMaGiamGia", ListMaGiamGia);
        request.getRequestDispatcher("MaGiamGia.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}

// Hung
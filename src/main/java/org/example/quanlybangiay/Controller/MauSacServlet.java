package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.MauSac;
import org.example.quanlybangiay.Repository.MaGiamGiaRepo;
import org.example.quanlybangiay.Repository.MauSacRepo;

@WebServlet(name = "MauSacServletServlet", value = "/MauSac")
public class MauSacServlet extends HttpServlet {
//    an
    MauSacRepo mauSacRepo = new MauSacRepo();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MauSac> listMauSac = mauSacRepo.getAllMauSac();
        request.setAttribute("listMauSac", listMauSac);
        request.getRequestDispatcher("MauSac.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
package org.example.quanlybangiay.Controller;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.Size;
import org.example.quanlybangiay.Repository.SizeRepo;

@WebServlet(name = "SizeServletServlet", value = "/Size")
public class SizeServlet extends HttpServlet {
//    an
    SizeRepo sizeRepo = new SizeRepo();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Size> listSize = sizeRepo.getAllSize();
        request.setAttribute("listSize", listSize);
        request.getRequestDispatcher("Size.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}
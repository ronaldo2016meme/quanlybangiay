package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.quanlybangiay.Model.NhanVien;
import org.example.quanlybangiay.Repository.NhanVienRepo;

import java.io.IOException;

@WebServlet(value = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final NhanVienRepo nhanVienRepo = new NhanVienRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            req.setAttribute("message", "Bạn đã đăng xuất.");
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            return;
        }

        NhanVien nv = nhanVienRepo.dangNhap(username.trim(), password);

        if (nv != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userLogin", nv);

            // Chuyển sang trang chủ index.jsp
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
        }
    }
}
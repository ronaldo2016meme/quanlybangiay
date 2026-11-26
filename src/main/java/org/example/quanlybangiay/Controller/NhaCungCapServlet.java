package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.NhaCungCap;
import org.example.quanlybangiay.Repository.NhaCungCapRepo;

import java.io.IOException;

@WebServlet(name = "NhaCungCapServlet", value = "/NhaCungCap")
public class NhaCungCapServlet extends HttpServlet {
    private final NhaCungCapRepo repo = new NhaCungCapRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        Integer id = parseInteger(req.getParameter("id"));

        if ("edit".equals(action) && id != null) {
            req.setAttribute("nccEdit", repo.getNhaCungCapById(id));
        }

        String keyword = req.getParameter("keyword");
        if (keyword != null && !keyword.isBlank()) {
            req.setAttribute("listNhaCungCap", repo.searchNhaCungCap(keyword));
        } else {
            req.setAttribute("listNhaCungCap", repo.getAllNhaCungCap());
        }

        req.getRequestDispatcher("NhaCungCap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Integer maNCC = parseInteger(req.getParameter("maNCC"));
        String tenNCC = req.getParameter("tenNCC");

        if (tenNCC == null || tenNCC.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/NhaCungCap");
            return;
        }

        NhaCungCap ncc = new NhaCungCap();
        ncc.setMaNCC(maNCC);
        ncc.setTenNCC(tenNCC.trim());
        ncc.setSdt(trimOrNull(req.getParameter("sdt")));
        ncc.setEmail(trimOrNull(req.getParameter("email")));
        ncc.setDiaChi(trimOrNull(req.getParameter("diaChi")));

        if (maNCC != null) {
            repo.updateNhaCungCap(ncc);
        } else {
            repo.addNhaCungCap(ncc);
        }

        resp.sendRedirect(req.getContextPath() + "/NhaCungCap");
    }

    private Integer parseInteger(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String trimOrNull(String val) {
        if (val == null || val.isBlank()) return null;
        return val.trim();
    }
}
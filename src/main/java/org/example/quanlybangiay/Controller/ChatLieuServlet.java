package org.example.quanlybangiay.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.quanlybangiay.Model.ChatLieu;
import org.example.quanlybangiay.Repository.ChatLieuRepo;

import java.io.IOException;

@WebServlet(name = "ChatLieuServlet", value = "/ChatLieu")
public class ChatLieuServlet extends HttpServlet {
    private final ChatLieuRepo repo = new ChatLieuRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        Integer id = parseInteger(req.getParameter("id"));

        if ("edit".equals(action) && id != null) {
            req.setAttribute("chatLieuEdit", repo.getChatLieuById(id));
        }

        String keyword = req.getParameter("keyword");
        if (keyword != null && !keyword.isBlank()) {
            req.setAttribute("listChatLieu", repo.searchChatLieu(keyword));
        } else {
            req.setAttribute("listChatLieu", repo.getAllChatLieu());
        }

        req.getRequestDispatcher("ChatLieu.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Integer maChatLieu = parseInteger(req.getParameter("maChatLieu"));

        ChatLieu cl = new ChatLieu();
        if (maChatLieu != null) {
            cl.setMaChatLieu(maChatLieu);
        }
        cl.setTenChatLieu(req.getParameter("tenChatLieu"));

        if (maChatLieu != null) {
            repo.updateChatLieu(cl);
        } else {
            repo.addChatLieu(cl);
        }

        resp.sendRedirect(req.getContextPath() + "/ChatLieu");
    }

    private Integer parseInteger(String val) {
        if (val == null || val.isBlank()) return null;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
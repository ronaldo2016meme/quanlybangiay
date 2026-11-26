package org.example.quanlybangiay.Controller;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.example.quanlybangiay.Model.ChatLieu;
import org.example.quanlybangiay.Model.DanhMucSanPham;
import org.example.quanlybangiay.Model.NhaCungCap;
import org.example.quanlybangiay.Model.SanPham;
import org.example.quanlybangiay.Repository.ChatLieuRepo;
import org.example.quanlybangiay.Repository.DanhMucSanPhamRepo;
import org.example.quanlybangiay.Repository.NhaCungCapRepo;
import org.example.quanlybangiay.Repository.SanPhamRepo;

@WebServlet(name = "SanPhamServlet", value = "/SanPham")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB: bộ đệm tạm trước khi ghi file
        maxFileSize = 1024 * 1024 * 10,       // Tối đa 10MB mỗi file ảnh
        maxRequestSize = 1024 * 1024 * 15     // Tối đa 15MB tổng dữ liệu gửi lên
)
public class SanPhamServlet extends HttpServlet {
    SanPhamRepo sanPhamRepo = new SanPhamRepo();
    DanhMucSanPhamRepo danhMucSanPhamRepo = new DanhMucSanPhamRepo();
    ChatLieuRepo chatLieuRepo = new ChatLieuRepo();
    NhaCungCapRepo nhaCungCapRepo = new NhaCungCapRepo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");

        // Nếu bấm nút "Sửa" trên bảng thì lấy sản phẩm theo id và đưa lên form
        if ("edit".equals(action)) {
            String idParam = request.getParameter("id");
            SanPham spEdit = sanPhamRepo.getSanPhamById(idParam);
            request.setAttribute("sanPhamEdit", spEdit);
        }

        // Lấy danh sách sản phẩm (có lọc theo từ khóa nếu người dùng tìm kiếm)
        List<SanPham> listSanPham = (keyword != null && !keyword.isBlank())
                ? sanPhamRepo.searchSanPham(keyword)
                : sanPhamRepo.getAllSanPham();

        // Truyền dữ liệu hiển thị bảng và các ô select cho SanPham.jsp
        request.setAttribute("listSanPham", listSanPham);
        request.setAttribute("listDanhMuc", danhMucSanPhamRepo.getAllDanhMucSanPham());
        request.setAttribute("listChatLieu", chatLieuRepo.getAllChatLieu());
        request.setAttribute("listNCC", nhaCungCapRepo.getAllNhaCungCap());

        request.getRequestDispatcher("SanPham.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        String tenSP = request.getParameter("tenSP");
        String moTa = request.getParameter("moTa");
        String trangThai = request.getParameter("trangThai");
        String maDanhMucStr = request.getParameter("maDanhMuc");
        String maChatLieuStr = request.getParameter("maChatLieu");
        String maNCCStr = request.getParameter("maNCC");

        DanhMucSanPham danhMuc = new DanhMucSanPham();
        danhMuc.setMaDanhMuc(parseIntSafe(maDanhMucStr));

        ChatLieu chatLieu = new ChatLieu();
        chatLieu.setMaChatLieu(parseIntSafe(maChatLieuStr));

        NhaCungCap nhaCungCap = new NhaCungCap();
        nhaCungCap.setMaNCC(parseIntSafe(maNCCStr));

        if ("add".equals(action)) {
            Part filePart = request.getPart("anhFile");
            String tenFileAnh = saveUploadedImage(request, filePart, "mercurial_cr7_gold.jpg");

            SanPham sp = new SanPham();
            sp.setTenSP(tenSP != null ? tenSP.trim() : "");
            sp.setAnh(tenFileAnh);
            sp.setMoTa(moTa != null ? moTa.trim() : "");
            sp.setTrangThai((trangThai != null && !trangThai.isBlank()) ? trangThai.trim() : "Đang kinh doanh");
            sp.setDanhMucSanPham(danhMuc);
            sp.setChatLieu(chatLieu);
            sp.setNhaCungCap(nhaCungCap);
            sp.setNgayTao(LocalDateTime.now());

            sanPhamRepo.addSanPham(sp);
        } else if ("update".equals(action)) {
            String maSPStr = request.getParameter("maSP");
            if (maSPStr == null || maSPStr.isBlank()) {
                maSPStr = request.getParameter("id");
            }

            SanPham sp = sanPhamRepo.getSanPhamById(maSPStr);
            if (sp != null) {
                Part filePart = request.getPart("anhFile");
                String anhHienTai = (sp.getAnh() != null && !sp.getAnh().isBlank())
                        ? sp.getAnh()
                        : "mercurial_cr7_gold.jpg";
                String tenFileAnh = saveUploadedImage(request, filePart, anhHienTai);

                sp.setTenSP(tenSP != null ? tenSP.trim() : sp.getTenSP());
                sp.setAnh(tenFileAnh);
                sp.setMoTa(moTa != null ? moTa.trim() : sp.getMoTa());
                sp.setTrangThai((trangThai != null && !trangThai.isBlank()) ? trangThai.trim() : sp.getTrangThai());
                sp.setDanhMucSanPham(danhMuc);
                sp.setChatLieu(chatLieu);
                sp.setNhaCungCap(nhaCungCap);
                if (sp.getNgayTao() == null) {
                    sp.setNgayTao(LocalDateTime.now());
                }
                sp.setNgayCapNhat(LocalDateTime.now());

                sanPhamRepo.updateSanPham(sp);
            }
        }

        // Chuyển hướng về GET /SanPham để tránh gửi lại form khi bấm F5
        response.sendRedirect(request.getContextPath() + "/SanPham");
    }

    // Chuyển chuỗi số sang int an toàn
    private int parseIntSafe(String value) {
        if (value == null || value.isBlank()) {
            return 0;
        }
        return Integer.parseInt(value.trim());
    }

    // Lưu file ảnh PNG/JPG vào thư mục img và trả về tên file đã lưu
    private String saveUploadedImage(HttpServletRequest request, Part filePart, String fallbackFileName) throws IOException {
        if (filePart == null || filePart.getSize() <= 0) {
            return fallbackFileName;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.isBlank()) {
            return fallbackFileName;
        }

        String cleanOriginalName = Path.of(submittedFileName).getFileName().toString();
        String lowerName = cleanOriginalName.toLowerCase();

        // Chỉ nhận file định dạng PNG hoặc JPG/JPEG
        if (!(lowerName.endsWith(".png") || lowerName.endsWith(".jpg") || lowerName.endsWith(".jpeg"))) {
            return fallbackFileName;
        }

        String safeName = cleanOriginalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String storedFileName = System.currentTimeMillis() + "_" + safeName;

        // 1. Lưu vào thư mục /img đang deploy trên Tomcat để hiển thị ngay lập tức
        String runtimeImgPath = request.getServletContext().getRealPath("/img");
        if (runtimeImgPath != null) {
            File runtimeImgDir = new File(runtimeImgPath);
            if (!runtimeImgDir.exists()) {
                runtimeImgDir.mkdirs();
            }
            File runtimeFile = new File(runtimeImgDir, storedFileName);
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, runtimeFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // 2. Lưu thêm vào src/main/webapp/img để giữ file khi rebuild/clean project
        File sourceImgDir = new File("src/main/webapp/img");
        if (!sourceImgDir.exists()) {
            sourceImgDir.mkdirs();
        }
        File sourceFile = new File(sourceImgDir, storedFileName);
        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, sourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        return storedFileName;
    }
}
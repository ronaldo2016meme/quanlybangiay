package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Date;

@Table(name = "SanPham")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SanPham {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSP")
    Integer maSP;

    @Column(name = "TenSP")
    String tenSP;

    @Column(name = "MoTa")
    String moTa;

    @Column(name = "NgayTao")
    LocalDateTime ngayTao;

    @Column(name = "NgayCapNhat")
    LocalDateTime ngayCapNhat;

    @Column(name = "Anh")
    String Anh;

    @ManyToOne
    @JoinColumn(name = "MaChatLieu")
    ChatLieu chatLieu;

    @ManyToOne
    @JoinColumn(name = "MaDanhMuc")
    DanhMucSanPham danhMucSanPham;

    @ManyToOne
    @JoinColumn(name = "MaNCC")
    NhaCungCap nhaCungCap;

    @Column(name = "TrangThai")
    String trangThai;
}

//MaSP INT IDENTITY(1,1) PRIMARY KEY,
//TenSP NVARCHAR(150) NOT NULL,
//MoTa NVARCHAR(MAX),
//NgayTao DATETIME DEFAULT GETDATE(),
//NgayCapNhat DATETIME,
//Anh VARCHAR(255),
//
//MaChatLieu INT,
//MaDanhMuc INT,
//MaNCC INT,
//TrangThai NVARCHAR(50),
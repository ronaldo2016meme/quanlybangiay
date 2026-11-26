package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;

@Table(name = "NhanVien")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class NhanVien {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNV")
    Integer MaNV;
    @Column(name = "HoTen")
    String HoTen;
    @Column(name = "NgaySinh")
    Date NgaySinh;
    @Column(name = "GioiTinh")
    String GioiTinh;
    @Column(name = "QuocTich")
    String QuocTich;
    @Column(name = "QueQuan")
    String QueQuan;
    @Column(name = "NoiThuongTru")
    String NoiThuongTru;
    @Column(name = "SDT")
    String SDT;
    @Column(name = "Email")
    String Email;
    @Column(name = "CCCD")
    String CCCD;
    @Column(name = "TenChucVu")
    String TenChucVu;
    @Column(name = "MaTK")
    Integer MaTK;
    @Column(name = "TenDangNhap")
    String TenDangNhap;
    @Column(name = "MauKhau")
    String MauKhau;
    @Column(name = "TrangThai")
    String TrangThai;


    // Hung
//    MaNV INT IDENTITY(1,1) PRIMARY KEY,
//    HoTen NVARCHAR(100) NOT NULL,
//    NgaySinh DATE,
//    GioiTinh NVARCHAR(10),
//    QuocTich NVARCHAR(50),
//    QueQuan NVARCHAR(100),
//    NoiThuongTru NVARCHAR(255),
//    SDT VARCHAR(15),
//    Email VARCHAR(100),
//    CCCD VARCHAR(20),
//    TenChucVu NVARCHAR(100),
//    MaTK INT,
//    TenDangNhap VARCHAR(50) UNIQUE,
//    MatKhau VARCHAR(255),
//    TrangThai NVARCHAR(50)
}

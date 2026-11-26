package org.example.quanlybangiay.Model;

import jakarta.persistence.*;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Date;

@Table(name = "MaGiamGia")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MaGiamGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaMGG")
    Integer MaMGG;
    @Column(name = "MaCode")
    String MaCode;
    @Column(name = "TenMGG")
    String TenMGG;
    @Column(name = "PhanTramGiam")
    Double PhanTramGiam;
    @Column(name = "NgayBatDau")
    LocalDateTime NgayBatDau;
    @Column(name = "NgayKetThuc")
    LocalDateTime NgayKetThuc;
    @Column(name = "SoLuong")
    Integer SoLuong;
    @Column(name = "SoLuongTon")
    Integer SoLuongTon;
    @Column(name = "TrangThai")
    String TrangThai;
    @Column(name = "DieuKien")
    String DieuKien;


    // Hung
//    MaMGG INT IDENTITY(1,1) PRIMARY KEY,
//    MaCode VARCHAR(50) NOT NULL UNIQUE,
//    TenMGG NVARCHAR(100),
//    PhanTramGiam DECIMAL(5,2),
//    NgayBatDau DATETIME,
//    NgayKetThuc DATETIME,
//    SoLuong INT,
//    SoLuongTon INT,
//    TrangThai NVARCHAR(50),
//    DieuKien NVARCHAR(MAX)
}

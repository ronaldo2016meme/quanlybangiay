package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "SanPhamChiTiet")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SanPhamChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSPCT")
    Integer maSPCT;

    @ManyToOne
    @JoinColumn(name = "MaSP")
    SanPham sanPham;

    @ManyToOne
    @JoinColumn(name = "MaMau")
    MauSac mauSac;

    @ManyToOne
    @JoinColumn(name = "MaSize")
    Size size;

    @Column(name = "GiaBan")
    Double giaBan;

    @Column(name = "GiaNhap")
    Double giaNhap;


    @Column(name = "SoLuongTon")
    Integer soLuongTon;

    @Column(name = "NgayTao")
    String ngayTao;

    @Column(name = "TrangThai")
    String trangThai;
}

//MaSPCT INT IDENTITY(1,1) PRIMARY KEY,
//MaSP INT NOT NULL,
//MaMau INT NOT NULL,
//MaSize INT NOT NULL,
//GiaBan DECIMAL(18,2) NOT NULL,
//GiaNhap DECIMAL(18,2),
//SoLuongTon INT NOT NULL CHECK (SoLuongTon >= 0),
//NgayTao DATETIME DEFAULT GETDATE(),
//TrangThai NVARCHAR(50),
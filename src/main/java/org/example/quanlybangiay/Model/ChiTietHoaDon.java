package org.example.quanlybangiay.Model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "ChiTietHoaDon")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ChiTietHoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCTHD")
    Integer maCTHD;

    @ManyToOne
    @JoinColumn(name = "MaHD")
    HoaDon hoaDon;

    @ManyToOne
    @JoinColumn(name = "MaSPCT")
    SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuong")
    Integer soLuong;

    @Column(name = "DonGia")
    Double donGia;

    @Column(name = "ThanhTien")
    Double thanhTien;
}
//MaCTHD INT IDENTITY(1,1) PRIMARY KEY,
//MaHD INT NOT NULL,
//MaSPCT INT NOT NULL,
//SoLuong INT NOT NULL CHECK (SoLuong > 0),
//DonGia DECIMAL(18,2) NOT NULL,
//ThanhTien AS (SoLuong * DonGia),
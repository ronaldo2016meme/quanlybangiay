package org.example.quanlybangiay.Model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;



import java.util.Date;

@Table(name = "HoaDon")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class HoaDon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaHD")
    Integer MaHD;
    @Column(name = "ngayLap")
    Date NgayLap;
    @Column(name = "HoTen")
    String HoTen;
    @Column(name = "sdt")
    String sdt;
    @Column(name = "TongTien")
    Double TongTien;
    @Column(name = "TienGiam")
    Double TienGiam;
    @Column(name = "TienThua")
    Double TienThua;
    @Column(name = "PhuongThucThanhToan")
    String PhuongThucThanhToan;
    @ManyToOne
    @JoinColumn(name = "MaNV")
    NhanVien nhanVien;
    @ManyToOne
    @JoinColumn(name = "MaKH")
    KhachHang khachHang;
    @ManyToOne
    @JoinColumn(name = "MaMGG")
    MaGiamGia maGiamGia;
    @Column(name = "TrangThaiHoaDon")
    String TrangThaiHoaDon;

}

//MaHD INT IDENTITY(1,1) PRIMARY KEY,
//NgayLap DATETIME DEFAULT GETDATE(),
//HoTen NVARCHAR(100),
//SDT VARCHAR(15),
//TongTien DECIMAL(18,2),
//TienGiam DECIMAL(18,2),
//TienThua DECIMAL(18,2),
//PhuongThucThanhToan NVARCHAR(50),
//MaNV INT,
//MaKH INT,
//MaMGG INT,
//TrangThaiHoaDon NVARCHAR(50),
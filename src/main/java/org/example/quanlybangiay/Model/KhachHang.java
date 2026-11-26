package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "KhachHang")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class KhachHang {

    @Id
            @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaKH")
    Integer MaKH;
    @Column(name = "HoTen")
    String HoTen;
    @Column(name = "sdt")
    String sdt;
    @Column(name = "DiaChi")
    String DiaChi;


    // Hung
//    MaKH INT IDENTITY(1,1) PRIMARY KEY,
//    HoTen NVARCHAR(100) NOT NULL,
//    SDT VARCHAR(15),
//    DiaChi NVARCHAR(255)
}

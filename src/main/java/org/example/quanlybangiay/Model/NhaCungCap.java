package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "NhaCungCap")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class NhaCungCap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maNCC")
    Integer maNCC;
    @Column(name = "tenNCC")
    String tenNCC;
    @Column(name = "sdt")
    String sdt;
    @Column(name = "email")
    String email;
    @Column(name = "diaChi")
    String diaChi;

//    an
//    MaNCC INT IDENTITY(1,1) PRIMARY KEY,
//    TenNCC NVARCHAR(150) NOT NULL,
//    SDT VARCHAR(15),
//    Email VARCHAR(100),
//    DiaChi NVARCHAR(255)
}

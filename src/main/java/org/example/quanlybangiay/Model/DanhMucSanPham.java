package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "DanhMucSanPham")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DanhMucSanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maDanhMuc")
    Integer maDanhMuc;
    @Column(name = "tenDanhMuc")
    String tenDanhMuc;
    @Column(name = "moTa")
    String moTa;

//    an
//    MaDanhMuc INT IDENTITY(1,1) PRIMARY KEY,
//    TenDanhMuc NVARCHAR(100) NOT NULL,
//    MoTa NVARCHAR(MAX)
}

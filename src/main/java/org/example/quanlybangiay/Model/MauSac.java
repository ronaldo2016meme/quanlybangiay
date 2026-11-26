package org.example.quanlybangiay.Model;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "MauSac")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MauSac {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maMau")
    Integer maMau;
    @Column(name = "tenMau")
    String tenMau;
//    an
//    MaMau INT IDENTITY(1,1) PRIMARY KEY,
//    TenMau NVARCHAR(50) NOT NULL
}

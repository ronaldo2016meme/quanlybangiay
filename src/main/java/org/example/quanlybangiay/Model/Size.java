package org.example.quanlybangiay.Model;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "Size")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Size {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maSize")
    Integer maSize;
    @Column(name = "tenSize")
    String tenSize;
//    an
//    MaSize INT IDENTITY(1,1) PRIMARY KEY,
//    TenSize NVARCHAR(20) NOT NULL
}

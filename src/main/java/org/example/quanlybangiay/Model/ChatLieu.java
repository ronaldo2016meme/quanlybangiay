package org.example.quanlybangiay.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Table(name = "ChatLieu")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ChatLieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "maChatLieu")
    Integer maChatLieu;
    @Column(name = "tenChatLieu")
    String tenChatLieu;

//    an
//    MaChatLieu INT IDENTITY(1,1) PRIMARY KEY,
//    TenChatLieu NVARCHAR(100) NOT NULL
}

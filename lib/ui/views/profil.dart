import 'package:bitirme_projesi/ui/views/anasayfa.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String kullaniciAdi = "ahmetberke";
  String email = "ahmetberke@mail.com";
  String profilResmiUrl = "resimler/profile.jpg"; // Profil resmi URL'si

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1B5E20), // Koyu yeşil
                  Color(0xFF4CAF50), // Açık yeşil
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)), // Yuvarlak alt köşeler
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Şeffaf arka plan
              elevation: 0, // Gölgeyi kaldır
              title: Text(
                "PROFİLİM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Anasayfa(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView( // İçeriği kaydırmak için eklenmiştir
              child: Column(
                children: [
                  // Profil resmi
                  ClipOval(
                    child: Image.asset(
                      profilResmiUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Kullanıcı adı
                  Text(
                    kullaniciAdi,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  // E-posta
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Düzenle butonu
                  ElevatedButton(
                    onPressed: () {
                      _duzenleProfil();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1B5E20),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Buton köşeleri yuvarlatıldı
                      ),
                    ),
                    child: Text(
                      "Düzenle",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Hakkında bölüm
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // X ve Y ekseni ofseti
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hakkında",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Bu alanda kendinizle ilgili bilgi verebilirsiniz. Hobileriniz, ilgi alanlarınız veya diğer bilgiler...",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]

      )

    );
  }

  void _duzenleProfil() {
    // Profil düzenleme işlemleri için basit bir alert dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Profil Düzenle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Kullanıcı Adı"),
                onChanged: (value) {
                  setState(() {
                    kullaniciAdi = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "E-posta"),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }
}

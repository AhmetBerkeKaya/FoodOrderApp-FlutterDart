import 'package:bitirme_projesi/data/entity/yemek.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/views/sepet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Detay extends StatefulWidget {
  final Yemek yemek;

  Detay({required this.yemek});

  @override
  _DetayState createState() => _DetayState();
}

class _DetayState extends State<Detay> {
  int adet = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // AppBar yüksekliğini ayarla
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1B5E20), // Koyu yeşil
                Color(0xFF4CAF50), // Açık yeşil
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)), // Aşağıda yuvarlak köşe
          ),
          child: AppBar(
            title: Text(
              widget.yemek.yemekAdi,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            backgroundColor: Colors.transparent, // Şeffaf arka plan
            elevation: 0, // Gölgeyi kaldır
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  // Sepet sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sepet(kullaniciAdi: 'ahmetberke'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Yemek görseli
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  'http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.yemekResimAdi}',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              // Yemek ismi ve fiyatı
              Text(
                widget.yemek.yemekAdi,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50), // Aynı yeşil ton
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                '${widget.yemek.yemekFiyat} ₺',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Adet seçme kısmı
              Text(
                "Adet Seçin",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (adet > 1) adet--;
                      });
                    },
                    icon: Icon(Icons.remove_circle_outline),
                    iconSize: 40,
                    color: Color(0xFF4CAF50),
                  ),
                  SizedBox(width: 20),
                  Text(
                    adet.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        adet++;
                      });
                    },
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 40,
                    color: Color(0xFF4CAF50),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Sepete Ekle butonu
              ElevatedButton(
                onPressed: () {
                  context.read<SepetCubit>().sepeteYemekEkle(widget.yemek, adet);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.yemek.yemekAdi} sepete eklendi!')),
                  );
                  Navigator.pop(context); // Detay sayfasını kapat
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B5E20), // Buton rengi
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sepete Ekle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // İptal butonu
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'İptal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bitirme_projesi/ui/views/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Lottie animasyonu kullanmak için

class Odeme extends StatefulWidget {
  final int toplamTutar;

  Odeme({required this.toplamTutar});

  @override
  _OdemeState createState() => _OdemeState();
}

class _OdemeState extends State<Odeme> {
  int indirim = 0;
  final TextEditingController _indirimController = TextEditingController();
  final TextEditingController _kartNumarasiController = TextEditingController();
  final TextEditingController _sonKullanmaController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool isLoading = false; // Animasyonu kontrol etmek için

  void _applyDiscount(int miktar) {
    setState(() {
      indirim += miktar; // Uygulanan indirim
    });
  }

  void _applyCustomDiscount() {
    int? enteredDiscount = int.tryParse(_indirimController.text);
    if (enteredDiscount != null && enteredDiscount > 0) {
      setState(() {
        indirim = enteredDiscount; // Uygulanan indirim
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lütfen geçerli bir indirim tutarı girin.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    int toplamIndirimliTutar = widget.toplamTutar - indirim;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Ödeme',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.home, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // İndirim bölümü
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İndirimlerim:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildIndirimButton(50),
                          SizedBox(width: 10),
                          _buildIndirimButton(75),
                          SizedBox(width: 10),
                          _buildIndirimButton(100),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Uygulanan İndirim: ${indirim} ₺', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Toplam indirimli tutar gösterimi
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Toplam Tutar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${widget.toplamTutar} ₺', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('İndirimli Toplam Tutar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${toplamIndirimliTutar} ₺', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kazancınız:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${indirim} ₺', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 1, color: Colors.grey), // Ayırıcı çizgi ekleyin
                    SizedBox(height: 10),
                    Text('Ödeme İşlemi için devam edin', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              // Kart bilgileri bölümü
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kart Bilgileri:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: _kartNumarasiController,
                      decoration: InputDecoration(
                        labelText: 'Kart Numarası',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _sonKullanmaController,
                            decoration: InputDecoration(
                              labelText: 'Son Kullanma Tarihi (MM/YY)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _completePayment();
                  },
                  child: Text('Ödemeyi Tamamla', style: TextStyle(color: Colors.white,fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // İndirim butonlarını oluşturmak için yardımcı fonksiyon
  Widget _buildIndirimButton(int miktar) {
    return ElevatedButton(
      onPressed: () => _applyDiscount(miktar), // İndirim butonuna tıklandığında indirim uygulanır
      child: Row(
        children: [
          Icon(Icons.discount, color: Colors.white), // İndirim simgesi
          SizedBox(width: 5),
          Text('${miktar} ₺ İndirim', style: TextStyle(color: Colors.white)),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700], // Buton rengi
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _completePayment() {
    setState(() {
      isLoading = true; // Animasyonu başlat
    });

    // Yükleme animasyonunu ekranda göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Geri tuşuna basılmasını engelle
          child: Center(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('animations/animation.json', width: 500, height: 500), // Yükleme animasyonu
                  SizedBox(height: 20),
                  Text('Siparişiniz Hazırlanıyor...', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Ödeme işlemini simüle et (örneğin, 2 saniye bekle)
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Yükleme animasyonunu kapat
      setState(() {
        isLoading = false; // Animasyonu durdur
      });

      // İşlemi tamamladıktan sonra ana sayfaya yönlendirin
      Navigator.pop(context); // Önceki sayfaya dön
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Anasayfa()), // Ana sayfaya yönlendir
      );
    });
  }
}

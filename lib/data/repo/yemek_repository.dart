import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/yemek.dart';

class YemekRepository {
  final String baseUrl = 'http://kasimadalan.pe.hu/yemekler';

  Future<List<Yemek>> tumYemekleriGetir() async {
    final response = await http.get(Uri.parse('$baseUrl/tumYemekleriGetir.php'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['yemekler'];
      return jsonResponse.map((yemek) => Yemek.fromJson(yemek)).toList();
    } else {
      throw Exception('Yemekleri yüklerken hata oluştu');
    }
  }

  // Sepete yemek ekleme
  Future<void> sepeteYemekEkle(String kullaniciAdi, Yemek yemek, int adet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepeteYemekEkle.php'),
      body: {
        'yemek_adi': yemek.yemekAdi,
        'yemek_resim_adi': yemek.yemekResimAdi,
        'yemek_fiyat': yemek.yemekFiyat.toString(),
        'yemek_siparis_adet': adet.toString(),
        'kullanici_adi': kullaniciAdi,
      },
    );

    if (response.statusCode == 200) {
      print("Yemek sepete eklendi: ${response.body}");
    } else {
      throw Exception('Yemek eklenirken hata: ${response.statusCode}');
    }
  }

  // Sepetteki yemekleri getir
  Future<List<Yemek>> sepettekiYemekleriGetir(String kullaniciAdi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepettekiYemekleriGetir.php'),
      body: {
        'kullanici_adi': kullaniciAdi,
      },
    );

    if (response.statusCode == 200) {
      print("Sepetteki Yemekler API Yanıtı: ${response.body}");
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == 0) {
        throw Exception(jsonResponse['message']);
      }
      // Burada 'sepet_yemekler' alanını kullanmalısınız
      return (jsonResponse['sepet_yemekler'] as List).map((yemek) => Yemek.fromJson(yemek)).toList();
    } else {
      throw Exception('Yemekleri alırken hata: ${response.statusCode}');
    }
  }


  // Sepetten yemek silme
  Future<void> sepettenYemekSil(String kullaniciAdi, int sepetYemekId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sepettenYemekSil.php'),
      body: {
        'kullanici_adi': kullaniciAdi,
        'sepet_yemek_id': sepetYemekId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Sepetten yemek silinirken hata oluştu');
    }
  }


}

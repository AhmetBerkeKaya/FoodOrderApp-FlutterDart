class Yemek {
  String yemekAdi;
  String yemekResimAdi;
  int yemekFiyat;
  int yemekId;
  int adet;
  bool isLiked; // Yeni özellik
  // Base URL tanımı
  static const String baseUrl = 'http://kasimadalan.pe.hu/yemekler/resimler/';

  Yemek({
    required this.yemekAdi,
    required this.yemekResimAdi,
    required this.yemekFiyat,
    required this.yemekId,
    this.adet = 1,
    this.isLiked = false, // Varsayılan olarak beğenilmemiş
  });

  factory Yemek.fromJson(Map<String, dynamic> json) {
    return Yemek(
      yemekAdi: json['yemek_adi'] ?? '',
      yemekResimAdi: json['yemek_resim_adi'] ?? '',
      yemekFiyat: int.tryParse(json['yemek_fiyat'] ?? '0') ?? 0,
      yemekId: int.tryParse(json['sepet_yemek_id'] ?? '0') ?? 0,
      adet: int.tryParse(json['yemek_siparis_adet'] ?? '1') ?? 1, // Burada yemek_siparis_adet'i alıyoruz
    );
  }

  // Yemek resminin tam URL'sini döndür
  String get yemekResimUrl => '$baseUrl$yemekResimAdi';
}

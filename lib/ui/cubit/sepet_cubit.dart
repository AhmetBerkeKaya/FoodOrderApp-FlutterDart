import 'package:bitirme_projesi/data/entity/yemek.dart';
import 'package:bitirme_projesi/data/repo/yemek_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SepetCubit extends Cubit<List<Yemek>> {
  final YemekRepository yemekRepository;
  final String kullaniciAdi;

  SepetCubit(this.yemekRepository, this.kullaniciAdi) : super([]);

  void fetchSepettekiYemekler() async {
    try {
      final yemekler = await yemekRepository.sepettekiYemekleriGetir(kullaniciAdi);
      emit(yemekler);
    } catch (e) {
      print(e);
      emit([]); // Hata durumunda boş bir liste yayınlayın
    }
  }

  void silSepettenYemek(int sepetYemekId) async {
    try {
      await yemekRepository.sepettenYemekSil(kullaniciAdi, sepetYemekId);
      fetchSepettekiYemekler(); // Sepet güncellemelerini çek
    } catch (e) {
      print(e);
    }
  }

  void sepeteYemekEkle(Yemek yemek, int adet) async {
    try {
      await yemekRepository.sepeteYemekEkle(kullaniciAdi, yemek, adet);
      fetchSepettekiYemekler(); // Sepet güncellemelerini çek
    } catch (e) {
      print(e);
    }
  }

  void adetArtir(int sepetYemekId) {
    final yemekler = state;
    final yemekIndex = yemekler.indexWhere((yemek) => yemek.yemekId == sepetYemekId);
    if (yemekIndex != -1) {
      yemekler[yemekIndex].adet++;
      emit(List.from(yemekler)); // Durumu güncelle
    }
  }

  void adetAzalt(int sepetYemekId) {
    final yemekler = state;
    final yemekIndex = yemekler.indexWhere((yemek) => yemek.yemekId == sepetYemekId);
    if (yemekIndex != -1) {
      if (yemekler[yemekIndex].adet > 1) {
        yemekler[yemekIndex].adet--;
        emit(List.from(yemekler)); // Durumu güncelle
      } else {
        // Adet 1'den az olamazsa, silme işlemi yapılabilir
        silSepettenYemek(sepetYemekId);
      }
    }
  }
}

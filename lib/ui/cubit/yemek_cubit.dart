import 'package:bitirme_projesi/data/entity/yemek.dart';
import 'package:bitirme_projesi/data/repo/yemek_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YemekCubit extends Cubit<List<Yemek>> {
  final YemekRepository yemekRepository;

  YemekCubit(this.yemekRepository) : super([]);

  void fetchYemekler() async {
    try {
      final yemekler = await yemekRepository.tumYemekleriGetir();
      emit(yemekler);
    } catch (e) {
      print(e);
    }
  }
}

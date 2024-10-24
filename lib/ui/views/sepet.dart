import 'package:bitirme_projesi/data/repo/yemek_repository.dart';
import 'package:bitirme_projesi/ui/views/odeme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/data/entity/yemek.dart';

class Sepet extends StatefulWidget {
  final String kullaniciAdi;

  Sepet({required this.kullaniciAdi});

  @override
  _SepetState createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  @override
  Widget build(BuildContext context) {
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
          'Sepetim',
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
            icon: Icon(Icons.home_outlined,color: Colors.white, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => SepetCubit(YemekRepository(), widget.kullaniciAdi)..fetchSepettekiYemekler(),
        child: BlocBuilder<SepetCubit, List<Yemek>>(
          builder: (context, yemekler) {
            if (yemekler.isEmpty) {
              return Center(
                child: Text('Sepetiniz boş!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              );
            }

            int toplamTutar = yemekler.fold(0, (sum, yemek) => sum + (yemek.yemekFiyat * yemek.adet));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: yemekler.length,
                    itemBuilder: (context, index) {
                      final yemek = yemekler[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(yemek.yemekResimUrl),
                          ),
                          title: Text(yemek.yemekAdi, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${yemek.yemekFiyat} ₺ x ${yemek.adet} = ${yemek.yemekFiyat * yemek.adet} ₺',
                                  style: TextStyle(fontSize: 16)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (yemek.adet > 1) {
                                        context.read<SepetCubit>().adetAzalt(yemek.yemekId);
                                      } else {
                                        context.read<SepetCubit>().silSepettenYemek(yemek.yemekId);
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      context.read<SepetCubit>().adetArtir(yemek.yemekId);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      context.read<SepetCubit>().silSepettenYemek(yemek.yemekId);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Toplam tutar gösterimi
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
                      Text('Toplam Tutar: ${toplamTutar} ₺',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ),
                // Ödeme sayfasına geçiş butonu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Ödeme sayfasına geçiş
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Odeme(toplamTutar: toplamTutar),
                        ),
                      );
                    },
                    child: Text('Ödemeye Geç', style: TextStyle(fontSize: 20, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 125),
                      textStyle: TextStyle(fontSize: 20),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

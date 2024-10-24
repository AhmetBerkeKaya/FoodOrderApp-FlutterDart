import 'package:bitirme_projesi/data/entity/yemek.dart';
import 'package:bitirme_projesi/data/repo/yemek_repository.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/views/profil.dart';
import 'package:bitirme_projesi/ui/views/sepet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/yemek_cubit.dart';
import 'detay.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final Color primaryColor = Color(0xFF4CAF50); // Yeşil ton
  final Color backgroundColor = Color(0xFFFFFFFF); // Beyaz
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'Azalan'; // Varsayılan sıralama

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                "Yemek Siparişi Uygulaması",
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
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profil(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                hintStyle: TextStyle(color: Colors.grey[700]), // Hint rengi
                filled: true,
                fillColor: primaryColor.withOpacity(0.2), // Açık yeşil arka plan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Yuvarlak köşeler
                  borderSide: BorderSide.none, // Kenar çizgisi yok
                ),
                suffixIcon: Icon(Icons.search, color: primaryColor), // Arama ikonu
              ),
            ),
          ),

          // Sıralama dropdown menüsü
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: Align(
              alignment: Alignment.centerRight, // Sağ hizalama
              child: DropdownButton<String>(
                value: _selectedSort,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSort = newValue!;
                  });
                },
                items: <String>['Azalan', 'Artan', 'Normal']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),


          Expanded(
            child: BlocProvider(
              create: (context) => YemekCubit(YemekRepository())..fetchYemekler(),
              child: BlocBuilder<YemekCubit, List<Yemek>>(
                builder: (context, yemekler) {
                  // Arama sorgusuna göre yemekleri filtrele
                  final filteredYemekler = yemekler.where((yemek) {
                    return yemek.yemekAdi.toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  // Fiyata göre sıralama
                  if (_selectedSort == 'Artan') {
                    filteredYemekler.sort((a, b) => a.yemekFiyat.compareTo(b.yemekFiyat));
                  } else if (_selectedSort == 'Azalan') {
                    filteredYemekler.sort((a, b) => b.yemekFiyat.compareTo(a.yemekFiyat));
                  } else if (_selectedSort == 'En Eski') {
                    filteredYemekler.sort((a, b) => a.yemekId.compareTo(b.yemekId)); // veya tarih sıralaması ekleyebilirsiniz
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2'li grid
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7, // Kartların boyut oranı
                      ),
                      itemCount: filteredYemekler.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    'http://kasimadalan.pe.hu/yemekler/resimler/${filteredYemekler[index].yemekResimAdi}',
                                    height: 130, // Resim yüksekliği azaltıldı
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredYemekler[index].yemekAdi,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                        maxLines: 1, // Metnin taşmasını önler
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${filteredYemekler[index].yemekFiyat} ₺',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_shopping_cart,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider(
                                                      create: (context) =>
                                                          SepetCubit(
                                                              YemekRepository(),
                                                              'ahmetberke'),
                                                      child: Detay(
                                                          yemek:
                                                          filteredYemekler[index]),
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Sepet(kullaniciAdi: 'ahmetberke'),
            ),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

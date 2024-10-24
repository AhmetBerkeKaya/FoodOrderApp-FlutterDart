import 'package:flutter/material.dart';
import 'ui/views/anasayfa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Sipariş Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Anasayfa(),
    );
  }
}

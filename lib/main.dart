import 'package:flutter/material.dart';
import 'package:storage/sqflite_islemleri.dart';
import 'package:storage/utils/database_helper.dart';

import 'model/ogrenci.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DatabaseHelper dbh1 = DatabaseHelper();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //dbh1.ogrenciEkle(Ogrenci("emre", 1));
    //dbh1VerileriGetir();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: SqfliteIslemleri(),
    );
  }

  void dbh1VerileriGetir() async {
    var sonuc = await dbh1.tumOgrenciler();
    print(sonuc.toString());
  }
}

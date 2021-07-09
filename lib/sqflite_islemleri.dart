import 'package:flutter/material.dart';
import 'package:storage/model/ogrenci.dart';
import 'package:storage/utils/database_helper.dart';

class SqfliteIslemleri extends StatefulWidget {
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri> {
  DatabaseHelper _databaseHelper;
  List<Ogrenci> tumOgrencilerListesi;
  bool aktiflik = false;
  var _controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklanilanIndex;
  int tiklanilanID;

  @override
  void initState() {
    super.initState();
    tumOgrencilerListesi = List<Ogrenci>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for (Map okunanOgrenciMapi in tumOgrencileriTutanMapListesi) {
        tumOgrencilerListesi
            .add(Ogrenci.dbdenOkudugunMapiObjeyeDOnustur(okunanOgrenciMapi));
      }
      print("dbden gelen ogrenci sayisi:" +
          tumOgrencilerListesi.length.toString());
    }).catchError((hata) => print("hata" + hata));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sqflite Kullanımı"),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controller,
                      validator: (kontrolEdilecekIsimDegeri) {
                        if (kontrolEdilecekIsimDegeri.length < 3) {
                          return "en az 3 karakter olmalı";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Ogrenci ismini giriniz",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SwitchListTile(
                    title: Text("Aktif"),
                    value: aktiflik,
                    onChanged: (aktifMi) {
                      setState(
                        () {
                          aktiflik = aktifMi;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _ogrenciEkle(
                          Ogrenci(_controller.text, aktiflik == true ? 1 : 0));
                    }
                  },
                  child: Text("Kaydet"),
                  color: Colors.green,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _ogrenciGuncelle(
                        Ogrenci.withID(tiklanilanID, _controller.text,
                            aktiflik == true ? 1 : 0),
                      );
                    }
                  },
                  child: Text("Güncelle"),
                  color: Colors.yellow,
                ),
                RaisedButton(
                  onPressed: () {
                    _tumTabloyuTemizle();
                  },
                  child: Text("Tüm TABLOYU SİL"),
                  color: Colors.red,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tumOgrencilerListesi.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: tumOgrencilerListesi[index].aktif == 1
                        ? Colors.green
                        : Colors.red,
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _controller.text = tumOgrencilerListesi[index].isim;
                          aktiflik = tumOgrencilerListesi[index].aktif == 1
                              ? true
                              : false;
                          tiklanilanIndex = index;
                          tiklanilanID = tumOgrencilerListesi[index].id;
                        });
                      },
                      title: Text(tumOgrencilerListesi[index].isim),
                      subtitle: Text(tumOgrencilerListesi[index].id.toString()),
                      trailing: GestureDetector(
                        onTap: () {
                          _ogrenciSil(tumOgrencilerListesi[index].id, index);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ogrenciEkle(Ogrenci ogrenci) async {
    var eklenenYeniOgrencininIDsi = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenYeniOgrencininIDsi;
    if (eklenenYeniOgrencininIDsi > 0) {
      setState(() {
        tumOgrencilerListesi.insert(0, ogrenci);
      });
    }
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumOgrenciTablosunuSil();
    if (silinenElemanSayisi > 0) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(silinenElemanSayisi.toString() + "Kayit silindi"),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        tumOgrencilerListesi.clear();
      });
    }
  }

  void _ogrenciSil(int id, int index) async {
    var sonuc = await _databaseHelper.ogrenciSil(id);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Kayit silindi"),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        tumOgrencilerListesi.removeAt(index);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Silerken hata"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Kayit Güncellendi"),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        tumOgrencilerListesi[tiklanilanIndex] = ogrenci;
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Silerken hata"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

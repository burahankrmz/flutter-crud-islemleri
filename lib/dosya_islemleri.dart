import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DosyaIslemleri extends StatefulWidget {
  DosyaIslemleri({Key key}) : super(key: key);

  @override
  _DosyaIslemleriState createState() => _DosyaIslemleriState();
}

class _DosyaIslemleriState extends State<DosyaIslemleri> {
  var myTextController = TextEditingController();

  Future<String> get getklasorYolu async {
    Directory klasor = await getApplicationDocumentsDirectory();
    debugPrint("path:" + klasor.path);
    return klasor.path;
  }

  Future<File> get dosyaOlustur async {
    var olusturulacakDosyaninKlasorununYolu = await getklasorYolu;
    return File(olusturulacakDosyaninKlasorununYolu + "/myDosya.txt");
  }

  Future<String> dosyaOku() async {
    try {
      var myDosya = await dosyaOlustur;
      String dosyaIcerigi = await myDosya.readAsStringSync();
      return dosyaIcerigi;
    } catch (exception) {
      return "hATA CIKTI";
    }
  }

  Future<File> dosyayaYaz(String yazi) async {
    var myDosya = await dosyaOlustur;
    return myDosya.writeAsString(yazi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dosya işlemleri"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myTextController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Buraya yazılacak değerler dosyaya kaydedilir"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(onPressed: _dosyaOku, child: Text("Dosya OKU")),
                ElevatedButton(onPressed: _dosyaYaz, child: Text("Dosya yAZ")),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _dosyaOku() async {
    debugPrint(await dosyaOku());
  }

  void _dosyaYaz() {
    dosyayaYaz(myTextController.text.toString());
  }
}

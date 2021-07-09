import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKullanimi extends StatefulWidget {
  @override
  _SharedPrefKullanimiState createState() => _SharedPrefKullanimiState();
}

class _SharedPrefKullanimiState extends State<SharedPrefKullanimi> {
  String isim;
  int id;
  bool cinsiyet;
  var formKey = GlobalKey<FormState>();
  var mySharedPrefences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sf) => mySharedPrefences = sf);
  }

  @override
  void dispose() {
    mySharedPrefences.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share Kullanımı"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (value) {
                    isim = value;
                  },
                  decoration: InputDecoration(
                    labelText: "İsmini gir",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (value) {
                    id = int.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Idni gir",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(
                  value: true,
                  groupValue: cinsiyet,
                  onChanged: (secildi) {
                    setState(
                      () {
                        cinsiyet = secildi;
                      },
                    );
                  },
                  title: Text("Erkek"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(
                  value: false,
                  groupValue: cinsiyet,
                  onChanged: (secildi) {
                    setState(
                      () {
                        cinsiyet = secildi;
                      },
                    );
                  },
                  title: Text("Kadın"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _ekle,
                    child: Text("KAYDET"),
                  ),
                  ElevatedButton(
                    onPressed: _sil,
                    child: Text("SİL"),
                  ),
                  ElevatedButton(
                    onPressed: _goster,
                    child: Text("GÖSTER"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _ekle() async {
    formKey.currentState.save();
    await (mySharedPrefences as SharedPreferences).setString("myName", isim);
    await (mySharedPrefences as SharedPreferences).setInt("myId", id);
    await (mySharedPrefences as SharedPreferences)
        .setBool("myCinsiyet", cinsiyet);
  }

  void _goster() {
    debugPrint(
        (mySharedPrefences as SharedPreferences).getString("myName") ?? "NULL");
    debugPrint(
        (mySharedPrefences as SharedPreferences).getInt("myId").toString() ??
            "NULL");
    debugPrint((mySharedPrefences as SharedPreferences)
            .getBool("myCinsiyet")
            .toString() ??
        "NULL");
  }

  void _sil() {
    (mySharedPrefences as SharedPreferences).remove("myName");
    (mySharedPrefences as SharedPreferences).remove("myId");
    (mySharedPrefences as SharedPreferences).remove("myCinsiyet");
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_kisiler_http/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KisiKayit extends StatefulWidget {
  const KisiKayit({Key? key}) : super(key: key);

  @override
  State<KisiKayit> createState() => _KisiKayitState();
}

class _KisiKayitState extends State<KisiKayit> {

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> kayit(String param1, String param2) async{
    var url = Uri.parse("http://kasimadalan.pe.hu./kisiler/insert_kisiler.php");
    var veri = {"kisi_ad": param1, "kisi_tel":param2};
    var yanit = await http.post(url,body: veri);
    print("Ekleme Cevabı : ${yanit.body}");
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Anasayfa()));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(





      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Kişi Kaydı"),
      ),












      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[


              TextField(
                controller: tfKisiAdi,
                decoration: const InputDecoration(hintText: "Kişi Adı",),
              ),

              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(hintText: "Kişi Cep Telefonu",),
              ),


            ],
          ),
        ),
      ),















      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          kayit(tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'Kişi Ekle',
        icon: const Icon(Icons.add_card),
        label: const Text("Kaydet"),
      ),










    );
  }
}

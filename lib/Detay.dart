import 'package:flutter/material.dart';
import 'package:flutter_kisiler_http/Kisiler.dart';
import 'package:flutter_kisiler_http/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Detay extends StatefulWidget {
  Kisiler kisi;

  Detay({required this.kisi});

  @override
  State<Detay> createState() => _DetayState();
}

class _DetayState extends State<Detay> {

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();


  Future<void> guncelle(int param0, String param1, String param2) async{
    var url = Uri.parse("http://kasimadalan.pe.hu./kisiler/update_kisiler.php");
    var veri = {"kisi_id": param0.toString(), "kisi_ad": param1, "kisi_tel":param2};
    var yanit = await http.post(url,body: veri);
    print("Ekleme Cevabı : ${yanit.body}");

    Navigator.push(context, MaterialPageRoute(builder: (context)=>Anasayfa()));
  }


  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAdi.text = kisi.kisi_ad;
    tfKisiTel.text = kisi.kisi_tel;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Kişi Detayı"),
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
          guncelle(int.parse(widget.kisi.kisi_id), tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'Kişi Güncelle',
        icon: const Icon(Icons.update_outlined),
        label: const Text("Güncelle"),
      ),
    );
  }
}

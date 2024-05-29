import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kisiler_http/Kisiler.dart';
import 'package:flutter_kisiler_http/Detay.dart';
import 'package:flutter_kisiler_http/KisiKayitSayfasi.dart';
import 'package:flutter_kisiler_http/KisilerCevap.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Anasayfa(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Anasayfa extends StatefulWidget {


  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {




  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";


  List<Kisiler> parseKCevap(String cevap){
    return Cevap.fromJson(json.decode(cevap)).kisilerListesi;
  }



 Future<List<Kisiler>> tumKisileriGoster() async{
    var url = Uri.parse("http://kasimadalan.pe.hu./kisiler/tum_kisiler.php");
    var yanit = await http.get(url);
    return parseKCevap(yanit.body);
  }


  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async{
    var url = Uri.parse("http://kasimadalan.pe.hu./kisiler/tum_kisiler_arama.php");
    var veri = {"kisi_ad": aramaKelimesi};
    var yanit = await http.post(url,body: veri);
    return parseKCevap(yanit.body);
  }




  Future<void> sil(int kisi_id) async{
    var url  = Uri.parse("http://kasimadalan.pe.hu./kisiler/delete_kisiler.php");
    var veri = {"kisi_id": kisi_id.toString()};
    var yanit = await http.post(url,body: veri);
    print("Silinme Cevabı : ${yanit.body}");
    setState(() {

        });
  }




  Future<bool> closeApp() async{
    await exit(0);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(





      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,


        leading: IconButton(
            onPressed: (){
              closeApp();
            },
            icon: const Icon(Icons.arrow_back_ios)),


        title: aramaYapiliyorMu ?
        TextField(
          decoration: const InputDecoration(
            hintText: "Aramak için bir şey yazın",
          ),
          onChanged: (aramaSonucu){
            print("Arama sonucu : $aramaSonucu");
            setState(() {
              aramaKelimesi = aramaSonucu;
            });
          },
        )


            :


        const Text("Kişiler Listesi"),


        actions: [
          aramaYapiliyorMu ?


          IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
                aramaKelimesi = "";
              });
            },
            icon: const Icon(Icons.cancel_outlined),
          )



              :


          IconButton(
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
            icon: const Icon(Icons.person_search_outlined),
          ),


        ],
      ),















      body: WillPopScope(
        onWillPop: closeApp,
        child: FutureBuilder<List<Kisiler>>(


            future: aramaYapiliyorMu?

            aramaYap(aramaKelimesi)      :     tumKisileriGoster(),





            builder: (context,snapshot){


              if(snapshot.hasData){
                var kisilerListesi = snapshot.data;
                return ListView.builder(
                    itemCount: kisilerListesi!.length,
                    itemBuilder: (context,index){
                      var kisiMain = kisilerListesi[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Detay(kisi: kisiMain,)));
                        },
                        child: Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(kisiMain.kisi_ad,style: const TextStyle(fontWeight: FontWeight.bold),),
                                Text(kisiMain.kisi_tel),
                                IconButton(
                                    onPressed: (){
                                      sil(int.parse(kisiMain.kisi_id));
                                    },
                                    icon: const Icon(Icons.delete_forever_outlined) ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              }else{
                return Container(
                  color: Colors.indigoAccent,
                );
              }
            }
        ),
      ),
















      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const KisiKayit()));
        },
        tooltip: 'Kişi Ekle',
        child: const Icon(Icons.add_card),
      ),
















    );
  }
}
import 'package:flutter_kisiler_http/Kisiler.dart';

class Cevap{
  int success;
  List<Kisiler> kisilerListesi;

  Cevap(this.success, this.kisilerListesi);

  factory Cevap.fromJson(Map<String,dynamic> json){
    var jsonDizisi = json["kisiler"] as List;
    List<Kisiler> yerelKisilerListesi = jsonDizisi.map((e) => Kisiler.fromJson(e)).toList();
    return Cevap(json["success"] as int, yerelKisilerListesi);
  }
}
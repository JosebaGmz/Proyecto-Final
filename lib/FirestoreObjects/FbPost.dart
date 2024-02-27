import 'package:cloud_firestore/cloud_firestore.dart';

class FbPost{


  final String titulo;
  final String cuerpo;
  final String sUrlImg;
  final String marca;
  final String color;
  final int talla;
  final int precio;

  FbPost ({
    required this.titulo,
    required this.cuerpo,
    required this.sUrlImg,
    required this.talla,
    required this.marca,
    required this.color,
    required this.precio
  });

  factory FbPost.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbPost(
        titulo: data?['titulo'],
        cuerpo: data?['cuerpo'],
        sUrlImg: data?['sUrlImg'] != null ? data!['sUrlImg'] : "",
        talla: data?['talla'] ?? 0,
        marca: data? ['marca'],
        color: data? ['color'],
        precio: data? ['precio'] ?? 1
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (titulo != null) "titulo": titulo,
      if (cuerpo != null) "cuerpo": cuerpo,
      if (sUrlImg != null) "sUrlImg": sUrlImg,
      if (talla != null) "talla": talla,
      if(marca != null) "marca": marca,
      if(color != null) "color": color,
      if(precio != null) "precio": precio,
    };
  }
}
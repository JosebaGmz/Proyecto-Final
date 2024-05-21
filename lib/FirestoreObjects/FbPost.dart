import 'package:cloud_firestore/cloud_firestore.dart';

class FbPost{

  final String? id; // Nuevo campo para almacenar el ID del documento
  final String titulo;
  final String cuerpo;
  final String sUrlImg;
  final String marca;
  final String color;
  final int talla;
  final int precio;

  FbPost ({
    this.id, // Actualización del constructor para incluir el campo id
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
        id: snapshot.id, // Asigna el ID del documento al campo id
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
      if (id != null) "id": id, // Agrega el campo id al documento
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

import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario{

  final String nombre;
  final int edad;
  final double talla;
  GeoPoint geoloc;

  FbUsuario ({
    required this.nombre,
    required this.edad,
    required this.talla,
    required this.geoloc
  });

  factory FbUsuario.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return FbUsuario(
        nombre: data?['nombre'] != null ? data!['nombre'] : "",
        edad: data?['edad'] != null ? data!['edad'] : 0,
        talla: data?['talla'] != null ? data!['talla'] : 0,
        geoloc:data?['geoloc'] != null ? data!['geoloc'] : GeoPoint(0, 0)

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nombre != null) "nombre": nombre,
      if (edad != null) "edad": edad,
      if (talla != null) "talla": talla,
      if (geoloc != null) "geoloc": geoloc,
    };
  }

}
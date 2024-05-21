import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/FirestoreObjects/FbPost.dart';

import '../SingleTone/DataHolder.dart';

class PostGridCellView extends StatelessWidget {
  final FbPost datosPost;
  final String sText;
  final int iColorCode;
  final double dFontSize;
  final double dHeight;
  final int iPosicion;
  final int precio;
  final String sUrlImg;
  final Function(int indice) onItemListClickedFun;

  const PostGridCellView({super.key,
    required this.sText,
    required this.iColorCode,
    required this.dFontSize,
    required this.dHeight,
    required this.iPosicion,
    required this.datosPost,
    required this.onItemListClickedFun,
    required this.precio,
    required this.sUrlImg
  });

  void _mostrarDialogoModificar(BuildContext context) {
    String? nuevoTitulo;
    String? nuevoCuerpo;
    String? nuevaUrlImg;
    int? nuevaTalla;
    String? nuevaMarca;
    String? nuevoColor;
    int? nuevoPrecio;

    nuevaUrlImg = datosPost.sUrlImg; // Conserva la misma URL de la imagen actual

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modificar post'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) => nuevoTitulo = value,
                  decoration: InputDecoration(labelText: 'Título', hintText: datosPost.titulo),
                ),
                TextField(
                  onChanged: (value) => nuevoCuerpo = value,
                  decoration: InputDecoration(labelText: 'Cuerpo', hintText: datosPost.cuerpo),
                ),
                TextField(
                  controller: TextEditingController(text: nuevaUrlImg), // Utiliza la URL actual como valor inicial
                  onChanged: (value) => nuevaUrlImg = value,
                  decoration: InputDecoration(labelText: 'URL Imagen', hintText: datosPost.sUrlImg),
                ),
                TextField(
                  onChanged: (value) => nuevaTalla = int.tryParse(value),
                  decoration: InputDecoration(labelText: 'Talla', hintText: datosPost.talla.toString()),
                ),
                TextField(
                  onChanged: (value) => nuevaMarca = value,
                  decoration: InputDecoration(labelText: 'Marca', hintText: datosPost.marca),
                ),
                TextField(
                  onChanged: (value) => nuevoColor = value,
                  decoration: InputDecoration(labelText: 'Color', hintText: datosPost.color),
                ),
                TextField(
                  onChanged: (value) => nuevoPrecio = int.tryParse(value),
                  decoration: InputDecoration(labelText: 'Precio', hintText: datosPost.precio.toString()),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                // Aquí deberías realizar alguna validación de los datos antes de guardarlos
                Map<String, dynamic> dataToUpdate = {
                  'titulo': nuevoTitulo,
                  'cuerpo': nuevoCuerpo,
                  'sUrlImg': nuevaUrlImg,
                  'talla': nuevaTalla,
                  'marca': nuevaMarca,
                  'color': nuevoColor,
                  'precio': nuevoPrecio,
                };
                DataHolder().updateZapatillasStock(dataToUpdate,datosPost.id.toString());
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).popAndPushNamed("/drawerview");
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemListClickedFun(iPosicion);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          margin: EdgeInsets.only(left: 25),
          width: 280,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        sUrlImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      sText,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            '\€' + precio.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'modificar',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Modificar'),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'borrar',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Borrar'),
                      ),
                    ),
                  ],
                  onSelected: (String value) async {
                    if (value == 'modificar') {
                      _mostrarDialogoModificar(context);
                    } else if (value == 'borrar') {
                     DataHolder().deleteZapatilla(datosPost.id.toString());
                     Future.delayed(const Duration(seconds: 2), () {
                       Navigator.of(context).popAndPushNamed("/perfilview");
                     });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/LikeButton.dart';
import 'package:proyecto_psp_pmdm/FirestoreObjects/FbPost.dart';

import '../SingleTone/DataHolder.dart';
import '../SingleTone/FirebaseAdmin.dart';

class PostGridCellView extends StatefulWidget {
  final FbPost datosPost;
  final String sText;
  final int iColorCode;
  final double dFontSize;
  final double dHeight;
  final int iPosicion;
  final int precio;
  final String sUrlImg;
  final Function(int indice) onItemListClickedFun;

  const PostGridCellView({
    super.key,
    required this.sText,
    required this.iColorCode,
    required this.dFontSize,
    required this.dHeight,
    required this.iPosicion,
    required this.datosPost,
    required this.onItemListClickedFun,
    required this.precio,
    required this.sUrlImg,
  });

  @override
  _PostGridCellViewState createState() => _PostGridCellViewState();
}

class _PostGridCellViewState extends State<PostGridCellView> {
  bool isFavorite = false;

  @override
  void initState(){
    super.initState();
    isFavorite = widget.datosPost.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onItemListClickedFun(widget.iPosicion);
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
                        widget.sUrlImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.sText,
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
                            '\€' + widget.precio.toString(),
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
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 110,
                right: 10,
                child: LikeButton(post: widget.datosPost),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

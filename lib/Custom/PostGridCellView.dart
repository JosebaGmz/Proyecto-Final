import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostGridCellView extends StatelessWidget {
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
    required this.onItemListClickedFun,
    required this.precio,
    required this.sUrlImg
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*
    return InkWell(
      child: FractionallySizedBox(
        widthFactor: 0.95,
        heightFactor: 0.95,
        child: Container(
          height: dHeight,
          width: dHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blueGrey,
              image: DecorationImage(
                opacity: 0.3,
                image: NetworkImage(
                    "https://media.tenor.com/zBc1XhcbTSoAAAAC/nyan-cat-rainbow.gif"),
              )),
          color: Colors.amber[iColorCode],
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image.asset("resources/logo_kyty2.png",width: 70,
                  //    height: 70),
                  //Text(sText,style: TextStyle(fontSize: dFontSize)),
                  Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 260),
                      child: Text(
                        sText,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )),
                  Text(
                    precio.toString(),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 20,
                  ),
                  TextButton(
                      onPressed: null,
                      child: Text("+", style: TextStyle(fontSize: dFontSize)))
                ],
              )),
        ),
      ),
      onTap: () {
        onItemListClickedFun(iPosicion);
      },
    );
  }*/
    return InkWell(
      onTap: () {
        onItemListClickedFun(iPosicion);
      },
      child: Container(
        margin: EdgeInsets.only(left: 25),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
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
      ),
    );
  }
}

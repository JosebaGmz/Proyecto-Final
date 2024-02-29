import 'package:flutter/material.dart';

class CButton extends StatelessWidget{

  String text;
  VoidCallback onPressed;
  double paddingH;
  double paddingV;

  CButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.paddingH = 20,
    this.paddingV = 20,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Padding(
       padding: EdgeInsets.symmetric(horizontal: paddingH,vertical: paddingV),
     child: ElevatedButton(
       onPressed: onPressed,
       style: ElevatedButton.styleFrom(
         padding: EdgeInsets.all(16.0),
         backgroundColor: Colors.blueGrey,),
       child: Text(
         text,
         style: TextStyle(fontSize: 16,color: Colors.white),
       ),
     ),
   );
  }
}
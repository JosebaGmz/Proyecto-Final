import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTextF extends StatelessWidget{

  String hint;
  TextEditingController tController;
  bool password;
  double paddingH;
  double paddingV;

  CTextF({Key? key,
    required this.hint,
    required this.tController,
    required this.password,
    this.paddingH=65,
    this.paddingV=20
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: paddingH,vertical: paddingV),
      child: Row(children: [
        Flexible(child: TextFormField(
          controller: tController,
          obscureText: password,
          enableSuggestions: !password,
          autocorrect: !password,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.white38,
            filled: true,
            labelText: hint,
          ),
        ),
        ),
      ],),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BottomMenu extends StatelessWidget{

  Function(int indice)? onBotonesClicked;
  Function(String nombre)? onPressed=null;

  BottomMenu({Key? key,required this.onBotonesClicked
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    /*return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(onPressed: () => onBotonesClicked!(0), child: Icon(Icons.list,color: Colors.black,)),
          TextButton(onPressed: () => onBotonesClicked!(1), child: Icon(Icons.grid_view,color: Colors.black,)),
          IconButton(onPressed: () => onBotonesClicked!(2), icon: Icon(Icons.exit_to_app,color: Colors.black,))
        ]
    );*/
    return NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: 0,
        onDestinationSelected: onBotonesClicked,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.shop), label: 'Shop'),
          NavigationDestination(icon: Icon(CupertinoIcons.heart_fill), label: 'WishList'),
          NavigationDestination(icon: Icon(Icons.supervised_user_circle_sharp), label: 'Profile'),
        ],
    );
  }
}
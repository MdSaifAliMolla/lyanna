import 'package:flutter/material.dart';
import 'package:lyanna/style.dart';

class drawerItem extends StatelessWidget {
  final name;
  final icon;
  final destination;

  drawerItem({super.key,required this.name,required this.icon, this.destination});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:Text(name,style: AppWidget.LightTextStyle(),),
      leading:Icon(icon),
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>destination)
        );
      },
    );
  }
}
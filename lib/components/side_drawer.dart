import 'package:flutter/material.dart';
import 'package:lyanna/style.dart';

class drawerItem extends StatelessWidget {
  final name;
  final icon;
  final destination;

  const drawerItem({super.key,required this.name,required this.icon, this.destination});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left:20),
      title:Text(name,style: AppWidget.LightTextStyle().copyWith(color: Colors.white),),
      leading:Icon(icon,color: Colors.white,),
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>destination)
        );
      },
    );
  }
}
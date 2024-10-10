import 'package:flutter/material.dart';
import 'package:lyanna/style.dart';

class about extends StatelessWidget {
  const about({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:Center(
        child: Text('Made with love ❤️ by Saif!',
        style:AppWidget.boldTextStyle(),),
      )
    );
  }
}
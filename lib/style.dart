import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              //fontFamily: 'Poppins'
     );
  }
  static TextStyle HeadTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              //fontFamily: 'Poppins'
     );
  }
  static TextStyle LightTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              //fontFamily: 'Poppins'
     );
  }
  static TextStyle SpecialTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.w900,          
     );
  }
}

final secondaryColor= Color.fromRGBO(165, 186, 231, 0.1);
double headerfont=30;
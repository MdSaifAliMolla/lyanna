import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily:'DMSerif'
     );
  }
  static TextStyle HeadTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily:'DMSerif'
     );
  }
  static TextStyle LightTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily:'DMSerif'
     );
  }
  static TextStyle SpecialTextStyle(){
    return const TextStyle(
              color: Colors.black,
              fontSize: 37,
              fontWeight: FontWeight.w900,  
              fontFamily:'DMSerif'        
     );
  }
}

const secondaryColor= Color.fromRGBO(165, 186, 231, 0.1);
double headerfont=30;

BoxDecoration neu(){
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow:const [ BoxShadow(
      color: Color.fromARGB(255, 151, 149, 149),
      offset: Offset(4,4),
      blurRadius: 10,
      spreadRadius: 1
    ),
    BoxShadow(
      color: Colors.white,
      offset: Offset(-4,-4),
      blurRadius: 10,
      spreadRadius: 1
    ),
    ]
  );
}
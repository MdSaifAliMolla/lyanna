import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/pages/cart.dart';
import 'package:lyanna/pages/payment.dart';
import 'package:lyanna/pages/profile.dart';

import '../pages/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int currentTabIndex = 0;
  late List<Widget>pages;
  late Widget currentPage;
  late Home homepage;
  late CartPage order;
  late Profile profile;
  //late Payment payment;

  @override
  void initState() {
    homepage=Home();
    profile=Profile();
    order=CartPage();
    //payment=Payment();
    pages=[homepage,order,profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(microseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
          });
        },
        items:[
          Icon(Icons.home_outlined,color: Colors.white,),
          Icon(Icons.shopping_cart,color: Colors.white,),
          //Icon(Icons.wallet_outlined,color: Colors.white,),
          Icon(Icons.person,color: Colors.white,)
        ] 
      ),
      body: pages[currentTabIndex],
    );
  }
}
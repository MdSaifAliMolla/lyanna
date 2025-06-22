import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/admin/admin_home.dart';
import 'package:lyanna/components/side_drawer.dart';
import 'package:lyanna/pages/cart.dart';
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

  @override
  void initState() {
    homepage=const Home();
    profile=const Profile();
    order=const CartPage();
    pages=[homepage,order,profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.grey.shade300,
        color: Colors.grey.shade900,
        animationDuration: const Duration(microseconds: 500),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
          });
        },
        items:const [
          Icon(Icons.home,color: Colors.white,),
          Icon(Icons.shopping_cart,color: Colors.white,),
          Icon(Icons.person,color: Colors.white,)
        ] 
      ),
      body: pages[currentTabIndex],
    );
  }
}
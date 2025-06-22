import 'dart:async';
import 'package:lyanna/pages/details.dart';
import 'package:lyanna/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String id = FirebaseAuth.instance.currentUser!.uid;
  Stream? ItemStream;
  int total=0;
   
   onthload()async{
    ItemStream = await DatabaseMethods().getCart(id);
    setState(() {
      
    });
  }
  @override
  void initState() {
    loadWishlist();
    super.initState();
  }

  loadWishlist() async {
    ItemStream = FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Wishlist')
        .snapshots();
    setState(() {});
  }

  Future<void> removeFromWishlist(String itemName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Wishlist')
        .where('Name', isEqualTo: itemName)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemName removed from Wishlist!')),
    );
  }


  Widget Wish(){
    return StreamBuilder(stream:ItemStream , builder: (context,AsyncSnapshot snapshot){

      return snapshot.hasData?ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,

        itemBuilder: (context, index) {

          DocumentSnapshot ds = snapshot.data.docs[index];
          total=total+int.parse(ds['Price']);
          return GestureDetector(
            onTap: () =>Navigator.push(context,MaterialPageRoute(
              builder:(context)=>Details(
                description:ds['Description'], image:ds['Image'], price:ds['Price'], name:ds['Name'])
            )),
            child: Container(
                margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 240, 239, 239),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 7,
                    spreadRadius: 1
                  )],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal:5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 120,
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(ds['Image'],
                              height:100,width: 100,
                              fit: BoxFit.fitHeight,
                              ),) ,
                          ),
                          const SizedBox(width: 13,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ds['Name'],style: AppWidget.boldTextStyle().copyWith(
                                  overflow: TextOverflow.ellipsis,fontSize: 18
                                ),maxLines: 2,),
                                const SizedBox(height: 15,),
                                Text('Rs. '+ds['Price'],style: AppWidget.LightTextStyle(),),
                                      
                              ],
                            ),
                          ),
                          
                          GestureDetector(
                            onTap: (){
                              removeFromWishlist(ds['Name']);
                            },
                            child: const Icon(Icons.delete)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          );
        },
      )
      :const CircularProgressIndicator();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text('Wishlist ',style: AppWidget.HeadTextStyle().copyWith(fontSize: 28))),),
        body: Wish(),
      );
    
  } 
} 


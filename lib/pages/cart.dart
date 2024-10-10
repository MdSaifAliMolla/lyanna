import 'dart:async';
import 'package:lyanna/pages/address.dart';
import 'package:lyanna/pages/details.dart';
import 'package:lyanna/style.dart';

//import 'details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String id = FirebaseAuth.instance.currentUser!.uid;
  Stream? ItemStream;
  int total=0;
  //List<PaymentItem>paymentItems=[];

  void startTimer(){
    Timer(const Duration(seconds:1), () {
    setState(() {
          
        });
     });
  }
   
   onthload()async{
    ItemStream = await DatabaseMethods().getCart(id);
    setState(() {
      
    });
  }
  @override
  void initState() {
    onthload();
    startTimer();
    super.initState();
  }



  Widget Cart(){
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
              builder:(context)=>Details(description:ds['Description'], image:ds['Image'], price:ds['Price'], name:ds['Name'])
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
                              fit: BoxFit.cover,
                              ),) ,
                          ),
                          const SizedBox(width: 30,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ds['Name'],style: AppWidget.boldTextStyle(),),
                              const SizedBox(height: 15,),
                              Text('Rs. '+ds['Price'],style: AppWidget.LightTextStyle(),),
          
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              FirebaseFirestore.instance.collection("users").doc(id).collection('Cart').doc(ds.id).delete();
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
  void onGooglePayResult(res){
    print('yes');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text('Cart',style: AppWidget.HeadTextStyle().copyWith(fontSize: 28))),),
      body: Column(
        children: [
          Container(
            child: Cart(),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 7),
            child: Row(
              children: [
                Text('Total Price',style: AppWidget.SpecialTextStyle().copyWith(fontSize: 25),),
                const Spacer(),
                Text('Rs. $total',style: AppWidget.SpecialTextStyle(),)
              ],
              ),
          ),
           const SizedBox(height:7),
            
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(
              builder:(context)=>const AddressPage(
              )));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20,left: 15,right: 15),
              height: 53,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8)
              ),
              child:const Center(child: Text(
                'Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  fontFamily: 'DMSerif',
                  color: Colors.white70,
                ),),),
          
            ),
          )
        ],
      ),
            
    );
    
  } 
} 


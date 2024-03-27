import 'dart:async';
import 'package:lyanna/pages/address.dart';
import 'package:lyanna/pages/details.dart';
import 'package:lyanna/pages/payment.dart';
import 'package:lyanna/style.dart';

//import 'details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay/pay.dart';


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
    Timer(Duration(seconds:1), () {
    setState(() {
          
        });
     });
    ;
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
          //paymentItems.add(PaymentItem(amount:ds['Price'],label:ds['Name'],status:PaymentItemStatus.final_price));
          
          return GestureDetector(
            onTap: () =>Navigator.push(context,MaterialPageRoute(
              builder:(context)=>Details(description:ds['Description'], image:ds['Image'], price:ds['Price'], name:ds['Name'])
            )),
            child: Container(
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(30),
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
                             // total=total-int.parse(ds['Price']) ;
                              FirebaseFirestore.instance.collection("users").doc(id).collection('Cart').doc(ds.id).delete();
                            },
                            child: Icon(Icons.delete)
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
      appBar: AppBar(title: Center(child: Text('Cart',style: AppWidget.HeadTextStyle().copyWith(fontSize: 28))),),
      body: Column(
        children: [
          Container(
            child: Cart(),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text('Total Price',style: AppWidget.SpecialTextStyle().copyWith(fontSize: 28),),
                Spacer(),
                Text('Rs. '+total.toString(),style: AppWidget.SpecialTextStyle(),)
              ],
              ),
          ),
           SizedBox(height: 15,),
            
          GestureDetector(
            onTap: () {
              Navigator.push(context,MaterialPageRoute(
              builder:(context)=>AddressPage(
               // paymentItems:paymentItems,
              )));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20,left: 15,right: 15),
              height: 53,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15)
              ),
              child:const Center(child: Text(
                'Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),),),
          
            ),
          )
        ],
      ),
            
    );
    
  } 
} 


//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';

class Details extends StatefulWidget {

  String name,image,description,price;
  Details({super.key,required this.description,required this.image,required this.price,required this.name});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  // int a=1;
  String id= FirebaseAuth.instance.currentUser!.uid;
  //bool ordered=false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 20,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              child: Image.network(widget.image,height:MediaQuery.of(context).size.height/2.5, width:MediaQuery.of(context).size.width,fit: BoxFit.cover,)),
              const SizedBox(height: 30,),

              Text(widget.name,style: AppWidget.HeadTextStyle(),),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a>1) {
                      --a;
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.remove,color: Colors.white,),
                  ),
                ),
                SizedBox(width: 20,),
                Text(a.toString()),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: () {
                    ++a;
                    setState(() {},);
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.add,color: Colors.white,),
                  ),
                ),
              ],
            ),*/
            const SizedBox(height: 10,),
            Container(
              height: 150,
              alignment: Alignment.topLeft,
              child: Text(widget.description,style: AppWidget.LightTextStyle(),)),
            const Spacer(),
            Divider(),
            const SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(bottom: 27),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price',style: AppWidget.LightTextStyle().copyWith(fontSize: 26),),
                      Text('Rs. '+ widget.price,style: AppWidget.HeadTextStyle(),),
                    ],),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                      child:
                        Container(
                            padding:const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                            alignment: Alignment.center,
                            width:MediaQuery.of(context).size.width/2.1 ,
                            child: GestureDetector(
                              onTap: ()async {
                               // if (ordered=false) {
                                  Map<String,dynamic>addToCart={
                                  'Name':widget.name,
                                  'Price':widget.price,
                                  'Image':widget.image,
                                  'Description':widget.description,
                                };
                                await DatabaseMethods().addToCart(addToCart,id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Item addaed to cart!'))
                                );
                              /* }else{
                                 ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Item alreddy addaed to cart!'))
                                );
                               }
                                ordered=true;*/
                                
                              },
                              child:const Row(
                                children: [
                                  Text('add to cart',style:TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25),),
                                  Spacer(),
                                  Icon(Icons.shopping_cart,color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
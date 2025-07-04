import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/admin/add_product.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminHome> {

  bool b=false,a=true;
  Stream?ItemStream;//ItemStream2;
  onthload()async{
    ItemStream = await DatabaseMethods().getItem('a');
    setState(() {});
  }

  @override
  void initState() {
    onthload();
    super.initState();
  }

  Widget myItems(){
    return StreamBuilder(stream:ItemStream , builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData?GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,

        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:secondaryColor,
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Image.network(ds['Image'],height: 130,width: 130,fit: BoxFit.fitHeight,),
                  Text(ds['Name'],style: AppWidget.boldTextStyle().copyWith(overflow: TextOverflow.ellipsis),),
                  //Text(ds['Description'],style: AppWidget.LightTextStyle(),),
                  Text('Rs.'+ ds['Price'],style: AppWidget.LightTextStyle(),),
                  const Spacer(),
                      GestureDetector(
                        child: const Icon(Icons.delete),
                        onTap:(){
                          FirebaseFirestore.instance.collection(a?'a':'b').doc(ds.id).delete();
                          setState(() {});
                        }
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

  Widget showItem(){
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async{
                a=true;
                b=false;
                ItemStream = await DatabaseMethods().getItem('a');
                setState(() {});
              },
              child: Material(
                elevation: 5,
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(color:a?Colors.black:const Color.fromRGBO(78, 117, 202, 0.377),
                  borderRadius: BorderRadius.circular(5)
                  ),
                    child:Text('Women',style: TextStyle(
                      color: a?Colors.white:Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),)
                ),
              ),
            ),
            GestureDetector(
              onTap: () async{
                a=false;
                b=true;
                ItemStream = await DatabaseMethods().getItem('b');
                setState(() {});
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  alignment: Alignment.center,
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(color:b?Colors.black:const Color.fromRGBO(78, 117, 202, 0.377),
                    borderRadius: BorderRadius.circular(5),
                    ),
                    child:Text('Men',style: TextStyle(
                      color: b?Colors.white:Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),)
                ),
              ),
            ),
            
          ],
        );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Home Admin',style: AppWidget.HeadTextStyle(),),),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              showItem(),
              const SizedBox(height: 20,),
              myItems(),
            ],
          ),
        ),
      ),


      
      floatingActionButton:FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddProductPage()));
        },
        tooltip:"Add a Product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


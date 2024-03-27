import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/admin/add_product.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';
import 'package:lyanna/service/database.dart';

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
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:secondaryColor,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(ds['Image'],height: 150,width: 150,fit: BoxFit.cover,),
                  Text(ds['Name'],style: AppWidget.boldTextStyle(),),
                  /*Text(ds['Description'],style: AppWidget.LightTextStyle(),),*/
                  Text('Rs.'+ds['Price'],style: AppWidget.LightTextStyle(),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.delete),
                        onTap:(){
                          var value;
                          if (a=true) {
                            value=a;
                          }
                          if (b=true) {
                            value=b;
                          }
                          FirebaseFirestore.instance.collection(value).doc(ds.id).delete();
                        }
                      ),
                      const Spacer(),
                      GestureDetector(
                        child: Icon(Icons.edit),
                        onTap:(){
                          
                        }
                      ),
                    ],
                  )
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
                  decoration: BoxDecoration(color:a?Colors.black:Color.fromRGBO(78, 117, 202, 0.377),
                  borderRadius: BorderRadius.circular(5)
                  ),
                    child:Text('a',style: TextStyle(
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
                    decoration: BoxDecoration(color:b?Colors.black:Color.fromRGBO(78, 117, 202, 0.377),
                    borderRadius: BorderRadius.circular(5),
                    ),
                    child:Text('b',style: TextStyle(
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
        child: Icon(Icons.add),
        tooltip:"Add a Product",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


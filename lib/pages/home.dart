import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/admin/admin_home.dart';
import 'package:lyanna/components/carousel_slider.dart';
import 'package:lyanna/pages/details.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/components/side_drawer.dart';
import 'package:lyanna/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  bool b=false,a=true;

  Stream?ItemStream;
  onthload()async{
    ItemStream = await DatabaseMethods().getItem('a');
    setState(() {
      
    });
  }
  @override
  void initState() {
    onthload();
    super.initState();
  }

  Widget allItems(){
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
        shrinkWrap:false,

        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(name: ds['Name'],
                    description: ds['Description'],
                    image: ds['Image'],
                    price: ds['Price'],
                    ))),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:secondaryColor,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Image.network(ds['Image'],height: 150,width: 150,fit: BoxFit.cover,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ds['Name'],style: AppWidget.boldTextStyle(),),
                                  Text('Rs.'+ds['Price'],style: AppWidget.LightTextStyle(),),
                                ],
                              ),
                              /*GestureDetector(
                                child: Icon(Icons.heart_broken_outlined),
                                onTap: (){},
                              ) */
                             ],
                            )
                            
                          ],
                        ),
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
      appBar: AppBar(
        title: Image.asset('assets/images/Lyanna.png',height:90,width:170,fit:BoxFit.fill,),
      ),
      drawer: Drawer(
        shadowColor:secondaryColor,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height/5,
              decoration:BoxDecoration(
                image: const DecorationImage(image:AssetImage('assets/images/Lyanna.png'),fit: BoxFit.fill,),
                borderRadius: BorderRadius.vertical(
                  bottom:Radius.elliptical(MediaQuery.sizeOf(context).width,110)
                )
              )
            ),
            drawerItem(name:'I am Seller', icon:Icons.settings,destination: const AdminHome(),),
            const SizedBox(height: 15,),

            drawerItem(name: 'About', icon:Icons.newspaper),
            const SizedBox(height: 15,),

            drawerItem(name:"Contact Us", icon:Icons.mail_outline_rounded)
            
          ],
        ),
      ),

      body:
        // margin: EdgeInsets.only(top: 10,left: 20,right: 10,bottom: 0),
         
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              
              // Text(
              //   "Discover",
              //   style:AppWidget.LightTextStyle(),
              // ),
              
              showItem(),
              
              const SizedBox(height: 20,),
             CarouselImage(),
              const SizedBox(height: 20,),
              Text(
                  "Premium collection",
                    style:AppWidget.HeadTextStyle(),
                  ),
                  const SizedBox(height: 20,),
              
              Container(
                height: 270,
                child: allItems()
              ),
              const SizedBox(height: 20,),
            ],
          ),
        
      
    );
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
                    decoration: BoxDecoration(color:b?Colors.black:const Color.fromRGBO(78, 117, 202, 0.377),
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
}
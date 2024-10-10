import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/admin/admin_home.dart';
import 'package:lyanna/components/bottomNavBar.dart';
import 'package:lyanna/components/carousel_slider.dart';
import 'package:lyanna/pages/about.dart';
import 'package:lyanna/pages/contact.dart';
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
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.70,
        ),
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap:true,

        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(name: ds['Name'],
                    description: ds['Description'],
                    image: ds['Image'],
                    price: ds['Price'],
                    ))),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[100],
                        boxShadow: [BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 15
                        )]
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Image.network(ds['Image'],
                            height: 150,width: 150,fit: BoxFit.cover,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height:13),
                                  Text(ds['Name'],style: AppWidget.boldTextStyle(),),
                                  const SizedBox(height: 6),
                                  Text('Rs.'+ds['Price'],style: AppWidget.LightTextStyle(),),
                                ],
                              ),
                              GestureDetector(
                                child: const Icon(Icons.shopping_bag),
                                onTap: (){},
                              ) 
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Lyanna",style: AppWidget.SpecialTextStyle(),),
      ),
      drawer: Drawer(
        backgroundColor:Colors.grey[900],
        child: ListView(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height/5,
              child: const Center(
                child: Text('Lyanna',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize:47,fontWeight: FontWeight.w900 ,
                  fontFamily: 'DMSerif'
                ),),
              ),
            ),
            const drawerItem(name:'I am Seller', icon:Icons.settings,destination: AdminHome(),),
            const SizedBox(height: 15,),

            const drawerItem(name: 'About', icon:Icons.newspaper,destination: about(),),
            const SizedBox(height: 15,),

            const drawerItem(name:"Contact Us", icon:Icons.mail_outline_rounded,destination: Contact(),)
            
          ],
        ),
      ),

      body:
           Padding(
             padding: const EdgeInsets.all(4.0),
             child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showItem(),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:12.0),
                    child: Text(
                        "Premium collection 🔥",
                          style:AppWidget.HeadTextStyle(),
                        ),
                  ),
                      const SizedBox(height: 12,),
                  
                  allItems(),
                  const SizedBox(height: 20,),
                ],
                         ),
             ),
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
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 45,
                decoration: neu().copyWith(color:a?Colors.grey[500]:Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
                ),
                  child:Text('a',style: TextStyle(
                    color:Colors.grey[900],
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),)
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
                    decoration: neu().copyWith(color:b?Colors.grey[500]:Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                    ),
                    child:Text('b',style: TextStyle(
                      color: Colors.grey[900],
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
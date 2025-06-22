import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lyanna/admin/admin_home.dart';
import 'package:lyanna/components/bottomNavBar.dart';
import 'package:lyanna/components/carousel_slider.dart';
import 'package:lyanna/pages/Wish.dart';
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
  String id= FirebaseAuth.instance.currentUser!.uid;
  
  Stream?ItemStream;
  //String name="favorite_border";

  onthload()async{
    ItemStream = await DatabaseMethods().getItem('a');
    setState(() {
      
    });
  }
  @override
  void initState() {
    onthload();
    onLoad();
    super.initState();
  }

    Set<String> wishlistItems = {};

  /// Load items and wishlist from Firestore
  onLoad() async {
    ItemStream = await DatabaseMethods().getItem('a');
    wishlistItems = await getWishlistItems();
    setState(() {});
  }

  /// Get wishlisted item IDs from Firestore
  Future<Set<String>> getWishlistItems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Wishlist')
        .get();

    return snapshot.docs.map((doc) => doc['Name'].toString()).toSet();
  }

  /// Toggle wishlist state (add/remove)
  Future<void> toggleWishlist(String itemName, Map<String, dynamic> itemData) async {
    if (wishlistItems.contains(itemName)) {
      // Remove from wishlist
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('Wishlist')
          .where('Name', isEqualTo: itemName)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        wishlistItems.remove(itemName);
      });
    } else {
      // Add to wishlist
      await DatabaseMethods().addToWishList(itemData, id);

      setState(() {
        wishlistItems.add(itemName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to Wishlist!')),
      );
    }
  }

  Widget allItems(){
    return StreamBuilder(stream:ItemStream , builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData?GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.75,
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
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          children: [
                            Stack(
                              children:[ Image.network(ds['Image'],
                              height: 150,width: 150,fit: BoxFit.fitHeight,),
                              Positioned(
                                top: 5,
                                right:0,
                                child:GestureDetector(
                              onTap: () => toggleWishlist(ds['Name'], ds.data() as Map<String, dynamic>),
                              child: Icon(
                                wishlistItems.contains(ds['Name'])
                                    ? Icons.favorite // Filled heart if wishlisted
                                    : Icons.favorite_border, // Outlined heart if not wishlisted
                                color: const Color.fromARGB(255, 255, 17, 0),
                                size: 28,
                              ),
                              ),
                            )
                          ]),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                //const SizedBox(height:13),
                                Text(
                                  ds['Name'],
                                  style: AppWidget.boldTextStyle().copyWith(
                                    overflow: TextOverflow.fade,
                                  ),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 5),
                                Text('Rs.'+ ds['Price'],style: AppWidget.LightTextStyle(),),  
                               ],
                              ),
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
        title: Row(
          children: [
            Text("Lyanna",style: AppWidget.SpecialTextStyle(),),
            Icon(FontAwesomeIcons.leaf,color: Color.fromARGB(255, 20, 147, 24),size: 30),
          ],
        ),
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
            const drawerItem(name:'Wishlist 😍', icon:Icons.favorite,destination:WishlistPage()),
            const SizedBox(height: 15,),
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
                  const SizedBox(height: 4),
                  showItem(),
                  const SizedBox(height: 18,),
                  Padding(
                    padding: const EdgeInsets.only(left:12.0),
                    child: Text(
                        "Premium collection 🔥",
                          style:AppWidget.HeadTextStyle(),
                        ),
                  ),
                      const SizedBox(height: 12,),
                  
                  allItems(),
                  //const SizedBox(height: 20,),
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
                //height: 30,
                //width: 45,
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                decoration: neu().copyWith(color:a?Colors.grey[500]:Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
                ),
                  child:Text('Women',style: TextStyle(
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
                    //height: 30,
                    //width: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                    decoration: neu().copyWith(color:b?Colors.grey[500]:Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                    ),
                    child:Text('Men',style: TextStyle(
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
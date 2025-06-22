import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/auth.dart';
import 'package:lyanna/style.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user =FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots() , 
        builder:(context,snapshot){
          if(snapshot.hasData){
            final userData=snapshot.data!.data() as Map<String,dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top:35,bottom: 25),
            color: const Color.fromARGB(255, 209, 206, 206),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Icon(Icons.person,size: 80,),
                    //child: Image.network(userData['profilePhoto'],height: 80,width: 80,fit: BoxFit.cover,),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userData['username'],style: AppWidget.LightTextStyle().copyWith(fontSize: 27)),
                  Text(userData['email'],style: AppWidget.LightTextStyle().copyWith(fontSize: 16)),
                ],
              ),]),
          ),
          Text('My order',style: AppWidget.boldTextStyle().copyWith(fontSize: 20),),
          const Spacer(),
          GestureDetector(
            onTap: () {
              AuthMethods().deleteUser();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              decoration: neu().copyWith(color: Colors.grey[300],),
              child:Row(
                children: [
                  Icon(Icons.delete,color: Colors.black,),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delete Account',style: AppWidget.LightTextStyle(),),
                    ],
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              AuthMethods().SignOut();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              decoration: neu().copyWith(color: Colors.grey[300],),
              child:Row(
                children: [
                  Icon(Icons.logout,color: Colors.black,),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Log Out',style: AppWidget.LightTextStyle(),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20,)
        ],
      );

          }
          else if (snapshot.hasError){
            return const Center(child: Text('Error'),);
          }
          else{return const Center(child: CircularProgressIndicator(),);}
        } 
        )
      
      
      
    );
  }
}
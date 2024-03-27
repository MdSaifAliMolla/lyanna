import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/service/auth.dart';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots() , 
        builder:(context,snapshot){
          if(snapshot.hasData){
            final userData=snapshot.data!.data() as Map<String,dynamic>;
            return Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 65,left: 20,right: 20),
                height: MediaQuery.of(context).size.height/3.8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width,105)
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/6.5),
                child:Center(
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(userData['profilePhoto'],height: 140,width: 140,fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(
                  child: Text(userData['username'],
                  style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),),
                ),
                )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical:15 ,horizontal: 10),
            child: Material(
              borderRadius:BorderRadius.circular(10),
              elevation: 2.5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Icon(Icons.person,color: Colors.black,),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,),),
                        SizedBox(height: 5,),
                        Text(userData['username'],style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical:15 ,horizontal: 10),
            child: Material(
              borderRadius:BorderRadius.circular(10),
              elevation: 2.5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Icon(Icons.mail,color: Colors.black,),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text(userData['email'],style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),


          GestureDetector(
            onTap: () {
              AuthMethods().deleteUser();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical:15 ,horizontal: 10),
              child: Material(
                borderRadius:BorderRadius.circular(10),
                elevation: 2.5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child:const Row(
                    children: [
                      Icon(Icons.delete,color: Colors.black,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delete Account',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              AuthMethods().SignOut();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical:15 ,horizontal: 10),
              child: Material(
                borderRadius:BorderRadius.circular(10),
                elevation: 2.5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child:const Row(
                    children: [
                      Icon(Icons.logout,color: Colors.black,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Log Out',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );

          }
          else if (snapshot.hasError){
            return Center(child: Text('Error'),);
          }
          else{return Center(child: CircularProgressIndicator(),);}
        } 
        )
      
      
      
    );
  }
}
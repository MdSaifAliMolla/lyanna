import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lyanna/style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Lyanna',style: AppWidget.HeadTextStyle().copyWith(fontSize: 50),),
                const Icon(FontAwesomeIcons.leaf,color: Color.fromARGB(255, 20, 147, 24),size: 30),
              ],
            ),
          ),
          const SizedBox(height: 50,),
          Center(
            child:GestureDetector(
            onTap:signInWithGoogle,
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 35),
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              decoration: neu().copyWith(color: const Color.fromARGB(255, 227, 225, 225),),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login,color: Colors.black,),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login with Google',style: AppWidget.LightTextStyle(),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      )    
    );
  }
}

Future<bool> signInWithGoogle()async{
  bool result =false;
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken ,
    idToken: googleAuth?.idToken,
  );
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  
  User?user= userCredential.user;

      if (user!=null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'username':user.displayName,
            'uid':user.uid,
            'profilePhoto':user.photoURL,
            'email':user.email,
          });
        }
        result=true;
      }
  } on FirebaseAuthException catch (e) {
      result= false;
      SnackBar(content:Text(e.toString()));
    }return result;
  
}
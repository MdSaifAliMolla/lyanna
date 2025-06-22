import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lyanna/pages/login.dart';
import 'components/bottomNavBar.dart';
import 'firebase_options.dart';

void main()async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions(
      apiKey: "AIzaSyB0D7EsXEZDl7xpmOjw2kubobtiaB5gOdM",
      authDomain: "lyanna-bd625.firebaseapp.com",
      projectId: "lyanna-bd625",
      storageBucket: "lyanna-bd625.appspot.com",
      messagingSenderId: "670053862489",
      appId: "1:670053862489:web:7f8ae773d95d0ec0e23548",
      measurementId: "G-561GK67SFE"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 235, 233, 239)),
        useMaterial3: true,
      ),
      home:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder:(BuildContext context,AsyncSnapshot snapshot){
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState==ConnectionState.active) {
            if (snapshot.data==null) {
              return const LoginPage();
            }else{
              return const BottomNav();
            }
          }
          return const Center(child: CircularProgressIndicator());
        }),
      //home:const BottomAppBar(),
    );
  }
}


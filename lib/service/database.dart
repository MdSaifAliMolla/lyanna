import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addProduct(Map<String,dynamic>userInfoMap,String name)async{
    return await FirebaseFirestore.instance.collection(name)
    .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>>getItem(String name)async{
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addToCart(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance.collection('users')
    .doc(id).collection('Cart')
    .add(userInfoMap);
  }

  Future addToWishList(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance.collection('users')
    .doc(id).collection('Wishlist')
    .add(userInfoMap);
  }

  Future addAddress(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance.collection('users')
    .doc(id).collection('Address')
    .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>>getCart(String id)async{
    return FirebaseFirestore.instance.collection("users").doc(id).collection('Cart').snapshots();
  }

  Future<Stream<QuerySnapshot>>getWishList(String id)async{
    return FirebaseFirestore.instance.collection("users").doc(id).collection('Wishlist').snapshots();
  }


}
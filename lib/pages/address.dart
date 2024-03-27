import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lyanna/payment_configurations.dart';
import 'package:lyanna/components/custom_textfield.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';
import 'package:lyanna/pages/cart.dart';
import 'package:pay/pay.dart';

class AddressPage extends StatefulWidget {
  //List<PaymentItem> paymentItems;

  AddressPage({super.key,/*required this.paymentItems*/});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  String uid = FirebaseAuth.instance.currentUser!.uid;
  
  final TextEditingController villController=TextEditingController();
  final TextEditingController areaController=TextEditingController();
  final TextEditingController townController=TextEditingController();
  final TextEditingController pinController=TextEditingController();
  final TextEditingController distController=TextEditingController();
  final TextEditingController stateController=TextEditingController();
  List<PaymentItem>paymentItems=[
    PaymentItem(amount:'100',status: PaymentItemStatus.final_price,label: 'saif')
  ];

  @override
  void dispose() {
    super.dispose();
    villController.dispose();
    areaController.dispose();
    townController.dispose();
    pinController.dispose();
    distController.dispose();
    stateController.dispose();
  }

  

  void onGooglePayResult(res){
    //saveAddress();
  }

  //List<PaymentItem>paymentItems=[];
  @override
  void initState() {
    super.initState();
    
  }

  
  saveAddress()async{
    if (villController.text!='' || pinController.text!=''||areaController.text!='' || townController.text!='' ||distController.text!='' || stateController.text!='') {
    
      Map<String,dynamic>address={
        "Vill":villController.text,
        "Area":areaController.text,
        "Town":townController.text,
        "Pincode":pinController.text,
        "District":distController,
        "State":stateController
      };
      await DatabaseMethods().addAddress(address,uid);
        
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:Column(
        children: [
          CustomTextField(
          controller: villController,
          hintText:"Vill, House or Flat",),
          const SizedBox(height: 10,),

          CustomTextField(
          controller: areaController,
          hintText:"Area,Street", ),
          const SizedBox(height: 10,),

          CustomTextField(
          controller: townController,
          hintText:"Town or City", ),
          const SizedBox(height: 10,),

          CustomTextField(
          controller: pinController,
          hintText:"Pincode", ),
          const SizedBox(height: 10,),

          CustomTextField(
          controller: distController,
          hintText:"District", ),
          const SizedBox(height: 10,),

          CustomTextField(
          controller: stateController,
          hintText:"State", ),
          const SizedBox(height: 10,),

          GooglePayButton(
            paymentConfiguration:PaymentConfiguration.fromJsonString(defaultGooglePay),
            type: GooglePayButtonType.pay,
            loadingIndicator: const Center(child: CircularProgressIndicator()),
            onPaymentResult:onGooglePayResult , 
            paymentItems:paymentItems),

          /*GestureDetector(
                onTap:(){
                  uploadAddress();
                }, 
                child: Container(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width/1.4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child:Center(
                    child: Text('Proceed',
                      style: AppWidget.HeadTextStyle().copyWith(color: Colors.white),
                    ),
                  )),
              ),*/





        ],
      ) ,
    );
  }
}
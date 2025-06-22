import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lyanna/components/custom_textfield.dart';
import 'package:lyanna/service/database.dart';
import 'package:lyanna/style.dart';


class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final List<String>items = ['a','b',];
  String? value='a';

  final TextEditingController productNameController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();
  final TextEditingController priceController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final ImagePicker picker = ImagePicker();
  File?selectedImage;

  Future<void> getImage() async {
  final image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    selectedImage = File(image.path);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Picture added successfully"))
      );
  }
}

  upLoadProduct()async{
    if (selectedImage!=null && productNameController.text.isNotEmpty && priceController.text.isNotEmpty ) {
      String addId = DateTime.now().toString();
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('blogImage').child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      TaskSnapshot snapshot = await task;
      String downloadURL = await snapshot.ref.getDownloadURL();

      Map<String,dynamic>addproduct={
        "Image":downloadURL,
        "Name":productNameController.text,
        "Price":priceController.text,
        "Description":descriptionController.text,
        "Quantity":quantityController.text
      };
      try {
      await DatabaseMethods().addProduct(addproduct, value!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully"))
      );
      // Clear form after success
      productNameController.clear();
      descriptionController.clear();
      priceController.clear();
      quantityController.clear();
      setState(() => selectedImage = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding product: ${e.toString()}"))
      );
    }
    }
  }
  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product',style: AppWidget.HeadTextStyle(),),),
      body:Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Material(
                  elevation: 4.5,
                  child:selectedImage==null? 
                  GestureDetector(
                    onTap:(){getImage();},
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1.5)),
                      child:const Icon(Icons.camera_alt_outlined) ,
                    ),
                  ):Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1.5)),
                    child:Image.file(selectedImage!,fit: BoxFit.cover,) ,
                  ),
                ),
              ),const SizedBox(height: 10,),
              CustomTextField(controller:productNameController , hintText:'Product Name'),
              const SizedBox(height: 10,),

              CustomTextField(controller: descriptionController, hintText:'Description',maxLines: 7,),
              const SizedBox(height: 10,),
              CustomTextField(controller: priceController, hintText:'Price'),
              const SizedBox(height: 10,),

              CustomTextField(controller:quantityController , hintText:'Quantity'),
              const SizedBox(height: 10,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 223, 223),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: DropdownButton<String>(
                  items:items.map((item) =>DropdownMenuItem<String>(value: item,child:Text(item),)).toList(),

                onChanged:(value){setState(() {
                  this.value=value;
                  });
                },
                value:value,
                hint: const Text('Select Category'),
                icon:const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 20,),

              GestureDetector(
                onTap:(){upLoadProduct();}, 
                child: Container(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width/1.4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child:Center(
                    child: Text('Add',
                      style: AppWidget.HeadTextStyle().copyWith(color: Colors.white),
                    ),
                  )),
              ),
              
            ],
          ),
        ),
      ) ,
    );
  }
}

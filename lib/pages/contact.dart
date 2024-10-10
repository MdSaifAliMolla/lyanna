import 'package:flutter/material.dart';
import 'package:lyanna/style.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:Center(
        child: GestureDetector(
          onTap: _launchUrl,
          child: Container(
            height: 120,
            width: 120,
            decoration: neu().copyWith(color: Colors.grey[300]),
            child: Icon(Icons.contact_support_rounded),
          ),
        ),
      ) ,
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
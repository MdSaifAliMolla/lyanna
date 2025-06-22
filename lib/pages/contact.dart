import 'package:flutter/material.dart';
import 'package:lyanna/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Uri _url = Uri.parse('https://flutter.dev');
final Uri u = Uri.parse('https://www.linkedin.com/in/md-saif-ali-molla-0751b227a/');

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _launchUrl(_url),
              child: Container(
                height: 70,
                width: 70,
                decoration: neu().copyWith(color: Colors.grey[300]),
                child: Icon(Icons.contact_support_rounded),
              ),
            ),
            GestureDetector(
              onTap: () => _launchUrl(u),
              child: Container(
                height: 70,
                width: 70,
                decoration: neu().copyWith(color: Colors.grey[300]),
                child: Icon(FontAwesomeIcons.linkedin),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}

Future<void> _launchUrl(Uri u) async {
  if (!await launchUrl(u)) {
    throw Exception('Could not launch $u');
  }
}
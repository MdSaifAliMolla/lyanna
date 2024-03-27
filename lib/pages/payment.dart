import 'package:url_launcher/url_launcher.dart';

void openWhatsapp()async{
 // String phone='7908687744';
  final Uri url=Uri.parse("https://wa.me/79086?text=yo");
  launchUrl(url);
}
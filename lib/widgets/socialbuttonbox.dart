import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global_controller/languages_controller.dart';

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

LanguagesController languagesController = Get.put(LanguagesController());

void showSocialPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languagesController.tr("FIND_US_ON"),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Buttons grid
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _socialButton(
                    icon: Icons.telegram,
                    label: "Telegram",
                    color: Colors.blue,
                    url: "https://t.me/username",
                  ),
                  _socialButton(
                    icon: Icons.facebook,
                    label: "Facebook",
                    color: Colors.blueAccent,
                    url: "https://facebook.com/username",
                  ),
                  _socialButton(
                    icon: Icons.camera_alt,
                    label: "Instagram",
                    color: Colors.purple,
                    url: "https://instagram.com/username",
                  ),

                  // ✅ WhatsApp button uses custom function
                  _socialButton(
                    icon: FontAwesomeIcons.whatsapp,
                    label: "WhatsApp",
                    color: Colors.green,
                    url: "", // not used
                    isWhatsApp: true,
                  ),
                ],
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  languagesController.tr("CLOSE"),
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _socialButton({
  required IconData icon,
  required String label,
  required Color color,
  required String url,
  bool isWhatsApp = false,
}) {
  return SizedBox(
    width: 140,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      icon: Icon(icon, color: Colors.white, size: 20),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: () => isWhatsApp ? whatsapp() : _launchUrl(url),
    ),
  );
}

// ✅ Custom WhatsApp launcher function
Future<void> whatsapp() async {
  const contact = "+930777005805";

  final androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
  final iosUrl =
      "https://wa.me/${contact.replaceAll('+', '')}?text=Hi,%20I%20need%20some%20help";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl), mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(Uri.parse(androidUrl),
          mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    print("WhatsApp not found: $e");
  }
}

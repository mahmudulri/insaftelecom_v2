import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';

import 'routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final dashboardController = Get.find<DashboardController>();
  final box = GetStorage();
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  checkData() async {
    String languageShortName = box.read("language") ?? "Fa";

    /// Find language information
    final matchedLang = languagesController.alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {
        "name": "En",
        "fullname": "English",
        "isoCode": "en",
        "region": "US",
        "direction": "ltr",
      },
    );

    final String isoCode = matchedLang["isoCode"] ?? "en";

    final String region = matchedLang["region"] ?? "US";

    final String direction = matchedLang["direction"] ?? "ltr";

    /// Save language information
    await box.write("language", languageShortName);

    await box.write("language_iso", isoCode);

    await box.write("language_region", region);

    await box.write("direction", direction);

    // Load translations manually
    languagesController.changeLanguage(languageShortName);

    final Locale locale = Locale(isoCode, region);

    if (!mounted) return;

    await EasyLocalization.of(context)!.setLocale(locale);

    print("🌐 API Language: ${box.read("language_iso")}");

    // If no token, go to onboarding
    if (box.read('userToken') == null) {
      Get.toNamed(signinscreen);
    } else {
      // Fetch initial data
      dashboardController.fetchDashboardData();

      Get.toNamed(basescreen);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => checkData());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/icons/logo.png"),
              radius: 55,
            ),
            Text(
              "انصاف تیلیکام",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

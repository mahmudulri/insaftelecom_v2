import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/network_checker.dart';
import 'package:insaftelecom/routes/routes.dart';

import 'controllers/currency_controller.dart';
import 'global_controller/afghan_recharge_controller.dart';
import 'global_controller/recharge_config_controller.dart';
import 'global_controller/time_zone_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Get.put(CurrencyController(), permanent: true);
  Get.put(RechargeConfigController(), permanent: true);
  Get.put(AfghanRechargeController(), permanent: true);
  await GetStorage.init();
  DependencyInjection.init();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
        Locale('ar', 'AE'),
        Locale('ps', 'AF'),
        Locale('tr', 'TR'),
        Locale('bn', 'BD'),
      ],
      path: 'assets/langs',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());
  @override
  void initState() {
    super.initState();
    initTimezone();
  }

  void initTimezone() {
    Duration offset = DateTime.now().timeZoneOffset;

    timeZoneController.sign = offset.isNegative ? "-" : "+";
    timeZoneController.hour = offset.inHours.abs().toString().padLeft(2, '0');
    timeZoneController.minute = (offset.inMinutes.abs() % 60)
        .toString()
        .padLeft(2, '0');

    print(
      "Offset = ${timeZoneController.sign}${timeZoneController.hour}:${timeZoneController.minute}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: splash,
      getPages: myroutes,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule locale update after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.updateLocale(context.locale);
    });
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/network_checker.dart';
import 'package:insaftelecom/routes/routes.dart';

import 'controllers/currency_controller.dart';
import 'global_controller/time_zone_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();

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
  // used for check real time internet access
  // DependencyInjection.init();
  //
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
    _initTimezone();
  }

  Future<void> _initTimezone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();

      print('TimezoneInfo object: $timezoneInfo');

      timeZoneController.myzone = timezoneInfo.toString();

      // Apply your offset logic
      timeZoneController.setTimezoneOffset();
      timeZoneController.extractTimeDetails();

      print('Detected Timezone: ${timeZoneController.myzone}');
      print(
        'UTC Offset: ${timeZoneController.sign}${timeZoneController.hour}:${timeZoneController.minute}',
      );
    } catch (e) {
      print('Error getting timezone: $e');
      timeZoneController.myzone = 'UTC';
      timeZoneController.setTimezoneOffset();
    }
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

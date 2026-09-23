import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/network_checker.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/routes/routes.dart';
import 'dart:developer';
import 'controllers/currency_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/wallets_controller.dart';
import 'global_controller/afghan_recharge_controller.dart';
import 'global_controller/recharge_config_controller.dart';
import 'global_controller/time_zone_controller.dart';
import 'services/firebase_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  log('========== BACKGROUND FCM ==========');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Type: ${message.data['type']}');
  log('Event: ${message.data['event']}');
  log('Order ID: ${message.data['order_id']}');
  log('Status: ${message.data['status']}');
  log('Reseller ID: ${message.data['reseller_id']}');
  log('Message: ${message.data['message']}');
  log('Full Data: ${message.data}');
  log('====================================');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Get.put(CurrencyController(), permanent: true);
  Get.put(RechargeConfigController(), permanent: true);
  Get.put(AfghanRechargeController(), permanent: true);
  Get.put(LanguagesController(), permanent: true);
  await GetStorage.init();
  DependencyInjection.init();

  FirebaseNotificationService.instance.configure(
    refreshOrders: (Map<String, dynamic> data) async {
      final String type = data['type']?.toString() ?? '';

      final String orderId = data['order_id']?.toString() ?? '';

      final String status = data['status']?.toString() ?? '';

      final String? rejectReason = data['reject_reason']?.toString();

      log('========== ORDER STATUS EVENT ==========');
      log('Type: $type');
      log('Order ID: $orderId');
      log('Status: $status');
      log('Reject reason: $rejectReason');
      log('========================================');

      if (type != 'order_status') {
        log('Notification ignored because type is not order_status');
        return;
      }

      if (orderId.isEmpty || status.isEmpty) {
        log('Order ID or status is empty');
        return;
      }

      if (!Get.isRegistered<HistoryController>()) {
        log('HistoryController is not registered');
        return;
      }

      final HistoryController historyController = Get.find<HistoryController>();

      final bool updated = historyController.updateOrderStatusFromNotification(
        orderId: orderId,
        status: status,
        rejectReason: rejectReason,
      );

      log('History order locally updated: $updated');

      /*
   * Current list-এ order না থাকলে API থেকে
   * fresh history load করবে।
   */
      if (!updated) {
        await historyController.refreshHistory();
      }
    },

    refreshGeneralNotifications: (Map<String, dynamic> data) async {
      log('Refresh general notifications');
      log('Data: $data');
    },

    refreshBalance: (Map<String, dynamic> data) async {
      log('Refresh dashboard balance and balance history');
      log('Data: $data');
    },

    refreshPayments: (Map<String, dynamic> data) async {
      log('Refresh payment history');
      log('Data: $data');
    },

    refreshHawala: (Map<String, dynamic> data) async {
      log('Refresh hawala history');
      log('Data: $data');
    },
  );

  await FirebaseNotificationService.instance.initialize();

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

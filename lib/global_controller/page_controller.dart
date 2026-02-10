import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/pages/orders.dart';
import 'package:insaftelecom/pages/transaction_type.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/order_list_controller.dart';
import '../pages/hawala_page.dart';
import '../pages/homepages.dart';
import '../pages/service_screen.dart';

class Mypagecontroller extends GetxController {
  final selectedIndex = 0.obs;

  final navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> mainPages = [
    Homepages(),
    ServiceScreen(),
    HawalaPage(),
    TransactionsType(),
  ];

  void onTabSelected(int index) {
    if (selectedIndex.value == index) return;

    if (index == 0) {
      Get.find<DashboardController>().onhomeTabOpened();
    } else if (index == 1) {
      Get.find<OrderlistController>().onOrdersTabOpened();
    } else if (index == 2) {
      print(".............");
    } else if (index == 3) {
      print(".............");
    } else {
      print("object");
    }
  }

  /// Bottom nav switch
  void goToMainPageByIndex(int index) {
    selectedIndex.value = index;

    // pop all sub pages when switching tab
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  void openSubPage(Widget page) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
  }

  Future<bool> handleBack() async {
    final navigator = navigatorKey.currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    // if main page  → exit dialog
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(languagesController.tr("EXIT_APP")),
        content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(languagesController.tr("NO")),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: Text(languagesController.tr("YES")),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

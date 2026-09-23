import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../pages/hawala_page.dart';
import '../pages/homepages.dart';
import '../pages/service_screen.dart';
import '../pages/transaction_type.dart';
import 'languages_controller.dart';

class Mypagecontroller extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> mainPages = [
    Homepages(),
    ServiceScreen(),
    HawalaPage(),
    TransactionsType(),
  ];

  int _tabChangeVersion = 0;

  /// Call from the bottom navigation's onTap.
  void onTabSelected(int index) {
    goToMainPageByIndex(index);
  }

  /// Switch tab and close any open subpages.
  void goToMainPageByIndex(int index) {
    if (isClosed || index < 0 || index >= mainPages.length) {
      return;
    }

    navigatorKey.currentState?.popUntil((route) => route.isFirst);

    if (selectedIndex.value == index) {
      return;
    }

    selectedIndex.value = index;

    final int changeVersion = ++_tabChangeVersion;

    // Refresh after the tab's build has finished.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed ||
          changeVersion != _tabChangeVersion ||
          selectedIndex.value != index) {
        return;
      }

      switch (index) {
        case 0:
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().onhomeTabOpened();
          }
          break;

        case 1:
          // ServiceScreen
          break;

        case 2:
          // HawalaPage
          break;

        case 3:
          // TransactionsType
          break;
      }
    });
  }

  void openSubPage(Widget page) {
    if (isClosed) return;

    navigatorKey.currentState?.push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Future<bool> handleBack() async {
    final NavigatorState? navigator = navigatorKey.currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }

    final bool? result = await Get.dialog<bool>(
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

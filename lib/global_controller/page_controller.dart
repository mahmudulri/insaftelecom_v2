import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/pages/orders.dart';
import 'package:insaftelecom/pages/transactions.dart';

import '../pages/hawala_page.dart';
import '../pages/homepages.dart';
import '../screens/service_screen.dart';

class Mypagecontroller extends GetxController {
  RxList<Widget> pageStack = <Widget>[Homepages()].obs;
  int lastSelectedIndex = 0;

  final List<Widget> mainPages = [
    Homepages(),
    ServiceScreen(),
    Orders(),
    HawalaPage(),
  ];

  Function(int)? updateIndexCallback;

  void setUpdateIndexCallback(Function(int) callback) {
    updateIndexCallback = callback;
  }

  void changePage(Widget page, {bool isMainPage = true}) {
    if (isMainPage) {
      lastSelectedIndex = mainPages.indexWhere(
        (element) => element.runtimeType == page.runtimeType,
      );
      pageStack.value = [page]; // reset stack for main page change
    } else {
      pageStack.add(page);
    }

    if (updateIndexCallback != null) {
      updateIndexCallback!(isMainPage ? lastSelectedIndex : -1);
    }
  }

  bool goBack() {
    if (pageStack.length > 1) {
      pageStack.removeLast();
      return false; // don't exit
    } else {
      return true; // allow exit
    }
  }

  void goToMainPageByIndex(int index) {
    lastSelectedIndex = index;
    changePage(mainPages[index], isMainPage: true);
  }
}

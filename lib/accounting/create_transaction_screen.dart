import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';

class CreateTransactionScreen extends StatelessWidget {
  CreateTransactionScreen({super.key});

  final LanguagesController languageController =
      Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          languageController.tr("NEW_TRANSACTION"),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_controller/languages_controller.dart';

class Inventory extends StatelessWidget {
  Inventory({super.key});

  final languagesController = Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          languagesController.tr("INVENTORY"),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.white,
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(height: screenHeight, width: screenWidth),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';
import 'custom_text.dart';

class DefaultButton1 extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  DefaultButton1({
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color(0xffFF6A60),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: KText(
                    text: buttonName.toString(),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultButton2 extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  DefaultButton2({
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color(0xff04B75D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: KText(
                    text: buttonName.toString(),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';

class KText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;

  final double? height;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;

  const KText({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
    this.height,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        fontFamily: box.read("language").toString() == "Fa"
            ? Get.find<FontController>().currentFont
            : fontFamily,
      ),
    );
  }
}

class NText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  NText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  }) : super(key: key);

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        languagesController.number(text),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          height: height,
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}

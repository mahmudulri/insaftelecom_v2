import 'package:insaftelecom/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';

class KText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;

  const KText({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        fontFamily: box.read("language").toString() == "Fa"
            ? Get.find<FontController>().currentFont
            : null,
      ),
    );
  }
}

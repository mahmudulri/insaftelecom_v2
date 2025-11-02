import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/languages_controller.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class ProductButton extends StatelessWidget {
  ProductButton({super.key, this.onpressed});

  VoidCallback? onpressed;

  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 52,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.45),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onpressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(
              //   width: 10,
              // ),
              Icon(
                Icons.menu,
                color: Colors.white,
              ),
              KText(
                text: languagesController.tr("VIEW_PRODUCTS"),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              // Spacer(),
              Container(
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.white,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.grey.withOpacity(0.45),
                //       spreadRadius: 2,
                //       blurRadius: 8,
                //       offset: Offset(0, 4),
                //     ),
                //   ],
                // ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    box.read("language") != "Fa"
                        ? FontAwesomeIcons.arrowRight
                        : FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

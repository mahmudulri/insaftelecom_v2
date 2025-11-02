import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:get_storage/get_storage.dart';

class SocialButton extends StatelessWidget {
  SocialButton({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                print(box.read("language"));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          "assets/icons/apple.png",
                          height: screenHeight * 0.045,
                        ),
                      ),
                      SizedBox(width: 10),
                      KText(
                        text: languagesController.tr("APPLE"),
                        fontSize: screenHeight * 0.020,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "assets/icons/google.png",
                        height: screenHeight * 0.045,
                      ),
                    ),
                    SizedBox(width: 10),
                    KText(
                      text: languagesController.tr("GOOGLE"),
                      fontSize: screenHeight * 0.020,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

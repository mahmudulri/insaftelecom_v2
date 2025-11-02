import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
  });

  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: screenHeight * 0.020,
            ),
          ),
        ),
      ),
    );
  }
}

class CreditButton extends StatelessWidget {
  CreditButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
  });

  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;
  LanguagesController languagesController = Get.put(LanguagesController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/credit-transfer.png",
                width: screenWidth * 0.10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                buttonName.toString(),
                style: TextStyle(
                  color: Color(0xff454F5B),
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                  fontFamily: languagesController.selectedlan == "Fa"
                      ? "Iranfont"
                      : "Roboto",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

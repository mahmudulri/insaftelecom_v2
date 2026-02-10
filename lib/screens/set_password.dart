import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/controllers/sub_reseller_password_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/button_one.dart';
import 'package:insaftelecom/widgets/drawer.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';

class SetPassword extends StatefulWidget {
  SetPassword({super.key, this.subID});

  String? subID;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final SubresellerPassController passwordConttroller = Get.put(
    SubresellerPassController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homeback.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 40),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.handleBack();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.chevronLeft),
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => KText(
                          text: languagesController.tr("SET_PASSWORD"),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.menu, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          KText(
                            text: languagesController.tr("NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.022,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      PasswordBox(
                        // hintText:
                        //     languagesController.tr("ENTER_NEW_PASSWORD"),
                        controller: passwordConttroller.newpassController,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            languagesController.tr("CONFIRM_PASSWORD"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.022,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      PasswordBox(
                        // hintText:
                        //     languagesController.tr("ENTER_CONFIRM_PASSWORD"),
                        controller: passwordConttroller.confirmpassController,
                      ),
                      SizedBox(height: 25),
                      Obx(
                        () => DefaultButton2(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              passwordConttroller.isLoading.value == false
                              ? languagesController.tr("CONFIRMATION")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (passwordConttroller
                                    .newpassController
                                    .text
                                    .isEmpty ||
                                passwordConttroller
                                    .confirmpassController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Fill the data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              passwordConttroller.change(
                                widget.subID.toString(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
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

class PasswordBox extends StatelessWidget {
  PasswordBox({super.key, this.hintText, this.controller});
  final box = GetStorage();
  String? hintText;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}

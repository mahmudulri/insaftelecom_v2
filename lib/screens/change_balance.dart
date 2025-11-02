import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/authtextfield.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/button_one.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../controllers/change_balance_controller.dart';

class ChangeBalance extends StatefulWidget {
  String? subID;
  ChangeBalance({super.key, this.subID});

  @override
  State<ChangeBalance> createState() => _ChangeBalanceState();
}

class _ChangeBalanceState extends State<ChangeBalance> {
  int _value = 1;

  final Mypagecontroller mypagecontroller = Get.find();
  final BalanceController balanceController = Get.put(BalanceController());
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

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
    balanceController.status.value = "credit";
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
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
                          mypagecontroller.changePage(
                            Network(),
                            isMainPage: false,
                          );
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
                        () => Text(
                          languagesController.tr("CHANGE_BALANCE"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                          ),
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
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      RadioListTile(
                        value: 1,
                        groupValue: _value,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          balanceController.status.value = "credit";
                          setState(() {
                            _value = val!;
                          });
                        },
                        title: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.primaryColor.withOpacity(
                                      0.20,
                                    ),
                                  ),
                                  color: _value == 1
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          languagesController.tr("CREDIT"),
                                          style: TextStyle(
                                            color: _value == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                      RadioListTile(
                        value: 2,
                        groupValue: _value,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          balanceController.status.value = "debit";
                          setState(() {
                            _value = val!;
                          });
                        },
                        title: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.primaryColor.withOpacity(
                                      0.20,
                                    ),
                                  ),
                                  color: _value == 2
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => Text(
                                          languagesController.tr("DEBIT"),
                                          style: TextStyle(
                                            color: _value == 2
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              languagesController.tr("AMOUNT"),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: screenHeight * 0.020,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 50,
                        width: screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Obx(
                                () => Authtextfield(
                                  hinttext: languagesController.tr(
                                    "ENTER_AMOUNT",
                                  ),
                                  controller:
                                      balanceController.amountController,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/icons/afghanistan.png",
                                        height: 30,
                                      ),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Colors.grey.shade600,
                                        size: screenHeight * 0.020,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Obx(
                        () => DefaultButton2(
                          height: 50,
                          width: screenWidth,
                          buttonName: balanceController.isLoading.value == false
                              ? languagesController.tr("CONFIRMATION")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (balanceController
                                    .amountController
                                    .text
                                    .isEmpty ||
                                balanceController.status.value == '') {
                              Fluttertoast.showToast(
                                msg: languagesController.tr("ENTER_AMOUNT"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              if (balanceController.status.value == "credit") {
                                balanceController.credit(
                                  widget.subID.toString(),
                                );
                              } else {
                                balanceController.debit(
                                  widget.subID.toString(),
                                );
                              }
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
  PasswordBox({super.key, this.hintText});

  String? hintText;

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
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}

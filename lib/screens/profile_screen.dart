import 'dart:io';

import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/pages/homepages.dart';
import 'package:insaftelecom/screens/change_pin.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/button_one.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../global_controller/page_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dashboardController = Get.find<DashboardController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final box = GetStorage();
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
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
                            Homepages(),
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
                        () => KText(
                          text: languagesController.tr("PROFILE"),
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
            Center(
              child: Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.hardEdge, // Ensures circular clipping
                child:
                    dashboardController
                                .alldashboardData
                                .value
                                .data
                                ?.userInfo
                                ?.profileImageUrl !=
                            null &&
                        dashboardController
                            .alldashboardData
                            .value
                            .data!
                            .userInfo!
                            .profileImageUrl!
                            .isNotEmpty
                    ? Image.network(
                        dashboardController
                            .alldashboardData
                            .value
                            .data!
                            .userInfo!
                            .profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // When image fails (like 404), show fallback icon
                          return Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 100,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
              ),
            ),

            SizedBox(height: 15),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 100),
            //   child: GestureDetector(
            //     onTap: () {
            //       mypagecontroller.changePage(
            //         ChangePinScreen(),
            //         isMainPage: false,
            //       );
            //     },
            //     child: DefaultButton1(
            //       width: double.maxFinite,
            //       height: 45,
            //       buttonName: languagesController.tr("CHANGE_PIN"),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      SizedBox(height: 15),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("FULL_NAME"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .resellerName
                              .toString(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("EMAIL"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .email
                              .toString(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("PHONENUMBER"),
                          data: dashboardController
                              .alldashboardData
                              .value
                              .data!
                              .userInfo!
                              .phone
                              .toString(),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Profilebox(
                      //   boxname: "Location",
                      //   data: "IRAN, RAZAVIKHHORASAN, MASHHAD",
                      // ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("BALANCE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .balance
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("LOAN_BALANCE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .loanBalance
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .totalSoldAmount
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Profilebox(
                          boxname: languagesController.tr("TOTAL_REVENUE"),
                          data:
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .totalRevenue
                                  .toString() +
                              " " +
                              box.read("currency_code"),
                        ),
                      ),

                      SizedBox(height: 80),
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

class Profilebox extends StatelessWidget {
  Profilebox({super.key, this.boxname, this.data});

  String? boxname;
  String? data;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KText(text: boxname.toString()),
            KText(text: data.toString(), fontSize: screenHeight * 0.0150),
          ],
        ),
      ),
    );
  }
}

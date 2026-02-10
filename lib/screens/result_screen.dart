import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/result_controller.dart';
import 'dart:ui' as ui;

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../global_controller/time_zone_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';
import 'base_screen.dart';
import '../utils/colors.dart';
import '../widgets/custom_text.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ResultController resultController = Get.find<ResultController>();

  final HistoryController historyController = Get.put(HistoryController());

  final countryListController = Get.find<CountryListController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey captureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (resultController.resultModel.value == null) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }

          var order = resultController.resultModel.value!.data?.order;
          if (order == null) {
            return Center(
              child: Text(languagesController.tr("ORDER_DATA_IS_MISSING")),
            );
          }

          return Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF2C2C2C), // dark gray
                  Color.fromARGB(255, 83, 82, 82), // lighter gray
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    key: captureKey,
                    child: RepaintBoundary(
                      key: shareKey,
                      child: Container(
                        height: 400,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffE8F4FF),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                            "assets/icons/logo.png",
                                          ),
                                          radius: 30,
                                        ),
                                      ],
                                    ),
                                    KText(
                                      text: languagesController.tr(
                                        "ORDER_CREATED_SUSSESSFULLY",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  order
                                                      .bundle!
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString(),
                                                ),
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            order.bundle!.bundleTitle
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff212B36),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Spacer(),
                                          KText(
                                            text:
                                                order.bundle!.validityType
                                                        .toString() ==
                                                    "yearly"
                                                ? languagesController.tr(
                                                    "YEARLY",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "unlimited"
                                                ? languagesController.tr(
                                                    "UNLIMITED",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "monthly"
                                                ? languagesController.tr(
                                                    "MONTHLY",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "weekly"
                                                ? languagesController.tr(
                                                    "WEEKLY",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "daily"
                                                ? languagesController.tr(
                                                    "DAILY",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "hourly"
                                                ? languagesController.tr(
                                                    "HOURLY",
                                                  )
                                                : order.bundle!.validityType
                                                          .toString() ==
                                                      "nightly"
                                                ? languagesController.tr(
                                                    "NIGHTLY",
                                                  )
                                                : "",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Color(0xff3E4094),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "ORDER_ID",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          KText(
                                            text: "WT#- " + order.id.toString(),
                                            fontSize: 14,
                                            color: Color(0xff212B36),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "DATE",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            convertToDate(
                                              order.createdAt.toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "TIME",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(width: 5),

                                          Text(
                                            convertToLocalTime(
                                              order.createdAt.toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffE8F4FF),
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "PHONE_NUMBER",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: KText(
                                              text: order.rechargebleAccount
                                                  .toString(),
                                              fontSize: 14,
                                              color: Color(0xff212B36),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "SENDER",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: KText(
                                              text: order.reseller!.resellerName
                                                  .toString(),
                                              fontSize: 14,
                                              color: Color(0xff212B36),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "PRICE",
                                            ),
                                            fontSize: 14,
                                            color: Color(0xff637381),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          Row(
                                            children: [
                                              KText(
                                                text: box.read("currency_code"),
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(width: 8),
                                              KText(
                                                text:
                                                    NumberFormat.currency(
                                                      locale: 'en_US',
                                                      symbol: '',
                                                      decimalDigits: 2,
                                                    ).format(
                                                      double.parse(
                                                        order
                                                            .bundle!
                                                            .sellingPrice
                                                            .toString(),
                                                      ),
                                                    ),
                                                color: Color(0xff212B36),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 50,
                            width: double.maxFinite,
                            // color: Colors.red,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      capturePng(captureKey);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0xff2196F3),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: KText(
                                          text: languagesController.tr(
                                            "SAVE_TO_GALLERY",
                                          ),
                                          fontSize: 12,
                                          color: Color(0xff2196F3),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      captureImageFromWidgetAsFile(shareKey);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xff2196F3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: KText(
                                          text: languagesController.tr("SHARE"),
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              historyController.finalList.clear();
                              historyController.initialpage = 1;
                              mypagecontroller.goToMainPageByIndex(
                                0,
                              ); // Set homepage at index 0
                              Get.to(() => BaseScreen());
                            },
                            child: Container(
                              height: 50,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: KText(
                                  text: languagesController.tr("CLOSE"),
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

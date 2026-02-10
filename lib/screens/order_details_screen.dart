import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../global_controller/font_controller.dart';
import '../global_controller/time_zone_controller.dart';
import '../helpers/capture_image_helper.dart';

import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({
    super.key,
    this.createDate,
    this.status,
    this.rejectReason,
    this.companyName,
    this.bundleTitle,
    this.rechargebleAccount,
    this.validityType,
    this.sellingPrice,
    this.buyingPrice,
    this.orderID,
    this.resellerName,
    this.resellerPhone,
    this.companyLogo,
    this.amount,
  });
  String? createDate;
  String? status;
  String? rejectReason;
  String? companyName;
  String? bundleTitle;
  String? rechargebleAccount;
  String? validityType;
  String? sellingPrice;
  String? buyingPrice;
  String? orderID;
  String? resellerName;
  String? resellerPhone;
  String? companyLogo;
  String? amount;
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();

  bool showSelling = false;

  final GlobalKey captureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Container(
        decoration: BoxDecoration(color: Color(0xffE8F4FF)),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RepaintBoundary(
                key: captureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    height: 470,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/icons/logo.png",
                            ),
                            radius: 30,
                          ),
                          SizedBox(height: 10),
                          KText(
                            text: languagesController.tr("ORDER_DETAILS"),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 10),
                          Image.asset(
                            widget.status.toString() == "0"
                                ? "assets/icons/info-circle.png"
                                : widget.status.toString() == "1"
                                ? "assets/icons/confirmed.png"
                                : "assets/icons/close-circle.png",
                            height: 40,
                          ),
                          SizedBox(height: 6),
                          KText(
                            text: widget.status.toString() == "0"
                                ? languagesController.tr("PENDING")
                                : widget.status.toString() == "1"
                                ? languagesController.tr("CONFIRMED")
                                : languagesController.tr("REJECTED"),
                            fontWeight: FontWeight.w500,
                            color: widget.status.toString() == "0"
                                ? Colors.black
                                : widget.status.toString() == "1"
                                ? Colors.green
                                : Colors.red,
                            fontSize: 18,
                          ),
                          Visibility(
                            visible: widget.status.toString() == "2",
                            child: Text(
                              widget.rejectReason.toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      widget.companyLogo.toString(),
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                widget.bundleTitle.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xff212B36),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 8),

                              KText(
                                text: widget.validityType.toString() == "yearly"
                                    ? languagesController.tr("YEARLY")
                                    : widget.validityType.toString() ==
                                          "unlimited"
                                    ? languagesController.tr("UNLIMITED")
                                    : widget.validityType.toString() ==
                                          "monthly"
                                    ? languagesController.tr("MONTHLY")
                                    : widget.validityType.toString() == "weekly"
                                    ? languagesController.tr("WEEKLY")
                                    : widget.validityType.toString() == "daily"
                                    ? languagesController.tr("DAILY")
                                    : widget.validityType.toString() == "hourly"
                                    ? languagesController.tr("HOURLY")
                                    : widget.validityType.toString() ==
                                          "nightly"
                                    ? languagesController.tr("NIGHTLY")
                                    : "",
                                fontSize: 17,
                                color: Color(0xff3E4094),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          KText(
                            text: widget.rechargebleAccount.toString(),
                            fontSize: 17,
                            color: Color(0xff212B36),
                          ),
                          Container(
                            height: 1,
                            width: screenWidth,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 13),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: languagesController.tr(
                                  "TRANSACTION_NUMBER",
                                ),
                                fontSize: 15,
                                color: Color(0xff637381),
                                fontWeight: FontWeight.w400,
                              ),
                              KText(
                                text: widget.orderID.toString(),
                                fontSize: 15,
                                color: Color(0xff637381),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: languagesController.tr(
                                  "TRANSACTION_DATE",
                                ),
                                fontSize: 15,
                                color: Color(0xff637381),
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(width: 5),

                              Text(
                                convertToDate(widget.createDate.toString()),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff637381),
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: languagesController.tr("TIME"),
                                fontSize: 14,
                                color: Color(0xff637381),
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(width: 5),

                              Text(
                                convertToLocalTime(
                                  widget.createDate.toString(),
                                ),
                                style: TextStyle(
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                  fontSize: 15,
                                  color: Color(0xff637381),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          Visibility(
                            visible: showSelling,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: languagesController.tr("PRICE"),
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
                                              widget.sellingPrice.toString(),
                                            ),
                                          ),
                                      fontSize: 15,
                                      color: Color(0xff637381),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            width: screenWidth,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 10),
                          KText(
                            text: widget.resellerName.toString(),
                            fontSize: 15,
                            color: Color(0xff637381),
                          ),

                          //     Row(
                          //       children: [
                          //         KText(
                          //           text: box.read("currency_code"),
                          //           fontSize: 14,
                          //           color: Colors.grey,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //         SizedBox(
                          //           width: 8,
                          //         ),
                          //         KText(
                          //           text: NumberFormat.currency(
                          //             locale: 'en_US',
                          //             symbol: '',
                          //             decimalDigits: 2,
                          //           ).format(
                          //             double.parse(
                          //               widget.sellingPrice.toString(),
                          //             ),
                          //           ),
                          //           color: Color(0xff212B36),
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),

                          // Row(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     KText(
                          //       text:
                          //           languagesController.tr("PHONE_NUMBER"),
                          //       fontSize: 14,
                          //       color: Color(0xff637381),
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     Flexible(
                          //       child: KText(
                          //         text:
                          //             widget.rechargebleAccount.toString(),
                          //         fontSize: 14,
                          //         color: Color(0xff212B36),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     KText(
                          //       text: languagesController.tr("SENDER"),
                          //       fontSize: 14,
                          //       color: Color(0xff637381),
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     Flexible(
                          //       child: KText(
                          //         text: widget.resellerName.toString(),
                          //         fontSize: 14,
                          //         color: Color(0xff212B36),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // Visibility(
                          //   visible: widget.status.toString() == "2",
                          //   child: Text(
                          //     widget.rejectReason.toString(),
                          //     style: TextStyle(
                          //       color: Colors.red,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6),
                    bottom: Radius.circular(6),
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showSelling = !showSelling;
                          });
                        },
                        child: Icon(
                          showSelling ? Icons.visibility : Icons.visibility_off,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 45,
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
                          Navigator.pop(context);
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
      ),
    );
  }
}

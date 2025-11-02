import 'dart:io';

import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/drawer.dart';
import 'hawala_list_screen.dart';

class HawalaScreen extends StatefulWidget {
  HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final Mypagecontroller mypagecontroller = Get.find();
  final AddHawalaController addHawalaController = Get.put(
    AddHawalaController(),
  );
  SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());
  final BranchController branchController = Get.put(BranchController());

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

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
    addHawalaController.amountController.clear();
    addHawalaController.currency.value = '';
    addHawalaController.finalAmount.value = '';
    conversationController.selectedCurrency.value = "";
    addHawalaController.senderNameController.clear();
    addHawalaController.receiverNameController.clear();
    addHawalaController.fatherNameController.clear();
    addHawalaController.idcardController.clear();
    addHawalaController.currencyID.value == "";
    addHawalaController.paidbyreceiver.value = "";
    addHawalaController.paidbysender.value = "";
    addHawalaController.branchId.value = "";
    addHawalaController.currency.value = "";
    addHawalaController.currency2.value = "";
    addHawalaController.branch.value = "";

    currencyController.fetchCurrency();
    branchController.fetchallbranch();
    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
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
                          mypagecontroller.goBack();
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
                          text: languagesController.tr("CREATE_HAWALA"),
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
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 600,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xffEEF4FF),
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    children: [
                      Text(
                        languagesController.tr("SENDER_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.senderNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("RECEIVER_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.receiverNameController,
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("RECEIVER_FATHERS_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.fatherNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("RECEIVER_ID_CARD_NUMBER"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.idcardController,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("HAWALA_AMOUNT"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                          Text(
                            languagesController.tr("CURRENCY"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: screenHeight * 0.065,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Color(0xffF9FAFB),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: TextField(
                                    style: TextStyle(
                                      height: 1.1,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    controller:
                                        addHawalaController.amountController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenHeight * 0.018,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      print("myvalue " + value.toString());

                                      if (conversationController
                                              .selectedCurrency
                                              .value
                                              .toString() !=
                                          "") {
                                        print("Doin Calculation");

                                        double amount =
                                            double.tryParse(
                                              addHawalaController
                                                  .amountController
                                                  .text
                                                  .trim(),
                                            ) ??
                                            0.0;

                                        double resellerRate =
                                            double.tryParse(
                                              conversationController
                                                  .resellerRate
                                                  .toString(),
                                            ) ??
                                            1.0;

                                        double exchangeRate =
                                            conversationController.currencyRate;

                                        addHawalaController.finalAmount.value =
                                            ((amount * resellerRate) /
                                                    exchangeRate)
                                                .toStringAsFixed(2);
                                      } else {
                                        print("Not Selected");
                                      }
                                    },
                                  ),
                                ),
                              ),
                              // child: Authtextfield(
                              //   hinttext: languagesController.tr("ENTER_AMOUNT"),
                              //   controller: addHawalaController.amountController,
                              // ),
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => Text(
                                            addHawalaController.currency.value
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontFamily:
                                                  box
                                                          .read("language")
                                                          .toString() ==
                                                      "Fa"
                                                  ? Get.find<FontController>()
                                                        .currentFont
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Container(
                                                    height: 250,
                                                    width: double.maxFinite,
                                                    child: Obx(
                                                      () =>
                                                          currencyController
                                                                  .isLoading
                                                                  .value ==
                                                              false
                                                          ? ListView.separated(
                                                              separatorBuilder:
                                                                  (
                                                                    context,
                                                                    index,
                                                                  ) {
                                                                    return SizedBox(
                                                                      height: 5,
                                                                    );
                                                                  },
                                                              itemCount:
                                                                  currencyController
                                                                      .allcurrency
                                                                      .value
                                                                      .data!
                                                                      .currencies!
                                                                      .length,
                                                              itemBuilder: (context, index) {
                                                                final data =
                                                                    currencyController
                                                                        .allcurrency
                                                                        .value
                                                                        .data!
                                                                        .currencies![index];
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    addHawalaController
                                                                        .currency
                                                                        .value = data
                                                                        .symbol
                                                                        .toString();
                                                                    addHawalaController
                                                                        .currency2
                                                                        .value = data
                                                                        .symbol
                                                                        .toString();
                                                                    addHawalaController
                                                                        .currencyID
                                                                        .value = data
                                                                        .id
                                                                        .toString();
                                                                    // Ensure currency values are available

                                                                    conversationController
                                                                        .selectedCurrency
                                                                        .value = data
                                                                        .code
                                                                        .toString();

                                                                    conversationController
                                                                            .currencyRate =
                                                                        double.tryParse(
                                                                          data.exchangeRatePerUsd
                                                                              .toString(),
                                                                        ) ??
                                                                        1.0;

                                                                    // String rateStr =
                                                                    //     box.read(
                                                                    //         "resellerrate");

                                                                    double
                                                                    resellerRate =
                                                                        double.tryParse(
                                                                          conversationController
                                                                              .resellerRate
                                                                              .toString(),
                                                                        ) ??
                                                                        1.0;

                                                                    double
                                                                    amount =
                                                                        double.tryParse(
                                                                          addHawalaController
                                                                              .amountController
                                                                              .text
                                                                              .trim(),
                                                                        ) ??
                                                                        0.0;

                                                                    double
                                                                    exchangeRate =
                                                                        double.tryParse(
                                                                          data.exchangeRatePerUsd
                                                                              .toString(),
                                                                        ) ??
                                                                        1.0;

                                                                    // print(signInController
                                                                    //     .resellerCurrencyRate
                                                                    //     .toString());

                                                                    addHawalaController
                                                                            .finalAmount
                                                                            .value =
                                                                        ((amount *
                                                                                    resellerRate) /
                                                                                exchangeRate)
                                                                            .toStringAsFixed(
                                                                              2,
                                                                            );

                                                                    //  final amount  = (amount * reseller rate) / exchange rate

                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    height: 40,
                                                                    width: double
                                                                        .maxFinite,
                                                                    decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                    ),
                                                                    child: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                            5.0,
                                                                          ),
                                                                      child: Center(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              data.symbol.toString(),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: AppColors
                                                .primaryColor
                                                .withOpacity(0.7),
                                            radius: 15,
                                            child: Icon(
                                              FontAwesomeIcons.chevronDown,
                                              color: Colors.white,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("YOUR_ACCOUNT_BALANCE_IS"),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.017,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("COMMISSION_PAID_BY"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    person.value.toString(),
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: 150,
                                          width: screenWidth,
                                          color: Colors.white,
                                          child: ListView.builder(
                                            itemCount: commissionpaidby.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  person.value =
                                                      commissionpaidby[index];
                                                  if (commissionpaidby[index] ==
                                                      "sender") {
                                                    addHawalaController
                                                            .paidbysender
                                                            .value =
                                                        "1";
                                                    addHawalaController
                                                            .paidbyreceiver
                                                            .value =
                                                        "0";
                                                  } else {
                                                    addHawalaController
                                                            .paidbysender
                                                            .value =
                                                        "0";
                                                    addHawalaController
                                                            .paidbyreceiver
                                                            .value =
                                                        "1";
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 8,
                                                  ),
                                                  height: 40,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    commissionpaidby[index],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.7),
                                  radius: 15,
                                  child: Icon(
                                    FontAwesomeIcons.chevronDown,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Color(0xff352B73),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  addHawalaController.finalAmount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr(
                          "FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE",
                        ),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.015,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("BRANCH"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    addHawalaController.branch.toString(),
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      color: Colors.grey.shade600,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: 150,
                                          width: screenWidth,
                                          color: Colors.white,
                                          child: Obx(
                                            () =>
                                                branchController
                                                        .isLoading
                                                        .value ==
                                                    false
                                                ? ListView.builder(
                                                    itemCount: branchController
                                                        .allbranch
                                                        .value
                                                        .data!
                                                        .hawalabranches!
                                                        .length,
                                                    itemBuilder: (context, index) {
                                                      final data = branchController
                                                          .allbranch
                                                          .value
                                                          .data!
                                                          .hawalabranches![index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          addHawalaController
                                                              .branch
                                                              .value = data.name
                                                              .toString();
                                                          addHawalaController
                                                              .branchId
                                                              .value = data.id
                                                              .toString();

                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                bottom: 8,
                                                              ),
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                data.name
                                                                    .toString(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.7),
                                  radius: 15,
                                  child: Icon(
                                    FontAwesomeIcons.chevronDown,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => DefaultButton1(
                          buttonName:
                              addHawalaController.isLoading.value == false
                              ? languagesController.tr("CONFIRM_AND_SUBMIT")
                              : languagesController.tr("PLEASE_WAIT"),
                          height: 50,
                          width: double.maxFinite,
                          onpressed: () async {
                            if (addHawalaController
                                    .senderNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .receiverNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .amountController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .fatherNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .idcardController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController.currencyID.value != "" &&
                                addHawalaController.paidbyreceiver.value !=
                                    "" &&
                                addHawalaController.branchId.value != "") {
                              print("All is ok............");

                              bool success = await addHawalaController
                                  .createhawala();
                              if (success) {
                                Get.find<Mypagecontroller>().goBack();
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter All data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
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

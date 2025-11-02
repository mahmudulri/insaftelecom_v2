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
import '../controllers/add_payment_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/payment_method_controller.dart';
import '../controllers/payment_type_controller.dart';
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
import 'receipts_screen.dart';

class CreatePaymentsScreen extends StatefulWidget {
  CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  SignInController signInController = Get.put(SignInController());

  CurrencyController currencyController = Get.put(CurrencyController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );
  PaymentTypeController paymentTypeController = Get.put(
    PaymentTypeController(),
  );

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  AddPaymentController addPaymentController = Get.put(AddPaymentController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentMethodController.fetchmethods();
    currencyController.fetchCurrency();
    paymentTypeController.fetchtypes();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );

    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  var selectedMethod = "".obs;
  var selectedType = "".obs;
  var selectedcurrency = "".obs;

  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                          text: languagesController.tr("ADD_NEW_RECEIPT"),
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
                      KText(
                        text: languagesController.tr("PAYMENT_METHOD"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 5),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Container(
                                      height: 150,
                                      width: screenWidth,
                                      color: Colors.white,
                                      child: Obx(
                                        () =>
                                            paymentMethodController
                                                    .isLoading
                                                    .value ==
                                                false
                                            ? ListView.builder(
                                                itemCount:
                                                    paymentMethodController
                                                        .allmethods
                                                        .value
                                                        .data!
                                                        .paymentMethods!
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  final data =
                                                      paymentMethodController
                                                          .allmethods
                                                          .value
                                                          .data!
                                                          .paymentMethods![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      addPaymentController
                                                          .payment_method_id
                                                          .value = data.id
                                                          .toString();
                                                      selectedMethod.value =
                                                          data.methodName
                                                              .toString();

                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        bottom: 8,
                                                      ),
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            KText(
                                                              text: data
                                                                  .methodName
                                                                  .toString(),
                                                            ),
                                                          ],
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => KText(
                                      text: selectedMethod.toString(),
                                      fontSize: screenHeight * 0.020,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.7),
                                  radius: 15,
                                  child: Icon(
                                    FontAwesomeIcons.chevronDown,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: languagesController.tr("AMOUNT"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                          KText(
                            text: languagesController.tr("CURRENCY"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        width: screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
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
                                    controller:
                                        addPaymentController.amountController,
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
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
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
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => KText(
                                            text: selectedcurrency.toString(),
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
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
                                                                    addPaymentController
                                                                        .currencyID
                                                                        .value = data
                                                                        .id
                                                                        .toString();
                                                                    selectedcurrency
                                                                        .value = data
                                                                        .code
                                                                        .toString();
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
                                                                            KText(
                                                                              text: data.symbol.toString(),
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
                      KText(
                        text: languagesController.tr("PAYMENT_DATE"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 5),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => KText(
                                    text:
                                        addPaymentController.selectedDate.value,
                                    fontSize: screenHeight * 0.020,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                    addPaymentController.selectedDate.value =
                                        formattedDate;
                                  }
                                },
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 22,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      KText(
                        text: languagesController.tr("TRACKING_CODE"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addPaymentController.trackingCodeController,
                      ),
                      SizedBox(height: 10),
                      KText(
                        text: languagesController.tr("NOTES"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addPaymentController.noteController,
                      ),
                      SizedBox(height: 10),
                      KText(
                        text: languagesController.tr("PAYMENT_TYPE"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 5),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Container(
                                      height: 150,
                                      width: screenWidth,
                                      color: Colors.white,
                                      child: Obx(
                                        () =>
                                            paymentTypeController
                                                    .isLoading
                                                    .value ==
                                                false
                                            ? ListView.builder(
                                                itemCount: paymentTypeController
                                                    .alltypes
                                                    .value
                                                    .data!
                                                    .paymentTypes!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final data =
                                                      paymentTypeController
                                                          .alltypes
                                                          .value
                                                          .data!
                                                          .paymentTypes![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      addPaymentController
                                                          .payment_type_id
                                                          .value = data.id
                                                          .toString();
                                                      selectedType.value = data
                                                          .name
                                                          .toString();

                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                        bottom: 8,
                                                      ),
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            KText(
                                                              text: data.name
                                                                  .toString(),
                                                            ),
                                                          ],
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => KText(
                                      text: selectedType.toString(),
                                      fontSize: screenHeight * 0.020,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor
                                      .withOpacity(0.7),
                                  radius: 15,
                                  child: Icon(
                                    FontAwesomeIcons.chevronDown,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      KText(
                        text: languagesController.tr("UPLOAD_IMAGES"),
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildImageUploaderBox(
                              context,
                              languagesController.tr("IMAGE_ONE"),
                              addPaymentController.paymentImagePath,
                              () => addPaymentController.pickImage("payment"),
                            ),
                            SizedBox(width: 10),
                            buildImageUploaderBox(
                              context,
                              languagesController.tr("IMAGE_TOW"),
                              addPaymentController.extraImage1Path,
                              () => addPaymentController.pickImage("extra1"),
                            ),
                            SizedBox(width: 10),
                            buildImageUploaderBox(
                              context,
                              languagesController.tr("IMAGE_THREE"),
                              addPaymentController.extraImage2Path,
                              () => addPaymentController.pickImage("extra2"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => DefaultButton2(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              addPaymentController.isLoading.value == false
                              ? languagesController.tr("ADD_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (addPaymentController.payment_method_id.value ==
                                    '' ||
                                addPaymentController
                                    .amountController
                                    .text
                                    .isEmpty ||
                                addPaymentController.currencyID.value == '' ||
                                addPaymentController.selectedDate.value ==
                                    '' || // <-- FIXED
                                addPaymentController
                                    .trackingCodeController
                                    .text
                                    .isEmpty ||
                                addPaymentController
                                    .noteController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Please fill all required fields correctly",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              addPaymentController.addNow();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
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

Widget buildImageUploaderBox(
  BuildContext context,
  String label,
  RxString imagePath,
  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 160,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imagePath.value.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imagePath.value),
                      width: 160,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KText(
                        text: label,
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        ),
        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                imagePath.value = '';
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    ),
  );
}

import 'package:insaftelecom/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/screens/add_new_user.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import '../controllers/payments_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer.dart';
import 'create_payments_screen.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

final Mypagecontroller mypagecontroller = Get.find();

LanguagesController languagesController = Get.put(LanguagesController());

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  List orderStatus = [];
  String defaultValue = "";

  String secondDropDown = "";
  @override
  void initState() {
    super.initState();
    paymentsController.fetchpayments();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  PaymentsController paymentsController = Get.put(PaymentsController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(0xffF1F3FF),
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
                          text: languagesController.tr(
                            "PAYMENT_RECEIPT_REQUEST",
                          ),
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
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.openSubPage(CreatePaymentsScreen());
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth,
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Color(0xff04B75D),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white.withOpacity(
                                              0.3,
                                            ), // উপরের দিকের হালকা সাদা
                                            Colors.transparent, // নিচে স্বচ্ছ
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            KText(
                                              text: languagesController.tr(
                                                "ADD_NEW_RECEIPT",
                                              ),
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
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
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              value: defaultValue,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "",
                                  child: KText(
                                    text: languagesController.tr("ALL"),
                                    fontSize: screenWidth * 0.040,
                                  ),
                                ),
                                ...orderStatus.map<DropdownMenuItem<String>>((
                                  data,
                                ) {
                                  return DropdownMenuItem(
                                    value: data['value'],
                                    child: KText(text: data['title']),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.search_sharp,
                                color: Colors.grey,
                                size: screenHeight * 0.040,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    decoration: InputDecoration(
                                      hintText: languagesController.tr(
                                        "SEARCH",
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.040,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: screenWidth,
                // color: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(
                    () => paymentsController.isLoading.value == false
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemCount: paymentsController
                                .allpaymentslist
                                .value
                                .data!
                                .payments
                                .length,
                            itemBuilder: (context, index) {
                              final data = paymentsController
                                  .allpaymentslist
                                  .value
                                  .data!
                                  .payments[index];
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        content: PaymentDialog(
                                          status: data.status,
                                          paymentmethod:
                                              data.paymentMethod!.methodName,
                                          amount: data.amount,
                                          performedByName: data.performedByName,
                                          currency: data.currency!.code,
                                          notes: data.notes,
                                          date: data.paymentDate.toString(),
                                          image1: data.paymentImageUrl,
                                          image2: data.extraImage1Url,
                                          image3: data.extraImage2Url,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 230,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: data.status.toString() == "pending"
                                          ? Color(0xffFFC107)
                                          : data.status.toString() ==
                                                "completed"
                                          ? Colors.green
                                          : Color(0xffFF4842),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                data.status.toString() ==
                                                    "pending"
                                                ? Color(
                                                    0xffFFC107,
                                                  ).withOpacity(0.12)
                                                : data.status.toString() ==
                                                      "completed"
                                                ? Colors.green.withOpacity(0.12)
                                                : Color(
                                                    0xffFF4842,
                                                  ).withOpacity(0.4),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                KText(
                                                  text: languagesController.tr(
                                                    "AMOUNT",
                                                  ),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                Spacer(),
                                                KText(
                                                  text: data.amount.toString(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                SizedBox(width: 4),
                                                KText(
                                                  text: data.currency!.symbol
                                                      .toString(),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("PAYMENT_METHOD"),
                                                  ),
                                                  Text(
                                                    data
                                                        .paymentMethod!
                                                        .methodName
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("PERFORMED_BY"),
                                                  ),
                                                  KText(
                                                    text: data.performedByName
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("NOTES"),
                                                  ),
                                                  SizedBox(width: 100),
                                                  Expanded(
                                                    child: Text(
                                                      data.notes.toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("STATUS"),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      color:
                                                          data.status
                                                                  .toString() ==
                                                              "pending"
                                                          ? Colors.grey
                                                          : data.status
                                                                    .toString() ==
                                                                "completed"
                                                          ? Colors.green
                                                          : Color(
                                                              0xffFF4842,
                                                            ).withOpacity(0.4),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 2,
                                                          ),
                                                      child: KText(
                                                        text: data.status
                                                            .toString(),
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "pending"
                                                            ? Colors.white
                                                            : data.status
                                                                      .toString() ==
                                                                  "completed"
                                                            ? Colors.white
                                                            : Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  KText(
                                                    text: languagesController
                                                        .tr("DATE"),
                                                  ),
                                                  KText(
                                                    text:
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.paymentDate
                                                                .toString(),
                                                          ),
                                                        ),
                                                    fontSize: 13,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: screenWidth,
                                          // color: Colors.green,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child:
                                                        (data.paymentImageUrl ==
                                                                null ||
                                                            data.paymentImageUrl
                                                                .toString()
                                                                .isEmpty)
                                                        ? Image.asset(
                                                            'assets/icons/no_image.png', // ✅ your local image
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Image.network(
                                                            data.paymentImageUrl
                                                                .toString(),
                                                            fit: BoxFit.contain,
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Image.asset(
                                                                    'assets/icons/no_image.png', // ✅ fallback asset image
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  );
                                                                },
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Container(
                                                  width: 120,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child:
                                                        (data.paymentImageUrl ==
                                                                null ||
                                                            data.extraImage1Url
                                                                .toString()
                                                                .isEmpty)
                                                        ? Image.asset(
                                                            'assets/icons/no_image.png', // ✅ your local image
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Image.network(
                                                            data.extraImage1Url
                                                                .toString(),
                                                            fit: BoxFit.contain,
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Image.asset(
                                                                    'assets/icons/no_image.png', // ✅ fallback asset image
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  );
                                                                },
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Container(
                                                  width: 120,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child:
                                                        (data.paymentImageUrl ==
                                                                null ||
                                                            data.extraImage2Url
                                                                .toString()
                                                                .isEmpty)
                                                        ? Image.asset(
                                                            'assets/icons/no_image.png', // ✅ your local image
                                                            fit: BoxFit.contain,
                                                          )
                                                        : Image.network(
                                                            data.extraImage2Url
                                                                .toString(),
                                                            fit: BoxFit.contain,
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Image.asset(
                                                                    'assets/icons/no_image.png', // ✅ fallback asset image
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  );
                                                                },
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class PaymentDialog extends StatelessWidget {
  PaymentDialog({
    super.key,
    this.status,
    this.paymentmethod,
    this.amount,
    this.performedByName,
    this.notes,
    this.currency,
    this.date,
    this.image1,
    this.image2,
    this.image3,
  });

  String? status;
  String? paymentmethod;
  String? amount;
  String? performedByName;
  String? notes;
  String? currency;
  String? date;
  String? image1;
  String? image2;
  String? image3;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 500,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 420,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: status.toString() == "pending"
                      ? Color(0xffFFC107)
                      : status.toString() == "completed"
                      ? Colors.green
                      : Color(0xffFF4842),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          status.toString() == "pending"
                              ? "assets/icons/pending.png"
                              : status.toString() == "completed"
                              ? "assets/icons/successful.png"
                              : "assets/icons/rejected.png",
                          height: 60,
                        ),
                      ),
                      KText(
                        text: status.toString() == "pending"
                            ? languagesController.tr("PENDING")
                            : status.toString() == "completed"
                            ? languagesController.tr("COMPLETED")
                            : languagesController.tr("REJECTED"),
                        color: status.toString() == "pending"
                            ? Color(0xffFFC107)
                            : status.toString() == "completed"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 80,
                        width: screenWidth,
                        // color: Colors.red,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    (image1 == null ||
                                        image1.toString().isEmpty)
                                    ? Image.asset(
                                        'assets/icons/no_image.png', // ✅ your local fallback image
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        image1.toString(),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/icons/no_image.png', // ✅ fallback asset image
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    (image2 == null ||
                                        image2.toString().isEmpty)
                                    ? Image.asset(
                                        'assets/icons/no_image.png', // ✅ your local fallback image
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        image2.toString(),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/icons/no_image.png', // ✅ fallback asset image
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    (image3 == null ||
                                        image3.toString().isEmpty)
                                    ? Image.asset(
                                        'assets/icons/no_image.png', // ✅ your local fallback image
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        image3.toString(),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/icons/no_image.png', // ✅ fallback asset image
                                            fit: BoxFit.contain,
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: languagesController.tr("PAYMENT_METHOD"),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                          KText(
                            text: paymentmethod.toString(),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: languagesController.tr("AMOUNT"),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                          Spacer(),
                          KText(
                            text: amount.toString(),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                          SizedBox(width: 4),
                          KText(
                            text: currency.toString(),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: languagesController.tr("PERFORMED_BY"),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                          KText(
                            text: performedByName.toString(),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: languagesController.tr("NOTES"),
                            color: Color(0xff637381),
                            fontSize: 15,
                          ),
                          Expanded(
                            child: Text(
                              notes.toString(),
                              style: TextStyle(
                                color: Color(0xff637381),
                                fontSize: 15,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
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
                            color: status.toString() == "pending"
                                ? Color(0xffFFC107)
                                : status.toString() == "completed"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: languagesController.tr("DATE"),
                                fontWeight: FontWeight.w600,
                              ),
                              KText(
                                text: DateFormat(
                                  'dd MMM yyyy',
                                ).format(DateTime.parse(date.toString())),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 45,
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(8),
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
    );
  }
}

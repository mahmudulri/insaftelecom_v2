import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/transaction_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/drawer_controller.dart';
import '../global_controller/font_controller.dart';
import '../screens/sign_in_screen.dart';

class Transactions extends StatefulWidget {
  Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List orderStatus = [
    {"title": "Pending", "value": "order_status=0"},
    {"title": "Confirmed", "value": "order_status=1"},
    {"title": "Rejected", "value": "order_status=2"},
  ];

  final box = GetStorage();

  String defaultValue = "";

  String secondDropDown = "";

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    transactionController.fetchTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: DrawerWidget(),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                          text: languagesController.tr("TRANSACTIONS"),
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: screenWidth,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
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
                                  child: Obx(
                                    () => KText(
                                      text: languagesController.tr("ALL"),
                                      fontSize: screenWidth * 0.040,
                                    ),
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
                              onChanged: (value) {
                                // box.write("orderstatus", value);
                                // print(
                                //     "selected Value $value");
                                setState(() {
                                  defaultValue = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
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
                              Obx(
                                () => KText(
                                  text: languagesController.tr("DATE"),
                                  fontSize: screenWidth * 0.040,
                                ),
                              ),
                              Icon(Icons.calendar_month, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
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
                                        "SEARCH_BY_PHOENUMBER",
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
                      SizedBox(height: 10),
                      Obx(
                        () => Container(
                          height: 45,
                          width: screenWidth,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffFF6A60),
                                    ),
                                  ),
                                  child: Center(
                                    child: KText(
                                      text: languagesController.tr(
                                        "APPLY_FILTER",
                                      ),
                                      color: Color(0xffFF6A60),
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: SinInbutton(
                                  buttonName: languagesController.tr(
                                    "REMOVE_FILTER",
                                  ),
                                  onpressed: () {},
                                  height: 45,
                                  width: double.maxFinite,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 400,
                // color: Colors.cyan,
                child: Obx(
                  () => transactionController.isLoading.value == false
                      ? ListView.separated(
                          padding: EdgeInsets.all(0),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5);
                          },
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: transactionController
                              .alltransactionlist
                              .value
                              .data!
                              .resellerBalanceTransactions
                              .length,
                          itemBuilder: (context, index) {
                            final data = transactionController
                                .alltransactionlist
                                .value
                                .data!
                                .resellerBalanceTransactions[index];
                            return Container(
                              height: 120,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: data.status.toString() == "debit"
                                      ? Colors.red.withOpacity(0.4)
                                      : Colors.green.withOpacity(0.4),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: data.status.toString() == "debit"
                                            ? Colors.red.withOpacity(0.12)
                                            : Colors.green.withOpacity(0.12),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            KText(
                                              text: data.reseller!.resellerName
                                                  .toString(),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.020,
                                            ),
                                            KText(
                                              text: DateFormat("dd-MM-yyyy")
                                                  .format(
                                                    DateTime.parse(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenHeight * 0.020,
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                KText(
                                                  text: languagesController.tr(
                                                    "TRANSACTION_TYPE",
                                                  ),
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      screenHeight * 0.020,
                                                ),
                                                Obx(
                                                  () => Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          data.status
                                                                  .toString() ==
                                                              "debit"
                                                          ? Colors.red
                                                                .withOpacity(
                                                                  0.12,
                                                                )
                                                          : Colors.green
                                                                .withOpacity(
                                                                  0.12,
                                                                ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6,
                                                          ),
                                                      child: KText(
                                                        text:
                                                            data.status
                                                                    .toString() ==
                                                                "debit"
                                                            ? languagesController
                                                                  .tr("DEBIT")
                                                            : languagesController
                                                                  .tr("CREDIT"),
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "debit"
                                                            ? Colors.red
                                                            : Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            screenHeight *
                                                            0.020,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Obx(
                                                  () => KText(
                                                    text: languagesController
                                                        .tr("AMOUNT"),
                                                    color: Colors.grey.shade700,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        screenHeight * 0.020,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    KText(
                                                      text:
                                                          NumberFormat.currency(
                                                            locale: 'en_US',
                                                            symbol: '',
                                                            decimalDigits: 2,
                                                          ).format(
                                                            double.parse(
                                                              data.amount
                                                                  .toString(),
                                                            ),
                                                          ),
                                                      fontSize:
                                                          screenHeight * 0.015,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          data.status
                                                                  .toString() ==
                                                              "debit"
                                                          ? Colors.black
                                                          : Colors.black,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "${box.read("currency_code")} ",
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenHeight *
                                                            0.015,
                                                        color:
                                                            data.status
                                                                    .toString() ==
                                                                "debit"
                                                            ? Colors.black
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:insaftelecom/widgets/button_one.dart';
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
import '../global_controller/page_controller.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/hawala_rates_screen.dart';
import '../screens/receipts_screen.dart';
import '../screens/loan_screen.dart';
import '../screens/sign_in_screen.dart';
import '../widgets/default_button1.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class HawalaPage extends StatefulWidget {
  HawalaPage({super.key});

  @override
  State<HawalaPage> createState() => _HawalaPageState();
}

class _HawalaPageState extends State<HawalaPage> {
  final Mypagecontroller mypagecontroller = Get.find();

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
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
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
                      Obx(() {
                        final profileImageUrl = dashboardController
                            .alldashboardData
                            .value
                            .data
                            ?.userInfo
                            ?.profileImageUrl;

                        if (dashboardController.isLoading.value ||
                            profileImageUrl == null ||
                            profileImageUrl.isEmpty) {
                          return Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 30,
                            ),
                          );
                        }

                        return Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            child: Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // fallback if 404 or failed to load
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                      Spacer(),
                      Obx(
                        () => KText(
                          text: languagesController.tr("HAWALA"),
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
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => KText(
                              text: languagesController.tr("SELECT"),
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8082ED),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA"),
                        imagelink: "assets/icons/exchange.png",
                        mycolor: Color(0xffFE8F2D),
                        onpressed: () {
                          mypagecontroller.changePage(
                            HawalaListScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "PAYMENT_RECEIPT_REQUEST",
                        ),
                        imagelink: "assets/icons/wallet.png",
                        mycolor: Color(0xff04B75D),
                        onpressed: () {
                          mypagecontroller.changePage(
                            ReceiptsScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA_RATES"),
                        imagelink: "assets/icons/exchange-rate.png",
                        mycolor: Color(0xff4B7AFC),
                        onpressed: () {
                          mypagecontroller.changePage(
                            HawalaCurrencyScreen(),
                            isMainPage: false,
                          );
                        },
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

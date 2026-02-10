import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final dashboardController = Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.find();

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
                  padding: EdgeInsets.symmetric(horizontal: 0),
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
                        () => Text(
                          languagesController.tr("WALLET_DETAILS"),
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
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.menu, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // optional, makes it modern
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08), // light shadow
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(0, 4), // shadow direction (x,y)
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Obx(
                    () => dashboardController.isLoading.value == false
                        ? Column(
                            children: [
                              balanceBox(
                                "assets/icons/balance.png",
                                languagesController.tr("BALANCE"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .balance
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/profit.png",
                                languagesController.tr("PROFIT"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .totalRevenue
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/profit.png",
                                languagesController.tr("TODAY_PROFIT"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .todayProfit
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/sale.png",
                                languagesController.tr("SALE"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .totalSoldAmount
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/sale.png",
                                languagesController.tr("TODAY_SALE"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .todaySale
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/loan_balance.png",
                                languagesController.tr("LOAN_BALANCE"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .loanBalance
                                    .toString(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: screenWidth,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 10),
                              balanceBox(
                                "assets/icons/comission.png",
                                languagesController.tr("COMISSION"),
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .userInfo!
                                    .totalearning
                                    .toString(),
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget balanceBox(String imagelink, String name, String balance) {
    return Row(
      children: [
        Image.asset(imagelink.toString(), height: 20, width: 20),
        SizedBox(width: 6),
        KText(
          text: name.toString(),
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        Spacer(),
        Text(
          NumberFormat.currency(
            locale: 'en_US',
            symbol: '',
            decimalDigits: 2,
          ).format(double.parse(balance.toString())),

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 4),
        KText(
          text: box.read("currencyName"),
          fontSize: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}

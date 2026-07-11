import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/wallet_setting_controller.dart';
import '../controllers/wallet_trans_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/drawer.dart';

class WalletSettingScreen extends StatefulWidget {
  WalletSettingScreen({super.key});

  @override
  State<WalletSettingScreen> createState() => _WalletSettingScreenState();
}

class _WalletSettingScreenState extends State<WalletSettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.find();

  final WalletTransController walletTransController =
      Get.find<WalletTransController>();

  final WalletsController walletsController = Get.find<WalletsController>();
  final WalletSettingController walletSettingController =
      Get.find<WalletSettingController>();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    walletSettingController.fetchsettings();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerWidget(),
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homeback.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.10),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(FontAwesomeIcons.chevronLeft, size: 18),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        languagesController.tr("WALLET_SETTINGS"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.10),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.menu, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Obx(() {
                  final walletModel =
                      walletTransController.alltransactions.value;

                  final wallet = walletModel?.data?.wallet;
                  final transactions = walletModel?.data?.transactions ?? [];

                  return Obx(
                    () => walletSettingController.isLoading.value == false
                        ? ListView(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 25,
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Prefered Currency",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    walletSettingController
                                        .allsettings
                                        .value
                                        .data!
                                        .preferredCurrency!
                                        .code
                                        .toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

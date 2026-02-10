import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/drawer.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  final dashboardController = Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                        () => Text(
                          languagesController.tr("HAWALA_RATES"),
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
              padding: const EdgeInsets.all(8.0),
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
                child: Obx(
                  () => hawalacurrencycontroller.isLoading.value == false
                      ? SizedBox(
                          height:
                              screenHeight *
                              0.7, // এখানে আপনি নিজে height fix করে দিন
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              itemCount: hawalacurrencycontroller
                                  .allcurrencylist
                                  .value
                                  .data!
                                  .rates!
                                  .length,
                              itemBuilder: (context, index) {
                                final data = hawalacurrencycontroller
                                    .allcurrencylist
                                    .value
                                    .data!
                                    .rates![index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Color(0xffEEF4FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Obx(
                                        () => Text(
                                          data.amount.toString() +
                                              " " +
                                              data.fromCurrency!.name
                                                  .toString() +
                                              " " +
                                              languagesController.tr("TO") +
                                              " " +
                                              data.toCurrency!.name.toString() +
                                              " " +
                                              languagesController.tr("BUYING") +
                                              " " +
                                              data.buyRate.toString() +
                                              " " +
                                              data.toCurrency!.symbol
                                                  .toString() +
                                              " " +
                                              languagesController.tr(
                                                "SELLING",
                                              ) +
                                              " " +
                                              data.sellRate.toString() +
                                              " " +
                                              data.toCurrency!.symbol
                                                  .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenHeight * 0.020,
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
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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

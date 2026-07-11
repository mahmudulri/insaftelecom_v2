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

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

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
              child: Obx(() {
                if (hawalacurrencycontroller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rates =
                    hawalacurrencycontroller
                        .allcurrencylist
                        .value
                        .data
                        ?.rates ??
                    [];

                if (rates.isEmpty) {
                  return Center(
                    child: Text(
                      languagesController.tr("NO_DATA_FOUND"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: screenHeight * 0.7,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: rates.length,
                      itemBuilder: (context, index) {
                        final data = rates[index];

                        final amount = data.amount?.toString() ?? "0";
                        final fromName =
                            data.fromCurrency?.name?.toString() ?? "";
                        final toName = data.toCurrency?.name?.toString() ?? "";
                        final toSymbol =
                            data.toCurrency?.symbol?.toString() ?? "";
                        final buyRate = data.buyRate?.toString() ?? "0";
                        final sellRate = data.sellRate?.toString() ?? "0";

                        final fontFamily =
                            box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xffF8FAFF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xffDDE7FF),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Top Row
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xff0B5ED7,
                                      ).withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "$amount $fromName",
                                      style: TextStyle(
                                        color: const Color(0xff0B5ED7),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.currency_exchange_rounded,
                                    size: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              /// Currency Conversion Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _currencyBox(
                                      title: languagesController.tr("FROM"),
                                      value: fromName,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff0B5ED7),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _currencyBox(
                                      title: languagesController.tr("TO"),
                                      value: toName,
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              /// Buying / Selling Rate Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _rateBox(
                                      title: languagesController.tr("BUYING"),
                                      value: "$buyRate $toSymbol",
                                      icon: Icons.south_west_rounded,
                                      color: const Color(0xff16A34A),
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _rateBox(
                                      title: languagesController.tr("SELLING"),
                                      value: "$sellRate $toSymbol",
                                      icon: Icons.north_east_rounded,
                                      color: const Color(0xffDC2626),
                                      fontFamily: fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _currencyBox({
  required String title,
  required String value,
  String? fontFamily,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xffE5EAF5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: fontFamily,
          ),
        ),
      ],
    ),
  );
}

Widget _rateBox({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
  String? fontFamily,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.20)),
    ),
    child: Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

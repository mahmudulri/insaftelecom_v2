import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/wallet_trans_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/drawer.dart';

class WalletTransScreen extends StatefulWidget {
  WalletTransScreen({super.key});

  @override
  State<WalletTransScreen> createState() => _WalletTransScreenState();
}

class _WalletTransScreenState extends State<WalletTransScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.find();

  final WalletTransController walletTransController =
      Get.find<WalletTransController>();

  final WalletsController walletsController = Get.find<WalletsController>();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return "";
    return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
  }

  Color _typeColor(String? type) {
    if (type == "credit") {
      return const Color(0xff14B86A);
    }

    if (type == "debit") {
      return const Color(0xffF04438);
    }

    return const Color(0xff667085);
  }

  IconData _typeIcon(String? type) {
    if (type == "credit") {
      return Icons.arrow_downward_rounded;
    }

    if (type == "debit") {
      return Icons.arrow_upward_rounded;
    }

    return Icons.swap_vert_rounded;
  }

  String _typeText(String? type) {
    if (type == "credit") return "Credit";
    if (type == "debit") return "Debit";
    return type ?? "";
  }

  Widget _loadingWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 34,
              width: 34,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xff011A52),
              ),
            ),
            SizedBox(height: 14),
            Text(
              languagesController.tr("LOADING_TRANSACTIONS"),
              style: TextStyle(
                color: Color(0xff101828),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
                        languagesController.tr("TRANSACTIONS"),
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

                  if (walletTransController.isLoading.value) {
                    return Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 25,
                          ),
                          children: [
                            // tomar existing ListView children ekhanei thakbe
                          ],
                        ),

                        if (walletTransController.isLoading.value)
                          Positioned.fill(
                            child: Container(
                              // color: Colors.black.withOpacity(.18),
                              child: _loadingWidget(),
                            ),
                          ),
                      ],
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 25,
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xffFFFFFF), Color(0xffEAF3FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.18),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 52,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xff082B58),
                                        Color(0xff041A36),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xff008CFF,
                                        ).withOpacity(.25),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        languagesController.tr(
                                          "CURRENT_BALANCE",
                                        ),
                                        style: TextStyle(
                                          color: Color(0xff667085),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${wallet?.currentBalance ?? "0.00"} ${wallet?.currencyCode ?? ""}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xff101828),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffF2F7FF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xffD7E7FF),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_long_rounded,
                                    color: Color(0xff175CD3),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${transactions.length} ${languagesController.tr("TRANSACTIONS")}",
                                    style: const TextStyle(
                                      color: Color(0xff175CD3),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${languagesController.tr("WALLET_ID")}: ${wallet?.id ?? ""}",
                                    style: const TextStyle(
                                      color: Color(0xff667085),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff011A52),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              child: Text(
                                languagesController.tr("TRANSACTIONS_HISTORY"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      if (transactions.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 35,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.10),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF2F4F7),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.hourglass_empty_rounded,
                                  color: Color(0xff667085),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                languagesController.tr("NO_TRANSACTIONS_FOUND"),
                                style: TextStyle(
                                  color: Color(0xff101828),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                languagesController.tr(
                                  "YOUR_WALLET_TRANSACTION_HISTORY_WILL_APEAR_HERE",
                                ),

                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff667085),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...transactions.map((item) {
                          final color = _typeColor(item.type);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.10),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(.10),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Icon(
                                        _typeIcon(item.type),
                                        color: color,
                                        size: 24,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.category ?? "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xff101828),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(.10),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  _typeText(item.type),
                                                  style: TextStyle(
                                                    color: color,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 6),

                                          Text(
                                            item.description ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xff667085),
                                              fontSize: 13,
                                              height: 1.35,
                                            ),
                                          ),

                                          const SizedBox(height: 8),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                color: Color(0xff98A2B3),
                                                size: 15,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  _formatDate(item.createdAt),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xff98A2B3),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF9FAFB),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xffEAECF0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              languagesController.tr("BEFORE"),
                                              style: TextStyle(
                                                color: Color(0xff98A2B3),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.balanceBefore ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xff475467),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 32,
                                        width: 1,
                                        color: const Color(0xffEAECF0),
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              languagesController.tr("AMOUNT"),
                                              style: TextStyle(
                                                color: Color(0xff98A2B3),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${item.type == "debit" ? "-" : "+"}${item.amount ?? "0.00"}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: color,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 32,
                                        width: 1,
                                        color: const Color(0xffEAECF0),
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              languagesController.tr("AFTER"),
                                              style: TextStyle(
                                                color: Color(0xff98A2B3),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.balanceAfter ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xff475467),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                    ],
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

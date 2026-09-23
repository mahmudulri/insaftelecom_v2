import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/wallet_details_controller.dart';
import '../controllers/wallet_setting_controller.dart';
import '../controllers/wallet_summary_controller.dart';
import '../controllers/wallet_trans_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer.dart';
import '../widgets/switch_active_wallet_dialog.dart';
import '../widgets/transfer_between_wallet_dialog.dart';
import '../widgets/transfer_to_balance_dialog.dart';
import '../widgets/wallet_details_dialog.dart';
import '../widgets/wallet_summary_dialog.dart';
import 'wallet_setting_screen.dart';
import 'wallet_trans_screen.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final WalletsController walletsController = Get.find<WalletsController>();
  final Mypagecontroller mypagecontroller = Get.find();

  final WalletTransController walletTransController = Get.put(
    WalletTransController(),
  );

  final WalletSummaryController walletSummaryController = Get.put(
    WalletSummaryController(),
  );

  final WalletDetailsController walletDetailsController = Get.put(
    WalletDetailsController(),
  );

  final WalletSettingController walletSettingController = Get.put(
    WalletSettingController(),
  );

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    walletsController.fetchwalletsData();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),

        // Android status bar icon white
        statusBarIconBrightness: Brightness.light,

        // iOS status bar text/icon white
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // walletSettingController.fetchsettings();
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
        child: ListView(
          padding: EdgeInsets.all(0.0),
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
                        () => GestureDetector(
                          onTap: () {
                            walletsController.fetchwalletsData();
                          },
                          child: Text(
                            languagesController.tr("WALLET_DETAILS"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // _scaffoldKey.currentState?.openDrawer();
                          mypagecontroller.openSubPage(WalletSettingScreen());
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
                            child: Icon(Icons.settings, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            Container(
              height: 600,
              width: screenWidth,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(() {
                        if (walletsController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        final wallets = walletsController.wallets;

                        if (wallets.isEmpty) {
                          return Container(
                            width: screenWidth,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              languagesController.tr("NO_WALLET_FOUND"),
                            ),
                          );
                        }

                        return Container(
                          width: screenWidth,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 24,
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
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xff011A52),
                                          Color(0xff006DFF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xff004AAD,
                                          ).withOpacity(0.28),
                                          blurRadius: 14,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          languagesController.tr(
                                            "SELECT_WALLET",
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xff101828),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          languagesController.tr(
                                            "MANAGE_WALLET",
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  PopupMenuButton<String>(
                                    color: Colors.white,
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    offset: const Offset(0, 46),
                                    onSelected: (value) {
                                      if (value == "switch") {
                                        Get.dialog(
                                          const SwitchActiveWalletDialog(),
                                          barrierDismissible: false,
                                        );
                                      } else if (value == "transfer") {
                                        walletDetailsController.fetchdetails(
                                          walletsController
                                              .selectedWalletId
                                              .value
                                              .toString(),
                                        );
                                        Get.dialog(
                                          const TransferToBalanceDialog(),
                                          barrierDismissible: false,
                                        );
                                      } else if (value == "exchange") {
                                        walletTransController.fetchtransaction(
                                          walletsController
                                              .selectedWalletId
                                              .value
                                              .toString(),
                                        );
                                        Get.dialog(
                                          const TransferBetweenWalletDialog(),
                                          barrierDismissible: false,
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: "switch",
                                        child: _walletOptionMenuItem(
                                          icon: Icons.swap_horiz_rounded,
                                          title: languagesController.tr(
                                            "SWITCH",
                                          ),
                                          subtitle: languagesController.tr(
                                            "SWITCH_ACTIVE_WALLET",
                                          ),
                                          color: const Color(0xff004AAD),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "transfer",
                                        child: _walletOptionMenuItem(
                                          icon: Icons.move_up_rounded,
                                          title: languagesController.tr(
                                            "TRANSFER",
                                          ),
                                          subtitle: languagesController.tr(
                                            "TRANSFER_TO_BALANCE",
                                          ),
                                          color: const Color(0xff7A5AF8),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "exchange",
                                        child: _walletOptionMenuItem(
                                          icon: Icons.currency_exchange_rounded,
                                          title: languagesController.tr(
                                            "EXCHANGE",
                                          ),
                                          subtitle: languagesController.tr(
                                            "TRANSFER_BETWEEN_WALLET",
                                          ),
                                          color: const Color(0xff12B76A),
                                        ),
                                      ),
                                    ],
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff011A52),
                                            Color(0xff004AAD),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xff011A52,
                                            ).withOpacity(0.22),
                                            blurRadius: 12,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.grid_view_rounded,
                                            size: 17,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            languagesController.tr("OPTIONS"),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F9FC),
                                  borderRadius: BorderRadius.circular(17),
                                  border: Border.all(
                                    color: const Color(0xffE6EAF0),
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonFormField<int>(
                                  value:
                                      walletsController.selectedWalletId.value,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xff011A52),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 13,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.payments_rounded,
                                      color: Color(0xff011A52),
                                      size: 22,
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  items: wallets.map((wallet) {
                                    return DropdownMenuItem<int>(
                                      value: wallet.walletId,
                                      child: Text(
                                        "${wallet.currency?.code ?? ''} (${wallet.currency?.symbol ?? ''})",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xff101828),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    walletsController.selectWallet(value);
                                    print(value.toString());
                                  },
                                ),
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: _walletActionCard(
                                      icon: Icons.pie_chart_rounded,
                                      title: languagesController.tr("SUMMARY"),

                                      iconColor: const Color(0xff004AAD),
                                      bgColor: const Color(0xffEEF4FF),
                                      onTap: () {
                                        Get.dialog(WalletSummaryDialog());
                                        walletSummaryController.fetchsummary();
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: _walletActionCard(
                                      icon: Icons.info_outline_rounded,
                                      title: languagesController.tr("DETAILS"),

                                      iconColor: const Color(0xff7A5AF8),
                                      bgColor: const Color(0xffF4F3FF),
                                      onTap: () {
                                        walletDetailsController.fetchdetails(
                                          walletsController
                                              .selectedWalletId
                                              .value
                                              .toString(),
                                        );

                                        Get.dialog(WalletDetailsDialog());
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: _walletActionCard(
                                      icon: Icons.receipt_long_rounded,
                                      title: languagesController.tr("HISTORY"),

                                      iconColor: const Color(0xff12B76A),
                                      bgColor: const Color(0xffECFDF3),
                                      onTap: () {
                                        walletTransController.fetchtransaction(
                                          walletsController
                                              .selectedWalletId
                                              .value
                                              .toString(),
                                        );

                                        mypagecontroller.openSubPage(
                                          WalletTransScreen(),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 15),

                    /// Second Container: Selected wallet details
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Obx(() {
                            if (walletsController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final selectedWallet =
                                walletsController.selectedWallet;

                            if (selectedWallet == null) {
                              return Center(
                                child: Text(
                                  languagesController.tr("NO_WALLET_SELECTED"),
                                ),
                              );
                            }

                            final symbol =
                                selectedWallet.currency?.symbol ?? "";

                            return Column(
                              children: [
                                balanceBox(
                                  "assets/icons/balance.png",
                                  languagesController.tr("BALANCE"),
                                  selectedWallet.balance ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/sale.png",
                                  languagesController.tr("PAYMENT"),
                                  selectedWallet.payment ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/balance.png",
                                  languagesController.tr("AVAILABLE_BALANCE"),
                                  selectedWallet.availableBalance ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/loan_balance.png",
                                  languagesController.tr("LOAN_BALANCE"),
                                  selectedWallet.loanBalance ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/balance.png",
                                  languagesController.tr("TOTAL_AVAILABLE"),
                                  selectedWallet.totalAvailable ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/comission.png",
                                  languagesController.tr("TOTAL_EARNING"),
                                  selectedWallet.totalEarnings ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/sale.png",
                                  languagesController.tr("TOTAL_HAWALA_SENT"),
                                  selectedWallet.totalHawalaSent ?? "0",
                                  symbol,
                                ),
                                dividerLine(screenWidth),

                                balanceBox(
                                  "assets/icons/sale.png",
                                  languagesController.tr(
                                    "TOTAL_HAWALA_RECEIVED",
                                  ),
                                  selectedWallet.totalHawalaReceived ?? "0",
                                  symbol,
                                ),
                              ],
                            );
                          }),
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
    );
  }

  Widget balanceBox(
    String imagelink,
    String name,
    String balance,
    String symbol,
  ) {
    final amount = double.tryParse(balance.replaceAll(",", "")) ?? 0.0;

    return Row(
      children: [
        Image.asset(imagelink, height: 20, width: 20),
        SizedBox(width: 6),
        Expanded(
          child: KText(
            text: name,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        Text(
          NumberFormat.currency(
            locale: 'en_US',
            symbol: '',
            decimalDigits: 2,
          ).format(amount),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 4),
        KText(text: symbol, fontSize: 12, color: Colors.black),
      ],
    );
  }

  Widget balanceBoxd(String imagelink, String name, String balance) {
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

  Widget dividerLine(double screenWidth) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(height: 1, width: screenWidth, color: Colors.grey.shade100),
        SizedBox(height: 10),
      ],
    );
  }
}

Widget _walletActionCard({
  required IconData icon,
  required String title,

  required Color iconColor,
  required Color bgColor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Color(0xff101828),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _walletOptionMenuItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
}) {
  return Row(
    children: [
      Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xff101828),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xff667085),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

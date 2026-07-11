import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insaftelecom/screens/wallet_screen.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/confirm_pin_controller.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/custom_recharge_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/slider_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/balance_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/order_details_screen.dart';
import '../utils/colors.dart';
import '../widgets/drawer.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List serviceimages = [
    "assets/images/cat1.png",
    "assets/images/cat2.png",
    "assets/images/cat3.png",
    "assets/images/cat4.png",
  ];

  final dashboardController = Get.find<DashboardController>();

  final categorisListController = Get.find<CategorisListController>();

  final box = GetStorage();

  final sliderController = Get.find<SliderController>();

  final confirmPinController = Get.find<ConfirmPinController>();

  final bundleController = Get.find<BundleController>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  final WalletsController walletsController = Get.find<WalletsController>();

  final historyController = Get.find<HistoryController>();

  int currentIndex = 0;
  int selectedIndex = 0;
  RxString title = "Balance".obs;
  RxString balance = "".obs;

  // var items = <Map<String, String>>[].obs;
  List<Map<String, String>> get items {
    return [
      {
        'name': languagesController.tr("BALANCE"),
        'icon': 'assets/icons/balance2.png',
      },
      {
        'name': languagesController.tr("DEBIT"),
        'icon': 'assets/icons/debit.png',
      },
      {
        'name': languagesController.tr("PROFIT"),
        'icon': 'assets/icons/profit2.png',
      },
      {
        'name': languagesController.tr("SALE"),
        'icon': 'assets/icons/profit2.png',
      },
      {
        'name': languagesController.tr("COMISSION"),
        'icon': 'assets/icons/profit2.png',
      },
    ];
  }

  final ScrollController scrollController = ScrollController();
  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    walletsController.fetchwalletsData();
    historyController.finalList.clear();
    historyController.initialpage = 1;
    historyController.fetchHistory();
    scrollController.addListener(refresh);
    companyController.fetchCompany();

    countrylistController.fetchCountryData();
    dashboardController.fetchDashboardData();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),

        // Android status bar icon white
        statusBarIconBrightness: Brightness.light,

        // iOS status bar text/icon white
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  final companyController = Get.find<CompanyController>();
  ConversationController conversationController = Get.put(
    ConversationController(),
  );
  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    conversationController.resetConversion();
    customRechargeController.amountController.clear();
    confirmPinController.numberController.clear();

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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
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
                        SizedBox(width: 10),
                        Obx(
                          () => dashboardController.isLoading.value == false
                              ? GestureDetector(
                                  onTap: () {
                                    // walletsController.fetchwalletsData();
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: dashboardController
                                            .alldashboardData
                                            .value
                                            .data!
                                            .userInfo!
                                            .resellerName
                                            .toString(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),

                                      // only for reseller...................
                                      Visibility(
                                        visible:
                                            dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data
                                                    ?.resellerGroup !=
                                                null &&
                                            dashboardController
                                                    .alldashboardData
                                                    .value
                                                    .data!
                                                    .resellerGroup !=
                                                "null",
                                        child: Text(
                                          dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data
                                                  ?.resellerGroup ??
                                              '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
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
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(() {
                        if (dashboardController.isLoading.value) {
                          return SizedBox(
                            height: 130,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final sliderList =
                            dashboardController
                                .alldashboardData
                                .value
                                .data
                                ?.advertisementSliders ??
                            [];

                        if (sliderList.isEmpty) {
                          return SizedBox(
                            height: 130,
                            child: Center(child: Text("هیچ تبلیغی موجود نیست")),
                          );
                        }

                        return CarouselSlider.builder(
                          itemCount: sliderList.length,
                          itemBuilder: (context, index, realIdx) {
                            final item = sliderList[index];
                            final imageUrl = item.adSliderImageUrl;

                            final ImageProvider imageProvider =
                                (imageUrl != null && imageUrl.isNotEmpty)
                                ? NetworkImage(imageUrl)
                                : const AssetImage(
                                        "assets/images/demoslider.png",
                                      )
                                      as ImageProvider;

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  /// Bottom gradient overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.10),
                                            Colors.black.withOpacity(0.72),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Slider title
                                  Positioned(
                                    left: 10,
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black.withOpacity(0.42),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.18),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.20,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 28,
                                            width: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xff00C6FF),
                                                  Color(0xff0072FF),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),

                                          Container(
                                            height: 28,
                                            width: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(
                                                0.14,
                                              ),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.18,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.campaign_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 8),

                                          Expanded(
                                            child: Text(
                                              item.advertisementTitle ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w700,
                                                height: 1.2,
                                                letterSpacing: 0.2,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                          options: CarouselOptions(
                            height: 135,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            enlargeCenterPage: true,
                            viewportFraction: 0.87,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10),

                    SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          /// Second Container: Selected wallet details
                          ///
                          SizedBox(height: 10),

                          /// Wallet selector container
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13),
                            child: Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      mypagecontroller.openSubPage(
                                        WalletScreen(),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/money.png",
                                          height: 60,
                                        ),
                                        SizedBox(width: 7),
                                        KText(
                                          text: languagesController.tr(
                                            "VIEW_WALLET",
                                          ),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Spacer(),
                                        Icon(
                                          box.read("language").toString() ==
                                                  "Fa"
                                              ? FontAwesomeIcons.chevronLeft
                                              : FontAwesomeIcons.chevronRight,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),

                                  SizedBox(height: 12),

                                  Obx(() {
                                    if (walletsController.isLoading.value) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      );
                                    }

                                    final wallets = walletsController.wallets;

                                    if (wallets.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          "No wallet found",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    }

                                    final selectedId =
                                        wallets.any(
                                          (wallet) =>
                                              wallet.walletId ==
                                              walletsController
                                                  .selectedWalletId
                                                  .value,
                                        )
                                        ? walletsController
                                              .selectedWalletId
                                              .value
                                        : null;

                                    return DropdownButtonFormField<int>(
                                      value: selectedId,
                                      isExpanded: true,
                                      hint: Text(
                                        languagesController.tr("SELECT_WALLET"),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      items: wallets.map((wallet) {
                                        return DropdownMenuItem<int>(
                                          value: wallet.walletId,
                                          child: Text(
                                            "${wallet.currency?.code ?? ''} (${wallet.currency?.symbol ?? ''})",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          walletsController.selectWallet(value);
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          /// Main dashboard container
                          /// All data from dashboard
                          /// Only balance from selected wallet if wallet selected
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
                                  if (dashboardController.isLoading.value) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final dashboardData = dashboardController
                                      .alldashboardData
                                      .value
                                      .data;

                                  if (dashboardData == null) {
                                    return SizedBox();
                                  }

                                  final selectedWallet =
                                      walletsController.selectedWallet;

                                  final bool hasSelectedWallet =
                                      selectedWallet != null;

                                  /// Balance logic:
                                  /// wallet thakle selected wallet balance + selected currency
                                  /// wallet na thakle dashboard balance + default currency
                                  final String balanceValue = hasSelectedWallet
                                      ? selectedWallet.balance?.toString() ??
                                            "0"
                                      : dashboardData.balance?.toString() ??
                                            "0";

                                  final String balanceCurrencySymbol =
                                      hasSelectedWallet
                                      ? selectedWallet.currency?.symbol ?? ""
                                      : box
                                                .read("currency_symbol")
                                                ?.toString() ??
                                            "";

                                  final String dashboardCurrencySymbol =
                                      box.read("currency_symbol")?.toString() ??
                                      "";

                                  return Column(
                                    children: [
                                      balanceBox2(
                                        "assets/icons/balance.png",
                                        languagesController.tr("BALANCE"),
                                        balanceValue,
                                        symbol: balanceCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/profit.png",
                                        languagesController.tr("PROFIT"),
                                        dashboardData.totalRevenue.toString(),
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/profit.png",
                                        languagesController.tr("TODAY_PROFIT"),
                                        dashboardData.todayProfit.toString(),
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/sale.png",
                                        languagesController.tr("SALE"),
                                        dashboardData.totalSoldAmount
                                            .toString(),
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/sale.png",
                                        languagesController.tr("TODAY_SALE"),
                                        dashboardData.todaySale.toString(),
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/loan_balance.png",
                                        languagesController.tr("LOAN_BALANCE"),
                                        dashboardData.loanBalance.toString(),
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/comission.png",
                                        languagesController.tr("COMISSION"),
                                        dashboardData.userInfo?.totalearning
                                                .toString() ??
                                            "0",
                                        symbol: dashboardCurrencySymbol,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          SizedBox(height: 8),
                          Obx(
                            () => historyController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                          Obx(
                            () => historyController.isLoading.value == false
                                ? Container(
                                    child:
                                        historyController
                                            .allorderlist
                                            .value
                                            .data!
                                            .orders
                                            .isNotEmpty
                                        ? SizedBox()
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/empty.png",
                                                  height: 80,
                                                ),
                                                Text("No Data found"),
                                              ],
                                            ),
                                          ),
                                  )
                                : SizedBox(),
                          ),
                          Container(
                            height: 400,
                            width: screenWidth,
                            child: Obx(
                              () =>
                                  historyController.isLoading.value == false &&
                                      historyController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: ListView.separated(
                                          padding: EdgeInsets.all(0.0),
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 5);
                                          },
                                          itemCount: historyController
                                              .finalList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = historyController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => OrderDetailsScreen(
                                                      createDate: data.createdAt
                                                          .toString(),
                                                      status: data.status
                                                          .toString(),
                                                      rejectReason: data
                                                          .rejectReason
                                                          .toString(),
                                                      companyName: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      bundleTitle: data
                                                          .bundle!
                                                          .bundleTitle!
                                                          .toString(),
                                                      rechargebleAccount: data
                                                          .rechargebleAccount!
                                                          .toString(),
                                                      validityType:
                                                          data
                                                              .bundle
                                                              ?.validityType
                                                              ?.toString() ??
                                                          "",
                                                      sellingPrice: data
                                                          .bundle!
                                                          .sellingPrice
                                                          .toString(),
                                                      orderID: data.id!
                                                          .toString(),
                                                      resellerName:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .contactName
                                                              .toString(),
                                                      resellerPhone:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .phone
                                                              .toString(),
                                                      companyLogo: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 60,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .listbuilderboxColor,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                locale: 'en_US',
                                                                symbol: '',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                double.parse(
                                                                  data
                                                                      .bundle!
                                                                      .sellingPrice
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " " +
                                                                  box.read(
                                                                    "currency_symbol",
                                                                  ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Icon(
                                                              //   Icons.check,
                                                              //   color: Colors.green,
                                                              //   size: 14,
                                                              // ),
                                                              Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   "2 days ago",
                                                              //   style: TextStyle(
                                                              //     color: Colors.green,
                                                              //     fontSize: 10,
                                                              //     fontWeight:
                                                              //         FontWeight.w600,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : historyController.finalList.isEmpty
                                  ? SizedBox()
                                  : RefreshIndicator(
                                      onRefresh: refresh,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: ListView.separated(
                                          padding: EdgeInsets.all(0.0),
                                          shrinkWrap: false,
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 5);
                                          },
                                          itemCount: historyController
                                              .finalList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final data = historyController
                                                .finalList[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => OrderDetailsScreen(
                                                      createDate: data.createdAt
                                                          .toString(),
                                                      status: data.status
                                                          .toString(),
                                                      rejectReason: data
                                                          .rejectReason
                                                          .toString(),
                                                      companyName: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      bundleTitle: data
                                                          .bundle!
                                                          .bundleTitle!
                                                          .toString(),
                                                      rechargebleAccount: data
                                                          .rechargebleAccount!
                                                          .toString(),
                                                      validityType:
                                                          data
                                                              .bundle
                                                              ?.validityType
                                                              ?.toString() ??
                                                          "",
                                                      sellingPrice: data
                                                          .bundle!
                                                          .sellingPrice
                                                          .toString(),
                                                      orderID: data.id!
                                                          .toString(),
                                                      resellerName:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .contactName
                                                              .toString(),
                                                      resellerPhone:
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .userInfo!
                                                              .phone
                                                              .toString(),
                                                      companyLogo: data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 60,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //   width: 1,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors
                                                      .listbuilderboxColor,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: CachedNetworkImageProvider(
                                                              data
                                                                  .bundle!
                                                                  .service!
                                                                  .company!
                                                                  .companyLogo
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 5,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  data
                                                                      .bundle!
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                data.rechargebleAccount
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              NumberFormat.currency(
                                                                locale: 'en_US',
                                                                symbol: '',
                                                                decimalDigits:
                                                                    2,
                                                              ).format(
                                                                double.parse(
                                                                  data
                                                                      .bundle!
                                                                      .sellingPrice
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              " " +
                                                                  box.read(
                                                                    "currency_symbol",
                                                                  ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Icon(
                                                              //   Icons.check,
                                                              //   color: Colors.green,
                                                              //   size: 14,
                                                              // ),
                                                              Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   "2 days ago",
                                                              //   style: TextStyle(
                                                              //     color: Colors.green,
                                                              //     fontSize: 10,
                                                              //     fontWeight:
                                                              //         FontWeight.w600,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  Widget dividerLine(double screenWidth) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(height: 1, width: screenWidth, color: Colors.grey.shade100),
        SizedBox(height: 10),
      ],
    );
  }

  Widget balanceBox2(
    String imagelink,
    String name,
    dynamic balance, {
    String? symbol,
  }) {
    final String cleanBalance = balance.toString().replaceAll(",", "").trim();

    final double amount = double.tryParse(cleanBalance) ?? 0.0;

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

        KText(
          text: symbol ?? box.read("currency_symbol")?.toString() ?? "",
          fontSize: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}

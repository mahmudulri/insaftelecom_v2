import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insaftelecom/screens/wallet_screen.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
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
import 'package:insaftelecom/screens/credit_transfer.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/custom_recharge_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/slider_controller.dart';
import '../global_controller/balance_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/order_details_screen.dart';
import 'service_screen.dart';
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

  LanguagesController languagesController = Get.put(LanguagesController());
  MyDrawerController drawerController = Get.put(MyDrawerController());

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

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
    // TODO: implement initState
    super.initState();
    historyController.finalList.clear();
    historyController.initialpage = 1;
    historyController.fetchHistory();
    scrollController.addListener(refresh);
    companyController.fetchCompany();

    countrylistController.fetchCountryData();
    dashboardController.fetchDashboardData();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
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
                              ? Column(
                                  children: [
                                    Column(
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
                                  ],
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
                                : AssetImage("assets/images/demoslider.png")
                                      as ImageProvider;

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    item.advertisementTitle ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 130,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 4),
                            enlargeCenterPage: true,
                            viewportFraction: 0.87,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: GestureDetector(
                        onTap: () {
                          // mypagecontroller.openSubPage(WalletScreen());
                          dashboardController.fetchDashboardData();
                        },
                        child: Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // optional, makes it modern
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.08,
                                ), // light shadow
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: Offset(0, 4), // shadow direction (x,y)
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Image.asset("assets/icons/money.png", height: 60),
                              SizedBox(width: 7),
                              KText(
                                text: languagesController.tr("VIEW_WALLET"),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Spacer(),
                              Icon(
                                box.read("language").toString() == "Fa"
                                    ? FontAwesomeIcons.chevronLeft
                                    : FontAwesomeIcons.chevronRight,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
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
                              color: Colors.black.withOpacity(
                                0.08,
                              ), // light shadow
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                      SizedBox(height: 6),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Colors.grey.shade100,
                                      ),
                                      SizedBox(height: 6),
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.separated(
                                    padding: EdgeInsets.all(0.0),
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 5);
                                    },
                                    itemCount:
                                        historyController.finalList.length,
                                    itemBuilder: (context, index) {
                                      final data =
                                          historyController.finalList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsScreen(
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color:
                                                AppColors.listbuilderboxColor,
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
                                                      image:
                                                          CachedNetworkImageProvider(
                                                            data
                                                                .bundle!
                                                                .service!
                                                                .company!
                                                                .companyLogo
                                                                .toString(),
                                                          ),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
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
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
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
                                                          decimalDigits: 2,
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
                                                              FontWeight.w600,
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
                                                              FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Colors.grey,
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
                                                              ? languagesController
                                                                    .tr(
                                                                      "PENDING",
                                                                    )
                                                              : data.status
                                                                        .toString() ==
                                                                    "1"
                                                              ? languagesController
                                                                    .tr(
                                                                      "CONFIRMED",
                                                                    )
                                                              : languagesController
                                                                    .tr(
                                                                      "REJECTED",
                                                                    ),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.separated(
                                    padding: EdgeInsets.all(0.0),
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 5);
                                    },
                                    itemCount:
                                        historyController.finalList.length,
                                    itemBuilder: (context, index) {
                                      final data =
                                          historyController.finalList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsScreen(
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color:
                                                AppColors.listbuilderboxColor,
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
                                                      image:
                                                          CachedNetworkImageProvider(
                                                            data
                                                                .bundle!
                                                                .service!
                                                                .company!
                                                                .companyLogo
                                                                .toString(),
                                                          ),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
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
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
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
                                                          decimalDigits: 2,
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
                                                              FontWeight.w600,
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
                                                              FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Colors.grey,
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
                                                              ? languagesController
                                                                    .tr(
                                                                      "PENDING",
                                                                    )
                                                              : data.status
                                                                        .toString() ==
                                                                    "1"
                                                              ? languagesController
                                                                    .tr(
                                                                      "CONFIRMED",
                                                                    )
                                                              : languagesController
                                                                    .tr(
                                                                      "REJECTED",
                                                                    ),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
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
          text: box.read("currency_symbol"),
          fontSize: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}

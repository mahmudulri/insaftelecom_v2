import 'dart:async';
import 'package:insaftelecom/controllers/notifications_controller.dart';
import 'package:insaftelecom/pages/notification_details_page.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
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
import '../global_controller/balance_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/order_details_screen.dart';
import '../utils/colors.dart';
import '../widgets/drawer.dart';
import 'all_notifications_page.dart';

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

  // Local display selection: each dashboard load starts at activeWallet.
  final RxnString _selectedDashboardWalletKey = RxnString();
  late final Worker _dashboardLoadingWorker;

  final historyController = Get.find<HistoryController>();

  final NotificationController notificationController =
      Get.isRegistered<NotificationController>()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController());

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

  Future<void> _checkforUpdate() async {
    print("checking");
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              print("update available");
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    print("Updating");
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      print(error.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _checkforUpdate();
    notificationController.fetchData();

    scrollController.addListener(refresh);
    _dashboardLoadingWorker = ever<bool>(dashboardController.isLoading, (
      loading,
    ) {
      if (loading) _selectedDashboardWalletKey.value = null;
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      notificationController.fetchData();

      historyController.finalList.clear();
      historyController.initialpage = 1;
      historyController.fetchHistory();

      companyController.fetchCompany();
      countrylistController.fetchCountryData();
      dashboardController.fetchDashboardData();
    });
  }

  @override
  void dispose() {
    _dashboardLoadingWorker.dispose();
    scrollController.removeListener(refresh);
    scrollController.dispose();
    super.dispose();
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
                                    // Keep the existing profile tap behavior.
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text:
                                            dashboardController
                                                .alldashboardData
                                                .value
                                                .data
                                                ?.userInfo
                                                ?.resellerName
                                                ?.toString() ??
                                            '',
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
                        Obx(() {
                          final unreadCount =
                              notificationController.unreadlength.value;

                          return GestureDetector(
                            onTap: () {
                              showNotificationPopup(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 29,
                                  ),

                                  if (unreadCount > 0)
                                    Positioned(
                                      right: -7,
                                      top: -7,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 19,
                                          minHeight: 19,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          unreadCount > 99
                                              ? '99+'
                                              : unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(() {
                        if (dashboardController.isLoading.value) {
                          return const SizedBox(
                            height: 205,
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
                          return const SizedBox(
                            height: 130,
                            child: Center(child: Text("هیچ تبلیغی موجود نیست")),
                          );
                        }

                        return CarouselSlider.builder(
                          itemCount: sliderList.length,
                          itemBuilder: (context, index, realIdx) {
                            final item = sliderList[index];
                            final imageUrl = item.adSliderImageUrl;
                            final title = (item.advertisementTitle ?? '')
                                .trim();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                      ),
                                      child:
                                          imageUrl != null &&
                                              imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Image.asset(
                                                      "assets/images/demoslider.png",
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                            )
                                          : Image.asset(
                                              "assets/images/demoslider.png",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),

                                if (title.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14),
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFE3EBFA),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE5EEFF),
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.campaign_rounded,
                                            color: Color(0xFF0072FF),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final textStyle =
                                                  DefaultTextStyle.of(
                                                    context,
                                                  ).style.merge(
                                                    const TextStyle(
                                                      color: Color(0xFF171717),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.3,
                                                    ),
                                                  );

                                              final textPainter =
                                                  TextPainter(
                                                    text: TextSpan(
                                                      text: title,
                                                      style: textStyle,
                                                    ),
                                                    maxLines: 2,
                                                    ellipsis: '…',
                                                    textDirection:
                                                        Directionality.of(
                                                          context,
                                                        ),
                                                    textScaler:
                                                        MediaQuery.textScalerOf(
                                                          context,
                                                        ),
                                                    locale:
                                                        Localizations.maybeLocaleOf(
                                                          context,
                                                        ),
                                                  )..layout(
                                                    maxWidth:
                                                        constraints.maxWidth,
                                                  );

                                              final showMore =
                                                  textPainter.didExceedMaxLines;
                                              textPainter.dispose();

                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textStyle,
                                                  ),
                                                  if (showMore)
                                                    InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                      onTap: () {
                                                        showDialog<void>(
                                                          context: context,
                                                          builder: (dialogContext) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                              ),
                                                              title: const Icon(
                                                                Icons
                                                                    .campaign_rounded,
                                                                color: Color(
                                                                  0xFF0072FF,
                                                                ),
                                                                size: 30,
                                                              ),
                                                              content: SingleChildScrollView(
                                                                child: SelectableText(
                                                                  title,
                                                                  style: const TextStyle(
                                                                    color: Color(
                                                                      0xFF171717,
                                                                    ),
                                                                    fontSize:
                                                                        14,
                                                                    height: 1.6,
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                      dialogContext,
                                                                    ).pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                        "Close",
                                                                      ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 5,
                                                            ),
                                                        child: Text(
                                                          "Show more",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF0072FF,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                          options: CarouselOptions(
                            height: 205,
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
                                    if (dashboardController.isLoading.value) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      );
                                    }

                                    final dashboardData = dashboardController
                                        .alldashboardData
                                        .value
                                        .data;
                                    final activeWallet =
                                        dashboardData?.activeWallet;
                                    final wallets = [
                                      ...?dashboardData?.wallets,
                                    ];
                                    // Include an active wallet omitted from the list.
                                    if (activeWallet != null &&
                                        !wallets.any(
                                          (wallet) =>
                                              (wallet.walletId?.toString() ??
                                                  wallet.currency?.code) ==
                                              (activeWallet.walletId
                                                      ?.toString() ??
                                                  activeWallet.currency?.code),
                                        )) {
                                      wallets.add(activeWallet);
                                    }
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

                                    final selectedKey =
                                        _selectedDashboardWalletKey.value;
                                    final selectedIndex = wallets.indexWhere(
                                      (wallet) =>
                                          selectedKey != null &&
                                          (wallet.walletId?.toString() ??
                                                  wallet.currency?.code) ==
                                              selectedKey,
                                    );
                                    final selectedWallet = selectedIndex >= 0
                                        ? wallets[selectedIndex]
                                        : activeWallet;
                                    final displayIndex = selectedWallet == null
                                        ? -1
                                        : wallets.indexWhere(
                                            (wallet) =>
                                                (wallet.walletId?.toString() ??
                                                    wallet.currency?.code) ==
                                                (selectedWallet.walletId
                                                        ?.toString() ??
                                                    selectedWallet
                                                        .currency
                                                        ?.code),
                                          );
                                    final int? selectedId = displayIndex < 0
                                        ? null
                                        : displayIndex;

                                    return DropdownButtonFormField<int>(
                                      key: ValueKey(
                                        'dashboard-wallet-$selectedId',
                                      ),
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
                                      items: wallets.asMap().entries.map((
                                        entry,
                                      ) {
                                        final wallet = entry.value;
                                        return DropdownMenuItem<int>(
                                          value: entry.key,
                                          child: Text(
                                            wallet.currency?.code ?? "",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          final wallet = wallets[value];
                                          _selectedDashboardWalletKey.value =
                                              wallet.walletId?.toString() ??
                                              wallet.currency?.code;
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
                          /// All amounts come from the displayed dashboard wallet.
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

                                  final selectedKey =
                                      _selectedDashboardWalletKey.value;
                                  final wallets = dashboardData.wallets ?? [];
                                  final selectedIndex = wallets.indexWhere(
                                    (wallet) =>
                                        selectedKey != null &&
                                        (wallet.walletId?.toString() ??
                                                wallet.currency?.code) ==
                                            selectedKey,
                                  );
                                  final selectedWallet = selectedIndex >= 0
                                      ? wallets[selectedIndex]
                                      : dashboardData.activeWallet;
                                  final report = selectedWallet?.report;
                                  final String balanceCurrencySymbol =
                                      selectedWallet?.currency?.symbol ??
                                      selectedWallet?.currency?.code ??
                                      "";
                                  final String dashboardCurrencySymbol =
                                      report?.reportingCurrency?.symbol ??
                                      report?.reportingCurrency?.code ??
                                      balanceCurrencySymbol;
                                  final String balanceValue =
                                      selectedWallet?.balance ?? "0";

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
                                        report?.totalProfit ?? "0",
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/profit.png",
                                        languagesController.tr("TODAY_PROFIT"),
                                        report?.todayProfit ?? "0",
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/sale.png",
                                        languagesController.tr("SALE"),
                                        report?.totalSale ?? "0",
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/sale.png",
                                        languagesController.tr("TODAY_SALE"),
                                        report?.todaySale ?? "0",
                                        symbol: dashboardCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/loan_balance.png",
                                        languagesController.tr("LOAN_BALANCE"),
                                        selectedWallet?.outstandingLoan ?? "0",
                                        symbol: balanceCurrencySymbol,
                                      ),

                                      dividerLine(screenWidth),

                                      balanceBox2(
                                        "assets/icons/comission.png",
                                        languagesController.tr("COMISSION"),
                                        selectedWallet?.earningBalance ?? "0",
                                        symbol: balanceCurrencySymbol,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          _buildHistoryContainer(context, screenWidth),

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

  void showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return Dialog(
          alignment: Alignment.topRight,
          insetPadding: const EdgeInsets.only(
            top: 70,
            right: 15,
            left: 25,
            bottom: 30,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxHeight: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Obx(() {
              final isLoading = notificationController.isLoading.value;

              final notifications =
                  notificationController
                      .allnotificationlist
                      .value
                      .data
                      ?.notifications ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            languagesController.tr("NOTIFICATIONS"),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

                  if (isLoading)
                    const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (notifications.isEmpty)
                    SizedBox(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 55,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            languagesController.tr("NO_NOTIFICATIONS"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,

                        // Popup-এ শুধু latest 10 notifications দেখাবে
                        itemCount: notifications.length > 10
                            ? 10
                            : notifications.length,

                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            color: Colors.grey.shade200,
                          );
                        },

                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return InkWell(
                            onTap: () async {
                              Get.back();

                              await Get.to(
                                () => NotificationDetailsPage(
                                  notification: notification,
                                ),
                              );

                              await notificationController.fetchData();
                            },
                            child: Container(
                              color: notification.isRead == false
                                  ? AppColors.primaryColor.withOpacity(0.05)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 13,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 43,
                                        width: 43,
                                        decoration: BoxDecoration(
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                                    .withOpacity(0.13)
                                              : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          size: 21,
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                              : Colors.grey,
                                        ),
                                      ),

                                      if (notification.isRead == false)
                                        Positioned(
                                          right: 1,
                                          top: 1,
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                notification.isRead == false
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          notification.message ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.4,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          notification.createdAt == null
                                              ? ""
                                              : DateFormat(
                                                  "dd MMM yyyy, hh:mm a",
                                                ).format(
                                                  notification.createdAt!
                                                      .toLocal(),
                                                ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();

                          await Get.to(() => const AllNotificationsPage());

                          await notificationController.fetchData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          languagesController.tr("VIEW_ALL"),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildHistoryContainer(BuildContext context, double screenWidth) {
    return Container(
      height: 400,
      width: screenWidth,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EBFA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              color: AppColors.primaryColor.withOpacity(0.05),
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KText(
                      text: languagesController.tr("HISTORY"),
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE3EBFA)),
            Expanded(
              child: Obx(() {
                final isLoading = historyController.isLoading.value;
                final isEmpty = historyController.finalList.isEmpty;

                if (isEmpty) {
                  if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.04),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/icons/empty.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            languagesController.tr("NO_DATA_FOUND"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 3,
                      child: isLoading
                          ? LinearProgressIndicator(
                              color: AppColors.primaryColor,
                              backgroundColor: AppColors.primaryColor
                                  .withOpacity(0.08),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 9),
                    Expanded(child: _buildOrderList(context, screenWidth)),
                    const SizedBox(height: 12),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, double screenWidth) {
    return RefreshIndicator(
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
          itemCount: historyController.finalList.length,
          itemBuilder: (context, index) {
            final data = historyController.finalList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(
                      createDate: data.createdAt.toString(),
                      status: data.status.toString(),
                      rejectReason: data.rejectReason.toString(),
                      companyName: data.bundle!.service!.company!.companyName
                          .toString(),
                      bundleTitle: data.bundle!.bundleTitle!.toString(),
                      rechargebleAccount: data.rechargebleAccount!.toString(),
                      validityType: data.bundle?.validityType?.toString() ?? "",
                      sellingPrice: data.bundle!.sellingPrice.toString(),
                      orderID: data.id!.toString(),
                      resellerName: dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .contactName
                          .toString(),
                      resellerPhone: dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .phone
                          .toString(),
                      companyLogo: data.bundle!.service!.company!.companyLogo
                          .toString(),
                      currencyCode: data.chargedCurrency!.code.toString(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 64,
                width: screenWidth,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.listbuilderboxColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =========================
                    // COMPANY LOGO
                    // =========================
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            data.bundle!.service!.company!.companyLogo
                                .toString(),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // =========================
                    // BUNDLE TITLE + ACCOUNT
                    // =========================
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.bundle!.bundleTitle.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            data.rechargebleAccount.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: NText(
                              text: data.bundle!.sellingPrice.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(width: 5),

                          // =========================
                          // CURRENCY BADGE
                          // =========================
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.15),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              data.chargedCurrency!.code.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 10,
                                height: 1,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    // =========================
                    // STATUS
                    // =========================
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          data.status.toString() == "0"
                              ? languagesController.tr("PENDING")
                              : data.status.toString() == "1"
                              ? languagesController.tr("CONFIRMED")
                              : languagesController.tr("REJECTED"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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

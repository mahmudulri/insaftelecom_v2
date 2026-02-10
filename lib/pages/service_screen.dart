import 'package:insaftelecom/controllers/currency_controller.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/custom_history_controller.dart';
import 'package:insaftelecom/controllers/custom_recharge_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/pages/homepages.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/button_one.dart';

import '../controllers/bundle_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/default_button1.dart';
import '../screens/country_selection.dart';
import '../screens/credit_transfer.dart';
import '../screens/social_bundles.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final customhistoryController = Get.find<CustomHistoryController>();

  final countryListController = Get.find<CountryListController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  CurrencyController currencyController = Get.put(CurrencyController());
  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );
  final box = GetStorage();
  int selectedIndex = 0;

  final FocusNode _focusNode = FocusNode();

  RxList<bool> expandedIndices = <bool>[].obs;

  final ScrollController scrollController = ScrollController();

  final dashboardController = Get.find<DashboardController>();
  final companyController = Get.find<CompanyController>();

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  Future<void> refresh() async {
    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

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
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyController.fetchCurrencyList();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );

    customRechargeController.numberController.addListener(() {
      final text = customRechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });

    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    customhistoryController.fetchHistory();
    scrollController.addListener(refresh);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final bundleController = Get.find<BundleController>();
  final categorisListController = Get.find<CategorisListController>();

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  List serviceimages = [
    "assets/images/cat1.png",
    "assets/images/cat2.png",
    "assets/images/cat3.png",
    "assets/images/cat4.png",
  ];

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
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
                          text: languagesController.tr("PRODUCTS"),
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: DefaultButton1(
                height: 45,
                width: screenWidth,
                buttonName: languagesController.tr("CREDIT_TRANSFER"),
                onpressed: () {
                  if (countrylistController.finalCountryList.isNotEmpty) {
                    // Find the country where the name is "Afghanistan"
                    var afghanistan = countrylistController.finalCountryList
                        .firstWhere(
                          (country) => country['country_name'] == "Afghanistan",
                          orElse: () => null, // Return null if not found
                        );

                    if (afghanistan != null) {
                      print("The ID for Afghanistan is: ${afghanistan['id']}");
                      box.write("country_id", "${afghanistan['id']}");
                      box.write("maxlength", "10");
                    } else {
                      print("Afghanistan not found in the list");
                    }
                  } else {
                    print("Country list is empty.");
                  }
                  mypagecontroller.openSubPage(CreditTransfer());
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 600,
                width: screenWidth,
                child: Obx(() {
                  if (categorisListController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categories = categorisListController
                      .allcategorieslist
                      .value
                      .data!
                      .servicecategories!;

                  // Responsive columns: 2 on phones, 3 on medium, 4 on wide
                  final crossAxisCount = screenWidth > 900
                      ? 4
                      : screenWidth > 600
                      ? 3
                      : 2;

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // Tweak for taller or shorter cards
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      final data = categories[index];

                      return GestureDetector(
                        onTap: () {
                          box.write("service_category_id", data.id);

                          if (data.type.toString() == "nonsocial") {
                            mypagecontroller.openSubPage(InternetPack());
                          } else {
                            box.write("validity_type", "");
                            box.write("search_tag", "");
                            box.write("service_category_id", data.id);
                            box.write("country_id", "");
                            box.write("company_id", "");
                            bundleController.finalList.clear();
                            bundleController.initialpage = 1;

                            mypagecontroller.openSubPage(SocialBundles());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFEAEAEA),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon / Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 48,
                                    width: 48,
                                    child: Image.network(
                                      data.categoryImageUrl.toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Title
                                Flexible(
                                  child: KText(
                                    text: data.categoryName.toString(),
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    textAlign: TextAlign.center,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Subtle forward chevron
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: const Color(0xff919EAB),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

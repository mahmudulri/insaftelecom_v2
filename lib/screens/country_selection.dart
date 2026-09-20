import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/controllers/service_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/models/country_list_model.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  const InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final BundleController bundleController = Get.put(BundleController());

  final ServiceController serviceController = Get.put(ServiceController());

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  final GetStorage box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    /// Load countries
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countrylistController.fetchCountryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerWidget(),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
          child: Column(
            children: [
              /// ============================================================
              /// HEADER
              /// ============================================================
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    /// Back Button
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
                        child: const Center(
                          child: Icon(FontAwesomeIcons.chevronLeft),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Title
                    Expanded(
                      child: Center(
                        child: Obx(
                          () => Text(
                            languagesController.tr("COUNTRY_SELECTION"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Drawer Button
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
                        child: const Center(
                          child: Icon(Icons.menu, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// ============================================================
              /// COUNTRY SECTION
              /// ============================================================
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Obx(() {
                        /// ===============================================
                        /// LOADING
                        /// ===============================================
                        if (countrylistController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        /// ===============================================
                        /// EMPTY COUNTRY LIST
                        /// ===============================================
                        if (countrylistController.finalCountryList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.public_off,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "No countries found",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    countrylistController.fetchCountryData();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Retry",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            /// ===========================================
                            /// TITLE
                            /// ===========================================
                            Row(
                              children: [
                                Flexible(
                                  child: Obx(
                                    () => Text(
                                      languagesController.tr("RESERVE_FOR"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff8082ED),
                                        fontFamily:
                                            languagesController.selectedlan ==
                                                "Fa"
                                            ? "Iranfont"
                                            : "Roboto",
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// ===========================================
                            /// COUNTRY GRID
                            /// ===========================================
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 1.2,
                                    ),
                                itemCount: countrylistController
                                    .finalCountryList
                                    .length,
                                itemBuilder: (context, index) {
                                  /// =====================================
                                  /// CURRENT COUNTRY MODEL
                                  /// =====================================
                                  final Country selectedCountry =
                                      countrylistController
                                          .finalCountryList[index];

                                  final bool enableOperatorLookup =
                                      selectedCountry.enableOperatorLookup;

                                  final String countryName =
                                      selectedCountry.countryName ?? '';

                                  final String flagUrl =
                                      selectedCountry.countryFlagImageUrl ?? '';

                                  return GestureDetector(
                                    onTap: () {
                                      /// =================================
                                      /// STORE COUNTRY
                                      /// =================================
                                      box.write(
                                        "country_id",
                                        selectedCountry.id,
                                      );

                                      box.write("countryName", countryName);

                                      box.write(
                                        "maxlength",
                                        selectedCountry.phoneNumberLength ?? "",
                                      );

                                      /// =================================
                                      /// IMPORTANT:
                                      /// STORE OPERATOR LOOKUP
                                      /// =================================
                                      box.write(
                                        "enable_operator_lookup",
                                        enableOperatorLookup,
                                      );

                                      /// =================================
                                      /// RESET FILTER DATA
                                      /// =================================
                                      box.write("validity_type", "");

                                      box.write("company_id", "");

                                      box.write("search_tag", "");

                                      serviceController.reserveDigit.clear();

                                      bundleController.initialpage = 1;

                                      bundleController.finalList.clear();

                                      /// =================================
                                      /// DEBUG
                                      /// =================================
                                      debugPrint(
                                        "========================================",
                                      );

                                      debugPrint(
                                        "Selected Country: $countryName",
                                      );

                                      debugPrint(
                                        "Country ID: ${selectedCountry.id}",
                                      );

                                      debugPrint(
                                        "Phone Length: ${selectedCountry.phoneNumberLength}",
                                      );

                                      debugPrint(
                                        "Enable Operator Lookup: $enableOperatorLookup",
                                      );

                                      debugPrint(
                                        "Stored Lookup: ${box.read("enable_operator_lookup")}",
                                      );

                                      debugPrint(
                                        "========================================",
                                      );

                                      mypagecontroller.openSubPage(
                                        RechargeScreen(
                                          enableOperatorLookup:
                                              enableOperatorLookup,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffEEF4FF),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            /// =============================
                                            /// FLAG
                                            /// =============================
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              backgroundImage:
                                                  flagUrl.isNotEmpty
                                                  ? NetworkImage(flagUrl)
                                                  : null,
                                              child: flagUrl.isEmpty
                                                  ? Icon(
                                                      Icons.public,
                                                      color:
                                                          Colors.grey.shade500,
                                                      size: 30,
                                                    )
                                                  : null,
                                            ),

                                            const SizedBox(height: 5),

                                            /// =============================
                                            /// COUNTRY NAME
                                            /// =============================
                                            Flexible(
                                              child: Text(
                                                countryName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize:
                                                      screenHeight * 0.020,
                                                  fontWeight: FontWeight.w500,
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
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

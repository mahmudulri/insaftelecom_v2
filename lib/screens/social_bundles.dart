import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/pages/homepages.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/confirm_pin_controller.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/service_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/helpers/price.dart';
import 'package:insaftelecom/utils/colors.dart';

import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import 'country_selection.dart';

class SocialBundles extends StatefulWidget {
  SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  // final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  int selectedIndex = -1;
  int duration_selectedIndex = -1;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    bundleController.finalList.clear();
    bundleController.initialpage = 1;
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

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
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  List countryCode = ["+93", "+880", "+91"];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                          () => KText(
                            text:
                                "${languagesController.tr("COMMUNICATION_PACKAGES")}",
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => KText(
                                text: languagesController.tr(
                                  "PACKAGE_SELECTION",
                                ),
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8082ED),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.search_sharp,
                                  color: Colors.grey,
                                  size: screenHeight * 0.040,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Obx(
                                    () => TextField(
                                      style: TextStyle(
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: languagesController.tr(
                                          "SEARCH_PACKAGE_NAME",
                                        ),
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: screenWidth * 0.040,
                                          fontFamily:
                                              box.read("language").toString() ==
                                                  "Fa"
                                              ? Get.find<FontController>()
                                                    .currentFont
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          width: screenWidth,
                          child: Obx(() {
                            // Check if the allserviceslist is not null and contains data
                            final services =
                                serviceController
                                    .allserviceslist
                                    .value
                                    .data
                                    ?.services ??
                                [];

                            // Show all services if input is empty, otherwise filter
                            final filteredServices = inputNumber.isEmpty
                                ? services
                                : services.where((service) {
                                    return service.company?.companycodes?.any((
                                          code,
                                        ) {
                                          final reservedDigit =
                                              code.reservedDigit ?? '';
                                          return inputNumber.startsWith(
                                            reservedDigit,
                                          );
                                        }) ??
                                        false;
                                  }).toList();

                            return serviceController.isLoading.value == false
                                ? Center(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(width: 5);
                                      },
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filteredServices.length,
                                      itemBuilder: (context, index) {
                                        final data = filteredServices[index];

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              bundleController.initialpage = 1;
                                              bundleController.finalList
                                                  .clear();
                                              selectedIndex = index;
                                              box.write(
                                                "company_id",
                                                data.companyId,
                                              );
                                              bundleController
                                                  .fetchallbundles();
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == index
                                                  ? Color(0xff34495e)
                                                  : Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    data.company?.companyLogo ??
                                                    '',
                                                placeholder: (context, url) {
                                                  print('Loading image: $url');
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  );
                                                },
                                                errorWidget: (context, url, error) {
                                                  print(
                                                    'Error loading image: $url, error: $error',
                                                  );
                                                  return Icon(Icons.error);
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 1.0,
                                    ),
                                  );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    width: screenWidth,
                    // decoration: BoxDecoration(
                    //   color: AppColors.secondaryColor,
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.withOpacity(0.2),
                    //       spreadRadius: 2,
                    //       blurRadius: 2,
                    //       offset: Offset(0, 0),
                    //     ),
                    //   ],
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Obx(
                              () =>
                                  bundleController.isLoading.value == false &&
                                      bundleController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 2);
                                        },
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        itemCount:
                                            bundleController.finalList.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              bundleController.finalList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              box.write(
                                                "bundleID",
                                                data.id.toString(),
                                              );
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            17,
                                                          ),
                                                    ),
                                                    content: SocialdialogBox(
                                                      companyname: data
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      title: data.bundleTitle,
                                                      validity:
                                                          data.validityType,
                                                      buyingprice:
                                                          data.buyingPrice,
                                                      sellingprice:
                                                          data.sellingPrice,
                                                      imagelink: data
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 3,
                                              ),
                                              child: Container(
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Image.network(
                                                        data
                                                            .service!
                                                            .company!
                                                            .companyLogo
                                                            .toString(),
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 3,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                KText(
                                                                  text: data
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                KText(
                                                                  text: data
                                                                      .service!
                                                                      .company!
                                                                      .companyName
                                                                      .toString(),
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Obx(
                                                                  () => KText(
                                                                    text: languagesController
                                                                        .tr(
                                                                          "SALE",
                                                                        ),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " : ",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                PriceTextView(
                                                                  price: data
                                                                      .sellingPrice
                                                                      .toString(),
                                                                  textStyle: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green,
                                                                    fontFamily:
                                                                        box
                                                                                .read(
                                                                                  "language",
                                                                                )
                                                                                .toString() ==
                                                                            "Fa"
                                                                        ? Get.find<
                                                                                FontController
                                                                              >()
                                                                              .currentFont
                                                                        : null,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  " ${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Obx(
                                                                () => KText(
                                                                  text: languagesController
                                                                      .tr(
                                                                        "BUY",
                                                                      ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              PriceTextView(
                                                                price: data
                                                                    .buyingPrice
                                                                    .toString(),
                                                                textStyle: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? Get.find<
                                                                              FontController
                                                                            >()
                                                                            .currentFont
                                                                      : null,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : bundleController.finalList.isEmpty
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: refresh,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 2);
                                        },
                                        padding: EdgeInsets.all(0),
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        itemCount:
                                            bundleController.finalList.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              bundleController.finalList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              box.write(
                                                "bundleID",
                                                data.id.toString(),
                                              );
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            17,
                                                          ),
                                                    ),
                                                    content: SocialdialogBox(
                                                      companyname: data
                                                          .service!
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      title: data.bundleTitle,
                                                      validity:
                                                          data.validityType,
                                                      buyingprice:
                                                          data.buyingPrice,
                                                      sellingprice:
                                                          data.sellingPrice,
                                                      imagelink: data
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 3,
                                              ),
                                              child: Container(
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Image.network(
                                                        data
                                                            .service!
                                                            .company!
                                                            .companyLogo
                                                            .toString(),
                                                        height: 60,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 3,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                KText(
                                                                  text: data
                                                                      .bundleTitle
                                                                      .toString(),
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                KText(
                                                                  text: data
                                                                      .service!
                                                                      .company!
                                                                      .companyName
                                                                      .toString(),
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 15,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Obx(
                                                                  () => KText(
                                                                    text: languagesController
                                                                        .tr(
                                                                          "SALE",
                                                                        ),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " : ",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                PriceTextView(
                                                                  price: data
                                                                      .sellingPrice
                                                                      .toString(),
                                                                  textStyle: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green,
                                                                    fontFamily:
                                                                        box
                                                                                .read(
                                                                                  "language",
                                                                                )
                                                                                .toString() ==
                                                                            "Fa"
                                                                        ? Get.find<
                                                                                FontController
                                                                              >()
                                                                              .currentFont
                                                                        : null,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                  " ${box.read("currency_code")}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Obx(
                                                                () => KText(
                                                                  text: languagesController
                                                                      .tr(
                                                                        "BUY",
                                                                      ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Text(
                                                                " : ",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              PriceTextView(
                                                                price: data
                                                                    .buyingPrice
                                                                    .toString(),
                                                                textStyle: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .red,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? Get.find<
                                                                              FontController
                                                                            >()
                                                                            .currentFont
                                                                      : null,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          Obx(
                            () => bundleController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  String? companyname;
  String? title;
  String? validity;
  String? buyingprice;
  String? sellingprice;
  String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  String selectedCode = "+93";

  final countrylistController = Get.find<CountryListController>();

  final confirmPinController = Get.find<ConfirmPinController>();

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 520,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Obx(
        () => confirmPinController.isLoading.value == false
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,

                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1890FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Company Logo
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                widget.imagelink.toString(),
                                height: 60,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Company Name
                            Text(
                              widget.companyname.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 5),

                            // Bundle Title
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languagesController.tr("BUNDLE_TITLE"),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.title.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),

                            // Pricing Info
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Color(0xff1890FF),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("BUY"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.buyingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 5,
                                    color: Colors.grey.shade200,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sell_outlined,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("SALE"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.sellingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // ID Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: Color(0xff1890FF),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller:
                                    confirmPinController.numberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languagesController.tr("ENTER_ID"),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    // PIN Input
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1.5,
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              maxLength: 4,
                              controller: confirmPinController.pinController,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: languagesController.tr("PIN"),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              if (confirmPinController
                                  .numberController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_ID"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              if (confirmPinController
                                  .pinController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_YOUR_PIN"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              print("ready for recharge...");
                              confirmPinController.placeOrder(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    languagesController.tr("CONFIRMATION"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    languagesController.tr("CANCEL"),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: Container(
                  height: 250,
                  width: 250,
                  child: Lottie.asset('assets/loties/recharge.json'),
                ),
              ),
      ),
    );
  }
}

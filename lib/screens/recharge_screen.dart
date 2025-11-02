import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/screens/result_screen.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/confirm_pin_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/price.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insaftelecom/widgets/number_textfield.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../widgets/custom_text.dart';
import 'country_selection.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},
      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languagesController.tr("DAILY"), "Value": "daily"},
      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];

  String search = "";
  String inputNumber = "";

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
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

  void _onTextChanged() {
    if (!mounted) return;

    setState(() {
      inputNumber = confirmPinController.numberController.text;

      // Print debug information
      print("Input Number: $inputNumber");

      if (inputNumber.isEmpty) {
        box.write("company_id", "");
        bundleController.initialpage = 1;
        bundleController.finalList.clear();
        bundleController.fetchallbundles();
        // Handle case where text field is cleared
        print("Text field is empty. Showing all services.");

        // Clear the company_id from the box

        // Reset bundleController and fetch all bundles
      } else if (inputNumber.length == 3 || inputNumber.length == 4) {
        final services = serviceController.allserviceslist.value.data!.services;

        // Print number of services for debugging
        print("Number of services: ${services.length}");

        bool matchFound = false;

        for (var service in services) {
          for (var code in service.company!.companycodes!) {
            // Print reservedDigit for debugging
            print("Checking reservedDigit: ${code.reservedDigit}");

            if (code.reservedDigit == inputNumber) {
              box.write("company_id", service.companyId);
              bundleController.initialpage = 1;
              bundleController.finalList.clear();
              setState(() {
                bundleController.fetchallbundles();
              });

              print("Matched company_id: ${service.companyId}");
              matchFound = true;
              break; // Exit the inner loop
            }
          }
          if (matchFound) break; // Exit the outer loop
        }

        if (!matchFound) {
          print("No match found for input number: $inputNumber");
        }
      }
    });
  }

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
    confirmPinController.numberController.clear();

    bundleController.initialpage = 1;
    serviceController.fetchservices();
    bundleController.fetchallbundles();

    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();

    scrollController.addListener(refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
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
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            mypagecontroller.changePage(
                              InternetPack(),
                              isMainPage: false,
                            );
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
                                " ${box.read("countryName")} ${languagesController.tr("INTERNET_PACKAGE")}",
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.040,
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: screenWidth,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Obx(
                          () => CustomTextField(
                            confirmPinController:
                                confirmPinController.numberController,
                            languageData: languagesController.tr(
                              "ENTER_PHONE_NUMBER",
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
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
                                            width: 50,
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
                        SizedBox(height: 15),
                        SizedBox(
                          height: 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: duration.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    duration_selectedIndex = index;
                                    box.write(
                                      "validity_type",
                                      duration[index]["Value"],
                                    );
                                    bundleController.initialpage = 1;
                                    bundleController.finalList.clear();
                                    bundleController.fetchallbundles();
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: duration_selectedIndex == index
                                          ? Color(0xff57C3E7).withOpacity(0.4)
                                          : Color(0xff57C3E7).withOpacity(0.4),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    color: duration_selectedIndex == index
                                        ? Color(0xff57C3E7)
                                        : Colors.white.withOpacity(0.30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                      child: KText(
                                        text: languagesController.tr(
                                          duration[index]["Name"]!,
                                        ),
                                        fontSize: screenWidth * 0.030,
                                        color: duration_selectedIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Padding(
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
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Obx(
                        () =>
                            bundleController.isLoading.value == false &&
                                bundleController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          print(data.id.toString());
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          17,
                                                        ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                17,
                                                              ),
                                                          color: Colors.white,
                                                        ),
                                                        height: 350,
                                                        width: screenWidth,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                15.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height: 90,
                                                                width:
                                                                    screenWidth,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          45,
                                                                      width: 45,
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image: CachedNetworkImageProvider(
                                                                            data.service!.company!.companyLogo.toString(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: Column(
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: data.bundleTitle.toString(),
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey.shade800,
                                                                                  ),
                                                                                  KText(
                                                                                    text:
                                                                                        data.validityType.toString() ==
                                                                                            "unlimited"
                                                                                        ? languagesController.tr(
                                                                                            "UNLIMITED",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "monthly"
                                                                                        ? languagesController.tr(
                                                                                            "MONTHLY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "weekly"
                                                                                        ? languagesController
                                                                                              .tr(
                                                                                                "WEEKLY",
                                                                                              )
                                                                                              .toString()
                                                                                        : data.validityType.toString() ==
                                                                                              "daily"
                                                                                        ? languagesController.tr(
                                                                                            "DAILY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "hourly"
                                                                                        ? languagesController.tr(
                                                                                            "HOURLY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "nightly"
                                                                                        ? languagesController.tr(
                                                                                            "NIGHTLY",
                                                                                          )
                                                                                        : "",
                                                                                    color: Color(
                                                                                      0xff826AF9,
                                                                                    ),
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: languagesController.tr(
                                                                                      "BUY",
                                                                                    ),
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      PriceTextView(
                                                                                        price: data.buyingPrice.toString(),
                                                                                        textStyle: TextStyle(
                                                                                          color: Colors.grey.shade600,
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
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
                                                                                        width: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        " ${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey.shade600,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: languagesController.tr(
                                                                                      "SELL",
                                                                                    ),
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      PriceTextView(
                                                                                        price: data.sellingPrice.toString(),
                                                                                        textStyle: TextStyle(
                                                                                          color: Colors.grey.shade600,
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
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
                                                                                        width: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        " ${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey.shade600,
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
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                height: 80,
                                                                width:
                                                                    screenWidth,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        5.0,
                                                                      ),
                                                                  child: Text(
                                                                    "If there is any explanation about the package, it will be included in this section...",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  KText(
                                                                    text: languagesController.tr(
                                                                      "PHONENUMBER",
                                                                    ),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                  ),
                                                                  KText(
                                                                    text: confirmPinController
                                                                        .numberController
                                                                        .text
                                                                        .toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                width:
                                                                    screenWidth,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                            context,
                                                                          );
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) {
                                                                                  return AlertDialog(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        17,
                                                                                      ),
                                                                                    ),
                                                                                    contentPadding: EdgeInsets.zero,
                                                                                    content: StatefulBuilder(
                                                                                      builder:
                                                                                          (
                                                                                            context,
                                                                                            setState,
                                                                                          ) {
                                                                                            return Container(
                                                                                              height: 320,
                                                                                              width: screenWidth,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  17,
                                                                                                ),
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              child: Obx(
                                                                                                () =>
                                                                                                    confirmPinController.isLoading.value ==
                                                                                                            false &&
                                                                                                        confirmPinController.loadsuccess.value ==
                                                                                                            false
                                                                                                    ? Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: 100,
                                                                                                            child: Lottie.asset(
                                                                                                              'assets/loties/pin.json',
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            height: 45,
                                                                                                            child: Obx(
                                                                                                              () => Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  KText(
                                                                                                                    text:
                                                                                                                        confirmPinController.isLoading.value ==
                                                                                                                                false &&
                                                                                                                            confirmPinController.loadsuccess.value ==
                                                                                                                                false
                                                                                                                        ? "Confirm your pin"
                                                                                                                        : "Please wait",
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  SizedBox(
                                                                                                                    width: 7,
                                                                                                                  ),
                                                                                                                  confirmPinController.isLoading.value ==
                                                                                                                              true &&
                                                                                                                          confirmPinController.loadsuccess.value ==
                                                                                                                              true
                                                                                                                      ? Center(
                                                                                                                          child: CircularProgressIndicator(
                                                                                                                            color: Colors.black,
                                                                                                                          ),
                                                                                                                        )
                                                                                                                      : SizedBox(),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          // OTPInput(),
                                                                                                          Container(
                                                                                                            height: 40,
                                                                                                            width: 100,
                                                                                                            // color: Colors.red,
                                                                                                            child: TextField(
                                                                                                              focusNode: _focusNode,
                                                                                                              style: TextStyle(
                                                                                                                fontWeight: FontWeight.w600,
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
                                                                                                              controller: confirmPinController.pinController,
                                                                                                              maxLength: 4,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              keyboardType: TextInputType.phone,
                                                                                                              decoration: InputDecoration(
                                                                                                                counterText: '',
                                                                                                                focusedBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                enabledBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                errorBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                focusedErrorBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),

                                                                                                          SizedBox(
                                                                                                            height: 30,
                                                                                                          ),

                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              GestureDetector(
                                                                                                                onTap: () {
                                                                                                                  Navigator.pop(
                                                                                                                    context,
                                                                                                                  );
                                                                                                                  confirmPinController.pinController.clear();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 50,
                                                                                                                  width: 120,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    border: Border.all(
                                                                                                                      width: 1,
                                                                                                                      color: Colors.grey,
                                                                                                                    ),
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      5,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      languagesController.tr(
                                                                                                                        "CANCEL",
                                                                                                                      ),
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontWeight: FontWeight.w500,
                                                                                                                        fontSize: 15,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 10,
                                                                                                              ),
                                                                                                              GestureDetector(
                                                                                                                onTap: () async {
                                                                                                                  if (!confirmPinController.isLoading.value) {
                                                                                                                    if (confirmPinController.pinController.text.isEmpty ||
                                                                                                                        confirmPinController.pinController.text.length !=
                                                                                                                            4) {
                                                                                                                      Fluttertoast.showToast(
                                                                                                                        msg: languagesController.tr(
                                                                                                                          "ENTER_YOUR_PIN",
                                                                                                                        ),
                                                                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                                                                        gravity: ToastGravity.BOTTOM,
                                                                                                                        timeInSecForIosWeb: 1,
                                                                                                                        backgroundColor: Colors.black,
                                                                                                                        textColor: Colors.white,
                                                                                                                        fontSize: 16.0,
                                                                                                                      );
                                                                                                                    } else {
                                                                                                                      await confirmPinController.verify(
                                                                                                                        context,
                                                                                                                      );
                                                                                                                      if (confirmPinController.loadsuccess.value ==
                                                                                                                          true) {
                                                                                                                        print(
                                                                                                                          "recharge Done...........",
                                                                                                                        );
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  width: 120,
                                                                                                                  height: 50,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: Color(
                                                                                                                      0xff04B75D,
                                                                                                                    ),
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      10,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: Stack(
                                                                                                                    children: [
                                                                                                                      Positioned.fill(
                                                                                                                        child: Container(
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                                              10,
                                                                                                                            ),
                                                                                                                            gradient: LinearGradient(
                                                                                                                              begin: Alignment.topCenter,
                                                                                                                              end: Alignment.bottomCenter,
                                                                                                                              colors: [
                                                                                                                                Colors.white.withOpacity(
                                                                                                                                  0.3,
                                                                                                                                ),
                                                                                                                                Colors.transparent,
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          child: Center(
                                                                                                                            child: KText(
                                                                                                                              text: languagesController.tr(
                                                                                                                                "VERIFY",
                                                                                                                              ),
                                                                                                                              color: Colors.white,
                                                                                                                              fontSize: 15,
                                                                                                                              fontWeight: FontWeight.bold,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    : Center(
                                                                                                        child: Container(
                                                                                                          height: 250,
                                                                                                          width: 250,
                                                                                                          child: Lottie.asset(
                                                                                                            'assets/loties/recharge.json',
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          width:
                                                                              double.maxFinite,
                                                                          height:
                                                                              double.maxFinite,
                                                                          decoration: BoxDecoration(
                                                                            color: Color(
                                                                              0xff04B75D,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                          ),
                                                                          child: Stack(
                                                                            children: [
                                                                              Positioned.fill(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    gradient: LinearGradient(
                                                                                      begin: Alignment.topCenter,
                                                                                      end: Alignment.bottomCenter,
                                                                                      colors: [
                                                                                        Colors.white.withOpacity(
                                                                                          0.3,
                                                                                        ),
                                                                                        Colors.transparent,
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: KText(
                                                                                      text: languagesController.tr(
                                                                                        "CONFIRMATION",
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                            context,
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                            border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey.shade300,
                                                                            ),
                                                                          ),
                                                                          child: Center(
                                                                            child: KText(
                                                                              text: languagesController.tr(
                                                                                "CANCEL",
                                                                              ),
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 65,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          left: 5,
                                          right: 5,
                                        ),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      KText(
                                                        text: data.bundleTitle
                                                            .toString(),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 10,
                                                      ),
                                                      Obx(
                                                        () => KText(
                                                          text:
                                                              languagesController
                                                                  .tr("SALE"),
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
                                              SizedBox(width: 2),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        // Text(
                                                        //   data.validityType
                                                        //       .toString(),
                                                        //   style: TextStyle(
                                                        //     fontSize: 14,
                                                        //     color: Colors
                                                        //         .grey.shade600,
                                                        //     fontWeight:
                                                        //         FontWeight.w600,
                                                        //   ),
                                                        // ),
                                                        Obx(
                                                          () => KText(
                                                            text:
                                                                data.validityType
                                                                        .toString() ==
                                                                    "unlimited"
                                                                ? languagesController.tr(
                                                                    "UNLIMITED",
                                                                  )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "monthly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "MONTHLY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "weekly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "WEEKLY",
                                                                      )
                                                                      .toString()
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "daily"
                                                                ? languagesController
                                                                      .tr(
                                                                        "DAILY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "hourly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "HOURLY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "nightly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "NIGHTLY",
                                                                      )
                                                                : "",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                          textStyle: TextStyle(
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
                                                        SizedBox(width: 2),
                                                        Text(
                                                          " ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey
                                                                .shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : bundleController.finalList.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          17,
                                                        ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  content: StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                17,
                                                              ),
                                                          color: Colors.white,
                                                        ),
                                                        height: 350,
                                                        width: screenWidth,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                15.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height: 90,
                                                                width:
                                                                    screenWidth,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          45,
                                                                      width: 45,
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image: CachedNetworkImageProvider(
                                                                            data.service!.company!.companyLogo.toString(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: Column(
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: data.bundleTitle.toString(),
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey.shade800,
                                                                                  ),
                                                                                  KText(
                                                                                    text:
                                                                                        data.validityType.toString() ==
                                                                                            "unlimited"
                                                                                        ? languagesController.tr(
                                                                                            "UNLIMITED",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "monthly"
                                                                                        ? languagesController.tr(
                                                                                            "MONTHLY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "weekly"
                                                                                        ? languagesController
                                                                                              .tr(
                                                                                                "WEEKLY",
                                                                                              )
                                                                                              .toString()
                                                                                        : data.validityType.toString() ==
                                                                                              "daily"
                                                                                        ? languagesController.tr(
                                                                                            "DAILY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "hourly"
                                                                                        ? languagesController.tr(
                                                                                            "HOURLY",
                                                                                          )
                                                                                        : data.validityType.toString() ==
                                                                                              "nightly"
                                                                                        ? languagesController.tr(
                                                                                            "NIGHTLY",
                                                                                          )
                                                                                        : "",
                                                                                    color: Color(
                                                                                      0xff826AF9,
                                                                                    ),
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: languagesController.tr(
                                                                                      "BUY",
                                                                                    ),
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      PriceTextView(
                                                                                        price: data.buyingPrice.toString(),
                                                                                        textStyle: TextStyle(
                                                                                          color: Colors.grey.shade600,
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
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
                                                                                        width: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        " ${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey.shade600,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  KText(
                                                                                    text: languagesController.tr(
                                                                                      "SELL",
                                                                                    ),
                                                                                    color: Colors.grey.shade600,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      PriceTextView(
                                                                                        price: data.sellingPrice.toString(),
                                                                                        textStyle: TextStyle(
                                                                                          color: Colors.grey.shade600,
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
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
                                                                                        width: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        " ${box.read("currency_code")}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey.shade600,
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
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Container(
                                                                height: 80,
                                                                width:
                                                                    screenWidth,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        5.0,
                                                                      ),
                                                                  child: Text(
                                                                    "If there is any explanation about the package, it will be included in this section...",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  KText(
                                                                    text: languagesController.tr(
                                                                      "PHONENUMBER",
                                                                    ),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                  ),
                                                                  KText(
                                                                    text: confirmPinController
                                                                        .numberController
                                                                        .text
                                                                        .toString(),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                width:
                                                                    screenWidth,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                            context,
                                                                          );
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) {
                                                                                  return AlertDialog(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        17,
                                                                                      ),
                                                                                    ),
                                                                                    contentPadding: EdgeInsets.zero,
                                                                                    content: StatefulBuilder(
                                                                                      builder:
                                                                                          (
                                                                                            context,
                                                                                            setState,
                                                                                          ) {
                                                                                            return Container(
                                                                                              height: 320,
                                                                                              width: screenWidth,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  17,
                                                                                                ),
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                              child: Obx(
                                                                                                () =>
                                                                                                    confirmPinController.isLoading.value ==
                                                                                                            false &&
                                                                                                        confirmPinController.loadsuccess.value ==
                                                                                                            false
                                                                                                    ? Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        children: [
                                                                                                          SizedBox(
                                                                                                            height: 100,
                                                                                                            child: Lottie.asset(
                                                                                                              'assets/loties/pin.json',
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            height: 45,
                                                                                                            child: Obx(
                                                                                                              () => Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                children: [
                                                                                                                  KText(
                                                                                                                    text:
                                                                                                                        confirmPinController.isLoading.value ==
                                                                                                                                false &&
                                                                                                                            confirmPinController.loadsuccess.value ==
                                                                                                                                false
                                                                                                                        ? "Confirm your pin"
                                                                                                                        : "Please wait",
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    fontSize: 15,
                                                                                                                  ),
                                                                                                                  SizedBox(
                                                                                                                    width: 7,
                                                                                                                  ),
                                                                                                                  confirmPinController.isLoading.value ==
                                                                                                                              true &&
                                                                                                                          confirmPinController.loadsuccess.value ==
                                                                                                                              true
                                                                                                                      ? Center(
                                                                                                                          child: CircularProgressIndicator(
                                                                                                                            color: Colors.black,
                                                                                                                          ),
                                                                                                                        )
                                                                                                                      : SizedBox(),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          // OTPInput(),
                                                                                                          Container(
                                                                                                            height: 40,
                                                                                                            width: 100,
                                                                                                            // color: Colors.red,
                                                                                                            child: TextField(
                                                                                                              focusNode: _focusNode,
                                                                                                              style: TextStyle(
                                                                                                                fontWeight: FontWeight.w600,
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
                                                                                                              controller: confirmPinController.pinController,
                                                                                                              maxLength: 4,
                                                                                                              textAlign: TextAlign.center,
                                                                                                              keyboardType: TextInputType.phone,
                                                                                                              decoration: InputDecoration(
                                                                                                                counterText: '',
                                                                                                                focusedBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                enabledBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                errorBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                focusedErrorBorder: UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(
                                                                                                                    color: Colors.grey,
                                                                                                                    width: 2.0,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),

                                                                                                          SizedBox(
                                                                                                            height: 30,
                                                                                                          ),

                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              GestureDetector(
                                                                                                                onTap: () {
                                                                                                                  Navigator.pop(
                                                                                                                    context,
                                                                                                                  );
                                                                                                                  confirmPinController.pinController.clear();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 50,
                                                                                                                  width: 120,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    border: Border.all(
                                                                                                                      width: 1,
                                                                                                                      color: Colors.grey,
                                                                                                                    ),
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      5,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: Center(
                                                                                                                    child: Text(
                                                                                                                      languagesController.tr(
                                                                                                                        "CANCEL",
                                                                                                                      ),
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontWeight: FontWeight.w500,
                                                                                                                        fontSize: 15,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                width: 10,
                                                                                                              ),
                                                                                                              GestureDetector(
                                                                                                                onTap: () async {
                                                                                                                  if (!confirmPinController.isLoading.value) {
                                                                                                                    if (confirmPinController.pinController.text.isEmpty ||
                                                                                                                        confirmPinController.pinController.text.length !=
                                                                                                                            4) {
                                                                                                                      Fluttertoast.showToast(
                                                                                                                        msg: languagesController.tr(
                                                                                                                          "ENTER_YOUR_PIN",
                                                                                                                        ),
                                                                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                                                                        gravity: ToastGravity.BOTTOM,
                                                                                                                        timeInSecForIosWeb: 1,
                                                                                                                        backgroundColor: Colors.black,
                                                                                                                        textColor: Colors.white,
                                                                                                                        fontSize: 16.0,
                                                                                                                      );
                                                                                                                    } else {
                                                                                                                      await confirmPinController.verify(
                                                                                                                        context,
                                                                                                                      );
                                                                                                                      if (confirmPinController.loadsuccess.value ==
                                                                                                                          true) {
                                                                                                                        print(
                                                                                                                          "recharge Done...........",
                                                                                                                        );
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  width: 120,
                                                                                                                  height: 50,
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: Color(
                                                                                                                      0xff04B75D,
                                                                                                                    ),
                                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                                      10,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  child: Stack(
                                                                                                                    children: [
                                                                                                                      Positioned.fill(
                                                                                                                        child: Container(
                                                                                                                          decoration: BoxDecoration(
                                                                                                                            borderRadius: BorderRadius.circular(
                                                                                                                              10,
                                                                                                                            ),
                                                                                                                            gradient: LinearGradient(
                                                                                                                              begin: Alignment.topCenter,
                                                                                                                              end: Alignment.bottomCenter,
                                                                                                                              colors: [
                                                                                                                                Colors.white.withOpacity(
                                                                                                                                  0.3,
                                                                                                                                ),
                                                                                                                                Colors.transparent,
                                                                                                                              ],
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                          child: Center(
                                                                                                                            child: KText(
                                                                                                                              text: languagesController.tr(
                                                                                                                                "VERIFY",
                                                                                                                              ),
                                                                                                                              color: Colors.white,
                                                                                                                              fontSize: 15,
                                                                                                                              fontWeight: FontWeight.bold,
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    : Center(
                                                                                                        child: Container(
                                                                                                          height: 250,
                                                                                                          width: 250,
                                                                                                          child: Lottie.asset(
                                                                                                            'assets/loties/recharge.json',
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                    ),
                                                                                  );
                                                                                },
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          width:
                                                                              double.maxFinite,
                                                                          height:
                                                                              double.maxFinite,
                                                                          decoration: BoxDecoration(
                                                                            color: Color(
                                                                              0xff04B75D,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                          ),
                                                                          child: Stack(
                                                                            children: [
                                                                              Positioned.fill(
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    gradient: LinearGradient(
                                                                                      begin: Alignment.topCenter,
                                                                                      end: Alignment.bottomCenter,
                                                                                      colors: [
                                                                                        Colors.white.withOpacity(
                                                                                          0.3,
                                                                                        ),
                                                                                        Colors.transparent,
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: KText(
                                                                                      text: languagesController.tr(
                                                                                        "CONFIRMATION",
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          Navigator.pop(
                                                                            context,
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                            border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.grey.shade300,
                                                                            ),
                                                                          ),
                                                                          child: Center(
                                                                            child: KText(
                                                                              text: languagesController.tr(
                                                                                "CANCEL",
                                                                              ),
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
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
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        height: 65,
                                        margin: EdgeInsets.only(
                                          top: 5,
                                          left: 5,
                                          right: 5,
                                        ),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      KText(
                                                        text: data.bundleTitle
                                                            .toString(),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 10,
                                                      ),
                                                      Obx(
                                                        () => KText(
                                                          text:
                                                              languagesController
                                                                  .tr("SALE"),
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
                                              SizedBox(width: 2),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        // Text(
                                                        //   data.validityType
                                                        //       .toString(),
                                                        //   style: TextStyle(
                                                        //     fontSize: 14,
                                                        //     color: Colors
                                                        //         .grey.shade600,
                                                        //     fontWeight:
                                                        //         FontWeight.w600,
                                                        //   ),
                                                        // ),
                                                        Obx(
                                                          () => KText(
                                                            text:
                                                                data.validityType
                                                                        .toString() ==
                                                                    "unlimited"
                                                                ? languagesController.tr(
                                                                    "UNLIMITED",
                                                                  )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "monthly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "MONTHLY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "weekly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "WEEKLY",
                                                                      )
                                                                      .toString()
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "daily"
                                                                ? languagesController
                                                                      .tr(
                                                                        "DAILY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "hourly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "HOURLY",
                                                                      )
                                                                : data.validityType
                                                                          .toString() ==
                                                                      "nightly"
                                                                ? languagesController
                                                                      .tr(
                                                                        "NIGHTLY",
                                                                      )
                                                                : "",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        PriceTextView(
                                                          price: data
                                                              .sellingPrice
                                                              .toString(),
                                                          textStyle: TextStyle(
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
                                                        SizedBox(width: 2),
                                                        Text(
                                                          " ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey
                                                                .shade600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 10),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

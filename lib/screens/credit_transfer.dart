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

import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/default_button1.dart';

class CreditTransfer extends StatefulWidget {
  CreditTransfer({super.key});

  @override
  State<CreditTransfer> createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
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
    currencyController.fetchCurrency();

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
                      GestureDetector(
                        onTap: () {
                          conversationController.resetConversion();
                          customRechargeController.amountController.clear();
                          mypagecontroller.changePage(
                            Homepages(),
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
                        () => GestureDetector(
                          onTap: () {
                            customhistoryController.finalList.clear();
                            customhistoryController.initialpage = 1;
                            customhistoryController.fetchHistory();
                            // countryListController.fetchCountryData();
                            print(box.read("countryID"));
                          },
                          child: Text(
                            languagesController.tr("CREDIT_TRANSFER"),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  countryListController.flagimageurl.toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    controller: customRechargeController
                                        .numberController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languagesController.tr(
                                        "PHONENUMBER",
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(() {
                              final company =
                                  companyController.matchedCompany.value;
                              return Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: company == null
                                      ? Colors.transparent
                                      : null,
                                  image: company != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            company.companyLogo ?? '',
                                          ),
                                          fit: BoxFit.contain,
                                        )
                                      : null,
                                ),
                                child: company == null
                                    ? Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              );
                            }),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "${languagesController.tr("TRANSFER_TOTAL_BALANCE")} (194/700/255 )",
                      //       style: TextStyle(
                      //         color: AppColors.primarycolor2,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: screenHeight * 0.017,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 8),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    conversationController.inputAmount.value =
                                        double.tryParse(value) ?? 0.0;
                                  },
                                  controller:
                                      customRechargeController.amountController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: languagesController.tr("AMOUNT"),
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                              KText(
                                text: "AFN",
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        child: Obx(() {
                          final convertedList = conversationController
                              .getConvertedValues();

                          if (convertedList.isEmpty) {
                            return Center(child: Text(""));
                          }

                          final item =
                              convertedList.first; // only show the first item

                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${item['symbol']} (${item['name']}):"),
                                Text(item['value'].toStringAsFixed(2)),
                              ],
                            ),
                          );
                        }),
                      ),

                      // Container(
                      //   height: 130,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       width: 1,
                      //       color: Colors.grey.shade300,
                      //     ),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Obx(() {
                      //     final convertedList =
                      //         conversationController.getConvertedValues();

                      //     return Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: ListView.builder(
                      //         padding: EdgeInsets.all(0),
                      //         itemCount: convertedList.length,
                      //         itemBuilder: (context, index) {
                      //           final item = convertedList[index];
                      //           return Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text(
                      //                   "${item['symbol']} (${item['name']}):"),
                      //               Text("${item['value'].toStringAsFixed(2)}"),
                      //             ],
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   }),
                      // ),
                      SizedBox(height: 10),
                      DefaultButton2(
                        height: 50,
                        width: screenWidth,
                        buttonName: languagesController.tr(
                          "SEND_TO_DESTINATION",
                        ),
                        onpressed: () {
                          if (customRechargeController
                                  .numberController
                                  .text
                                  .isEmpty ||
                              customRechargeController
                                  .amountController
                                  .text
                                  .isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Enter required data",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                          color: Colors.white,
                                        ),
                                        height: 150,
                                        width: screenWidth,
                                        child: Padding(
                                          padding: EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 8),
                                              Text(
                                                languagesController.tr(
                                                  "ARE_YOU_SURE_TO_TRANSFER",
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: screenWidth,
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
                                                                    EdgeInsets
                                                                        .zero,
                                                                content: StatefulBuilder(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                        setState,
                                                                      ) {
                                                                        return Container(
                                                                          height:
                                                                              320,
                                                                          width:
                                                                              screenWidth,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                              17,
                                                                            ),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          child: Obx(
                                                                            () =>
                                                                                customRechargeController.isLoading.value ==
                                                                                        false &&
                                                                                    customRechargeController.loadsuccess.value ==
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
                                                                                              Text(
                                                                                                customRechargeController.isLoading.value ==
                                                                                                            false &&
                                                                                                        customRechargeController.loadsuccess.value ==
                                                                                                            false
                                                                                                    ? languagesController.tr(
                                                                                                        "CONFIRM_YOUR_PIN",
                                                                                                      )
                                                                                                    : languagesController.tr(
                                                                                                        "PLEASE_WAIT",
                                                                                                      ),
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  fontSize: 15,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 7,
                                                                                              ),
                                                                                              customRechargeController.isLoading.value ==
                                                                                                          true &&
                                                                                                      customRechargeController.loadsuccess.value ==
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
                                                                                          ),
                                                                                          controller: customRechargeController.pinController,
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
                                                                                              customRechargeController.pinController.clear();
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
                                                                                              if (!customRechargeController.isLoading.value) {
                                                                                                if (customRechargeController.pinController.text.isEmpty ||
                                                                                                    customRechargeController.pinController.text.length !=
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
                                                                                                  await customRechargeController.verify(
                                                                                                    context,
                                                                                                  );
                                                                                                  if (customRechargeController.loadsuccess.value ==
                                                                                                      true) {
                                                                                                    print(
                                                                                                      "recharge Done...........",
                                                                                                    );
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 60,
                                                                                              width: 120,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.green,
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
                                                                                                    "VERIFY",
                                                                                                  ),
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize: 15,
                                                                                                  ),
                                                                                                ),
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
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              languagesController
                                                                  .tr(
                                                                    "CONFIRMATION",
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
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
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                            border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .grey
                                                                  .shade300,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              languagesController
                                                                  .tr("CANCEL"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  // Ensure expandedIndices matches the length of finalList
                  if (expandedIndices.length !=
                      customhistoryController.finalList.length) {
                    expandedIndices.assignAll(
                      List.generate(
                        customhistoryController.finalList.length,
                        (index) => false,
                      ),
                    );
                  }

                  return customhistoryController.isLoading.value == false &&
                          customhistoryController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: customhistoryController.finalList.length,
                            itemBuilder: (context, index) {
                              final data =
                                  customhistoryController.finalList[index];

                              return Container(
                                margin: EdgeInsets.only(bottom: 5),
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                      key: Key(
                                        index.toString(),
                                      ), // Ensure state retention
                                      initiallyExpanded: expandedIndices[index],
                                      onExpansionChanged: (isExpanded) {
                                        expandedIndices[index] = isExpanded;
                                      },
                                      tilePadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      title: Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data
                                                      .bundle!
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString(),
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.bundle!.bundleTitle
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              Text(
                                                data.rechargebleAccount
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
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
                                      trailing: expandedIndices[index]
                                          ? null
                                          : GestureDetector(
                                              onTap: () {
                                                expandedIndices[index] = true;
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .chevronDown,
                                                    size: screenHeight * 0.022,
                                                    color: Color(0xff1890FF),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "TRANSFER_STATUS",
                                                    ),
                                                  ),
                                                  Text(
                                                    data.status.toString() ==
                                                            "0"
                                                        ? languagesController
                                                              .tr("PENDING")
                                                        : data.status
                                                                  .toString() ==
                                                              "1"
                                                        ? languagesController
                                                              .tr("SUCCESS")
                                                        : languagesController
                                                              .tr("REJECTED"),
                                                    style: TextStyle(
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
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "AMOUNT",
                                                    ),
                                                  ),
                                                  Text(
                                                    "${data.bundle.amount} ${box.read("currency_code")}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "DATE",
                                                    ),
                                                    style: TextStyle(
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
                                                  Text(
                                                    DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(
                                                      DateTime.parse(
                                                        data.createdAt
                                                            .toString(),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "TIME",
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  Text(
                                                    DateFormat(
                                                      'hh:mm a',
                                                    ).format(
                                                      DateTime.parse(
                                                        data.createdAt
                                                            .toString(),
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : customhistoryController.finalList.isEmpty
                      ? SizedBox()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: customhistoryController.finalList.length,
                          itemBuilder: (context, index) {
                            final data =
                                customhistoryController.finalList[index];

                            return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: screenWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  ExpansionTile(
                                    key: Key(
                                      index.toString(),
                                    ), // Ensure state retention
                                    initiallyExpanded: expandedIndices[index],
                                    onExpansionChanged: (isExpanded) {
                                      expandedIndices[index] = isExpanded;
                                    },
                                    tilePadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    title: Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                data
                                                    .bundle!
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.bundle!.bundleTitle
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              data.rechargebleAccount
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: expandedIndices[index]
                                        ? null
                                        : GestureDetector(
                                            onTap: () {
                                              expandedIndices[index] = true;
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(width: 5),
                                                Icon(
                                                  FontAwesomeIcons.chevronDown,
                                                  size: screenHeight * 0.022,
                                                  color: Color(0xff1890FF),
                                                ),
                                              ],
                                            ),
                                          ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "TRANSFER_STATUS",
                                                  ),
                                                ),
                                                Text(
                                                  data.status.toString() == "0"
                                                      ? languagesController.tr(
                                                          "PENDING",
                                                        )
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? languagesController.tr(
                                                          "SUCCESS",
                                                        )
                                                      : languagesController.tr(
                                                          "REJECTED",
                                                        ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "AMOUNT",
                                                  ),
                                                ),
                                                Text(
                                                  "${data.bundle.amount} ${box.read("currency_code")}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "DATE",
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat(
                                                    'yyyy-MM-dd',
                                                  ).format(
                                                    DateTime.parse(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  languagesController.tr(
                                                    "TIME",
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  DateFormat('hh:mm a').format(
                                                    DateTime.parse(
                                                      data.createdAt.toString(),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/order_list_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/localtime_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../controllers/drawer_controller.dart';
import '../global_controller/page_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';
import '../screens/order_details_screen.dart';
import 'homepages.dart';

class Orders extends StatefulWidget {
  Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String defaultValue = "";

  String secondDropDown = "";

  final orderlistController = Get.find<OrderlistController>();

  TextEditingController searchController = TextEditingController();
  LanguagesController languagesController = Get.put(LanguagesController());

  List orderStatus = [];

  String search = "";

  final box = GetStorage();

  final ScrollController scrollController = ScrollController();

  final RxString selectedDate = ''.obs;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default date
      firstDate: DateTime(2000), // earliest date
      lastDate: DateTime(2100), // latest date
    );

    if (picked != null) {
      // Format the selected date as yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      selectedDate.value = formattedDate;
      print(formattedDate); // Print to console
      box.write("date", "selected_date=" + formattedDate.toString());
      orderlistController.finalList.clear();
      orderlistController.initialpage = 1;
      orderlistController.fetchOrderlistdata();
    }
  }

  Future<void> refresh() async {
    final int totalPages =
        orderlistController.allorderlist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = orderlistController.initialpage;

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
      orderlistController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (orderlistController.initialpage <= totalPages) {
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        orderlistController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  MyDrawerController drawerController = Get.put(MyDrawerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];
    box.write("orderstatus", "");
    box.write("date", "");
    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;
    orderlistController.fetchOrderlistdata();
    scrollController.addListener(refresh);
  }

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                        () => Text(
                          languagesController.tr("ORDERS"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
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
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              value: defaultValue,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "",
                                  child: KText(
                                    text: languagesController.tr("ALL"),
                                    fontSize: screenWidth * 0.040,
                                  ),
                                ),
                                ...orderStatus.map<DropdownMenuItem<String>>((
                                  data,
                                ) {
                                  return DropdownMenuItem(
                                    value: data['value'],
                                    child: KText(text: data['title']),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                box.write("orderstatus", value);
                                orderlistController.finalList.clear();
                                orderlistController.initialpage = 1;
                                orderlistController.fetchOrderlistdata();
                                print("selected Value $value");
                                setState(() {
                                  defaultValue = value!;
                                });
                              },
                            ),
                          ),
                        ),
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
                              Obx(
                                () => KText(
                                  text: languagesController.tr("DATE"),
                                  fontSize: screenWidth * 0.040,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                    decoration: InputDecoration(
                                      hintText: languagesController.tr(
                                        "SEARCH_BY_PHOENUMBER",
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.040,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   height: 45,
                      //   width: screenWidth,
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         flex: 5,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: AppColors.primaryColor,
                      //             borderRadius: BorderRadius.circular(25),
                      //           ),
                      //           child: Center(
                      //             child: Obx(
                      //               () => Text(
                      //                 languagesController.tr("APPLY_FILTER"),
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 11,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       Expanded(
                      //         flex: 4,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             border: Border.all(
                      //               width: 1,
                      //               color: Colors.red,
                      //             ),
                      //             borderRadius: BorderRadius.circular(25),
                      //           ),
                      //           child: Center(
                      //             child: Obx(
                      //               () => Text(
                      //                 languagesController.tr("REMOVE_FILTER"),
                      //                 style: TextStyle(
                      //                   color: Colors.red,
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: 11,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 450,
              color: Colors.white,
              child: Column(
                children: [
                  Obx(
                    () => orderlistController.isLoading.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                  Obx(
                    () => orderlistController.isLoading.value == false
                        ? Container(
                            child:
                                orderlistController
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
                                        KText(
                                          text: languagesController.tr(
                                            "NO_DATA_FOUND",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          )
                        : SizedBox(),
                  ),
                  Expanded(
                    child: Obx(
                      () =>
                          orderlistController.isLoading.value == false &&
                              orderlistController.finalList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
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
                                                  validityType: data
                                                      .bundle!
                                                      .validityType!
                                                      .toString(),
                                                  sellingPrice: data
                                                      .bundle!
                                                      .sellingPrice
                                                      .toString(),
                                                  buyingPrice: data
                                                      .bundle!
                                                      .buyingPrice
                                                      .toString(),
                                                  orderID: data.id!.toString(),
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
                                        height: 125,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      data.status.toString() ==
                                                          "0"
                                                      ? Color(
                                                          0xffFFC107,
                                                        ).withOpacity(0.12)
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? Colors.green
                                                            .withOpacity(0.12)
                                                      : Color(
                                                          0xffFF4842,
                                                        ).withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      KText(
                                                        text:
                                                            "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                        color: Color(
                                                          0xff637381,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenHeight *
                                                            0.018,
                                                      ),
                                                      KText(
                                                        text:
                                                            DateFormat(
                                                              'dd MMM yyyy',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                        color: Color(
                                                          0xff637381,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenHeight *
                                                            0.018,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Obx(
                                                            () => KText(
                                                              text: languagesController.tr(
                                                                "RECHARGEABLE_ACCOUNT",
                                                              ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                          ),
                                                          KText(
                                                            text: data
                                                                .rechargebleAccount
                                                                .toString(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenHeight *
                                                                0.016,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Obx(
                                                        () => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            KText(
                                                              text: languagesController.tr(
                                                                "TRANSACTION_STATUS",
                                                              ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : Colors.red
                                                                          .withOpacity(
                                                                            0.12,
                                                                          ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                child: KText(
                                                                  text:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? languagesController.tr(
                                                                          "PENDING",
                                                                        )
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? languagesController.tr(
                                                                          "CONFIRMED",
                                                                        )
                                                                      : languagesController.tr(
                                                                          "REJECTED",
                                                                        ),
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.015,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              KText(
                                                                text:
                                                                    languagesController
                                                                        .tr(
                                                                          "BUY",
                                                                        ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              Text(" : "),
                                                              KText(
                                                                text:
                                                                    NumberFormat.currency(
                                                                      locale:
                                                                          'en_US',
                                                                      symbol:
                                                                          '',
                                                                      decimalDigits:
                                                                          2,
                                                                    ).format(
                                                                      double.parse(
                                                                        data
                                                                            .bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              KText(
                                                                text: box.read(
                                                                  "currency_code",
                                                                ),
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              KText(
                                                                text:
                                                                    languagesController
                                                                        .tr(
                                                                          "SELL",
                                                                        ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              Text(" : "),
                                                              KText(
                                                                text:
                                                                    NumberFormat.currency(
                                                                      locale:
                                                                          'en_US',
                                                                      symbol:
                                                                          '',
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
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              KText(
                                                                text: box.read(
                                                                  "currency_code",
                                                                ),
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                    );
                                  },
                                ),
                              ),
                            )
                          : orderlistController.finalList.isEmpty
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
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
                                                  validityType: data
                                                      .bundle!
                                                      .validityType!
                                                      .toString(),
                                                  sellingPrice: data
                                                      .bundle!
                                                      .sellingPrice
                                                      .toString(),
                                                  buyingPrice: data
                                                      .bundle!
                                                      .buyingPrice
                                                      .toString(),
                                                  orderID: data.id!.toString(),
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
                                        height: 125,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      data.status.toString() ==
                                                          "0"
                                                      ? Color(
                                                          0xffFFC107,
                                                        ).withOpacity(0.12)
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? Colors.green
                                                            .withOpacity(0.12)
                                                      : Color(
                                                          0xffFF4842,
                                                        ).withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      KText(
                                                        text:
                                                            "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                        color: Color(
                                                          0xff637381,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenHeight *
                                                            0.018,
                                                      ),
                                                      KText(
                                                        text:
                                                            DateFormat(
                                                              'dd MMM yyyy',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                        color: Color(
                                                          0xff637381,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            screenHeight *
                                                            0.018,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Obx(
                                                            () => KText(
                                                              text: languagesController.tr(
                                                                "RECHARGEABLE_ACCOUNT",
                                                              ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                          ),
                                                          KText(
                                                            text: data
                                                                .rechargebleAccount
                                                                .toString(),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenHeight *
                                                                0.016,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Obx(
                                                        () => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            KText(
                                                              text: languagesController.tr(
                                                                "TRANSACTION_STATUS",
                                                              ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : Colors.red
                                                                          .withOpacity(
                                                                            0.12,
                                                                          ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                child: KText(
                                                                  text:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? languagesController.tr(
                                                                          "PENDING",
                                                                        )
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? languagesController.tr(
                                                                          "CONFIRMED",
                                                                        )
                                                                      : languagesController.tr(
                                                                          "REJECTED",
                                                                        ),
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.015,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              KText(
                                                                text:
                                                                    languagesController
                                                                        .tr(
                                                                          "BUY",
                                                                        ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              Text(" : "),
                                                              KText(
                                                                text:
                                                                    NumberFormat.currency(
                                                                      locale:
                                                                          'en_US',
                                                                      symbol:
                                                                          '',
                                                                      decimalDigits:
                                                                          2,
                                                                    ).format(
                                                                      double.parse(
                                                                        data
                                                                            .bundle!
                                                                            .buyingPrice
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              KText(
                                                                text: box.read(
                                                                  "currency_code",
                                                                ),
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              KText(
                                                                text:
                                                                    languagesController
                                                                        .tr(
                                                                          "SELL",
                                                                        ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              Text(" : "),
                                                              KText(
                                                                text:
                                                                    NumberFormat.currency(
                                                                      locale:
                                                                          'en_US',
                                                                      symbol:
                                                                          '',
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
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              KText(
                                                                text: box.read(
                                                                  "currency_code",
                                                                ),
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class DetailsDialog extends StatelessWidget {
  DetailsDialog({
    super.key,
    this.status,
    this.bundletitle,
    this.phoneNumber,
    this.sellingPrice,
    this.orderId,
    this.imagelink,
    this.date,
  });

  String? status;
  String? bundletitle;
  String? phoneNumber;
  String? sellingPrice;
  String? orderId;
  String? imagelink;
  String? date;

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  final GlobalKey captureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 490,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          child: Column(
            children: [
              RepaintBoundary(
                key: captureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: status.toString() == "0"
                            ? Color(0xffFFC107)
                            : status.toString() == "1"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // Background Image with Opacity
                              Opacity(
                                opacity:
                                    0.2, // Adjust the opacity value (0.0 to 1.0)
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/icons/logo.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              // Foreground Container with Status Icon
                              Container(
                                height: 60,
                                width: 60,
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  status.toString() == "0"
                                      ? "assets/icons/pending.png"
                                      : status.toString() == "1"
                                      ? "assets/icons/successful.png"
                                      : "assets/icons/rejected.png",
                                  height: 60,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            status.toString() == "0"
                                ? languagesController.tr("PENDING")
                                : status.toString() == "1"
                                ? languagesController.tr("CONFIRMED")
                                : languagesController.tr("REJECTED"),
                            style: TextStyle(
                              color: status.toString() == "0"
                                  ? Color(0xffFFC107)
                                  : status.toString() == "1"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("BUNDLE_TITLE"),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                bundletitle.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("PHONENUMBER"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                phoneNumber.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("SELLING_PRICE"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                sellingPrice.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("ORDER_ID"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                orderId.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 65,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: status.toString() == "1"
                                  ? AppColors.secondaryColor
                                  : Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Image.network(imagelink.toString()),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("DATE"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToDate(date.toString()),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("TIME"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToLocalTime(
                                                date.toString(),
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
                  ),
                ),
              ),
              SizedBox(height: 13),
              Container(
                height: 45,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          capturePng(captureKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SAVE_TO_GALLERY"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SHARE"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      languagesController.tr("CLOSE"),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

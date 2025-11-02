import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/change_status_controller.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/delete_sub_resellercontroller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/controllers/subreseller_details_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/screens/add_new_user.dart';
import 'package:insaftelecom/screens/change_balance.dart';
import 'package:insaftelecom/screens/set_password.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../global_controller/font_controller.dart';
import '../screens/set_subreseller_pin.dart';
import '../widgets/custom_text.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

final Mypagecontroller mypagecontroller = Get.find();

final subresellercontroller = Get.find<SubresellerController>();
LanguagesController languagesController = Get.put(LanguagesController());
final detailsController = Get.find<SubresellerDetailsController>();

final DeleteSubResellerController deleteSubResellerController = Get.put(
  DeleteSubResellerController(),
);

final ChangeStatusController changeStatusController = Get.put(
  ChangeStatusController(),
);

final commissionlistController = Get.find<CommissionGroupController>();

SetCommissionGroupController controller = Get.put(
  SetCommissionGroupController(),
);

class _NetworkState extends State<Network> {
  Set<int> expandedIndices = {};

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
    subresellercontroller.fetchSubReseller();
    commissionlistController.fetchGrouplist();
  }

  final box = GetStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();
  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(0xffF1F3FF),
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
                          mypagecontroller.goBack();
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
                          text: languagesController.tr("NETWORK"),
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
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                  borderRadius: BorderRadius.circular(8),
                ),
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.changePage(
                            AddNewUser(),
                            isMainPage: false,
                          );
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth,
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Color(0xffFF6A60),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white.withOpacity(
                                              0.3,
                                            ), // উপরের দিকের হালকা সাদা
                                            Colors.transparent, // নিচে স্বচ্ছ
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            KText(
                                              text: languagesController.tr(
                                                "ADD_USER",
                                              ),
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                        "SEARCH_BY_NAME",
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
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 410,
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
                  padding: EdgeInsets.only(top: 10),
                  child: Obx(
                    () => subresellercontroller.isLoading.value == false
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 8);
                              },
                              itemCount: subresellercontroller
                                  .allsubresellerData
                                  .value
                                  .data!
                                  .resellers
                                  .length,
                              itemBuilder: (context, index) {
                                final data = subresellercontroller
                                    .allsubresellerData
                                    .value
                                    .data!
                                    .resellers[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEEF4FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      onExpansionChanged: (isExpanded) {
                                        setState(() {
                                          if (isExpanded) {
                                            expandedIndices.add(
                                              index,
                                            ); // Add the expanded index

                                            detailsController
                                                .fetchSubResellerDetails(
                                                  data.id.toString(),
                                                );
                                          } else {
                                            expandedIndices.remove(
                                              index,
                                            ); // Remove the collapsed index
                                          }
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          data.profileImageUrl != null
                                              ? Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data.profileImageUrl
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Icon(Icons.person),
                                                  ),
                                                ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              KText(
                                                text: data.contactName
                                                    .toString(),
                                                color: Colors.grey.shade800,
                                                fontSize: screenHeight * 0.020,
                                              ),
                                              KText(
                                                text: data.phone.toString(),
                                                color: Colors.grey.shade800,
                                                fontSize: screenHeight * 0.020,
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              expandedIndices.contains(index)
                                                  ? "assets/icons/visible.png"
                                                  : "assets/icons/invisible.png",
                                              height: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      tilePadding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 2,
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.all(
                                                  0,
                                                ),
                                                content: Container(
                                                  height: 450,
                                                  width: screenWidth,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          15.0,
                                                        ),
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            mypagecontroller
                                                                .changePage(
                                                                  ChangeBalance(
                                                                    subID: data
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                                  isMainPage:
                                                                      false,
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/usdicon.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text: languagesController.tr(
                                                                  "CHANGE_BALANCE",
                                                                ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25),
                                                        GestureDetector(
                                                          onTap: () {
                                                            mypagecontroller
                                                                .changePage(
                                                                  SetPassword(
                                                                    subID: data
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                                  isMainPage:
                                                                      false,
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/padlock.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text: languagesController.tr(
                                                                  "SET_PASSWORD",
                                                                ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      top:
                                                                          Radius.circular(
                                                                            20,
                                                                          ),
                                                                    ),
                                                              ),
                                                              builder: (context) {
                                                                return Obx(() {
                                                                  if (commissionlistController
                                                                      .isLoading
                                                                      .value) {
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  }

                                                                  final groups =
                                                                      commissionlistController
                                                                          .allgrouplist
                                                                          .value
                                                                          .data
                                                                          ?.groups ??
                                                                      [];

                                                                  return ListView.builder(
                                                                    itemCount:
                                                                        groups
                                                                            .length,
                                                                    itemBuilder:
                                                                        (
                                                                          context,
                                                                          index,
                                                                        ) {
                                                                          final group =
                                                                              groups[index];
                                                                          return ListTile(
                                                                            title: Text(
                                                                              group.groupName ??
                                                                                  '',
                                                                            ),
                                                                            subtitle: Text(
                                                                              "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                                                            ),
                                                                            trailing:
                                                                                data.subResellerCommissionGroupId.toString() ==
                                                                                    group.id.toString()
                                                                                ? Icon(
                                                                                    Icons.check,
                                                                                    color: Colors.green,
                                                                                  )
                                                                                : null,
                                                                            onTap: () async {
                                                                              Navigator.pop(
                                                                                context,
                                                                              ); // বন্ধ করে দেই BottomSheet
                                                                              await controller.setgroup(
                                                                                data.id.toString(),
                                                                                group.id.toString(),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                  );
                                                                });
                                                              },
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/discount.png",
                                                                height: 30,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text: languagesController.tr(
                                                                  "SET_COMMISSION_GROUP",
                                                                ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    MediaQuery.of(
                                                                      context,
                                                                    ).size.height *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25),
                                                        GestureDetector(
                                                          onTap: () {
                                                            mypagecontroller.changePage(
                                                              SetSubresellerPin(
                                                                subID: data.id
                                                                    .toString(),
                                                              ),
                                                              isMainPage: false,
                                                            );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/key.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text: languagesController
                                                                    .tr(
                                                                      "SET_PIN",
                                                                    ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25),
                                                        GestureDetector(
                                                          onTap: () {
                                                            changeStatusController
                                                                .channgestatus(
                                                                  data.id
                                                                      .toString(),
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                data.status.toString() ==
                                                                        "1"
                                                                    ? "assets/icons/pause.png"
                                                                    : "assets/icons/active.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text:
                                                                    data.status
                                                                            .toString() ==
                                                                        "1"
                                                                    ? languagesController.tr(
                                                                        "DEACTIVE",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "ACTIVE",
                                                                      ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 25),
                                                        GestureDetector(
                                                          onTap: () {
                                                            deleteSubResellerController
                                                                .deletesub(
                                                                  data.id
                                                                      .toString(),
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/delete.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              KText(
                                                                text: languagesController
                                                                    .tr(
                                                                      "DELETE",
                                                                    ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Container(
                                                            height:
                                                                screenHeight *
                                                                0.065,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: KText(
                                                                text: languagesController
                                                                    .tr(
                                                                      "CLOSE",
                                                                    ),
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          "assets/icons/edit.png",
                                          height: 25,
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Container(
                                            height: 210,
                                            width: screenWidth,
                                            child: Obx(
                                              () =>
                                                  detailsController
                                                          .isLoading
                                                          .value ==
                                                      false
                                                  ? Column(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  // color: Colors.red,
                                                                  child: Column(
                                                                    children: [
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TODAY_ORDER",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.todayOrders
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TOTAL_ORDER",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.totalOrders
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  // color: Colors.red,
                                                                  child: Column(
                                                                    children: [
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TOTAL_SALE",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.totalSale
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TOTAL_PROFIT",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.totalProfit
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: Container(
                                                                  // color: Colors.red,
                                                                  child: Column(
                                                                    children: [
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TODAY_SALE",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.todaySale
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      KText(
                                                                        text: languagesController.tr(
                                                                          "TODAY_PROFIT",
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              AppColors.secondaryColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                3,
                                                                              ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8,
                                                                            ),
                                                                            child: KText(
                                                                              text:
                                                                                  detailsController.allsubresellerDetailsData.value.data!.reseller!.todayProfit
                                                                                      .toString() +
                                                                                  "  " +
                                                                                  box.read(
                                                                                    "currency_code",
                                                                                  ),
                                                                              fontSize: 12,
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
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          width: screenWidth,
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .secondaryColor,
                                                            border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .black26,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                KText(
                                                                  text: languagesController.tr(
                                                                    "ACCOUNT_BALANCE",
                                                                  ),
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.020,
                                                                ),
                                                                KText(
                                                                  text:
                                                                      detailsController
                                                                          .allsubresellerDetailsData
                                                                          .value
                                                                          .data!
                                                                          .reseller!
                                                                          .balance
                                                                          .toString() +
                                                                      " " +
                                                                      box.read(
                                                                        "currency_code",
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator(),
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
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

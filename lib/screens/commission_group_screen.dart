import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/drawer.dart';

class CommissionGroupScreen extends StatefulWidget {
  CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  final commissionlistController = Get.find<CommissionGroupController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    commissionlistController.fetchGrouplist();
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
                          languagesController.tr("COMMISSION_GROUP"),
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
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.020,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: CreateGroupBox(),
                                ),
                              );
                            },
                          );
                        },
                        child: DefaultButton1(
                          height: 50,
                          width: double.maxFinite,
                          buttonName: languagesController.tr("CREATE_NEW"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => commissionlistController.isLoading.value == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.separated(
                          padding: EdgeInsets.all(0),
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 5);
                          },
                          itemCount: commissionlistController
                              .allgrouplist
                              .value
                              .data!
                              .groups!
                              .length,
                          itemBuilder: (context, index) {
                            final data = commissionlistController
                                .allgrouplist
                                .value
                                .data!
                                .groups![index];
                            return Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("GROUP_NAME"),
                                          style: TextStyle(
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(data.groupName.toString()),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("AMOUNT"),
                                          style: TextStyle(
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          data.amount.toString(),
                                          style: TextStyle(
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr(
                                            "COMMISSION_TYPE",
                                          ),
                                          style: TextStyle(
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          data.commissionType.toString() ==
                                                  "percentage"
                                              ? languagesController.tr(
                                                  "PERCENTAGE",
                                                )
                                              : "",
                                          style: TextStyle(
                                            fontFamily:
                                                box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                      .currentFont
                                                : null,
                                          ),
                                        ),
                                      ],
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
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class CreateGroupBox extends StatefulWidget {
  CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final box = GetStorage();

  final AddCommsionGroupController addCommsionGroupController = Get.put(
    AddCommsionGroupController(),
  );

  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
    ];
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 400,
      width: screenWidth,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Transform.rotate(
                  angle: 0.785398,
                  child: Container(
                    height: 7,
                    width: 7,
                    color: Colors.grey.shade300,
                  ),
                ),
                Expanded(
                  child: Container(height: 1, color: Colors.grey.shade300),
                ),
                SizedBox(width: 8),
                Text(
                  languagesController.tr("COMMISSION_GROUP"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.022,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(height: 2, color: Colors.grey.shade300),
                ),
                Transform.rotate(
                  angle: 0.785398, // 45 degrees in radians (π/4 or 0.785398)
                  child: Container(
                    height: 7,
                    width: 7,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  languagesController.tr("GROUP_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_GROUP_NAME"),
              controller: addCommsionGroupController.nameController,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  languagesController.tr("COMMISSION_TYPE"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(
                        addCommsionGroupController.commitype.value.toString(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 150,
                              width: screenWidth,
                              color: Colors.white,
                              child: ListView.builder(
                                itemCount: commissiontype.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      addCommsionGroupController
                                              .commitype
                                              .value =
                                          commissiontype[index]["name"];
                                      addCommsionGroupController
                                              .commissiontype
                                              .value =
                                          commissiontype[index]["value"];
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          commissiontype[index]["name"],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      FontAwesomeIcons.chevronDown,
                      size: screenHeight * 0.018,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  languagesController.tr("AMOUNT"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: addCommsionGroupController.amountController,
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        addCommsionGroupController.amountController.clear();
                        addCommsionGroupController.nameController.clear();
                        addCommsionGroupController.commissiontype.value = "";
                        addCommsionGroupController.commitype.value = "";
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (addCommsionGroupController
                                .nameController
                                .text
                                .isNotEmpty &&
                            addCommsionGroupController
                                .amountController
                                .text
                                .isNotEmpty &&
                            addCommsionGroupController.commissiontype.value !=
                                "") {
                          addCommsionGroupController.createnow();
                          print(" filled");
                        } else {
                          print("No data filled");
                        }
                      },
                      child: Obx(
                        () => DefaultButton1(
                          width: double.maxFinite,
                          height: 50,
                          buttonName:
                              addCommsionGroupController.isLoading.value ==
                                  false
                              ? languagesController.tr("CREATE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
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
  }
}

import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_selling_price_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/only_service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/drawer.dart';
import 'selling_price_screen.dart';

class CreateSellingPriceScreen extends StatefulWidget {
  const CreateSellingPriceScreen({super.key});

  @override
  State<CreateSellingPriceScreen> createState() =>
      _CreateSellingPriceScreenState();
}

class _CreateSellingPriceScreenState extends State<CreateSellingPriceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  final categorisListController = Get.find<CategorisListController>();
  List commissiontype = [];

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

    commissiontype = [
      {"name": languagesController.tr("PERCENTAGE"), "value": "percentage"},
      {"name": languagesController.tr("FIXED"), "value": "fixed"},
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    LanguagesController languagesController = Get.put(LanguagesController());
    final Mypagecontroller mypagecontroller = Get.find();

    AddSellingPriceController addSellingPriceController = Get.put(
      AddSellingPriceController(),
    );

    final OnlyServiceController serviceController = Get.put(
      OnlyServiceController(),
    );

    final box = GetStorage();

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
                        () => KText(
                          text: languagesController.tr("CREATE_SELLING_PRICE"),
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
                height: 500,
                decoration: BoxDecoration(
                  color: Color(0xffEEF4FF),
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
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Row(
                        children: [
                          Text(
                            languagesController.tr("AMOUNT"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_AMOUNT"),
                        controller: addSellingPriceController.amountController,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            languagesController.tr("COMMISSION_TYPE"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
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
                                          addSellingPriceController
                                                  .commitype
                                                  .value =
                                              commissiontype[index]["name"];
                                          addSellingPriceController
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          height: 50,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Center(
                                              child: Text(
                                                commissiontype[index]["name"],
                                              ),
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
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    addSellingPriceController.commitype.value
                                        .toString(),
                                  ),
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.chevronDown,
                                size: screenHeight * 0.018,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            languagesController.tr("SERVICE"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 120,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Obx(
                                () =>
                                    addSellingPriceController.catName.value !=
                                        ''
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            addSellingPriceController.logolink
                                                .toString(),
                                            height: 50,
                                          ),
                                          Text(
                                            addSellingPriceController
                                                .serviceName
                                                .toString(),
                                          ),
                                          Text(
                                            addSellingPriceController.catName
                                                .toString(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(child: Text("")),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    child: ServiceBox(),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.chevronDown,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Obx(
                        () => DefaultButton1(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              addSellingPriceController.isLoading.value == false
                              ? languagesController.tr("CREATE_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (addSellingPriceController
                                    .amountController
                                    .text
                                    .isNotEmpty &&
                                addSellingPriceController
                                        .commissiontype
                                        .value !=
                                    "" &&
                                addSellingPriceController
                                    .serviceidcontroller
                                    .text
                                    .isNotEmpty) {
                              addSellingPriceController.createnow();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Fill data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                      ),
                    ],
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

class ServiceBox extends StatelessWidget {
  ServiceBox({super.key});

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );

  final categorisListController = Get.find<CategorisListController>();
  AddSellingPriceController addSellingPriceController = Get.put(
    AddSellingPriceController(),
  );
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Container(
        height: 500,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => serviceController.isLoading.value == false
                ? GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: serviceController
                        .allservices
                        .value
                        .data!
                        .services
                        .length,
                    itemBuilder: (context, index) {
                      final data = serviceController
                          .allservices
                          .value
                          .data!
                          .services[index];
                      return Padding(
                        padding: EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: () {
                            addSellingPriceController.serviceidcontroller.text =
                                data.id.toString();

                            addSellingPriceController.catName.value =
                                categorisListController
                                    .allcategorieslist
                                    .value
                                    .data!
                                    .servicecategories!
                                    .firstWhere(
                                      (cat) =>
                                          cat.id.toString() ==
                                          data.serviceCategoryId.toString(),
                                      orElse: () =>
                                          Servicecategory(categoryName: ''),
                                    )
                                    .categoryName
                                    .toString();

                            addSellingPriceController.logolink.value = data
                                .company!
                                .companyLogo
                                .toString();

                            addSellingPriceController.serviceName.value = data
                                .company!
                                .companyName
                                .toString();

                            Navigator.pop(context);
                          },
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          data.company!.companyLogo.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        data.company!.companyName.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily:
                                              box.read("language").toString() ==
                                                  "Fa"
                                              ? Get.find<FontController>()
                                                    .currentFont
                                              : null,
                                        ),
                                      ),
                                      // Text(data.serviceCategoryId.toString()),
                                      Text(
                                        categorisListController
                                            .allcategorieslist
                                            .value
                                            .data!
                                            .servicecategories!
                                            .firstWhere(
                                              (cat) =>
                                                  cat.id.toString() ==
                                                  data.serviceCategoryId
                                                      .toString(),
                                              orElse: () => Servicecategory(
                                                categoryName: '',
                                              ),
                                            )
                                            .categoryName
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily:
                                              box.read("language").toString() ==
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
                          ),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

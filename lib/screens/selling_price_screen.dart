import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/categories_controller.dart';
import '../controllers/delete_selling_price_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/default_button1.dart';
import '../widgets/drawer.dart';
import 'create_selling_price_screen.dart';

class SellingPriceScreen extends StatefulWidget {
  SellingPriceScreen({super.key});

  @override
  State<SellingPriceScreen> createState() => _SellingPriceScreenState();
}

class _SellingPriceScreenState extends State<SellingPriceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );

  final box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();
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
    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  final categorisListController = Get.find<CategorisListController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );
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
                          languagesController.tr("SELLING_PRICE"),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: DefaultButton1(
                        buttonName: languagesController.tr("CREATE_NEW"),
                        height: 50,
                        width: double.maxFinite,
                        onpressed: () {
                          mypagecontroller.openSubPage(
                            CreateSellingPriceScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 500,
                width: screenWidth,
                // color: Colors.cyan,
                child: Obx(
                  () =>
                      sellingPriceController.isLoading.value == false &&
                          serviceController.isLoading.value == false
                      ? ListView.builder(
                          padding: EdgeInsets.all(0),
                          physics: BouncingScrollPhysics(),
                          itemCount: sellingPriceController
                              .allpricelist
                              .value
                              .data!
                              .pricings!
                              .length,
                          itemBuilder: (context, index) {
                            final data = sellingPriceController
                                .allpricelist
                                .value
                                .data!
                                .pricings![index];
                            return Container(
                              width: screenWidth,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            serviceController
                                                .allservices
                                                .value
                                                .data!
                                                .services
                                                .firstWhere(
                                                  (srvs) =>
                                                      srvs.id.toString() ==
                                                      data.serviceId.toString(),
                                                )
                                                .company!
                                                .companyLogo
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                serviceController
                                                    .allservices
                                                    .value
                                                    .data!
                                                    .services
                                                    .firstWhere(
                                                      (srvs) =>
                                                          srvs.id.toString() ==
                                                          data.serviceId
                                                              .toString(),
                                                    )
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                              ),
                                              Text(
                                                categorisListController
                                                    .allcategorieslist
                                                    .value
                                                    .data!
                                                    .servicecategories!
                                                    .firstWhere(
                                                      (cat) =>
                                                          cat.id.toString() ==
                                                          data
                                                              .service!
                                                              .serviceCategoryId
                                                              .toString(),
                                                      orElse: () =>
                                                          Servicecategory(
                                                            categoryName:
                                                                'null',
                                                          ),
                                                    )
                                                    .categoryName
                                                    .toString(),
                                                style: TextStyle(
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "COMMISSION_TYPE",
                                                ),
                                              ),
                                              Text(
                                                data.commissionType
                                                            .toString() ==
                                                        "percentage"
                                                    ? languagesController.tr(
                                                        "PERCENTAGE",
                                                      )
                                                    : languagesController.tr(
                                                        "FIXED",
                                                      ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languagesController.tr(
                                                  "AMOUNT",
                                                ),
                                                style: TextStyle(
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
                                                data.amount.toString(),
                                                style: TextStyle(
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
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: DeleteDialog(
                                                priceID: data.id.toString(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, this.priceID});

  String? priceID;

  final DeleteSellingPriceController controller = Get.put(
    DeleteSellingPriceController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            languagesController.tr("DO_YOU_WANT_TO_DELETE"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 25),
          Container(
            height: 50,
            width: screenWidth,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.deleteprice(priceID.toString());
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          controller.isLoading.value == false
                              ? languagesController.tr("YES")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        languagesController.tr("NO"),
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
    );
  }
}

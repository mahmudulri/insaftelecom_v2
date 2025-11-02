import 'package:insaftelecom/helpers/capture_image_helper.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/categories_controller.dart';
import '../controllers/delete_selling_price_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';
import '../controllers/transferlist_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/service_category_model.dart';
import '../pages/homepages.dart';
import '../pages/transaction_type.dart';
import '../utils/colors.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/default_button1.dart';
import '../widgets/drawer.dart';
import 'create_selling_price_screen.dart';
import 'create_transfer_screen.dart';

class CommissionTransferScreen extends StatefulWidget {
  CommissionTransferScreen({super.key});

  @override
  State<CommissionTransferScreen> createState() =>
      _CommissionTransferScreenState();
}

class _CommissionTransferScreenState extends State<CommissionTransferScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  TransferlistController transferlistController = Get.put(
    TransferlistController(),
  );

  final SellingPriceController sellingPriceController = Get.put(
    SellingPriceController(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transferlistController.fetchdata();
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

  final OnlyServiceController serviceController = Get.put(
    OnlyServiceController(),
  );
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                          text: languagesController.tr("TRANSFER_COMISSION"),
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
                          mypagecontroller.changePage(
                            CreateTransferScreen(),
                            isMainPage: false,
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
                  () => transferlistController.isLoading.value == false
                      ? ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          itemCount: transferlistController
                              .alltransferlist
                              .value
                              .data!
                              .requests!
                              .length,
                          itemBuilder: (context, index) {
                            final data = transferlistController
                                .alltransferlist
                                .value
                                .data!
                                .requests![index];
                            return Card(
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Color(0xffEEF4FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "AMOUNT",
                                            ),
                                          ),
                                          KText(text: data.amount.toString()),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          KText(
                                            text: languagesController.tr(
                                              "STATUS",
                                            ),
                                          ),
                                          KText(text: data.status.toString()),
                                        ],
                                      ),
                                      Visibility(
                                        visible:
                                            data.adminNotes.toString() !=
                                            "null",
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            KText(
                                              text: languagesController.tr(
                                                "NOTES",
                                              ),
                                            ),
                                            KText(
                                              text: data.adminNotes.toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
          ],
        ),
      ),
    );
  }
}

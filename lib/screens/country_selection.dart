import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/controllers/service_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/pages/homepages.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/drawer.dart';

import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  LanguagesController languagesController = Get.put(LanguagesController());

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  BundleController bundleController = Get.put(BundleController());

  ServiceController serviceController = Get.put(ServiceController());

  MyDrawerController drawerController = Get.put(MyDrawerController());

  // final countrylistController = Get.find<CountryListController>();
  final box = GetStorage();

  // final serviceController = Get.find<ServiceController>();

  final Mypagecontroller mypagecontroller = Get.find();

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
  }

  @override
  Widget build(BuildContext context) {
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
                          languagesController.tr("COUNTRY_SELECTION"),
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
                  child: Obx(
                    () => countrylistController.isLoading.value == false
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Text(
                                      languagesController.tr("RESERVE_FOR"),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff8082ED),
                                        fontFamily:
                                            languagesController.selectedlan ==
                                                "Fa"
                                            ? "Iranfont"
                                            : "Roboto",
                                      ),
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
                              GridView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                      childAspectRatio: 1.5,
                                    ),
                                itemCount: countrylistController
                                    .finalCountryList
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = countrylistController
                                      .finalCountryList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      box.write("country_id", data["id"]);
                                      box.write(
                                        "countryName",
                                        data["country_name"],
                                      );
                                      serviceController.reserveDigit.clear();
                                      bundleController.finalList.clear();
                                      box.write(
                                        "maxlength",
                                        data["phone_number_length"],
                                      );
                                      box.write("validity_type", "");
                                      box.write("company_id", "");
                                      box.write("search_tag", "");
                                      bundleController.finalList.clear();
                                      mypagecontroller.openSubPage(
                                        RechargeScreen(),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffEEF4FF),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey,
                                              backgroundImage: NetworkImage(
                                                data["country_flag_image_url"],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              data["country_name"],
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: screenHeight * 0.020,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
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

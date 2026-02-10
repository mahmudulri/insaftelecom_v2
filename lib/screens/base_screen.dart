import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/drawer_controller.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final dashboardController = Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  void _onTabTap(int index) {
    if (mypagecontroller.selectedIndex.value == index) return;

    mypagecontroller.onTabSelected(index);
    mypagecontroller.goToMainPageByIndex(index);
  }

  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    dashboardController.fetchDashboardData();
  }

  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: mypagecontroller.handleBack,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Color(0xffF1F3FF),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Positioned.fill(
                child: Navigator(
                  key: mypagecontroller.navigatorKey,
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => Obx(
                      () => mypagecontroller
                          .mainPages[mypagecontroller.selectedIndex.value],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    height: 70,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                      child: Obx(() {
                        final index = mypagecontroller.selectedIndex.value;

                        return Row(
                          children: [
                            Expanded(
                              flex: index == 0 ? 2 : 1,
                              child: GestureDetector(
                                onTap: () => _onTabTap(0),
                                child: Container(
                                  child: Obx(
                                    () => Center(
                                      child: index == 0
                                          ? _buildFullStack(
                                              index == 0
                                                  ? Color(0xffFE8F2D)
                                                  : Color(0xffFE8F2D),
                                              languagesController.tr("HOME"),
                                              "assets/icons/homeicon.png",
                                            ) // Show full Stack design
                                          : _buildSimpleStack(
                                              Color(0xffFE8F2D),
                                              "assets/icons/homeicon.png",
                                              languagesController.tr("HOME"),
                                            ), // Show reduced Stack design
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              flex: index == 1 ? 2 : 1,
                              child: GestureDetector(
                                onTap: () => _onTabTap(1),
                                child: Container(
                                  child: Obx(
                                    () => Center(
                                      child: index == 1
                                          ? _buildFullStack(
                                              index == 0
                                                  ? Color(0xff4B7AFC)
                                                  : Color(0xff4B7AFC),
                                              languagesController.tr(
                                                "PRODUCTS",
                                              ),
                                              "assets/icons/products.png",
                                            )
                                          : _buildSimpleStack(
                                              Color(0xff4B7AFC),
                                              "assets/icons/products.png",
                                              languagesController.tr(
                                                "PRODUCTS",
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              flex: index == 2 ? 2 : 1,
                              child: GestureDetector(
                                onTap: () => _onTabTap(2),
                                child: Container(
                                  child: Obx(
                                    () => Center(
                                      child: index == 2
                                          ? _buildFullStack(
                                              index == 0
                                                  ? Color(0xff6A32F6)
                                                  : Color(0xff6A32F6),
                                              languagesController.tr(
                                                "EXCHANGE",
                                              ),
                                              "assets/icons/exchange.png",
                                            )
                                          : _buildSimpleStack(
                                              Color(0xff6A32F6),
                                              "assets/icons/exchange.png",
                                              languagesController.tr(
                                                "EXCHANGE",
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              flex: index == 3 ? 2 : 1,
                              child: GestureDetector(
                                onTap: () => _onTabTap(3),
                                child: Container(
                                  child: Obx(
                                    () => Center(
                                      child: index == 3
                                          ? _buildFullStack(
                                              index == 0
                                                  ? Color(0xffDE4B5E)
                                                  : Color(0xffDE4B5E),
                                              languagesController.tr(
                                                "TRANSACTIONS",
                                              ),
                                              "assets/icons/transactionsicon.png",
                                            )
                                          : _buildSimpleStack(
                                              Color(0xffDE4B5E),
                                              "assets/icons/transactionsicon.png",
                                              languagesController.tr(
                                                "TRANSACTIONS",
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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

  List<String> imagedata = [
    "assets/icons/homeicon.png",
    "assets/icons/transactionsicon.png",
    "assets/icons/ordericon.png",
    "assets/icons/sub_reseller.png",
  ];
}

Widget _buildFullStack(Color color, String menuname, String image) {
  final box = GetStorage();
  return Container(
    height: 50,
    width: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image.toString(), color: Colors.white, height: 30),
            KText(
              text: menuname,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ],
        ),
      ),
    ),
  );
}

// Simple Stack Design (Without the first container)
Widget _buildSimpleStack(Color color, String image, String name) {
  return Container(
    height: 50,
    width: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image.toString(), color: Colors.white, height: 20),
              KText(
                text: name,
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/helpers/download_image_helper.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/change_password_screen.dart';

import '../screens/change_pin.dart';
import '../screens/commission_group_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/helpscreen.dart';
import '../screens/profile_screen.dart';
import '../screens/selling_price_screen.dart';
import '../screens/sign_in_screen.dart';
import '../utils/colors.dart';
import 'custom_text.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final Mypagecontroller mypagecontroller = Get.find();

  final box = GetStorage();

  final dashboardController = Get.find<DashboardController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: box.read("direction") != "rtl"
            ? BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              // gradient: LinearGradient(
              //   colors: [
              //     Color(0xFFE0BCF3), // Left side color
              //     Color(0xFF7EE7EE), // Right side color
              //   ],
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              // ),
              borderRadius: box.read("direction") != "rtl"
                  ? BorderRadius.only(
                      topRight: Radius.circular(30),
                      // bottomRight: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      // bottomLeft: Radius.circular(30),
                    ),
            ),
            child: Column(
              children: [
                SizedBox(height: 50),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 45,
                  backgroundImage: AssetImage("assets/icons/logo.png"),
                ),
                SizedBox(height: 8),
                Text(
                  "انصاف تیلیکام",
                  style: TextStyle(
                    fontSize: screenHeight * 0.030,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Btitrbold",
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Obx(
                  () => drawermenu(
                    imagelink: "assets/icons/user.png",
                    menuname: languagesController.tr("PROFILE"),
                    onpressed: () {
                      mypagecontroller.changePage(
                        ProfileScreen(),
                        isMainPage: false,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Obx(
                  () => drawermenu(
                    imagelink: "assets/icons/set_sell_price.png",
                    menuname: languagesController.tr("SET_SALE_PRICE"),
                    onpressed: () {
                      mypagecontroller.changePage(
                        SellingPriceScreen(),
                        isMainPage: false,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Obx(
                  () => drawermenu(
                    imagelink: "assets/icons/sub_reseller.png",
                    menuname: languagesController.tr("NETWORK"),
                    onpressed: () {
                      mypagecontroller.changePage(Network(), isMainPage: false);
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Obx(
                  () => drawermenu(
                    imagelink: "assets/icons/set_vendor_sell_price.png",
                    menuname: languagesController.tr("COMMISSION_GROUP"),
                    onpressed: () {
                      mypagecontroller.changePage(
                        CommissionGroupScreen(),
                        isMainPage: false,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/accounting.png",
                  menuname: languagesController.tr("ACCOUNTING"),
                  onpressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white,
                          title: Row(
                            children: [
                              Icon(
                                Icons.hourglass_empty,
                                color: Colors.deepPurple,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                languagesController.tr("COMMING_SOON"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(languagesController.tr("CLOSE")),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/security-safe.png",
                  menuname: languagesController.tr("CHANGE_PIN"),
                  onpressed: () {
                    mypagecontroller.changePage(
                      ChangePinScreen(),
                      isMainPage: false,
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/padlock.png",
                  menuname: languagesController.tr("CHANGE_PASSWORD"),
                  onpressed: () {
                    mypagecontroller.changePage(
                      ChangePasswordScreen(),
                      isMainPage: false,
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/note-text.png",
                  menuname: languagesController.tr("HELP"),
                  onpressed: () {
                    mypagecontroller.changePage(
                      Helpscreen(),
                      isMainPage: false,
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/whatsapp.png",
                  menuname: languagesController.tr("CONTACTUS"),
                  onpressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          contentPadding: EdgeInsets.all(0),
                          content: ContactDialogBox(),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/global.png",
                  menuname: languagesController.tr("LANGUAGES"),
                  onpressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(languagesController.tr("LANGUAGES")),
                          content: Container(
                            height: 350,
                            width: screenWidth,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  languagesController.alllanguagedata.length,
                              itemBuilder: (context, index) {
                                final data =
                                    languagesController.alllanguagedata[index];
                                return GestureDetector(
                                  onTap: () {
                                    final languageName = data["name"]
                                        .toString();

                                    final matched = languagesController
                                        .alllanguagedata
                                        .firstWhere(
                                          (lang) =>
                                              lang["name"] == languageName,
                                          orElse: () => {
                                            "isoCode": "en",
                                            "direction": "ltr",
                                          },
                                        );

                                    final languageISO = matched["isoCode"]!;
                                    final languageDirection =
                                        matched["direction"]!;

                                    // Store selected language & direction
                                    languagesController.changeLanguage(
                                      languageName,
                                    );
                                    box.write("language", languageName);
                                    box.write("direction", languageDirection);

                                    // Set locale based on ISO
                                    Locale locale;
                                    switch (languageISO) {
                                      case "fa":
                                        locale = Locale("fa", "IR");
                                        break;
                                      case "ar":
                                        locale = Locale("ar", "AE");
                                        break;
                                      case "ps":
                                        locale = Locale("ps", "AF");
                                        break;
                                      case "tr":
                                        locale = Locale("tr", "TR");
                                        break;
                                      case "bn":
                                        locale = Locale("bn", "BD");
                                        break;
                                      case "en":
                                      default:
                                        locale = Locale("en", "US");
                                    }

                                    // Set app locale
                                    setState(() {
                                      EasyLocalization.of(
                                        context,
                                      )!.setLocale(locale);
                                    });

                                    // Pop dialog
                                    Navigator.pop(context);

                                    print(
                                      "🌐 Language changed to $languageName ($languageISO), Direction: $languageDirection",
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    height: 45,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: KText(
                                              text: languagesController
                                                  .alllanguagedata[index]["fullname"]
                                                  .toString(),
                                            ),
                                          ),
                                        ],
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
                    // Navigator.pop(context);
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                drawermenu(
                  imagelink: "assets/icons/logout.png",
                  menuname: languagesController.tr("LOGOUT"),
                  onpressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: LogoutDialogBox(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class drawermenu extends StatelessWidget {
  drawermenu({super.key, this.menuname, this.imagelink, this.onpressed});

  String? menuname;
  String? imagelink;
  VoidCallback? onpressed;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Row(
        children: [
          SizedBox(width: 20),
          Image.asset(
            imagelink.toString(),
            height: 26,
            color: menuname.toString() == languagesController.tr("ACCOUNTING")
                ? null
                : AppColors.primaryColor,
          ),
          SizedBox(width: 10),
          Text(
            menuname.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: screenHeight * 0.017,
              fontWeight: FontWeight.w600,
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoutDialogBox extends StatelessWidget {
  LogoutDialogBox({super.key});

  final signInController = Get.find<SignInController>();

  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/rejected.png", height: 40),
              SizedBox(width: 15),
              Text(
                languagesController.tr("ARE_YOU_READY_TO_LOG_OUT"),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 45,
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        signInController.usernameController.clear();
                        signInController.passwordController.clear();

                        box.remove("userToken");

                        Get.to(() => SignInScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("YES_IAMGOING_OUT"),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

whatsapp() async {
  var contact = "+930777005805";
  var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
  var iosUrl = "https://wa.me/$contact?text=${Uri.parse('')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    print("not found");
  }
}

class ContactDialogBox extends StatelessWidget {
  ContactDialogBox({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 300,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/icons/whatsapp2.png", height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => Text(
                languagesController.tr("WHATSAPP_TITLE"),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        whatsapp();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              languagesController.tr("YES"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              languagesController.tr("CANCEL"),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}

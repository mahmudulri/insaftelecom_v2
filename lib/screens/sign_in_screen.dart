import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/sign_in_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/routes/routes.dart';

import 'package:insaftelecom/screens/sign_up_screen.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/authtextfield.dart';
import 'package:insaftelecom/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/font_controller.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/socialbuttonbox.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  // final Mypagecontroller mypagecontroller = Get.find();

  // final Mypagecontroller mypagecontroller = Get.find();

  final signInController = Get.find<SignInController>();

  final dashboardController = Get.find<DashboardController>();

  final box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());
  // Future<bool> showExitPopup() async {
  //   final shouldExit = mypagecontroller.goBack();
  //   if (shouldExit) {
  //     return await showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text(languagesController.tr("EXIT_APP")),
  //             content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
  //             actions: [
  //               ElevatedButton(
  //                 onPressed: () => Navigator.of(context).pop(false),
  //                 child: Text(languagesController.tr("NO")),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   exit(0);
  //                 },
  //                 child: Text(languagesController.tr("YES")),
  //               ),
  //             ],
  //           ),
  //         ) ??
  //         false;
  //   }
  //   setState(() {}); // Rebuild screen after popping
  //   return false;
  // }

  final String phoneNumber = "+930777005805";
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mywebp.webp'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 220, left: 20, right: 20),
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
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
                                  final data = languagesController
                                      .alllanguagedata[index];
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
                    },
                    child: KText(
                      text: languagesController.tr("LOGIN"),
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  KText(
                    text: languagesController.tr("ENTER_YOUR_LOGIN_INFO"),
                    fontSize: 12,
                    color: Color(0xffF4F6F8),
                  ),
                  SizedBox(height: 10),
                  Authtextfield(
                    hinttext: languagesController.tr("USERNAME"),
                    controller: signInController.usernameController,
                  ),
                  SizedBox(height: 10),
                  PasswordField(
                    hinttext: languagesController.tr("PASSWORD"),
                    controller: signInController.passwordController,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      KText(
                        text: languagesController.tr("FORGOT_YOUR_PASSWORD"),
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      SizedBox(width: 8),
                      KText(
                        text: languagesController.tr("PASSWORD_RECOVERY"),
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(
                    () => SinInbutton(
                      width: screenWidth,
                      height: 50,
                      buttonName: signInController.isLoading.value == false
                          ? languagesController.tr("LOGIN")
                          : languagesController.tr("PLEASE_WAIT"),
                      onpressed: () async {
                        if (signInController.usernameController.text
                                .trim()
                                .isEmpty ||
                            signInController.passwordController.text
                                .trim()
                                .isEmpty) {
                          Get.snackbar("Oops!", "Fill the text fields");
                          return;
                        }

                        await signInController.signIn();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            whatsapp();
                          },
                          child: Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            showSocialPopup(context);
                          },
                          child: Image.asset(
                            "assets/icons/social-media.png",
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(phoneNumber);
                          },
                          child: Icon(
                            FontAwesomeIcons.phone,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      KText(
                        text: languagesController.tr("HAVE_NOT_REGISTERED_YET"),
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: KText(
                          text: languagesController.tr("REGISTER"),
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          signInController.usernameController.text =
                              "01986072587";
                          signInController.passwordController.text = "00000000";
                        },
                        child: Text(
                          "01986",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          signInController.usernameController.text =
                              "0796321768";
                          signInController.passwordController.text = "00000000";
                        },
                        child: Text(
                          "0796321",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class languageBox extends StatelessWidget {
  const languageBox({super.key, this.lanName, this.onpressed});
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              lanName.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SinInbutton extends StatelessWidget {
  final double width;
  final double height;
  final String? buttonName;
  final VoidCallback? onpressed;

  SinInbutton({
    required this.width,
    required this.height,
    this.buttonName,
    this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
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
                    colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                  ),
                ),
                child: Center(
                  child: KText(
                    text: buttonName.toString(),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
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

class PasswordField extends StatefulWidget {
  PasswordField({required this.hinttext, this.controller, super.key});

  String hinttext;
  TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final box = GetStorage();

  bool isvisible = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.065,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.grey.shade300),
        color: Color(0xffF9FAFB),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                obscureText: isvisible,
                style: TextStyle(
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
                keyboardType: widget.hinttext.toString() == "Enter amount"
                    ? TextInputType.phone
                    : TextInputType.name,
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hinttext,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isvisible = !isvisible;
                });
              },
              child: Icon(isvisible ? Icons.visibility_off : Icons.visibility),
            ),
          ],
        ),
      ),
    );
  }
}

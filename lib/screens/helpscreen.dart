import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../global_controller/languages_controller.dart';
import '../pages/homepages.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/drawer.dart';

class Helpscreen extends StatefulWidget {
  Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
  final helpController = Get.find<HelpController>();

  final languagesController = Get.find<LanguagesController>();

  String helpdata =
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    helpController.helpService();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
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
                          languagesController.tr("GUIDE"),
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
            Expanded(
              child: Obx(
                () => helpController.isLoading.value == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: helpController
                              .helpdata
                              .value
                              .data!
                              .articles!
                              .length,
                          itemBuilder: (context, index) {
                            final data = helpController
                                .helpdata
                                .value
                                .data!
                                .articles![index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.help_outline,
                                          color: Colors.blueAccent,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            data.title.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.grey),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.question_answer_outlined,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            data.description.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
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
          ],
        ),
      ),
    );
  }
}

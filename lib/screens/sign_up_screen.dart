import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
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

import '../controllers/country_list_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/district_controller.dart';
import '../controllers/province_controller.dart';
import '../controllers/sign_up_controller.dart';
import '../models/currency_model.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/socialbuttonbox.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  SignUpController signUpController = Get.put(SignUpController());

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );
  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());
  final CurrencyController currencyController = Get.put(CurrencyController());

  String selected_country = "";

  String selected_province = "";

  String selected_district = "";

  String selected_currency = "";
  final box = GetStorage();

  File? _selectedImage;

  Future<void> _pickImage() async {
    await signUpController.uploadImage();

    if (signUpController.imageFile != null) {
      setState(() {
        _selectedImage = signUpController.imageFile;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countryListController.fetchCountryData();
    districtController.fetchDistrict();
    provinceController.fetchProvince();
    currencyController.fetchCurrency();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
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
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // optional, makes it modern
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), // light shadow
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: Offset(0, 4), // shadow direction (x,y)
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    countryListController.fetchCountryData();
                                  },
                                  child: Text(
                                    languagesController.tr("REGISTER"),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            Text(
                              languagesController.tr("FULL_NAME"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Authtextfield(
                              hinttext: languagesController.tr(
                                "ENTER_YOUR_FULL_NAME",
                              ),
                              controller:
                                  signUpController.resellerNameController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              languagesController.tr("CONTACT_NAME"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Authtextfield(
                              hinttext: languagesController.tr(
                                "ENTER_CONTACT_NAME",
                              ),
                              controller:
                                  signUpController.contactNameController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              languagesController.tr("PHONE_NUMBER"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Authtextfield(
                              hinttext: languagesController.tr(
                                "ENTER_PHONE_NUMBER",
                              ),
                              controller: signUpController.phoneController,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  languagesController.tr("EMAIL"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Authtextfield(
                              hinttext: languagesController.tr("EMAIL_ADDRESS"),
                              controller: signUpController.emailController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              languagesController.tr("CURRENCY"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            // --- Currency Select (stores ID; shows symbol; fully null-safe & strongly typed) ---
                            Container(
                              height: 50,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Obx(() {
                                  // 1) Strongly type as List<Currency>
                                  final List<Currency> currencies =
                                      currencyController
                                          .allcurrency
                                          .value
                                          .data
                                          ?.currencies ??
                                      <Currency>[];

                                  // (Optional) filter out items without an ID to avoid invalid dropdown values
                                  final List<Currency> usable = currencies
                                      .where((c) => c.id != null)
                                      .toList();

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment:
                                        box.read("language").toString() != "Fa"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,

                                    // 2) value comes from controller (ID as string)
                                    value:
                                        signUpController
                                            .currencyId
                                            .value
                                            .isEmpty
                                        ? null
                                        : signUpController.currencyId.value,

                                    // 3) Force the lambda parameter type to Currency so it's never Object
                                    items: usable.map<DropdownMenuItem<String>>(
                                      (Currency c) {
                                        final String idStr = (c.id ?? 0)
                                            .toString();
                                        final String symbol = (c.symbol ?? '')
                                            .trim(); // null-safe
                                        final String code = (c.code ?? '')
                                            .trim(); // null-safe
                                        final String label = symbol.isNotEmpty
                                            ? symbol
                                            : code;

                                        return DropdownMenuItem<String>(
                                          value: idStr,
                                          child: Text(
                                            label,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (screenHeight * 0.020),
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),

                                    // 4) Also force Currency here to avoid Object
                                    selectedItemBuilder: (context) {
                                      return usable.map<Widget>((Currency c) {
                                        final String symbol = (c.symbol ?? '')
                                            .trim();
                                        final String code = (c.code ?? '')
                                            .trim();
                                        final String label = symbol.isNotEmpty
                                            ? symbol
                                            : code;

                                        return Align(
                                          alignment:
                                              box.read("language").toString() !=
                                                  "Fa"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Text(
                                            label,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (screenHeight * 0.020),
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },

                                    onChanged: (String? value) {
                                      if (value == null) return;
                                      // store currency ID (string), like province/district
                                      signUpController.currencyId.value = value;
                                    },

                                    hint: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: (screenHeight * 0.020),
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),

                                    icon: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.7),
                                      radius: 18,
                                      child: const Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  languagesController.tr(
                                    "COUNTRY_OF_RESIDENCE",
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 50,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Obx(() {
                                  // Safe list extraction
                                  final countries =
                                      countryListController
                                          .allcountryListData
                                          .value
                                          .data
                                          ?.countries ??
                                      <dynamic>[];

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment:
                                        box.read("language").toString() != "Fa"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,

                                    value:
                                        (signUpController
                                            .countryId
                                            .value
                                            .isEmpty)
                                        ? null
                                        : signUpController.countryId.value,

                                    items: countries
                                        .map<DropdownMenuItem<String>>((c) {
                                          final String idStr = ((c?.id) ?? '')
                                              .toString();
                                          final String name =
                                              ((c?.countryName) ?? '')
                                                  .toString();
                                          final String flagUrl =
                                              ((c?.countryFlagImageUrl) ?? '')
                                                  .toString();

                                          return DropdownMenuItem<String>(
                                            value: idStr,
                                            child: Row(
                                              children: [
                                                // Flag
                                                if (flagUrl.isNotEmpty)
                                                  Image.network(
                                                    flagUrl,
                                                    height: 40,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                const SizedBox(width: 10),
                                                // Name
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                    fontSize:
                                                        (screenHeight * 0.020),
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                        .toList(),

                                    // Show just the text (no flag) in the closed field to match your design
                                    selectedItemBuilder: (context) {
                                      return countries.map<Widget>((c) {
                                        final String name =
                                            ((c?.countryName) ?? '').toString();
                                        return Align(
                                          alignment:
                                              box.read("language").toString() !=
                                                  "Fa"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (screenHeight * 0.020),
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },

                                    // update both selected text and id
                                    onChanged: (value) {
                                      if (value == null) return;

                                      dynamic picked;
                                      for (final c in countries) {
                                        if (((c?.id) ?? '').toString() ==
                                            value) {
                                          picked = c;
                                          break;
                                        }
                                      }
                                      picked ??= countries.isNotEmpty
                                          ? countries.first
                                          : null;

                                      signUpController.countryId.value = value;
                                      selected_country =
                                          ((picked?.countryName) ?? '')
                                              .toString();
                                      // Optional: setState(() {}); if needed in a StatefulWidget
                                    },

                                    // Keep same look when nothing selected yet (uses your selected_country text)
                                    // hint: Text(
                                    //   selected_country,
                                    //   style: TextStyle(
                                    //     fontSize: (screenHeight * 0.020),
                                    //     color: Colors.grey.shade600,
                                    //   ),
                                    // ),

                                    // match your Container design: no underline, zero padding
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),

                                    // keep your CircleAvatar + chevron on the right
                                    icon: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.7),
                                      radius: 18,
                                      child: const Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 10),

                            Row(
                              children: [
                                Text(
                                  languagesController.tr("PROVINCE"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 50,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Obx(() {
                                  final provinces =
                                      provinceController
                                          .allprovincelist
                                          .value
                                          .data
                                          ?.provinces ??
                                      <dynamic>[];

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment:
                                        box.read("language").toString() != "Fa"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    value:
                                        (signUpController
                                            .provinceId
                                            .value
                                            .isEmpty)
                                        ? null
                                        : signUpController.provinceId.value,
                                    items: provinces
                                        .map<DropdownMenuItem<String>>((p) {
                                          final String idStr = ((p?.id) ?? '')
                                              .toString();
                                          final String name =
                                              ((p?.provinceName) ?? '')
                                                  .toString();
                                          return DropdownMenuItem<String>(
                                            value: idStr,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                fontSize:
                                                    (screenHeight * 0.020),
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    selectedItemBuilder: (context) {
                                      return provinces.map<Widget>((p) {
                                        final String name =
                                            ((p?.provinceName) ?? '')
                                                .toString();
                                        return Align(
                                          alignment:
                                              box.read("language").toString() !=
                                                  "Fa"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (screenHeight * 0.020),
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      if (value == null) return;

                                      dynamic picked;
                                      for (final p in provinces) {
                                        if (((p?.id) ?? '').toString() ==
                                            value) {
                                          picked = p;
                                          break;
                                        }
                                      }
                                      picked ??= provinces.isNotEmpty
                                          ? provinces.first
                                          : null;

                                      signUpController.provinceId.value = value;
                                      selected_province =
                                          ((picked?.provinceName) ?? '')
                                              .toString();
                                      // Optional: setState(() {}); if inside a StatefulWidget and you need a rebuild here.
                                    },
                                    hint: Text(
                                      selected_province,
                                      style: TextStyle(
                                        fontSize: (screenHeight * 0.020),
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    icon: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.7),
                                      radius: 18,
                                      child: const Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  languagesController.tr("DISTRICT"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 50,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Obx(() {
                                  final districts =
                                      districtController
                                          .alldistrictList
                                          .value
                                          .data
                                          ?.districts ??
                                      <dynamic>[];

                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment:
                                        box.read("language").toString() != "Fa"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    value:
                                        (signUpController
                                            .districtID
                                            .value
                                            .isEmpty)
                                        ? null
                                        : signUpController.districtID.value,
                                    items: districts
                                        .map<DropdownMenuItem<String>>((d) {
                                          final String idStr = ((d?.id) ?? '')
                                              .toString();
                                          final String name =
                                              ((d?.districtName) ?? '')
                                                  .toString();
                                          return DropdownMenuItem<String>(
                                            value: idStr,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                fontSize:
                                                    (screenHeight * 0.020),
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    selectedItemBuilder: (context) {
                                      return districts.map<Widget>((d) {
                                        final String name =
                                            ((d?.districtName) ?? '')
                                                .toString();
                                        return Align(
                                          alignment:
                                              box.read("language").toString() !=
                                                  "Fa"
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Text(
                                            name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: (screenHeight * 0.020),
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                    onChanged: (value) {
                                      if (value == null) return;

                                      dynamic picked;
                                      for (final d in districts) {
                                        if (((d?.id) ?? '').toString() ==
                                            value) {
                                          picked = d;
                                          break;
                                        }
                                      }
                                      picked ??= districts.isNotEmpty
                                          ? districts.first
                                          : null;

                                      signUpController.districtID.value = value;
                                      selected_district =
                                          ((picked?.districtName) ?? '')
                                              .toString();
                                      // Optional: setState(() {}); if you need an immediate rebuild.
                                    },
                                    hint: Text(
                                      selected_district,
                                      style: TextStyle(
                                        fontSize: (screenHeight * 0.020),
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    icon: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.7),
                                      radius: 18,
                                      child: const Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    print("start............");
                                    await signUpController.uploadImage();
                                    _selectedImage = signUpController.imageFile;
                                    print("End............");
                                  },
                                  child: DottedBorder(
                                    color: Colors
                                        .grey
                                        .shade300, // Dotted border color
                                    strokeWidth: 2,
                                    dashPattern: [6, 3],
                                    borderType: BorderType.Circle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[200],
                                        child:
                                            signUpController
                                                    .selectedImagePath
                                                    .value ==
                                                ""
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/upload_image.png",
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    languagesController.tr(
                                                      "UPLOAD_PHOTO",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize:
                                                          screenHeight * 0.013,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ClipOval(
                                                child: Image.file(
                                                  signUpController.imageFile!,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // -------------------- Identity Attachment (Optional) --------------------
                            SizedBox(height: 20),
                            Row(
                              children: [
                                KText(
                                  text: languagesController.tr(
                                    "IDENTITY_ATTACHMENT",
                                  ),
                                  color: Colors.grey.shade600,
                                  fontSize: screenHeight * 0.020,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Obx(() {
                              final hasImage = signUpController
                                  .selectedIdentityPath
                                  .value
                                  .isNotEmpty;
                              return GestureDetector(
                                onTap: () async {
                                  await signUpController
                                      .uploadIdentityAttachment();
                                  setState(() {});
                                },
                                child: DottedBorder(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 2,
                                  dashPattern: const [6, 3],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: hasImage
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(
                                                    signUpController
                                                        .selectedIdentityPath
                                                        .value,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    signUpController
                                                            .selectedIdentityPath
                                                            .value =
                                                        '';
                                                    setState(() {});
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        Colors.black54,
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/upload_image.png",
                                                  height: 28,
                                                ),
                                                const SizedBox(height: 6),
                                                KText(
                                                  text: languagesController.tr(
                                                    "TAP_TO_UPLOAD_IDENTITY_IMAGE",
                                                  ),
                                                  color: Colors.grey.shade600,
                                                  fontSize:
                                                      screenHeight * 0.015,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 12),

                            // -------------------- Extra Optional Proof (Optional) --------------------
                            Row(
                              children: [
                                KText(
                                  text: languagesController.tr("EXTRA_PROOF"),
                                  color: Colors.grey.shade600,
                                  fontSize: screenHeight * 0.020,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Obx(() {
                              final hasImage = signUpController
                                  .selectedExtraProofPath
                                  .value
                                  .isNotEmpty;
                              return GestureDetector(
                                onTap: () async {
                                  await signUpController
                                      .uploadExtraOptionalProof();
                                  setState(() {});
                                },
                                child: DottedBorder(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 2,
                                  dashPattern: const [6, 3],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: hasImage
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(
                                                    signUpController
                                                        .selectedExtraProofPath
                                                        .value,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    signUpController
                                                            .selectedExtraProofPath
                                                            .value =
                                                        '';
                                                    setState(() {});
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 16,
                                                    backgroundColor:
                                                        Colors.black54,
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/upload_image.png",
                                                  height: 28,
                                                ),
                                                const SizedBox(height: 6),
                                                KText(
                                                  text: languagesController.tr(
                                                    "TAP_TO_UPLOAD_EXTRA_PROOF",
                                                  ),
                                                  color: Colors.grey.shade600,
                                                  fontSize:
                                                      screenHeight * 0.015,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  languagesController.tr("ENTER_YOUR_PIN"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Authtextfield(
                              hinttext: languagesController.tr("NEW_PIN"),
                              controller: signUpController.pinController,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  languagesController.tr("CONFIRM_PIN"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "(${languagesController.tr("OPTIONAL")})",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Authtextfield(
                              hinttext: languagesController.tr("CONFIRM_PIN"),
                              controller: signUpController.confirmPinController,
                            ),

                            SizedBox(height: 10),
                            Text(
                              languagesController.tr("PASSWORD"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),

                            Authtextfield(
                              hinttext: languagesController.tr("PASSWORD"),
                              controller: signUpController.passwordController,
                            ),
                            SizedBox(height: 10),
                            Text(
                              languagesController.tr("CONFIRM_PASSWORD"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),

                            Authtextfield(
                              hinttext: languagesController.tr(
                                "CONFIRM_PASSWORD",
                              ),
                              controller:
                                  signUpController.confirmPassController,
                            ),
                            SizedBox(height: 20),
                            Obx(
                              () => DefaultButton(
                                mycolor: AppColors.primaryColor,
                                buttonName: signUpController.isLoading.value
                                    ? languagesController.tr("PLEASE_WAIT")
                                    : languagesController.tr("REGISTER_NOW"),
                                onpressed: () async {
                                  if (signUpController.isLoading.value) return;

                                  final err = signUpController.validateInputs();
                                  if (err != null) {
                                    Get.snackbar(
                                      languagesController.tr("INVALID_INPUT"),
                                      err,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  await signUpController.registernow();

                                  // If you keep local UI vars in the widget (e.g., selected_country/province/district),
                                  // also clear them here after success:
                                  // setState(() {
                                  //   selected_country = '';
                                  //   selected_province = '';
                                  //   selected_district = '';
                                  //   selected_currency = '';
                                  // });
                                },
                              ),
                            ),

                            SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              languagesController.tr("ALREADY_REGISTERED"),
                              style: TextStyle(
                                color: Color(0xffA3A3A3),
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                languagesController.tr("LOGIN"),
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 18,
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
        ),
      ),
    );
  }
}

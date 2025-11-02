import 'dart:io';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insaftelecom/controllers/add_sub_reseller_controller.dart';
import 'package:insaftelecom/controllers/country_list_controller.dart';
import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/controllers/district_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/controllers/province_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/pages/homepages.dart';
import 'package:insaftelecom/pages/network.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/authtextfield.dart';
import 'package:insaftelecom/widgets/bottomsheet.dart';
import 'package:insaftelecom/widgets/button_one.dart';

import '../controllers/commission_group_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/drawer.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    await addSubResellerController.uploadImage();

    if (addSubResellerController.imageFile != null) {
      setState(() {
        _selectedImage = addSubResellerController.imageFile;
      });
    }
  }

  final box = GetStorage();
  final Mypagecontroller mypagecontroller = Get.find();

  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );
  final AddSubResellerController addSubResellerController = Get.put(
    AddSubResellerController(),
  );

  final CountryListController countryListController = Get.put(
    CountryListController(),
  );

  final ProvinceController provinceController = Get.put(ProvinceController());

  final DistrictController districtController = Get.put(DistrictController());

  String selected_comissiongroup = "Select Comission Group";

  String selected_country = "Select Country";

  String selected_province = "Select Province";

  String selected_district = "Select District";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  CommissionGroupController commissionlistController = Get.put(
    CommissionGroupController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commissionlistController.fetchGrouplist();
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                          () => Text(
                            "${languagesController.tr("ADD_USER")}",
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
              SizedBox(height: 40),
              Obx(
                () => Center(
                  child: GestureDetector(
                    onTap: () async {
                      await addSubResellerController.uploadImage();
                      _selectedImage = addSubResellerController.imageFile;
                    },
                    child: DottedBorder(
                      color: Colors.grey.shade300, // Dotted border color
                      strokeWidth: 2,
                      dashPattern: [6, 3],
                      borderType: BorderType.Circle,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child:
                              addSubResellerController
                                      .selectedImagePath
                                      .value ==
                                  ""
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/upload_image.png",
                                      height: 30,
                                    ),
                                    Text(
                                      languagesController.tr("UPLOAD_PHOTO"),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: screenHeight * 0.013,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipOval(
                                  child: Image.file(
                                    addSubResellerController.imageFile!,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Text(
                        languagesController.tr("FULL_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: languagesController.tr(
                          "ADD_FIRST_AND_LAST_NAME",
                        ),
                        controller:
                            addSubResellerController.resellerNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("CONTACT_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: languagesController.tr("CONTACT_NAME"),
                        controller:
                            addSubResellerController.contactNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("PHONENUMBER"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ),
                      SizedBox(height: 7),
                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_PHONE_NUMBER"),
                        controller: addSubResellerController.phoneController,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            languagesController.tr("EMAIL"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "(${languagesController.tr("OPTIONAL")})",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: languagesController.tr("ENTER_EMAIL_ADDRESS"),
                        controller: addSubResellerController.emailController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("COMMISSION_GROUP"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Obx(() {
                            // Safe dynamic list extraction
                            final List<dynamic> groups =
                                (commissionlistController
                                        .allgrouplist
                                        .value
                                        .data
                                        ?.groups
                                    as List?) ??
                                <dynamic>[];

                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              alignment: box.read("language").toString() != "Fa"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,

                              // keep your selected state
                              value:
                                  (addSubResellerController
                                      .groupId
                                      .value
                                      .isEmpty)
                                  ? null
                                  : addSubResellerController.groupId.value,

                              // build items from your controller
                              items: groups.map<DropdownMenuItem<String>>((g) {
                                final String idStr = ((g?.id) ?? '').toString();
                                final String name = ((g?.groupName) ?? '')
                                    .toString();
                                return DropdownMenuItem<String>(
                                  value: idStr,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: (screenHeight * 0.020),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                );
                              }).toList(),

                              // update both selected text and id (kept same as your logic)
                              onChanged: (value) {
                                if (value == null) return;

                                dynamic picked;
                                for (final g in groups) {
                                  if (((g?.id) ?? '').toString() == value) {
                                    picked = g;
                                    break;
                                  }
                                }
                                picked ??= groups.isNotEmpty
                                    ? groups.first
                                    : null;

                                addSubResellerController.groupId.value = value;
                                selected_comissiongroup =
                                    ((picked?.groupName) ?? '').toString();
                                // Optional: setState(() {}); if needed in a StatefulWidget context
                              },

                              // keep the same text look when nothing selected yet
                              hint: Text(
                                selected_comissiongroup,
                                style: TextStyle(
                                  fontSize: (screenHeight * 0.020),
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              // remove default underline/padding to match your Container design
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

                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("COUNTRY_OF_RESIDENCE"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ),
                      SizedBox(height: 7),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
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
                              alignment: box.read("language").toString() != "Fa"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,

                              // keep your selected state
                              value:
                                  (addSubResellerController
                                      .countryId
                                      .value
                                      .isEmpty)
                                  ? null
                                  : addSubResellerController.countryId.value,

                              // items with flag + name
                              items: countries.map<DropdownMenuItem<String>>((
                                c,
                              ) {
                                final String idStr = ((c?.id) ?? '').toString();
                                final String name = ((c?.countryName) ?? '')
                                    .toString();
                                final String flagUrl =
                                    ((c?.countryFlagImageUrl) ?? '').toString();

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
                                          fontSize: (screenHeight * 0.020),
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              // Show just the text (no flag) in the closed field to match your design
                              selectedItemBuilder: (context) {
                                return countries.map<Widget>((c) {
                                  final String name = ((c?.countryName) ?? '')
                                      .toString();
                                  return Align(
                                    alignment:
                                        box.read("language").toString() != "Fa"
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
                                  if (((c?.id) ?? '').toString() == value) {
                                    picked = c;
                                    break;
                                  }
                                }
                                picked ??= countries.isNotEmpty
                                    ? countries.first
                                    : null;

                                addSubResellerController.countryId.value =
                                    value;
                                selected_country = ((picked?.countryName) ?? '')
                                    .toString();
                                // Optional: setState(() {}); if needed in a StatefulWidget
                              },

                              // Keep same look when nothing selected yet (uses your selected_country text)
                              hint: Text(
                                selected_country,
                                style: TextStyle(
                                  fontSize: (screenHeight * 0.020),
                                  color: Colors.grey.shade600,
                                ),
                              ),

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
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("PROVINCE"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
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
                              alignment: box.read("language").toString() != "Fa"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              value:
                                  (addSubResellerController
                                      .provinceId
                                      .value
                                      .isEmpty)
                                  ? null
                                  : addSubResellerController.provinceId.value,
                              items: provinces.map<DropdownMenuItem<String>>((
                                p,
                              ) {
                                final String idStr = ((p?.id) ?? '').toString();
                                final String name = ((p?.provinceName) ?? '')
                                    .toString();
                                return DropdownMenuItem<String>(
                                  value: idStr,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: (screenHeight * 0.020),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              selectedItemBuilder: (context) {
                                return provinces.map<Widget>((p) {
                                  final String name = ((p?.provinceName) ?? '')
                                      .toString();
                                  return Align(
                                    alignment:
                                        box.read("language").toString() != "Fa"
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
                                  if (((p?.id) ?? '').toString() == value) {
                                    picked = p;
                                    break;
                                  }
                                }
                                picked ??= provinces.isNotEmpty
                                    ? provinces.first
                                    : null;

                                addSubResellerController.provinceId.value =
                                    value;
                                selected_province =
                                    ((picked?.provinceName) ?? '').toString();
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
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("DISTRICT"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
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
                              alignment: box.read("language").toString() != "Fa"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              value:
                                  (addSubResellerController
                                      .districtID
                                      .value
                                      .isEmpty)
                                  ? null
                                  : addSubResellerController.districtID.value,
                              items: districts.map<DropdownMenuItem<String>>((
                                d,
                              ) {
                                final String idStr = ((d?.id) ?? '').toString();
                                final String name = ((d?.districtName) ?? '')
                                    .toString();
                                return DropdownMenuItem<String>(
                                  value: idStr,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: (screenHeight * 0.020),
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              selectedItemBuilder: (context) {
                                return districts.map<Widget>((d) {
                                  final String name = ((d?.districtName) ?? '')
                                      .toString();
                                  return Align(
                                    alignment:
                                        box.read("language").toString() != "Fa"
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
                                  if (((d?.id) ?? '').toString() == value) {
                                    picked = d;
                                    break;
                                  }
                                }
                                picked ??= districts.isNotEmpty
                                    ? districts.first
                                    : null;

                                addSubResellerController.districtID.value =
                                    value;
                                selected_district =
                                    ((picked?.districtName) ?? '').toString();
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
                      SizedBox(height: 12),
                      Text(
                        languagesController.tr("DESIRED_CURRENCY"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(
                        height: 45,
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
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  box.read("currencyName") +
                                      " (${box.read("currency_code")})",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.020,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              // Icon(
                              //   FontAwesomeIcons.chevronDown,
                              //   size: screenHeight * 0.018,
                              //   color: Colors.grey,
                              // ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // -------------------- Identity Attachment (Optional) --------------------
                      Row(
                        children: [
                          KText(
                            text: languagesController.tr("IDENTITY_ATTACHMENT"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "(${languagesController.tr("OPTIONAL")})",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Obx(() {
                        final hasImage = addSubResellerController
                            .selectedIdentityPath
                            .value
                            .isNotEmpty;
                        return GestureDetector(
                          onTap: () async {
                            await addSubResellerController
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.file(
                                            File(
                                              addSubResellerController
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
                                              addSubResellerController
                                                      .selectedIdentityPath
                                                      .value =
                                                  '';
                                              setState(() {});
                                            },
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.black54,
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
                                            fontSize: screenHeight * 0.015,
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
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Obx(() {
                        final hasImage = addSubResellerController
                            .selectedExtraProofPath
                            .value
                            .isNotEmpty;
                        return GestureDetector(
                          onTap: () async {
                            await addSubResellerController
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.file(
                                            File(
                                              addSubResellerController
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
                                              addSubResellerController
                                                      .selectedExtraProofPath
                                                      .value =
                                                  '';
                                              setState(() {});
                                            },
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.black54,
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
                                            fontSize: screenHeight * 0.015,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 10),

                      Obx(
                        () => DefaultButton2(
                          height: 50,
                          width: screenWidth,
                          buttonName:
                              addSubResellerController.isLoading.value == false
                              ? languagesController.tr("ADD_NOW")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            if (addSubResellerController
                                    .resellerNameController
                                    .text
                                    .isEmpty ||
                                addSubResellerController
                                    .contactNameController
                                    .text
                                    .isEmpty ||
                                addSubResellerController
                                    .phoneController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: languagesController.tr(
                                  "FILL_DATA_CORRECTLY",
                                ),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              addSubResellerController.addNow();
                              print("ok");
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:insaftelecom/widgets/default_button1.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/branch_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/drawer.dart';
import 'hawala_list_screen.dart';

class HawalaScreen extends StatefulWidget {
  HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final Mypagecontroller mypagecontroller = Get.find();
  final AddHawalaController addHawalaController = Get.put(
    AddHawalaController(),
  );
  SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());
  final BranchController branchController = Get.put(BranchController());

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  ConversationController conversationController = Get.put(
    ConversationController(),
  );
  HawalaCurrencyController hawalaCurrencyController = Get.put(
    HawalaCurrencyController(),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hawalaCurrencyController.fetchcurrency();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
    addHawalaController.amountController.clear();
    addHawalaController.currency.value = '';
    addHawalaController.finalAmount.value = '';
    conversationController.selectedCurrency.value = "";
    addHawalaController.senderNameController.clear();
    addHawalaController.receiverNameController.clear();
    addHawalaController.fatherNameController.clear();
    addHawalaController.idcardController.clear();
    addHawalaController.currencyID.value == "";
    addHawalaController.paidbyreceiver.value = "";
    addHawalaController.paidbysender.value = "";
    addHawalaController.branchId.value = "";
    addHawalaController.currency.value = "";
    addHawalaController.currency2.value = "";
    addHawalaController.branch.value = "";

    currencyController.fetchCurrencyList();
    branchController.fetchallbranch();
    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
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
                        () => GestureDetector(
                          onTap: () {
                            hawalaCurrencyController.fetchcurrency();
                          },
                          child: KText(
                            text: languagesController.tr("CREATE_HAWALA"),
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
                height: 600,
                width: screenWidth,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    children: [
                      Text(
                        languagesController.tr("SENDER_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.senderNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("RECEIVER_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.receiverNameController,
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("RECEIVER_FATHERS_NAME"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.fatherNameController,
                      ),
                      SizedBox(height: 5),
                      Text(
                        languagesController.tr("RECEIVER_ID_CARD_NUMBER"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 5),
                      Authtextfield(
                        hinttext: "",
                        controller: addHawalaController.idcardController,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("HAWALA_AMOUNT"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                  ? Get.find<FontController>().currentFont
                                  : null,
                            ),
                          ),
                          Text(
                            languagesController.tr("CURRENCY"),
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
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: screenHeight * 0.065,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Color(0xffF9FAFB),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: TextField(
                                    style: TextStyle(height: 1.1),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,2}'),
                                      ),
                                    ],
                                    controller:
                                        addHawalaController.amountController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenHeight * 0.018,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      final selected = addHawalaController
                                          .selectedRate
                                          .value;

                                      // যদি কোন currency সিলেক্ট না করা হয় (selected null হয়) তাহলে হিসাব না করো
                                      if (selected == null ||
                                          addHawalaController
                                              .currency
                                              .value
                                              .isEmpty) {
                                        addHawalaController.finalAmount.value =
                                            "0.00";
                                        return;
                                      }

                                      double input =
                                          double.tryParse(
                                            addHawalaController
                                                .amountController
                                                .text
                                                .trim(),
                                          ) ??
                                          0;
                                      double dAmount =
                                          double.tryParse(
                                            selected.amount?.toString() ?? "0",
                                          ) ??
                                          0;
                                      double sRate =
                                          double.tryParse(
                                            selected.sellRate?.toString() ??
                                                "0",
                                          ) ??
                                          0;

                                      double result = 0;
                                      if (dAmount > 0 && sRate > 0) {
                                        result = (input / dAmount) * sRate;
                                      }

                                      addHawalaController.finalAmount.value =
                                          result.toStringAsFixed(2);
                                    },
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Obx(() {
                                // Use dynamic since model name isn't specified
                                final List<dynamic> rates =
                                    (hawalaCurrencyController
                                            .hawalafilteredcurrency
                                            .value
                                            .data
                                            ?.rates
                                        as List?) ??
                                    <dynamic>[];

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    alignment:
                                        box.read("language").toString() != "Fa"
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    value:
                                        addHawalaController
                                            .currencyID
                                            .value
                                            .isEmpty
                                        ? null
                                        : addHawalaController.currencyID.value,
                                    items: rates.map<DropdownMenuItem<String>>((
                                      r,
                                    ) {
                                      final String idStr =
                                          ((r?.toCurrency?.id) ?? '')
                                              .toString();
                                      final String symbol =
                                          ((r?.toCurrency?.symbol) ?? '')
                                              .toString();
                                      return DropdownMenuItem<String>(
                                        value: idStr,
                                        child: Text(symbol),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value == null) return;

                                      // find selected rate
                                      dynamic selectedRate;
                                      for (final r in rates) {
                                        final String idStr =
                                            ((r?.toCurrency?.id) ?? '')
                                                .toString();
                                        if (idStr == value) {
                                          selectedRate = r;
                                          break;
                                        }
                                      }
                                      selectedRate ??= rates.isNotEmpty
                                          ? rates.first
                                          : null;

                                      // update controllers
                                      addHawalaController.currencyID.value =
                                          value;
                                      addHawalaController.currency.value =
                                          ((selectedRate?.toCurrency?.symbol) ??
                                                  '')
                                              .toString();

                                      // if selectedRate is Rx-typed to a specific model, ensure its type matches
                                      addHawalaController.selectedRate.value =
                                          selectedRate;

                                      final double input =
                                          double.tryParse(
                                            addHawalaController
                                                .amountController
                                                .text
                                                .trim(),
                                          ) ??
                                          0;
                                      final double dAmount =
                                          double.tryParse(
                                            (selectedRate?.amount ?? '0')
                                                .toString(),
                                          ) ??
                                          0;
                                      final double sRate =
                                          double.tryParse(
                                            (selectedRate?.sellRate ?? '0')
                                                .toString(),
                                          ) ??
                                          0;

                                      double result = 0;
                                      if (dAmount > 0 && sRate > 0) {
                                        result = (input / dAmount) * sRate;
                                      }
                                      addHawalaController.finalAmount.value =
                                          result.toStringAsFixed(2);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.chevronDown,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    hint: Text(
                                      addHawalaController.currency.value.isEmpty
                                          ? ''
                                          : addHawalaController.currency.value,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("YOUR_ACCOUNT_BALANCE_IS"),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.017,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("COMMISSION_PAID_BY"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          alignment: box.read("language").toString() != "Fa"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          value: person.value.isEmpty ? null : person.value,
                          items: commissionpaidby.map((p) {
                            return DropdownMenuItem<String>(
                              value: p,
                              child: Text(
                                p,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            person.value = value;

                            if (value == "sender") {
                              addHawalaController.paidbysender.value = "1";
                              addHawalaController.paidbyreceiver.value = "0";
                            } else {
                              addHawalaController.paidbysender.value = "0";
                              addHawalaController.paidbyreceiver.value = "1";
                            }
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.grey,
                            size: 20, // larger like the other dropdowns
                          ),
                          hint: Text(
                            person.value.isEmpty ? '' : person.value,
                            style: TextStyle(
                              fontSize: screenHeight * 0.020,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Color(0xff352B73),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Text(
                                  addHawalaController.finalAmount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr(
                          "FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE",
                        ),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenHeight * 0.015,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        languagesController.tr("BRANCH"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          // Use dynamic since model name isn't specified; cast to list safely
                          final List<dynamic> branches =
                              (branchController
                                      .allbranch
                                      .value
                                      .data
                                      ?.hawalabranches
                                  as List?) ??
                              <dynamic>[];

                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            alignment: box.read("language").toString() != "Fa"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,

                            // value is the selected branch id (String)
                            value: addHawalaController.branchId.value.isEmpty
                                ? null
                                : addHawalaController.branchId.value,

                            items: branches.map<DropdownMenuItem<String>>((b) {
                              final String idStr = ((b?.id) ?? '').toString();
                              final String name = ((b?.name) ?? '').toString();
                              return DropdownMenuItem<String>(
                                value: idStr,
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              if (value == null) return;

                              // find selected branch
                              dynamic picked;
                              for (final b in branches) {
                                if (((b?.id) ?? '').toString() == value) {
                                  picked = b;
                                  break;
                                }
                              }
                              picked ??= branches.isNotEmpty
                                  ? branches.first
                                  : null;

                              // update controllers
                              addHawalaController.branchId.value = value;
                              addHawalaController.branch.value =
                                  ((picked?.name) ?? '').toString();
                            },

                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),

                            icon: const Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Colors.grey,
                              size: 20,
                            ),

                            // show current branch text like before
                            hint: Text(
                              addHawalaController.branch.value.isEmpty
                                  ? ''
                                  : addHawalaController.branch.value,
                              style: TextStyle(
                                fontSize: screenHeight * 0.020,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => DefaultButton1(
                          buttonName:
                              addHawalaController.isLoading.value == false
                              ? languagesController.tr("CONFIRM_AND_SUBMIT")
                              : languagesController.tr("PLEASE_WAIT"),
                          height: 50,
                          width: double.maxFinite,
                          onpressed: () async {
                            if (addHawalaController
                                    .senderNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .receiverNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .amountController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .fatherNameController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController
                                    .idcardController
                                    .text
                                    .isNotEmpty &&
                                addHawalaController.currencyID.value != "" &&
                                addHawalaController.paidbyreceiver.value !=
                                    "" &&
                                addHawalaController.branchId.value != "") {
                              print("All is ok............");

                              bool success = await addHawalaController
                                  .createhawala();
                              if (success) {
                                Get.find<Mypagecontroller>().handleBack();
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter All data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 80),
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

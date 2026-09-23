import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/drawer.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  HawalaCurrencyController hawalacurrencycontroller = Get.put(
    HawalaCurrencyController(),
  );

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  final dashboardController = Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String getLocalizedCurrencyName({
    required String? code,
    required String? fallbackName,
  }) {
    final currencyCode = code?.trim().toUpperCase() ?? "";
    final defaultName = fallbackName?.trim() ?? "";

    if (currencyCode.isEmpty) {
      return defaultName.isEmpty ? "-" : defaultName;
    }

    final translationKey = "CURRENCY_$currencyCode";
    final translatedName = languagesController.tr(translationKey).trim();

    if (translatedName.isEmpty || translatedName == translationKey) {
      return defaultName.isEmpty ? currencyCode : defaultName;
    }

    return translatedName;
  }

  String getCurrencyFlag({required String? code, required String? symbol}) {
    final currencyCode = code?.trim().toUpperCase() ?? "";
    final currencySymbol = symbol?.trim().toUpperCase() ?? "";

    switch (currencyCode) {
      case "AFN":
        return "assets/flags/afghanistan.png";

      case "IRR":
      case "TMN":
        return "assets/flags/iran.png";

      case "TRY":
      case "LIR":
      case "TL":
        return "assets/flags/turkey.png";

      case "USD":
        return "assets/flags/usa.png";

      case "BDT":
        return "assets/flags/bangladesh.png";
    }

    switch (currencySymbol) {
      case "AFN":
        return "assets/flags/afghanistan.png";

      case "IRR":
      case "TMN":
        return "assets/flags/iran.png";

      case "TRY":
      case "LIR":
      case "TL":
      case "₺":
        return "assets/flags/turkey.png";

      case "USD":
      case "\$":
        return "assets/flags/usa.png";

      case "BDT":
      case "৳":
      case "TK":
        return "assets/flags/bangladesh.png";

      default:
        return "assets/flags/default.png";
    }
  }

  String getDisplayCode({required String? code, required String? symbol}) {
    final currencyCode = code?.trim() ?? "";
    final currencySymbol = symbol?.trim() ?? "";

    if (currencyCode.isNotEmpty) {
      return currencyCode.toUpperCase();
    }

    if (currencySymbol.isNotEmpty) {
      return currencySymbol.toUpperCase();
    }

    return "-";
  }

  String getAmountInLetter({
    required String? amount,
    required String? apiAmountInLetter,
  }) {
    final apiText = apiAmountInLetter?.trim() ?? "";

    if (apiText.isNotEmpty) {
      return apiText;
    }

    final amountText = amount?.trim() ?? "";

    if (amountText.isEmpty) {
      return "-";
    }

    final parsedAmount = double.tryParse(amountText);

    if (parsedAmount == null || !parsedAmount.isFinite) {
      return "-";
    }

    final wholeNumber = parsedAmount.truncate();
    final decimalText = amountText.contains(".")
        ? amountText.split(".").last
        : "";

    String result = numberToEnglishWords(wholeNumber);

    final cleanedDecimal = decimalText.replaceFirst(RegExp(r'0+$'), "");

    if (cleanedDecimal.isNotEmpty) {
      final decimalWords = cleanedDecimal
          .split("")
          .map((digit) {
            final value = int.tryParse(digit);

            if (value == null) {
              return "";
            }

            return numberToEnglishWords(value);
          })
          .where((word) => word.isNotEmpty)
          .join(" ");

      if (decimalWords.isNotEmpty) {
        result = "$result Point $decimalWords";
      }
    }

    return result.trim().isEmpty ? "-" : result.trim();
  }

  String numberToEnglishWords(int number) {
    if (number == 0) {
      return "Zero";
    }

    if (number < 0) {
      return "Minus ${numberToEnglishWords(number.abs())}";
    }

    const belowTwenty = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen",
    ];

    const tens = [
      "",
      "",
      "Twenty",
      "Thirty",
      "Forty",
      "Fifty",
      "Sixty",
      "Seventy",
      "Eighty",
      "Ninety",
    ];

    String convertBelowThousand(int value) {
      final words = <String>[];
      var remainingValue = value;

      if (remainingValue >= 100) {
        words.add("${belowTwenty[remainingValue ~/ 100]} Hundred");

        remainingValue %= 100;
      }

      if (remainingValue >= 20) {
        words.add(tens[remainingValue ~/ 10]);

        if (remainingValue % 10 != 0) {
          words.add(belowTwenty[remainingValue % 10]);
        }
      } else if (remainingValue > 0) {
        words.add(belowTwenty[remainingValue]);
      }

      return words.join(" ");
    }

    final words = <String>[];
    var remainingNumber = number;

    if (remainingNumber >= 1000000000000) {
      words.add(
        "${numberToEnglishWords(remainingNumber ~/ 1000000000000)} Trillion",
      );

      remainingNumber %= 1000000000000;
    }

    if (remainingNumber >= 1000000000) {
      words.add(
        "${numberToEnglishWords(remainingNumber ~/ 1000000000)} Billion",
      );

      remainingNumber %= 1000000000;
    }

    if (remainingNumber >= 1000000) {
      words.add("${numberToEnglishWords(remainingNumber ~/ 1000000)} Million");

      remainingNumber %= 1000000;
    }

    if (remainingNumber >= 1000) {
      words.add("${numberToEnglishWords(remainingNumber ~/ 1000)} Thousand");

      remainingNumber %= 1000;
    }

    if (remainingNumber > 0) {
      words.add(convertBelowThousand(remainingNumber));
    }

    return words.join(" ").trim();
  }

  String getRateDescription({
    required String? apiDescription,
    required String amountInLetter,
    required String fromName,
    required String toName,
    required String buyingRate,
    required String sellingRate,
    required String toCurrencyCode,
  }) {
    final description = apiDescription?.trim() ?? "";

    if (description.isNotEmpty) {
      return description;
    }

    return "$amountInLetter $fromName to $toName. "
        "Buying $buyingRate $toCurrencyCode, "
        "Selling $sellingRate $toCurrencyCode.";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF1F3FF),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
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
                          languagesController.tr("HAWALA_RATES"),
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
            const SizedBox(height: 10),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: Obx(() {
                    if (hawalacurrencycontroller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final rates =
                        hawalacurrencycontroller
                            .allcurrencylist
                            .value
                            .data
                            ?.rates ??
                        [];

                    if (rates.isEmpty) {
                      return Center(
                        child: Text(
                          languagesController.tr("NO_DATA_FOUND"),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    final fontFamily = box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null;

                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(fontFamily: fontFamily),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: rates.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final data = rates[index];
                                final amount = _displayText(data.amount);
                                final amountInLetter = getAmountInLetter(
                                  amount: data.amount?.toString(),
                                  apiAmountInLetter: data.amountInLetter
                                      ?.toString(),
                                );
                                final fromName = getLocalizedCurrencyName(
                                  code: data.fromCurrency?.code?.toString(),
                                  fallbackName: data.fromCurrency?.name
                                      ?.toString(),
                                );
                                final toName = getLocalizedCurrencyName(
                                  code: data.toCurrency?.code?.toString(),
                                  fallbackName: data.toCurrency?.name
                                      ?.toString(),
                                );
                                final fromCode = getDisplayCode(
                                  code: data.fromCurrency?.code?.toString(),
                                  symbol: data.fromCurrency?.symbol?.toString(),
                                );
                                final toCode = getDisplayCode(
                                  code: data.toCurrency?.code?.toString(),
                                  symbol: data.toCurrency?.symbol?.toString(),
                                );
                                final fromFlag = getCurrencyFlag(
                                  code: data.fromCurrency?.code?.toString(),
                                  symbol: data.fromCurrency?.symbol?.toString(),
                                );
                                final toFlag = getCurrencyFlag(
                                  code: data.toCurrency?.code?.toString(),
                                  symbol: data.toCurrency?.symbol?.toString(),
                                );
                                final buyingRate = _displayText(data.buyRate);
                                final sellingRate = _displayText(data.sellRate);
                                final description = getRateDescription(
                                  apiDescription: data.description?.toString(),
                                  amountInLetter: amountInLetter,
                                  fromName: fromName,
                                  toName: toName,
                                  buyingRate: buyingRate,
                                  sellingRate: sellingRate,
                                  toCurrencyCode: toCode,
                                );

                                return Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF8FAFF),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xffDDE7FF),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 10,
                                        ),
                                        child: Table(
                                          columnWidths: _columnWidths,
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(
                                              children: [
                                                _buildAmountCell(
                                                  amount: amount,
                                                  amountInLetter:
                                                      amountInLetter,
                                                  fontFamily: fontFamily,
                                                ),
                                                _buildCurrencyCell(
                                                  flag: fromFlag,
                                                  name: fromName,
                                                  code: fromCode,
                                                  fontFamily: fontFamily,
                                                ),
                                                _buildCurrencyCell(
                                                  flag: toFlag,
                                                  name: toName,
                                                  code: toCode,
                                                  fontFamily: fontFamily,
                                                ),
                                                _buildRateCell(
                                                  rate: buyingRate,
                                                  code: toCode,
                                                  color: const Color(
                                                    0xff16A34A,
                                                  ),
                                                  fontFamily: fontFamily,
                                                ),
                                                _buildRateCell(
                                                  rate: sellingRate,
                                                  code: toCode,
                                                  color: const Color(
                                                    0xffDC2626,
                                                  ),
                                                  fontFamily: fontFamily,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xffDDE7FF),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          description,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                            height: 1.4,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keep header and rate rows aligned using identical column widths.
  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FlexColumnWidth(2),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(3),
    3: FlexColumnWidth(2),
    4: FlexColumnWidth(2),
  };

  String _displayText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? '-' : text;
  }

  Widget _buildTableHeader({String? fontFamily}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF1F3FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffDDE7FF)),
      ),
      child: Table(
        columnWidths: _columnWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              _buildHeaderCell(
                title: languagesController.tr("AMOUNT"),
                subtitle: languagesController.tr("IN_LETTER"),
                icon: Icons.payments_outlined,
                color: const Color(0xff0B5ED7),
                fontFamily: fontFamily,
              ),
              _buildHeaderCell(
                title: languagesController.tr("FROM"),
                icon: Icons.flag_rounded,
                color: const Color(0xff0B5ED7),
                fontFamily: fontFamily,
              ),
              _buildHeaderCell(
                title: languagesController.tr("TO"),
                icon: Icons.flag_rounded,
                color: const Color(0xff0B5ED7),
                fontFamily: fontFamily,
              ),
              _buildHeaderCell(
                title: languagesController.tr("BUYING"),
                icon: Icons.shopping_cart_outlined,
                color: const Color(0xff16A34A),
                fontFamily: fontFamily,
              ),
              _buildHeaderCell(
                title: languagesController.tr("SELLING"),
                icon: Icons.sell_outlined,
                color: const Color(0xffDC2626),
                fontFamily: fontFamily,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell({
    required String title,
    required IconData icon,
    required Color color,
    String? subtitle,
    String? fontFamily,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              fontFamily: fontFamily,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 8,
                fontFamily: fontFamily,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountCell({
    required String amount,
    required String amountInLetter,
    String? fontFamily,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: const BoxDecoration(
        border: BorderDirectional(end: BorderSide(color: Color(0xffDDE7FF))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: const Color(0xff0B5ED7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amountInLetter,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 9,
              height: 1.3,
              fontFamily: fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCell({
    required String flag,
    required String name,
    required String code,
    String? fontFamily,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              flag,
              height: 22,
              width: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/flags/default.png',
                height: 22,
                width: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 22,
                  width: 30,
                  child: Icon(
                    Icons.flag_outlined,
                    size: 20,
                    color: Color(0xff0B5ED7),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            code,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 9,
              fontFamily: fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCell({
    required String rate,
    required String code,
    required Color color,
    String? fontFamily,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rate,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: fontFamily,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: color.withOpacity(0.20)),
            ),
            child: Text(
              code,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

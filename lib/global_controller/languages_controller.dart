import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguagesController extends GetxController {
  final box = GetStorage();

  /// Text / App Language
  RxString selectedlan = "En".obs;

  /// শুধুমাত্র Number/Digit Language
  RxString selectedNumberLanguage = "En".obs;

  RxMap<String, String> currentlanguage = <String, String>{}.obs;

  List<Map<String, String>> alllanguagedata = [
    {
      "name": "En",
      "fullname": "English",
      "isoCode": "en",
      "region": "US",
      "direction": "ltr",
    },
    {
      "name": "Fa",
      "fullname": "فارسی",
      "isoCode": "fa",
      "region": "IR",
      "direction": "rtl",
    },
    {
      "name": "Ar",
      "fullname": "العربية",
      "isoCode": "ar",
      "region": "AE",
      "direction": "rtl",
    },
    {
      "name": "Tr",
      "fullname": "Türkçe",
      "isoCode": "tr",
      "region": "TR",
      "direction": "ltr",
    },
    {
      "name": "Ps",
      "fullname": "پښتو",
      "isoCode": "ps",
      "region": "AF",
      "direction": "rtl",
    },
    {
      "name": "Bn",
      "fullname": "বাংলা",
      "isoCode": "bn",
      "region": "BD",
      "direction": "ltr",
    },
  ];

  @override
  void onInit() {
    super.onInit();

    /// Previously selected text language
    final savedLanguage = box.read("language") ?? "En";

    /// Previously selected number language
    final savedNumberLanguage = box.read("number_language") ?? "En";

    selectedNumberLanguage.value = savedNumberLanguage;

    changeLanguage(savedLanguage);
  }

  /// Load JSON file using full locale
  Future<void> loadLanguageByLocale(String isoCode, String regionCode) async {
    final localeKey = "$isoCode-$regionCode";

    try {
      print("📂 Loading JSON: assets/langs/$localeKey.json");

      String jsonString = await rootBundle.loadString(
        "assets/langs/$localeKey.json",
      );

      Map<String, dynamic> jsonData = json.decode(jsonString);

      currentlanguage.clear();

      currentlanguage.addAll(
        jsonData.map((key, value) => MapEntry(key, value.toString())),
      );
    } catch (e) {
      print("❌ Error loading language file: $e");
    }
  }

  /// Change normal app/text language
  void changeLanguage(String languageShortName) {
    print("🔄 Changing Language to: $languageShortName");

    selectedlan.value = languageShortName;

    final matchedLang = alllanguagedata.firstWhere(
      (lang) => lang["name"] == languageShortName,
      orElse: () => {"isoCode": "en", "region": "US"},
    );

    final iso = matchedLang["isoCode"]!;
    final region = matchedLang["region"]!;

    box.write("language", languageShortName);

    loadLanguageByLocale(iso, region);
  }

  /// শুধুমাত্র Number/Digit language change করবে
  void changeNumberLanguage(String languageShortName) {
    print("🔢 Changing Number Language to: $languageShortName");

    selectedNumberLanguage.value = languageShortName;

    box.write("number_language", languageShortName);
  }

  /// Translate normal text
  String tr(String key) {
    return currentlanguage[key] ?? key;
  }

  /// যেকোনো String এর মধ্যে শুধু 0-9 digit পরিবর্তন করবে
  String number(String value) {
    switch (selectedNumberLanguage.value) {
      case "Fa":
      case "Ps":
        return _convertToPersianDigits(value);

      case "Ar":
        return _convertToArabicDigits(value);

      case "Bn":
        return _convertToBanglaDigits(value);

      case "En":
      case "Tr":
      default:
        return _convertToEnglishDigits(value);
    }
  }

  String _convertToPersianDigits(String value) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    /// আগে অন্য language-এর digit থাকলেও English এ convert
    value = _convertToEnglishDigits(value);

    for (int i = 0; i < english.length; i++) {
      value = value.replaceAll(english[i], persian[i]);
    }

    return value;
  }

  String _convertToArabicDigits(String value) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    value = _convertToEnglishDigits(value);

    for (int i = 0; i < english.length; i++) {
      value = value.replaceAll(english[i], arabic[i]);
    }

    return value;
  }

  String _convertToBanglaDigits(String value) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    value = _convertToEnglishDigits(value);

    for (int i = 0; i < english.length; i++) {
      value = value.replaceAll(english[i], bangla[i]);
    }

    return value;
  }

  /// Persian / Arabic / Bangla digit থেকে English digit
  String _convertToEnglishDigits(String value) {
    const foreignDigits = {
      /// Persian
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',

      /// Arabic
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',

      /// Bangla
      '০': '0',
      '১': '1',
      '২': '2',
      '৩': '3',
      '৪': '4',
      '৫': '5',
      '৬': '6',
      '৭': '7',
      '৮': '8',
      '৯': '9',
    };

    foreignDigits.forEach((key, digit) {
      value = value.replaceAll(key, digit);
    });

    return value;
  }
}

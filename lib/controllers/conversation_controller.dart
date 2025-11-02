import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/currency_model.dart';

class ConversationController extends GetxController {
  RxList<Currency> currencies = <Currency>[].obs;

  RxString selectedCurrency = "".obs;
  double resellerRate = 0.0;
  double currencyRate = 0.0;
  RxDouble inputAmount = 0.0.obs;
  final box = GetStorage();

  void resetConversion() {
    inputAmount.value = 0.0;
    resellerRate = 0.0;
    currencies.clear(); // যদি চাই সবকিছুই ফাঁকা হোক
  }

  List<Map<String, dynamic>> getConvertedValues() {
    double afnAmount = inputAmount.value;

    // Try to find AFN currency from the fetched list
    final afnCurrency = currencies.firstWhereOrNull((c) => c.code == "AFN");

    if (afnCurrency == null || afnCurrency.exchangeRatePerUsd == null) {
      return []; // যদি AFN না থাকে বা null থাকে, কিছুই রিটার্ন করো না
    }

    // Parse the AFN rate
    double? afnRate = double.tryParse(afnCurrency.exchangeRatePerUsd!);
    if (afnRate == null || afnRate <= 0) return [];

    // Step 1: Convert AFN → USD
    double amountInUsd = afnAmount / afnRate;

    // Step 2: Convert USD → other currencies
    return currencies.where((c) => c.code != "AFN").map((c) {
      double rate = double.tryParse(c.exchangeRatePerUsd ?? "1") ?? 1;
      double converted = amountInUsd * rate;

      return {
        "name": c.name ?? "",
        "symbol": c.symbol ?? c.code,
        "code": c.code ?? "",
        "value": converted,
      };
    }).toList();
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/country_list_model.dart';
import '../models/currency_model.dart';
import '../services/currency_service.dart';
import 'conversation_controller.dart';

class CurrencyController extends GetxController {
  ConversationController conversationController =
      Get.put(ConversationController());
  var isLoading = false.obs;

  final box = GetStorage();

  var allcurrency = CurrencyModel().obs;

  void fetchCurrency() async {
    try {
      isLoading(true);
      await CurrencyApi().fetchcurrency().then((value) {
        allcurrency.value = value;

        if (allcurrency.value.data?.currencies != null) {
          conversationController.currencies.clear();
          conversationController.currencies
              .addAll(allcurrency.value.data!.currencies!);

          String codeFromBox = box.read("currency_code") ?? "";

          Currency? matchedCurrency = allcurrency.value.data!.currencies!
              .firstWhereOrNull((currency) => currency.code == codeFromBox);
          if (matchedCurrency != null) {
            conversationController.resellerRate =
                double.tryParse(matchedCurrency.exchangeRatePerUsd!) ?? 0.0;
            print(
                "Matched Exchange Rate: ${matchedCurrency.exchangeRatePerUsd}");
          } else {
            print("Currency with code $codeFromBox not found.");
          }
          print(allcurrency.toString());
        }

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

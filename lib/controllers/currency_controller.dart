import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/country_list_model.dart';
import '../models/currency_model.dart';
import '../services/currency_service.dart';
import 'conversation_controller.dart';

class CurrencyController extends GetxController {
  @override
  void onInit() {
    fetchCurrencyList();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcurrencylist = CurrencyModel().obs;

  void fetchCurrencyList() async {
    try {
      isLoading(true);
      await CurrencyApi().fetchcurrency().then((value) {
        allcurrencylist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

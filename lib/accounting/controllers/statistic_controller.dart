import 'package:get/get.dart';

import '../models/statistic_model.dart';
import '../services/statistic_service.dart';

class StatisticController extends GetxController {
  var isLoading = false.obs;

  var allstatiscic = StatisticsModel().obs;

  final RxInt selectedCurrencyIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchstatistic();
  }

  List<BalanceSummaryByCurrency> get currencyList {
    return allstatiscic.value.data?.balanceSummary?.byCurrency ?? [];
  }

  BalanceSummaryByCurrency? get selectedCurrencyData {
    final list = currencyList;

    if (list.isEmpty) {
      return null;
    }

    if (selectedCurrencyIndex.value >= list.length) {
      selectedCurrencyIndex.value = 0;
    }

    return list[selectedCurrencyIndex.value];
  }

  void selectCurrency(int index) {
    selectedCurrencyIndex.value = index;
  }

  Future<void> fetchstatistic() async {
    try {
      isLoading(true);

      final value = await StatisticService().fetchstatistic();

      allstatiscic.value = value;
      selectedCurrencyIndex.value = 0;
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }
}

import 'package:get/get.dart';
import '../models/wallet_summary_model.dart';
import '../services/wallet_summary_service.dart';

class WalletSummaryController extends GetxController {
  var isLoading = false.obs;

  var allsummary = WalletSummaryModel().obs;

  void fetchsummary() async {
    try {
      isLoading(true);
      await WalletSummaryApi().fetchsummary().then((value) {
        allsummary.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

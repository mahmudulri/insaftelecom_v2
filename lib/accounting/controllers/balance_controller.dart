import 'package:get/get.dart';
import '../models/balance_model.dart';
import '../models/branch_model.dart';
import '../services/balance_service.dart';

class BalanceController extends GetxController {
  var isLoading = false.obs;

  var balance = BalanceModel().obs;

  void fetchbalance(id) async {
    try {
      isLoading(true);
      await BalanceApi().fetchbalance(id).then((value) {
        balance.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

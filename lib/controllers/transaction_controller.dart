import 'package:get/get.dart';

import '../models/dashboard_data_model.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionController extends GetxController {
  // @override
  // void onInit() {
  //   fetchTransactionData();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  var alltransactionlist = TransactionModel().obs;

  void fetchTransactionData() async {
    try {
      isLoading(true);
      await TransactionApi().fetchTransaction(1).then((value) {
        alltransactionlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:get/get.dart';

import '../models/account_transactions_model.dart';
import '../services/account_transaction_service.dart';

class AccountTransactionController extends GetxController {
  int initialpage = 1;

  RxList<Transaction> finalList = <Transaction>[].obs;

  var isLoading = false.obs;

  var alltransactions = AccountTransactionsModel().obs;

  Future<void> fetchtransactions() async {
    try {
      isLoading(true);
      await AccountTransactionApi().fetchtransactions(initialpage).then((
        value,
      ) {
        alltransactions.value = value;

        if (alltransactions.value.data?.transactions != null) {
          finalList.addAll(alltransactions.value.data!.transactions!);
        }

        // print(alltransactions.value.toJson());

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:get/get.dart';
import '../models/transaction_of_account_model.dart';
import '../services/transaction_of_account_service.dart';

class TransactionsOfAccountController extends GetxController {
  var isLoading = false.obs;

  var alltransactions = TransactionsofAccountModel().obs;

  Future fetchdata(id) async {
    try {
      isLoading(true);
      await TransactionOfAccountApi().fetchtransactions(id).then((value) {
        alltransactions.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

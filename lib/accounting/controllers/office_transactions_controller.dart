import 'package:get/get.dart';

import '../models/office_list_model.dart';
import '../models/office_withtransaction_model.dart';
import '../services/office_list_service.dart';
import '../services/office_transaction_service.dart';

class OfficeTransactionsListController extends GetxController {
  int initialpage = 1;

  RxList<Datum> finalList = <Datum>[].obs;

  var isLoading = false.obs;

  var alltransactionlist = OfficeTransactionModel().obs;

  void fetchtransactions(int officeId) async {
    try {
      isLoading(true);

      final value = await OfficeTransactionApi().fetchtransactions(
        initialpage,
        officeId,
      );
      alltransactionlist.value = value;

      final transactions =
          alltransactionlist.value.data?.office?.transactions?.data;
      if (transactions != null) {
        finalList.addAll(transactions);
      }

      // print(alltransactionlist.value.toJson());
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading(false);
    }
  }
}

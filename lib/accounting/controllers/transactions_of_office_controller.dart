import 'package:get/get.dart';

import '../models/transaction_of_office_model.dart';

import '../services/transactionof_office_service.dart';

class TransactionsOfOfficeController extends GetxController {
  var isLoading = false.obs;

  var alltransactions = TransactionsofOfficeModel().obs;

  Future fetchdata(id) async {
    try {
      isLoading(true);
      await TrasactionsofOfficeApi().fetchtransactions(id).then((value) {
        alltransactions.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

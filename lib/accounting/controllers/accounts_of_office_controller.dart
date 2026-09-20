import 'package:get/get.dart';
import '../models/accountof_office_model.dart';
import '../services/accountsof_office_service.dart';

class AccountsofOfficeController extends GetxController {
  var isLoading = false.obs;

  var accountsdetails = AccountofOfficeModel().obs;

  Future fetchdata(id) async {
    try {
      isLoading(true);
      await AccountsofOfficeApi().fetchaccountlist(id).then((value) {
        accountsdetails.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

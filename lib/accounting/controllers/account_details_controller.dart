import 'package:get/get.dart';
import '../models/accountdetails_model.dart';
import '../services/account_details_service.dart';

class AccountDetailsController extends GetxController {
  var isLoading = false.obs;

  var alldata = AccountDetailsModel().obs;

  Future fetchdata(id) async {
    try {
      isLoading(true);
      await AccountDetailsApi().fetchdetails(id).then((value) {
        alldata.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

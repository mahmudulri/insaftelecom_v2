import 'package:get/get.dart';
import 'package:insaftelecom/accounting/models/party_accounts_model.dart';
import 'package:insaftelecom/accounting/services/party_accounts_service.dart';

class PartyAccountslistController extends GetxController {
  var isLoading = false.obs;

  RxList<Datum> accountlist = <Datum>[].obs;

  Future<void> fetchaccount(id) async {
    try {
      isLoading(true);
      await PartyAccountsApi().fetchaccounts(id).then((value) {
        accountlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

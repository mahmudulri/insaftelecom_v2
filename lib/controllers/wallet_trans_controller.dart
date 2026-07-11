import 'package:get/get.dart';
import '../models/wallet_transaction_model.dart';
import '../services/wallet_transaction_service.dart';

class WalletTransController extends GetxController {
  var isLoading = false.obs;

  var alltransactions = WalletTransactionModel().obs;

  void fetchtransaction(String walletID) async {
    try {
      isLoading(true);
      await WalletTransactionApi().fetchtransactions(walletID.toString()).then((
        value,
      ) {
        alltransactions.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

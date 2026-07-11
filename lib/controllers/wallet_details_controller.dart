import 'package:get/get.dart';
import '../models/wallet_details_model.dart';
import '../services/wallet_details_service.dart';

class WalletDetailsController extends GetxController {
  var isLoading = false.obs;

  var alldetails = WalletDetailsModel().obs;

  void fetchdetails(String id) async {
    try {
      isLoading(true);
      await WalletDetailsApi().fetchdetails(id.toString()).then((value) {
        alldetails.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:get/get.dart';
import '../models/walletsettings_model.dart';
import '../services/wallet_setting_service.dart';

class WalletSettingController extends GetxController {
  // @override
  // void onInit() {
  //   fetchsettings();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  var allsettings = WalletSettingsModel().obs;

  void fetchsettings() async {
    try {
      isLoading(true);
      await WalletSettingsApi().fetchwalletsettings().then((value) {
        allsettings.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

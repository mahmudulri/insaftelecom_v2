import 'package:get/get.dart';
import '../models/recharge_config_model.dart';
import '../services/recharge_config_service.dart';

class RechargeConfigController extends GetxController {
  var isLoading = false.obs;

  var allsettings = RechargeConfigModel().obs;

  void fetchrechargeConfig() async {
    try {
      isLoading(true);
      await RechargeConfigApi().fetchconfig().then((value) {
        allsettings.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

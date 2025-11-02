import 'package:get/get.dart';

import '../models/help_model.dart';

import '../services/help_service.dart';

class HelpController extends GetxController {
  @override
  void onInit() {
    helpService();
    super.onInit();
  }

  var isLoading = false.obs;

  var helpdata = HelpModel().obs;

  void helpService() async {
    try {
      isLoading(true);
      await HelpServiceApi().fetchhelpdata().then((value) {
        helpdata.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

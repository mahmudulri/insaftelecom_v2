import 'package:get/get.dart';

import '../models/sub_reseller_model.dart';
import '../services/sub_reseller_service.dart';

class SubresellerController extends GetxController {
  @override
  void onInit() {
    fetchSubReseller();
    super.onInit();
  }

  var isLoading = false.obs;

  var allsubresellerData = SubResellerModel().obs;

  void fetchSubReseller() async {
    try {
      isLoading(true);
      await SubResellerApi().fetchSubReseller().then((value) {
        allsubresellerData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

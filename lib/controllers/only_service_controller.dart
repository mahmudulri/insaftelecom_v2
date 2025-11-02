import 'package:get/get.dart';

import '../models/commision_group_model.dart';
import '../models/service_model.dart';
import '../services/commsion_grouplist_service.dart';
import '../services/only_service.dart';

class OnlyServiceController extends GetxController {
  @override
  void onInit() {
    fetchservices();
    super.onInit();
  }

  var isLoading = false.obs;

  var allservices = ServiceModel().obs;

  void fetchservices() async {
    try {
      isLoading(true);
      await OnlyServiceListApi().fetchservicelist().then((value) {
        allservices.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

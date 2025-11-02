import 'package:get/get.dart';

import '../models/commision_group_model.dart';
import '../services/commsion_grouplist_service.dart';

class CommissionGroupController extends GetxController {
  @override
  void onInit() {
    fetchGrouplist();
    super.onInit();
  }

  var isLoading = false.obs;

  var allgrouplist = ComissionGroupModel().obs;

  void fetchGrouplist() async {
    try {
      isLoading(true);
      await ComissionGroupApi().fetchgroup().then((value) {
        allgrouplist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

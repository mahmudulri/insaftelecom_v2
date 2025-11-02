import 'package:get/get.dart';
import 'package:insaftelecom/services/dashboard_service.dart';

import '../global_controller/balance_controller.dart';
import '../models/dashboard_data_model.dart';

class DashboardController extends GetxController {
  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  var isLoading = false.obs;

  var alldashboardData = DashboardDataModel().obs;

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  void fetchDashboardData() async {
    try {
      isLoading(true);
      await DashboardApi().fetchDashboard().then((value) {
        alldashboardData.value = value;
        userBalanceController.balance.value = alldashboardData
            .value
            .data!
            .balance
            .toString();
        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

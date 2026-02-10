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

  void onhomeTabOpened() {
    fetchDashboardData();
  }

  void setDeactivated(String status, String message) {
    deactiveStatus.value = status;
    deactivateMessage.value = message;
  }

  var isLoading = false.obs;

  final deactiveStatus = ''.obs;
  final deactivateMessage = ''.obs;

  var alldashboardData = DashboardDataModel().obs;

  UserBalanceController userBalanceController = Get.put(
    UserBalanceController(),
  );

  void fetchDashboardData() async {
    try {
      isLoading(true);
      await DashboardApi().fetchDashboard().then((value) {
        alldashboardData.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

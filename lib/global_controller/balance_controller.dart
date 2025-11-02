import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class UserBalanceController extends GetxController {
  var isLoading = false.obs;

  RxString balance = ''.obs;
  RxString comission = ''.obs;
  RxString todayvalue = ''.obs;
}

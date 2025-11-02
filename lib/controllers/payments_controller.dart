import 'package:get/get.dart';
import 'package:insaftelecom/models/province_model.dart';
import 'package:insaftelecom/services/province_service.dart';

import '../models/country_list_model.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentsController extends GetxController {
  // @override
  // void onInit() {
  //   fetchpayments();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  var allpaymentslist = PaymentsModel().obs;

  void fetchpayments() async {
    try {
      isLoading(true);
      await PaymentsApi().fetchpayments().then((value) {
        allpaymentslist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

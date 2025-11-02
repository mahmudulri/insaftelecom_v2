import 'package:get/get.dart';
import '../models/payment_method_model.dart';
import '../models/payment_type_model.dart';
import '../services/payment_method_service.dart';
import '../services/payment_type_service.dart';

class PaymentTypeController extends GetxController {
  var isLoading = false.obs;

  var alltypes = PaymentTypeModel().obs;

  void fetchtypes() async {
    try {
      isLoading(true);
      await PaymentTypeApi().fetchtypes().then((value) {
        alltypes.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

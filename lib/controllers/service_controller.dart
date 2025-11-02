import 'package:get/get.dart';

import '../models/service_model.dart';
import '../services/service_service.dart';

class ServiceController extends GetxController {
  @override
  void onInit() {
    fetchservices();
    super.onInit();
  }

  var isLoading = false.obs;
  List reserveDigit = [];

  var allserviceslist = ServiceModel().obs;

  void fetchservices() async {
    try {
      isLoading(true);
      await ServiceListApi().fetchservicelist().then((value) {
        allserviceslist.value = value;

        reserveDigit.clear();
        value.data?.services.forEach((service) {
          service.company?.companycodes?.forEach((companycode) {
            if (companycode.reservedDigit != null) {
              reserveDigit.add(companycode.reservedDigit!);
            }
          });
        });

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

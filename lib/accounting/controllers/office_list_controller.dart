import 'package:get/get.dart';

import '../models/office_list_model.dart';
import '../services/office_list_service.dart';

class OfficeListController extends GetxController {
  int initialpage = 1;

  RxList<Office> finalList = <Office>[].obs;

  var isLoading = false.obs;

  var allofficelist = OfficelistModel().obs;

  Future fetchofficelist() async {
    try {
      isLoading(true);
      await OfficeListApi().fetchoffice(initialpage).then((value) {
        allofficelist.value = value;

        if (allofficelist.value.data != null) {
          finalList.addAll(allofficelist.value.data!.offices!);
        }

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:get/get.dart';

import '../models/hawala_list_model.dart';
import '../services/hawala_list_service.dart';

class HawalaListController extends GetxController {
  int initialpage = 1;

  RxList<Order> finalList = <Order>[].obs;

  var isLoading = false.obs;

  var allhawalalist = HawalaModel().obs;

  void fetchhawala() async {
    try {
      isLoading(true);
      await HawalalistApi().fetchhawala(initialpage).then((value) {
        allhawalalist.value = value;

        if (allhawalalist.value.data!.orders != null) {
          finalList.addAll(allhawalalist.value.data!.orders!);
        }

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

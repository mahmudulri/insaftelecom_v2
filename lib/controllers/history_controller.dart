import 'package:get/get.dart';

import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryController extends GetxController {
  RxList finalList = <Order>[].obs;
  int initialpage = 1;

  var isLoading = false.obs;

  var allorderlist = HistoryModel().obs;

  void fetchHistory() async {
    try {
      isLoading(true);
      await HistoryServiceApi().fetchorderList(initialpage).then((value) {
        allorderlist.value = value;

        if (allorderlist.value.data != null) {
          finalList.addAll(allorderlist.value.data!.orders);
        }
        // print(finalList.length.toString());
        // finalList.forEach((order) {
        //   print(order.id.toString());
        // });

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

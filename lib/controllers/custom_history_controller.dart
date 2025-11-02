import 'package:get/get.dart';
import 'package:insaftelecom/models/custom_history_model.dart';
import 'package:insaftelecom/services/custom_recharge_history_service.dart';

class CustomHistoryController extends GetxController {
  RxList finalList = <Order>[].obs;
  int initialpage = 1;

  var isLoading = false.obs;

  var allorderlist = CustomHistoryModel().obs;

  void fetchHistory() async {
    try {
      isLoading(true);
      await CustomRechargeHistoryApi().fetchcustomhistory(initialpage).then((
        value,
      ) {
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

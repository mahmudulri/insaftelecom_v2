import 'package:get/get.dart';

import '../models/hawala_list_model.dart';
import '../models/transferlist_model.dart';
import '../services/hawala_list_service.dart';
import '../services/transferlist_service.dart';

class TransferlistController extends GetxController {
  var isLoading = false.obs;

  var alltransferlist = TransferListModel().obs;

  void fetchdata() async {
    try {
      isLoading(true);
      await TransferlistApi().fetchtransferlist().then((value) {
        alltransferlist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

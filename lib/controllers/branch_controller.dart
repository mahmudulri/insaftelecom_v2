import 'package:get/get.dart';

import '../models/branch_model.dart';
import '../services/branch_service.dart';
import '../services/currency_service.dart';

class BranchController extends GetxController {
  var isLoading = false.obs;

  var allbranch = BranchModel().obs;

  void fetchallbranch() async {
    try {
      isLoading(true);
      await BranchApi().fetchBranch().then((value) {
        allbranch.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

import 'package:get/get.dart';

import '../models/selling_price_model.dart';
import '../services/selling_price_service.dart';

class SellingPriceController extends GetxController {
  // @override
  // void onInit() {
  //   fetchhawala();
  //   super.onInit();
  // }

  var isLoading = false.obs;

  var allpricelist = SellingpriceModel().obs;

  void fetchpriceData() async {
    try {
      isLoading(true);
      await SellingPriceApi().fetchsellingprice().then((value) {
        allpricelist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

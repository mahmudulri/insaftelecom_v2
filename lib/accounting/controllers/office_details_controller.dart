import 'package:get/get.dart';
import 'package:insaftelecom/accounting/services/office_details_service.dart';

import '../models/office_details_model.dart';

class OfficeDetailsController extends GetxController {
  var isLoading = false.obs;

  var allofficedata = OfficeDetailsModel().obs;

  Future fetchdata(id) async {
    try {
      isLoading(true);
      await OfficeDetailsApi().fetchoffice(id).then((value) {
        allofficedata.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

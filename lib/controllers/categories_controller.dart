import 'package:get/get.dart';
import 'package:insaftelecom/models/service_category_model.dart';

import '../services/category_service.dart';

class CategorisListController extends GetxController {
  @override
  void onInit() {
    fetchcategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var allcategorieslist = CategoriesModel().obs;

  void fetchcategories() async {
    try {
      isLoading(true);
      await CategoriesListApi().fetchcategoriesList().then((value) {
        // Filter to keep only categories that have services
        value.data!.servicecategories!.removeWhere(
          (category) => category.services == null || category.services!.isEmpty,
        );

        // Assign filtered list to observable
        allcategorieslist.value = value;

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

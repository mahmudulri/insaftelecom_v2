import 'package:get/get.dart';
import 'package:insaftelecom/services/country_list_service.dart';
import 'package:get_storage/get_storage.dart';
import '../models/country_list_model.dart';

class CountryListController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var finalCountryList = [];
  var countrycodelist = <String>[].obs;
  var flagimageurl = "";

  var allcountryListData = CountryListModel().obs;

  void fetchCountryData() async {
    try {
      isLoading(true);
      await CountryListApi().fetchCountryList().then((value) {
        allcountryListData.value = value;

        finalCountryList = allcountryListData.toJson()['data']['countries'];
        final storedCountryId = box.read("countryID");
        // 🔹 Find the matching country
        final matchedCountry = finalCountryList.firstWhere(
          (country) => country['id'].toString() == storedCountryId.toString(),
          orElse: () => null,
        );
        if (matchedCountry != null) {
          flagimageurl = matchedCountry['country_flag_image_url'] ?? "";
        }

        countrycodelist.value = finalCountryList
            .map((country) => country['country_telecom_code']?.toString() ?? "")
            .toList();

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}

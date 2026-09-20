import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/country_list_model.dart';
import '../services/country_list_service.dart';

class CountryListController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;

  final RxList<Country> finalCountryList = <Country>[].obs;

  final RxList<String> countrycodelist = <String>[].obs;

  final RxString flagimageurl = "".obs;

  final Rx<CountryListModel> allcountryListData = CountryListModel().obs;

  Future<void> fetchCountryData() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final CountryListModel response = await CountryListApi()
          .fetchCountryList();

      allcountryListData.value = response;

      final List<Country> countries = response.data?.countries ?? <Country>[];

      finalCountryList.assignAll(countries);

      final dynamic storedCountryId = box.read("countryID");

      Country? matchedCountry;

      for (final Country country in countries) {
        if (country.id.toString() == storedCountryId.toString()) {
          matchedCountry = country;
          break;
        }
      }

      flagimageurl.value = matchedCountry?.countryFlagImageUrl ?? "";

      countrycodelist.assignAll(
        countries
            .map((Country country) => country.countryTelecomCode ?? "")
            .toList(),
      );
    } catch (e, stackTrace) {
      print("Country list API error: $e");

      print(
        "Country list stack trace: "
        "$stackTrace",
      );

      finalCountryList.clear();
      countrycodelist.clear();
      flagimageurl.value = "";
    } finally {
      isLoading.value = false;
    }
  }
}

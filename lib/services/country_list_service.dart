import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/country_list_model.dart';
import '../utils/api_endpoints.dart';

class CountryListApi {
  final box = GetStorage();
  Future<CountryListModel> fetchCountryList() async {
    final url = Uri.parse(ApiEndPoints.publicUrl + "countries");
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );
    final decodedBody = json.decode(response.body);

    if (response.statusCode == 200) {
      // print(response.body);
      final countryModel = CountryListModel.fromJson(
        json.decode(response.body),
      );

      Country? afghanistan;
      try {
        afghanistan = countryModel.data?.countries.firstWhere(
          (c) => c.countryName == "Afghanistan",
        );
      } catch (e) {
        afghanistan = null;
      }

      if (afghanistan != null) {
        // ✅ Save in GetStorage
        box.write("afghanistan_id", afghanistan.id);
        box.write("afghanistan_flag", afghanistan.countryFlagImageUrl);
        print(
          "Saved Afghanistan -> id: ${afghanistan.id}, flag: ${afghanistan.countryFlagImageUrl}",
        );
      } else {
        print("Afghanistan not found in country list");
      }

      return countryModel;
    } // 🔴 Handle 403 – account deactivated
    if (response.statusCode == 403) {
      Fluttertoast.showToast(
        msg: decodedBody['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      throw Exception(decodedBody['message'] ?? 'Your account is deactivated');
    }

    // 🔴 Handle all other errors
    throw Exception(decodedBody['message'] ?? 'Failed to fetch hawala list');
  }
}

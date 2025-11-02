import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/country_list_model.dart';
import '../utils/api_endpoints.dart';

class CountryListApi {
  final box = GetStorage();
  Future<CountryListModel> fetchCountryList() async {
    final url = Uri.parse(
        "https://app-api-vpro-wl-waslat.milliekit.com/api/public/countries");

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final countryModel =
          CountryListModel.fromJson(json.decode(response.body));

      return countryModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

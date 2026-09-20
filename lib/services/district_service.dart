import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/district_model.dart';

import '../models/country_list_model.dart';
import '../utils/api_endpoints.dart';

class DistrictApi {
  final box = GetStorage();
  Future<DistrictModel> fetchDistrict() async {
    final url = Uri.parse(ApiEndPoints.publicUrl + "districts");

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final districtModel = DistrictModel.fromJson(json.decode(response.body));

      return districtModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

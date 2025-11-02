import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/branch_model.dart';

import '../models/hawala_currency_model.dart';
import '../utils/api_endpoints.dart';

class HawalaCurrencyApi {
  final box = GetStorage();
  Future<HawalaCurrencyModel> fetchcurrency() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.hawalacurrency);
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final branchModel =
          HawalaCurrencyModel.fromJson(json.decode(response.body));

      return branchModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

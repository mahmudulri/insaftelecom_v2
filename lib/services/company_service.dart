import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/service_category_model.dart';

import '../models/companies_model.dart';
import '../utils/api_endpoints.dart';

class CompaniesApi {
  final box = GetStorage();
  Future<CompaniesModel> fetchcompanies() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.companies,
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final companiesModel = CompaniesModel.fromJson(
        json.decode(response.body),
      );

      return companiesModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

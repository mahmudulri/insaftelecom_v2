import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/bundle_model.dart';

import '../utils/api_endpoints.dart';

class BundlesApi {
  final box = GetStorage();
  Future<BundleModel> fetchBundles(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}bundles?page=$pageNo&country_id=${box.read("country_id")}&validity_type=${box.read("validity_type")}&per_page=15&company_id=${box.read("company_id")}&service_category_id=${box.read("service_category_id")}&search_tag=${box.read("search_tag")}",
    );
    print("bundles $url");

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      // print("body   ... " + response.body.toString());
      final bundleModel = BundleModel.fromJson(json.decode(response.body));

      return bundleModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

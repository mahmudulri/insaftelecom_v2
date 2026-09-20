import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/bundle_model.dart';

import '../utils/api_endpoints.dart';

class BundlesApi {
  final GetStorage box = GetStorage();

  /// Initial / normal bundle API
  Future<BundleModel> fetchBundles(int pageNo) async {
    final Uri url = Uri.parse("${ApiEndPoints.baseUrl}bundles").replace(
      queryParameters: {
        "page": pageNo.toString(),
        "country_id": box.read("country_id")?.toString() ?? "",
        "validity_type": box.read("validity_type")?.toString() ?? "",
        "per_page": "15",
        "company_id": box.read("company_id")?.toString() ?? "",
        "service_category_id":
            box.read("service_category_id")?.toString() ?? "",
        "search_tag": box.read("search_tag")?.toString() ?? "",
      },
    );

    print("Normal bundles URL: $url");

    final http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${box.read("userToken")}",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return BundleModel.fromJson(json.decode(response.body));
    }

    throw Exception("Failed to fetch bundles: ${response.statusCode}");
  }

  Future<BundleModel> fetchlookupBundles(String phoneNumber) async {
    final String cleanPhoneNumber = phoneNumber
        .trim()
        .replaceAll(" ", "")
        .replaceAll("-", "")
        .replaceAll("(", "")
        .replaceAll(")", "");

    if (cleanPhoneNumber.isEmpty) {
      throw Exception("Phone number is required for operator lookup.");
    }

    final Uri url = Uri.parse("${ApiEndPoints.baseUrl}bundles").replace(
      queryParameters: {
        "country_id": box.read("country_id")?.toString() ?? "",
        "service_category_id":
            box.read("service_category_id")?.toString() ?? "",
        "rechargeable_account": cleanPhoneNumber,
      },
    );

    print("Lookup bundles URL: $url");

    final http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${box.read("userToken")}",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return BundleModel.fromJson(json.decode(response.body));
    }

    throw Exception("Failed to fetch lookup bundles: ${response.statusCode}");
  }
}

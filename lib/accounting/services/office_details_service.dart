import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import '../models/office_details_model.dart';

class OfficeDetailsApi {
  final box = GetStorage();
  Future<OfficeDetailsModel> fetchoffice(String officeID) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/offices/$officeID",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final officeDetailsModel = OfficeDetailsModel.fromJson(
        json.decode(response.body),
      );

      return officeDetailsModel;
    } else {
      throw Exception('Failed to fetch office list service');
    }
  }
}

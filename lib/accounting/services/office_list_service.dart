import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import '../models/office_list_model.dart';

class OfficeListApi {
  final box = GetStorage();
  Future<OfficelistModel> fetchoffice(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/offices?page=${pageNo}",
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final officelistModel = OfficelistModel.fromJson(
        json.decode(response.body),
      );

      return officelistModel;
    } else {
      throw Exception('Failed to fetch office list service');
    }
  }
}

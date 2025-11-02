import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/slider_model.dart';

import '../models/dashboard_data_model.dart';
import '../utils/api_endpoints.dart';

class SlidersApi {
  final box = GetStorage();
  Future<SliderModel> fetchSliders() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.sliders,
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.statusCode.toString());
      // print(response.body.toString());
      final dashboardModel = SliderModel.fromJson(json.decode(response.body));

      return dashboardModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/recharge_config_model.dart';

import '../utils/api_endpoints.dart';

class RechargeConfigApi {
  final box = GetStorage();
  Future<RechargeConfigModel> fetchconfig() async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.rechargeconfig}",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final rechargeconfigModel = RechargeConfigModel.fromJson(
        json.decode(response.body),
      );

      return rechargeconfigModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

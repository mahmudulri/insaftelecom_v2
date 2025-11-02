import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/custom_history_model.dart';

import '../controllers/order_list_controller.dart';

import '../models/sub_reseller_model.dart';
import '../utils/api_endpoints.dart';

class CustomRechargeHistoryApi {
  final box = GetStorage();
  Future<CustomHistoryModel> fetchcustomhistory(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}orders?page=${pageNo}&order_type=custom_recharge",
    );
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final customhistorymodel = CustomHistoryModel.fromJson(
        json.decode(response.body),
      );

      return customhistorymodel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

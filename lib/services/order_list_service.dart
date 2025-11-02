import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/orders_list_model.dart';

import '../utils/api_endpoints.dart';

class OrderListApi {
  // OrderlistController orderlistController = Get.put(OrderlistController());
  final box = GetStorage();
  Future<OrderListModel> fetchorderList(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}orders?page=$pageNo&${box.read("orderstatus").toString()}&${box.read("date")}",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final orderlistModel = OrderListModel.fromJson(
        json.decode(response.body),
      );

      return orderlistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

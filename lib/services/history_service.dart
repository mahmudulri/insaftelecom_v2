import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/history_model.dart';
import '../utils/api_endpoints.dart';

class HistoryServiceApi {
  // OrderlistController orderlistController = Get.put(OrderlistController());
  final box = GetStorage();
  Future<HistoryModel> fetchorderList(int pageNo) async {
    final url = Uri.parse(
        "${ApiEndPoints.baseUrl}orders?page=${pageNo}&${box.read("orderstatus").toString()}&selected_Date=&&");
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final orderlistModel = HistoryModel.fromJson(json.decode(response.body));

      return orderlistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

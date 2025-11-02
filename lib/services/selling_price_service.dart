import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/selling_price_model.dart';
import '../utils/api_endpoints.dart';

class SellingPriceApi {
  final box = GetStorage();
  Future<SellingpriceModel> fetchsellingprice() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.sellingprice);
    print("sellingprice $url");

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      // print(response.body.toString());

      final sellingpriceModel =
          SellingpriceModel.fromJson(json.decode(response.body));

      return sellingpriceModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

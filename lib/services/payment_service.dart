import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/orders_list_model.dart';

import '../models/payment_model.dart';
import '../utils/api_endpoints.dart';

class PaymentsApi {
  final box = GetStorage();
  Future<PaymentsModel> fetchpayments() async {
    final url = Uri.parse("${ApiEndPoints.baseUrl}reseller-payments");
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final paymentsModel = PaymentsModel.fromJson(json.decode(response.body));

      return paymentsModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

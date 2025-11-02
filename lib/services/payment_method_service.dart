import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/branch_model.dart';

import '../models/payment_method_model.dart';
import '../utils/api_endpoints.dart';

class PaymentMethodSApi {
  final box = GetStorage();
  Future<PaymentMethodModel> fetchmethod() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.paymentmethod);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final methodmodel =
          PaymentMethodModel.fromJson(json.decode(response.body));

      return methodmodel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

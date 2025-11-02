import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/branch_model.dart';

import '../models/payment_method_model.dart';
import '../models/payment_type_model.dart';
import '../utils/api_endpoints.dart';

class PaymentTypeApi {
  final box = GetStorage();
  Future<PaymentTypeModel> fetchtypes() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.paymenttypes);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final typesModel = PaymentTypeModel.fromJson(json.decode(response.body));

      return typesModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

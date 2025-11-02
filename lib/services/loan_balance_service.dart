import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/models/service_category_model.dart';

import '../models/loan_balance_model.dart';
import '../utils/api_endpoints.dart';

class LoanBalanceApi {
  final box = GetStorage();
  Future<LoanBalanceModel> fetchbalance() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.loanbalance,
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final loanbalanceModel = LoanBalanceModel.fromJson(
        json.decode(response.body),
      );

      return loanbalanceModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

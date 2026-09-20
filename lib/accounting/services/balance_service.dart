import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import '../models/balance_model.dart';
import '../models/branch_model.dart';

class BalanceApi {
  final box = GetStorage();
  Future<BalanceModel> fetchbalance(officeID) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl +
          "accounting/offices/${officeID}?include=accounts.transactions&include_summary=1",
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final balanceModel = BalanceModel.fromJson(json.decode(response.body));

      return balanceModel;
    } else {
      throw Exception('Failed to fetch balance services');
    }
  }
}

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';

import '../models/account_currency_model.dart';

class AccountingCurrencyApi {
  final box = GetStorage();
  Future<AccountCurrencyModel> fetchCurrency() async {
    final url = Uri.parse(ApiEndPoints.baseUrl + "accounting/currencies");

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final currencyModel = AccountCurrencyModel.fromJson(
        json.decode(response.body),
      );

      return currencyModel;
    } else {
      throw Exception('Failed to fetch accounting currency services');
    }
  }
}

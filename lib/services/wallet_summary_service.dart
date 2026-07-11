import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallet_summary_model.dart';

import '../utils/api_endpoints.dart';

class WalletSummaryApi {
  final box = GetStorage();
  Future<WalletSummaryModel> fetchsummary() async {
    final url = Uri.parse(ApiEndPoints.baseUrl + "wallets/summary");
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final walletsummaryMode = WalletSummaryModel.fromJson(
        json.decode(response.body),
      );

      return walletsummaryMode;
    } else {
      throw Exception('Failed to fetch walletsummary');
    }
  }
}

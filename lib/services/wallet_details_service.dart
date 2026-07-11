import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallet_details_model.dart';
import '../models/wallet_summary_model.dart';

import '../utils/api_endpoints.dart';

class WalletDetailsApi {
  final box = GetStorage();
  Future<WalletDetailsModel> fetchdetails(String id) async {
    final url = Uri.parse(ApiEndPoints.baseUrl + "wallets/$id");

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final walletdetailsmodel = WalletDetailsModel.fromJson(
        json.decode(response.body),
      );

      return walletdetailsmodel;
    } else {
      throw Exception('Failed to fetch walletdetailsmodel');
    }
  }
}

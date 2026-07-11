import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallet_transaction_model.dart';
import '../utils/api_endpoints.dart';

class WalletTransactionApi {
  final box = GetStorage();
  Future<WalletTransactionModel> fetchtransactions(String walletID) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl +
          "wallets/transactions?wallet_id=$walletID&limit=50&category=order",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final transactionmodel = WalletTransactionModel.fromJson(
        json.decode(response.body),
      );

      return transactionmodel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

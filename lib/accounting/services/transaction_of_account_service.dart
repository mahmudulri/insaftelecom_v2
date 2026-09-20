import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/transaction_of_account_model.dart';

class TransactionOfAccountApi {
  final box = GetStorage();
  Future<TransactionsofAccountModel> fetchtransactions(id) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + "accounting/accounts/${id}/transactions",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );
    // print(response.body.toString());

    if (response.statusCode == 200) {
      final transactionlistmodel = TransactionsofAccountModel.fromJson(
        json.decode(response.body),
      );

      return transactionlistmodel;
    } else {
      throw Exception('Failed to fetch transaction of account service');
    }
  }
}

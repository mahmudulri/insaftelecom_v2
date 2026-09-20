import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/account_transactions_model.dart';

class AccountTransactionApi {
  final box = GetStorage();
  Future<AccountTransactionsModel> fetchtransactions(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/transactions?page=${pageNo}&per_page=25",
    );
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final alltransactions = AccountTransactionsModel.fromJson(
        json.decode(response.body),
      );

      return alltransactions;
    } else {
      throw Exception('Failed to fetch accounting transactions service');
    }
  }
}

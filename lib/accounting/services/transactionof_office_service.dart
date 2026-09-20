import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/transaction_of_office_model.dart';

class TrasactionsofOfficeApi {
  final box = GetStorage();
  Future<TransactionsofOfficeModel> fetchtransactions(id) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + "accounting/offices/${id}?include=transactions",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      final transactionlistmodel = TransactionsofOfficeModel.fromJson(
        json.decode(response.body),
      );

      return transactionlistmodel;
    } else {
      throw Exception('Failed to fetch transaction of office');
    }
  }
}

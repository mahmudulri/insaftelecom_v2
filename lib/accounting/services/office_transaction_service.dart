import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import '../models/office_withtransaction_model.dart';

class OfficeTransactionApi {
  final box = GetStorage();
  Future<OfficeTransactionModel> fetchtransactions(int pageNo, int id) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/offices/${id}?page=${pageNo}&include=transactions",
    );
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final transactionsModel = OfficeTransactionModel.fromJson(
        json.decode(response.body),
      );

      return transactionsModel;
    } else {
      throw Exception('Failed to fetch office transactions');
    }
  }
}

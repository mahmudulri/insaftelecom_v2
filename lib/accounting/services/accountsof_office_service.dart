import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/accountof_office_model.dart';

class AccountsofOfficeApi {
  final box = GetStorage();
  Future<AccountofOfficeModel> fetchaccountlist(id) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + "accounting/offices/${id}?include=accounts",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      final accountlistModel = AccountofOfficeModel.fromJson(
        json.decode(response.body),
      );

      return accountlistModel;
    } else {
      throw Exception('Failed to fetch account of office services');
    }
  }
}

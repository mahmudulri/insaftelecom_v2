import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/accountdetails_model.dart';

class AccountDetailsApi {
  final box = GetStorage();
  Future<AccountDetailsModel> fetchdetails(id) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + "accounting/accounts/${id}/statistics",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );
    // print(response.body);

    if (response.statusCode == 200) {
      final accountdetailsModel = AccountDetailsModel.fromJson(
        json.decode(response.body),
      );

      return accountdetailsModel;
    } else {
      throw Exception('Failed to fetch account statistic');
    }
  }
}

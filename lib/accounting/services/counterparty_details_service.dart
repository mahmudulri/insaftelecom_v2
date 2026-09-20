import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/accounting/models/counterparty_details_model.dart';
import '../../utils/api_endpoints.dart';

class CounterpartyDetailsApi {
  final box = GetStorage();
  Future<CounterPartyDetailsModel> fetchcounterpary(String ID) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/counterparties/${ID}",
    );
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final counterpartyDetailsModel = CounterPartyDetailsModel.fromJson(
        json.decode(response.body),
      );

      return counterpartyDetailsModel;
    } else {
      throw Exception('Failed to fetch counter party');
    }
  }
}

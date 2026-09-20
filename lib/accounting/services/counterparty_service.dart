import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/accounting/models/counter_party_model.dart';
import '../../utils/api_endpoints.dart';

class CounterpartyApi {
  final box = GetStorage();
  Future<CounterPartyModel> fetchcounterpary(int pageNo) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/counterparties?page=${pageNo}&per_page=25",
    );
    print("order Url : " + url.toString());

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final alltransactions = CounterPartyModel.fromJson(
        json.decode(response.body),
      );

      return alltransactions;
    } else {
      throw Exception('Failed to fetch counter party');
    }
  }
}

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/accounting/models/party_accounts_model.dart';
import '../../utils/api_endpoints.dart';

class PartyAccountsApi {
  final box = GetStorage();

  Future<List<Datum>> fetchaccounts(partyID) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}accounting/counterparties/$partyID?include=accounts&page=1",
    );
    print(url);

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      final model = partyAccountsModelFromJson(response.body);

      return model.data?.counterparty?.accounts?.data ?? [];
    } else {
      throw Exception('Failed to fetch party account service');
    }
  }
}

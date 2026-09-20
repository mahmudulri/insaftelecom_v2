import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';

import '../models/allaccount_model.dart';

class AllAccountlistApi {
  final box = GetStorage();

  Future<AllAccountsModel> fetchaccountlist(
    int pageNO, {
    String? search,
    int? officeId,
    String? currencyCode,
    int? counterpartyId,
    String? balanceStatus,
  }) async {
    final Map<String, String> queryParameters = {
      'page': pageNO.toString(),
      'per_page': '20',
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (officeId != null) {
      queryParameters['office_id'] = officeId.toString();
    }

    if (currencyCode != null && currencyCode.trim().isNotEmpty) {
      queryParameters['currency_code'] = currencyCode.trim();
    }

    if (counterpartyId != null) {
      queryParameters['counterparty_id'] = counterpartyId.toString();
    }

    if (balanceStatus != null && balanceStatus.trim().isNotEmpty) {
      queryParameters['balance_status'] = balanceStatus.trim();
    }

    final Uri url = Uri.parse(
      '${ApiEndPoints.baseUrl}accounting/accounts',
    ).replace(queryParameters: queryParameters);

    print('ACCOUNT LIST URL: $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return AllAccountsModel.fromJson(json.decode(response.body));
    } else {
      print('ACCOUNT LIST STATUS: ${response.statusCode}');
      print('ACCOUNT LIST BODY: ${response.body}');
      throw Exception('Failed to fetch all accountlist service');
    }
  }
}

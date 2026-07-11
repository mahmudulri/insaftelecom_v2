import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallets_model.dart';
import '../models/walletsettings_model.dart';
import '../utils/api_endpoints.dart';

class WalletSettingsApi {
  final box = GetStorage();

  Future<WalletSettingsModel> fetchwalletsettings() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.walletsettings,
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final walletsettingsmodel = WalletSettingsModel.fromJson(
        json.decode(response.body),
      );

      return walletsettingsmodel;
    } else {
      throw Exception('Failed to fetch walletsettingsmodel');
    }
  }
}

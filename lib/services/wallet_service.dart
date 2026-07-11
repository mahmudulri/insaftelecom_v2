import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallets_model.dart';
import '../utils/api_endpoints.dart';

class WalletService {
  final box = GetStorage();
  Future<WalletsModel> fetchwalletes() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.wallets,
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final walletsModel = WalletsModel.fromJson(json.decode(response.body));

      return walletsModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

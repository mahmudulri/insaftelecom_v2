import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/commision_group_model.dart';
import '../utils/api_endpoints.dart';

class ComissionGroupApi {
  final box = GetStorage();
  Future<ComissionGroupModel> fetchgroup() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.commsiongrouplist);
    print("commission group $url");

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode.toString());

      final comissionGroupModel =
          ComissionGroupModel.fromJson(json.decode(response.body));

      return comissionGroupModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

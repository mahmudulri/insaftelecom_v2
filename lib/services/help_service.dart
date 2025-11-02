import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/help_model.dart';
import '../models/service_model.dart';
import '../utils/api_endpoints.dart';

class HelpServiceApi {
  final box = GetStorage();
  Future<HelpModel> fetchhelpdata() async {
    final url = Uri.parse("${ApiEndPoints.baseUrl}help-articles");
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final helpModel = HelpModel.fromJson(json.decode(response.body));

      return helpModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

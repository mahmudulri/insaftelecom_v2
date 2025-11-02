import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';
import '../utils/api_endpoints.dart';

class OnlyServiceListApi {
  final box = GetStorage();
  Future<ServiceModel> fetchservicelist() async {
    final url = Uri.parse("${ApiEndPoints.baseUrl}services");
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final servicelistModel =
          ServiceModel.fromJson(json.decode(response.body));

      return servicelistModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

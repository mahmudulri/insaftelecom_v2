import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/sub_reseller_model.dart';
import '../utils/api_endpoints.dart';

class SubResellerApi {
  final box = GetStorage();
  Future<SubResellerModel> fetchSubReseller() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.subreseller);
    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final subresellerModel =
          SubResellerModel.fromJson(json.decode(response.body));

      return subresellerModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../models/allaccount_model.dart';
import '../models/statistic_model.dart';

class StatisticService {
  final box = GetStorage();
  Future<StatisticsModel> fetchstatistic() async {
    final url = Uri.parse(ApiEndPoints.baseUrl + "accounting/statistics");

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final allstatistic = StatisticsModel.fromJson(json.decode(response.body));

      return allstatistic;
    } else {
      throw Exception('Failed to fetch statistic service');
    }
  }
}

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/transferlist_model.dart';
import '../utils/api_endpoints.dart';
import 'dart:convert';

class TransferlistApi {
  final box = GetStorage();

  Future<TransferListModel> fetchtransferlist() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.earningtransfer);
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      final transferlistmode =
          TransferListModel.fromJson(json.decode(response.body));
      return transferlistmode;
    } else {
      throw Exception("Failde to fetch gateway");
    }
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_data_model.dart';
import '../models/sub_reseller_model.dart';
import '../models/subreseller_details_model.dart';
import '../utils/api_endpoints.dart';

// final UpdateSubResellerController controller =
//     Get.put(UpdateSubResellerController());

class SubResellerDetailsApi {
  final box = GetStorage();
  Future<SubresellerDetailsModel> fetchSubResellerDetails(String id) async {
    final url = Uri.parse(
        "${ApiEndPoints.baseUrl}${ApiEndPoints.otherendpoints.subresellerDetails}$id");

    print(url);

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${box.read("userToken")}',
      },
    );

    if (response.statusCode == 200) {
      // print(response.body.toString());
      final subresellerDetailsModel =
          SubresellerDetailsModel.fromJson(json.decode(response.body));
      var mydata = subresellerDetailsModel.toJson()['data']['reseller'];

      // controller.resellerNameController.text = mydata['reseller_name'];
      // controller.contactNameController.text = mydata['contact_name'];
      // controller.emailController.text = mydata['email'];
      // controller.phoneController.text = mydata['phone'];

      // controller.countryId.value = mydata['country_id'];
      // controller.provinceId.value = mydata['province_id'];
      // controller.districtID.value = mydata['districts_id'];

      return subresellerDetailsModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

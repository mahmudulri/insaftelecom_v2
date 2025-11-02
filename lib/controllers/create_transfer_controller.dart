import 'dart:convert';

import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../utils/api_endpoints.dart';

final dashboardController = Get.find<DashboardController>();

class CreateTransferController extends GetxController {
  TextEditingController amountController = TextEditingController();

  RxString amount = "".obs;
  RxBool isLoading = false.obs;
  final box = GetStorage();

  Future<void> createnow() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse("${ApiEndPoints.baseUrl}earning-transfer");

      Map body = {'amount': amountController.text};
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (results["success"] == true) {
          Fluttertoast.showToast(
            msg: results["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          amountController.clear();

          dashboardController.fetchDashboardData();

          isLoading.value = false;
        } else {
          Get.snackbar(
            "Opps !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Opps !",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

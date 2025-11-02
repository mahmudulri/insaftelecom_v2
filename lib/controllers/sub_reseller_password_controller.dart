import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoints.dart';

class SubresellerPassController extends GetxController {
  final box = GetStorage();
  // TextEditingController nameController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> change(subID) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}'
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}sub-resellers/set-sub-reseller-password");

      Map body = {
        'sub_reseller_id': subID.toString(),
        'new_password': newpassController.text,
        'confirm_new_password': confirmpassController.text,
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body${response.body}");
      print("statuscode${response.statusCode}");
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        newpassController.clear();
        confirmpassController.clear();
        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

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

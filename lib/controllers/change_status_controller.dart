import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';
import 'sub_reseller_controller.dart';

final SubresellerController subresellerController = Get.put(
  SubresellerController(),
);

class ChangeStatusController extends GetxController {
  final box = GetStorage();

  RxBool isLoading = false.obs;

  Future<void> channgestatus(subID) async {
    try {
      isLoading.value = true;

      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}sub-resellers/change-sub-reseller-status/$subID",
      );

      http.Response response = await http.get(url, headers: headers);

      // print("body${response.body}");
      print("statuscode${response.statusCode}");
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (results["success"] == true) {
          isLoading.value = false;
          subresellerController.fetchSubReseller();
          Fluttertoast.showToast(
            msg: "Status successfully changed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
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

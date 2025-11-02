import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoints.dart';
import 'sub_reseller_controller.dart';

final SubresellerController subresellerController =
    Get.put(SubresellerController());

class BalanceController extends GetxController {
  final box = GetStorage();

  TextEditingController amountController = TextEditingController();

  RxBool isLoading = false.obs;
  var status = ''.obs;

  Future<void> credit(subID) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}'
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}sub-reseller/transactions/credit-balance");

      Map body = {
        'sub_reseller_id': subID.toString(),
        'amount': amountController.text,
        'status': status.toString(),
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 201) {
        amountController.clear();

        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          subresellerController.fetchSubReseller();

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

  Future<void> debit(subID) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}'
      };
      var url = Uri.parse(
          "${ApiEndPoints.baseUrl}sub-reseller/transactions/debit-balance");

      Map body = {
        'sub_reseller_id': subID.toString(),
        'amount': amountController.text,
        'status': status.toString(),
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 201) {
        amountController.clear();

        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          subresellerController.fetchSubReseller();

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

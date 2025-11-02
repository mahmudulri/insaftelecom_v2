import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';
import '../global_controller/page_controller.dart';
import '../pages/network.dart';
import 'loanlist_controller.dart';
import 'sub_reseller_controller.dart';

class RequestLoanController extends GetxController {
  final box = GetStorage();

  RxBool isLoading = false.obs;

  TextEditingController amountController = TextEditingController();
  LoanlistController loanlistController = Get.put(LoanlistController());

  Future<void> requestloan() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}reseller-balances/request-loan?balance_amount=${amountController.text.toString()}",
      );
      print(url);

      http.Response response = await http.post(url, headers: headers);

      print("body${response.body}");
      print("statuscode${response.statusCode}");

      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        loanlistController.fetchLoan();
        amountController.clear();
        if (results["success"] == true) {
          isLoading.value = false;

          Fluttertoast.showToast(
            msg: results["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
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

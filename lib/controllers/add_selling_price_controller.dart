import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../utils/api_endpoints.dart';
import 'commission_group_controller.dart';

class AddSellingPriceController extends GetxController {
  final box = GetStorage();

  TextEditingController serviceidcontroller = TextEditingController();
  TextEditingController amountController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString logolink = ''.obs;
  RxString catName = ''.obs;
  RxString serviceName = ''.obs;

  RxString commitype = ''.obs;

  var commissiontype = "".obs; // Or use 'percentage'.obs if you want a default

  Future<void> createnow() async {
    try {
      isLoading.value = true;
      // Reset to false before starting login

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.createselling);

      print("API URL: $url");

      Map body = {
        'service_id': serviceidcontroller.text,
        'amount': amountController.text,
        'commission_type': commissiontype.value.toString(),
      };
      print(body);

      http.Response response = await http.post(
        url,
        body: body,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final results = jsonDecode(response.body);

      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        serviceidcontroller.clear();
        amountController.clear();
        commitype.value = "";
        commissiontype.value = "";
        logolink.value = '';
        serviceName.value = '';
        catName.value = '';

        if (results["success"] == true) {
          Fluttertoast.showToast(
              msg: results["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          // Fetch country data only if login is successful
        } else {
          Get.snackbar(
            "Oops!",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Oops!",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error during sign in: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

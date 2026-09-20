import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/accounting/controllers/counter_party_controller.dart';
import '../../utils/api_endpoints.dart';

CounterPartyController counterPartyController = Get.put(
  CounterPartyController(),
);

class DeleteCounterpartyController extends GetxController {
  final box = GetStorage();

  RxBool isLoading = false.obs;

  Future<void> deleteparty(id) async {
    try {
      isLoading.value = true;

      // var headers = {'Content-Type': 'application/json'};
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}accounting/counterparties/$id",
      );
      print(url);

      http.Response response = await http.delete(url, headers: headers);

      print("body${response.body}");
      print("statuscode${response.statusCode}");
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        counterPartyController.initialpage = 1;
        counterPartyController.finalList.clear();
        counterPartyController.fetchcounterpary();
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

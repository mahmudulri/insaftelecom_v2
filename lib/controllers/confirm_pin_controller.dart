import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/screens/result_screen.dart';

import 'package:insaftelecom/utils/api_endpoints.dart';

import 'result_controller.dart';

class ConfirmPinController extends GetxController {
  TextEditingController numberController = TextEditingController();

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();

  TextEditingController pinController = TextEditingController();

  RxBool isLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> placeOrder(BuildContext context) async {
    try {
      isLoading.value = true;

      var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
      Map body = {
        'bundle_id': box.read("bundleID"),
        'rechargeble_account': numberController.text,
        'pin': pinController.text,
      };

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );
      print("checkurl" + url.toString());
      print(pinController.toString());
      print(body.toString());

      final orderResults = jsonDecode(response.body);
      if (response.statusCode == 201 && orderResults["success"] == true) {
        // loadsuccess.value = false;
        isLoading.value = false;
        pinController.clear();
        numberController.clear();
        box.remove("bundleID");

        showSuccessDialog(context);
      } else {
        showErrorDialog(context, orderResults["message"]);
        pinController.clear();
        isLoading.value = false;
        // loadsuccess.value = false;
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
      isLoading.value = false;
    }
  }

  // void handleFailure(String message) {
  //   pinController.clear();
  //   loadsuccess.value = false;
  // }

  void showSuccessDialog(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    pinController.clear();
    numberController.clear;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 350,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(languagesController.tr("SUCCESS")),
                SizedBox(height: 15),
                Text(
                  languagesController.tr("RECHARGE_SUCCESSFULL"),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close success dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    languagesController.tr("CLOSE"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    var screenWidth = MediaQuery.of(context).size.width;
    pinController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 350,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Failed"),
                SizedBox(height: 15),
                Text(
                  "Recharge Failed!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close error dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Close", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

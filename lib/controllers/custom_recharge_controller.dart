import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/global_controller/languages_controller.dart';

import 'package:insaftelecom/utils/api_endpoints.dart';

import '../global_controller/afghan_recharge_controller.dart';
import 'conversation_controller.dart';
import 'custom_history_controller.dart';

ConversationController conversationController = Get.put(
  ConversationController(),
);

final AfghanRechargeController controller =
    Get.find<AfghanRechargeController>();

class CustomRechargeController extends GetxController {
  TextEditingController numberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();

  final customhistoryController = Get.find<CustomHistoryController>();

  RxBool isLoading = false.obs;

  Future<void> placeOrder(BuildContext context) async {
    try {
      isLoading.value = true;
      var url = Uri.parse("${ApiEndPoints.baseUrl}custom-recharge");
      Map body = {
        'country_id': box.read("afghanistan_id"),
        'rechargeble_account': numberController.text,
        'amount': amountController.text,
      };
      print(body.toString());

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      final orderResults = jsonDecode(response.body);
      // print(response.statusCode.toString());
      // print(response.body.toString());
      if (response.statusCode == 201 && orderResults["success"] == true) {
        customhistoryController.finalList.clear();
        customhistoryController.initialpage = 1;
        customhistoryController.fetchHistory();
        controller.reset();
        conversationController.resetConversion();
        isLoading.value = false;

        numberController.clear();
        box.remove("bundleID");

        showSuccessDialog(context);
      } else {
        isLoading.value = false;
        showErrorDialog(context, orderResults["message"]);
      }
    } catch (e) {
      isLoading.value = false;
      showErrorDialog(context, e.toString());
    }
  }

  void handleFailure(String message) {
    isLoading.value = false;
  }

  void showSuccessDialog(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    numberController.clear();
    amountController.clear();
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
                    Navigator.pop(context); // Close main dialog
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
                Text(languagesController.tr("FAILED")),
                SizedBox(height: 15),
                Text(
                  languagesController.tr("RECHARGE_FAILED"),
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
                    Navigator.pop(context); // Close main dialog
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
}

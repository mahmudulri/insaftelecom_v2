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

  ResultController resultController = Get.put(ResultController());

  RxBool isLoading = false.obs;
  RxBool placeingLoading = false.obs;

  RxBool loadsuccess = false.obs;

  Future<void> verify(BuildContext context) async {
    try {
      isLoading.value = true;
      loadsuccess.value =
          false; // Start with false, only set to true if successful.

      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}confirm_pin?pin=${pinController.text}",
      );

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 200 && results["success"] == true) {
        pinController.clear();
        loadsuccess.value =
            true; // Mark as successful only if status and success are correct

        // Proceed with placing the order
        await placeOrder(context);
      } else {
        showErrorDialog(context, results["message"]);
      }
    } catch (e) {
      showErrorDialog(context, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder(BuildContext context) async {
    try {
      placeingLoading.value = true;

      var url = Uri.parse("${ApiEndPoints.baseUrl}place_order");
      Map body = {
        'bundle_id': box.read("bundleID"),
        'rechargeble_account': numberController.text,
      };
      print(url);

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read("userToken")}',
        },
      );

      print(
        "Status Code------------------------------: ${response.statusCode}",
      );
      print("Response Body--------------------------: ${response.body}");

      final orderResults = jsonDecode(response.body);
      print(orderResults["success"].toString());

      if (response.statusCode == 201 && orderResults["success"] == true) {
        // ✅ Order successful
        resultController.updateResult(response.body);

        loadsuccess.value = false;

        pinController.clear();
        numberController.clear();
        box.remove("bundleID");
        placeingLoading.value = false;
        await Future.delayed(Duration(milliseconds: 200));
        Get.to(() => ResultScreen());
      } else {
        // ❌ Error occurred
        var errorMessage = orderResults["message"];
        if (errorMessage is Map) {
          errorMessage = errorMessage.values.join(", ");
        }
        showErrorDialog(context, errorMessage.toString());
        placeingLoading.value = false;
        pinController.clear();
        loadsuccess.value = false;
      }
    } catch (e) {
      // 🧨 Exception (network error, etc.)
      showErrorDialog(context, e.toString());
      placeingLoading.value = false;
      pinController.clear();
      loadsuccess.value = false;
    }
  }

  void handleFailure(String message) {
    pinController.clear();
    loadsuccess.value = false;
    placeingLoading.value = false;
  }

  // void showSuccessDialog(BuildContext context) {
  //   var screenWidth = MediaQuery.of(context).size.width;
  //   pinController.clear();
  //   numberController.clear;
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(17),
  //         ),
  //         contentPadding: EdgeInsets.zero,
  //         content: Container(
  //           height: 350,
  //           width: screenWidth,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(17),
  //             color: Colors.white,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 languagesController.tr("SUCCESS"),
  //               ),
  //               SizedBox(height: 15),
  //               Text(
  //                 languagesController.tr("RECHARGE_SUCCESSFULL"),
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.green),
  //               ),
  //               SizedBox(height: 20),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context); // Close success dialog
  //                   Navigator.pop(context); // Close main dialog
  //                 },
  //                 style:
  //                     ElevatedButton.styleFrom(backgroundColor: Colors.green),
  //                 child: Text(languagesController.tr("CLOSE"),
  //                     style: TextStyle(color: Colors.white)),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                    Navigator.pop(context); // Close main dialog
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

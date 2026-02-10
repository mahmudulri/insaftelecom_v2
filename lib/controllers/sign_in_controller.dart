import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';

import '../routes/routes.dart';
import 'dashboard_controller.dart';

final dashboardController = Get.find<DashboardController>();

class SignInController extends GetxController {
  final box = GetStorage();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // final CountryListController countryListController =
  //     Get.put(CountryListController());

  RxBool isLoading = false.obs;
  RxBool loginsuccess = false.obs;

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      loginsuccess.value = true; // Reset to false before starting login

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.loginIink,
      );
      print("API URL: $url");

      Map body = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      // Map body = {
      //   'username': "0700930683",
      //   'password': "test@2024",
      // };

      print("Request Body: $body");

      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      final results = jsonDecode(response.body);
      // print("Response Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        box.write("userToken", results["data"]["api_token"]);
        box.write(
          "currency_code",
          results["data"]["user_info"]["currency"]["code"],
        );
        box.write(
          "currency_symbol",
          results["data"]["user_info"]["currency"]["symbol"],
        );
        box.write(
          "countryID",
          results["data"]["user_info"]["reseller"]["country_id"],
        );
        box.write(
          "currencypreferenceID",
          results["data"]["user_info"]["currency_preference_id"],
        );
        box.write(
          "currencyName",
          results["data"]["user_info"]["currency"]["name"],
        );

        box.write(
          "resellerrate",
          results["data"]["user_info"]["currency"]["exchange_rate_per_usd"],
        );
        dashboardController.fetchDashboardData();

        Get.toNamed(basescreen);

        if (results["success"] == true) {
          loginsuccess.value = false;
          print(loginsuccess.value);

          Fluttertoast.showToast(
            msg: results["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // Fetch country data only if login is successful
        } else {
          _showError(results);
        }
      } else {
        _showError(results);
      }
    } catch (e) {
      print("Error during sign in: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

/// ✅ Handles both String and Map error formats
void _showError(dynamic results) {
  String errorMessage = "Login failed";

  if (results["errors"] is String) {
    errorMessage = results["errors"];
  } else if (results["errors"] is Map) {
    // Extract first validation message
    final errorsMap = results["errors"] as Map;
    if (errorsMap.isNotEmpty) {
      final firstError = errorsMap.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        errorMessage = firstError.first.toString();
      }
    }
  }

  Get.snackbar(
    results["message"] ?? "Error",
    errorMessage,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

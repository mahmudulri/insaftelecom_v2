import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';

class VerifyPinController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> verifyPin(String pin) async {
    if (isLoading.value) return false;

    errorMessage.value = '';

    final String? token = box.read<String>("userToken");

    if (token == null || token.isEmpty) {
      errorMessage.value = "Authorization token not found";
      return false;
    }

    try {
      isLoading.value = true;

      final Uri url = Uri.parse(
        ApiEndPoints.baseUrl + "confirm_pin",
      ).replace(queryParameters: {"pin": pin});

      print("Verify PIN URL: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Verify PIN Status: ${response.statusCode}");
      print("Verify PIN Response: ${response.body}");

      Map<String, dynamic>? responseData;

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          responseData = decoded;
        }
      } catch (e) {
        print("JSON Decode Error: $e");
      }

      // Correct PIN
      if (response.statusCode == 200 && responseData?["success"] == true) {
        errorMessage.value = '';
        return true;
      }

      // Wrong PIN
      if (response.statusCode == 401) {
        errorMessage.value =
            responseData?["message"]?.toString() ?? "Incorrect Pin";

        return false;
      }

      // Other server errors
      errorMessage.value =
          responseData?["message"]?.toString() ?? "Unable to verify PIN";

      return false;
    } catch (e) {
      print("Verify PIN Error: $e");

      errorMessage.value =
          "Something went wrong. Please check your connection.";

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}

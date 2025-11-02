import 'dart:convert';
import 'package:get/get.dart';
import '../models/result_model.dart'; // Ensure this points to your ResultModel

class ResultController extends GetxController {
  Rx<ResultModel?> resultModel = Rx<ResultModel?>(null);

  var isLoading = false.obs;

  void updateResult(String jsonResponse) {
    try {
      print("🔹 updateResult() called");
      print("🔹 Raw response: $jsonResponse");
      isLoading(true);

      var decodedJson = jsonDecode(jsonResponse);
      print("🔹 Decoded JSON keys: ${decodedJson.keys}");

      resultModel.value = ResultModel.fromJson(decodedJson);
      print("✅ Result model updated successfully");

      isLoading(false);
    } catch (e) {
      print("❌ JSON parse error: $e");
    }
  }
}

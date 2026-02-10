import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_data_model.dart';
import '../utils/api_endpoints.dart';

final dashboardController = Get.find<DashboardController>();

class DashboardApi {
  final box = GetStorage();

  Future<DashboardDataModel> fetchDashboard() async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.dashboard,
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );

    final decoded = json.decode(response.body);
    // print("STATUS: ${response.statusCode}");
    // print("BODY: ${response.body}");

    if (response.statusCode == 403) {
      dashboardController.setDeactivated(
        decoded['errors'] ?? '',
        decoded['message'] ?? '',
      );
      Get.snackbar(
        decoded['errors'],
        decoded['message'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 1),
        icon: const Icon(Icons.block, color: Colors.white),
      );

      return DashboardDataModel(
        success: false,
        message: decoded['message'],
        data: null,
      );
    }

    if (response.statusCode == 200) {
      dashboardController.setDeactivated('', '');

      return DashboardDataModel.fromJson(decoded);
    }

    throw Exception('Failed to fetch dashboard');
  }
}

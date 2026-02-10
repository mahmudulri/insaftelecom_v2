import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../controllers/dashboard_controller.dart';
import '../models/transaction_model.dart';
import '../utils/api_endpoints.dart';

final dashboardController = Get.find<DashboardController>();

class TransactionApi {
  final box = GetStorage();

  Future<TransactionModel> fetchTransaction(int pageNo) async {
    final url = Uri.parse(
      ApiEndPoints.baseUrl +
          ApiEndPoints.otherendpoints.transactions +
          "?page=$pageNo&items_per_page=300&search=${box.read("transactiontype")}${box.read("category")}${box.read("purpose")}${box.read("startdate")}${box.read("enddate")}",
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${box.read("userToken")}'},
    );
    // print(url);

    final decoded = json.decode(response.body);
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

      return TransactionModel.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 200) {
      print(response.statusCode.toString());

      // print(response.body.toString());
      final transactionModel = TransactionModel.fromJson(
        json.decode(response.body),
      );

      return transactionModel;
    } else {
      throw Exception('Failed to fetch gateway');
    }
  }
}

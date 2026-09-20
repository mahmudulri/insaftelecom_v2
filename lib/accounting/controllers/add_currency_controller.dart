import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../global_controller/languages_controller.dart';
import '../../utils/api_endpoints.dart';

class AddCurrencyController extends GetxController {
  final GetStorage box = GetStorage();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> addCurrency({
    required String name,
    required String code,
    required String symbol,
    required String exchangeRatePerUsd,
  }) async {
    try {
      errorMessage.value = '';

      final String currencyName = name.trim();
      final String currencyCode = code.trim();
      final String currencySymbol = symbol.trim();
      final String exchangeRate = exchangeRatePerUsd.trim();

      // Only validation: every field must be filled.
      if (currencyName.isEmpty ||
          currencyCode.isEmpty ||
          currencySymbol.isEmpty ||
          exchangeRate.isEmpty) {
        errorMessage.value = languagesController.tr('PLEASE_FILL_ALL_FIELDS');

        return false;
      }

      isLoading.value = true;

      final String? token = box.read('userToken');

      final Uri url = Uri.parse(ApiEndPoints.baseUrl + 'accounting/currencies');

      final Map<String, dynamic> requestBody = {
        'name': currencyName,
        'code': currencyCode.toUpperCase(),
        'symbol': currencySymbol,
        'ignore_digits_count': '2',
        'exchange_rate_per_usd': exchangeRate,
      };

      debugPrint('Add currency URL: $url');
      debugPrint('Add currency body: ${jsonEncode(requestBody)}');

      final http.Response response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Add currency status: ${response.statusCode}');
      debugPrint('Add currency response: ${response.body}');

      dynamic decodedBody;

      try {
        decodedBody = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
      } catch (e) {
        decodedBody = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String successMessage =
            decodedBody is Map &&
                decodedBody['message'] != null &&
                decodedBody['message'].toString().trim().isNotEmpty
            ? decodedBody['message'].toString()
            : languagesController.tr('CURRENCY_ADDED_SUCCESSFULLY');

        Fluttertoast.showToast(msg: successMessage);

        return true;
      }

      errorMessage.value = _extractErrorMessage(decodedBody);

      return false;
    } catch (e, stackTrace) {
      debugPrint('Add currency error: $e');
      debugPrintStack(stackTrace: stackTrace);

      errorMessage.value = languagesController.tr('UNABLE_TO_ADD_CURRENCY');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic body) {
    if (body is! Map) {
      return languagesController.tr('UNABLE_TO_ADD_CURRENCY');
    }

    final dynamic errors = body['errors'];

    if (errors is Map) {
      for (final dynamic value in errors.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }

        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    final String apiMessage = body['message']?.toString().trim() ?? '';

    if (apiMessage.isNotEmpty) {
      return apiMessage;
    }

    return languagesController.tr('UNABLE_TO_ADD_CURRENCY');
  }
}

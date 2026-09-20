import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';

class UpdateCurrencyController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> updateCurrency({
    required dynamic currencyId,
    required String exchangeRatePerUsd,
  }) async {
    try {
      errorMessage.value = '';

      final int? parsedCurrencyId = int.tryParse(currencyId.toString());

      if (parsedCurrencyId == null || parsedCurrencyId <= 0) {
        errorMessage.value = 'Invalid currency ID.';
        return false;
      }

      final double? parsedExchangeRate = double.tryParse(
        exchangeRatePerUsd.trim(),
      );

      if (parsedExchangeRate == null || parsedExchangeRate <= 0) {
        errorMessage.value = 'Enter a valid exchange rate.';
        return false;
      }

      isLoading.value = true;

      final String? token = box.read('userToken');

      final url = Uri.parse(
        ApiEndPoints.baseUrl + "accounting/currencies/$parsedCurrencyId",
      );

      final Map<String, dynamic> requestBody = {
        'exchange_rate_per_usd': parsedExchangeRate,
      };

      debugPrint('Update currency URL: $url');
      debugPrint('Update currency body: ${jsonEncode(requestBody)}');

      final http.Response response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Update currency status: ${response.statusCode}');
      debugPrint('Update currency response: ${response.body}');

      final dynamic decodedBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: decodedBody is Map
              ? decodedBody['message']?.toString() ??
                    'Currency updated successfully.'
              : 'Currency updated successfully.',
        );

        return true;
      }

      errorMessage.value = _extractErrorMessage(decodedBody);

      return false;
    } catch (e, stackTrace) {
      debugPrint('Update currency error: $e');
      debugPrintStack(stackTrace: stackTrace);

      errorMessage.value = 'Unable to update currency. Please try again.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic body) {
    if (body is! Map) {
      return 'Unable to update currency.';
    }

    final dynamic errors = body['errors'];

    if (errors is Map) {
      for (final dynamic value in errors.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }

        if (value != null) {
          return value.toString();
        }
      }
    }

    return body['message']?.toString() ?? 'Unable to update currency.';
  }
}

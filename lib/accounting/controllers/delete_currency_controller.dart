import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';

class DeleteCurrencyController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> deleteCurrency({required dynamic currencyId}) async {
    try {
      errorMessage.value = '';

      final int? parsedCurrencyId = int.tryParse(currencyId.toString());

      if (parsedCurrencyId == null || parsedCurrencyId <= 0) {
        errorMessage.value = 'Invalid currency ID.';
        return false;
      }

      isLoading.value = true;

      final String? token = box.read('userToken');

      final Uri url = Uri.parse(
        ApiEndPoints.baseUrl + "accounting/currencies/$parsedCurrencyId",
      );

      debugPrint('Delete currency URL: $url');

      final http.Response response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Delete currency status: ${response.statusCode}');
      debugPrint('Delete currency response: ${response.body}');

      dynamic decodedBody;

      if (response.body.isNotEmpty) {
        decodedBody = jsonDecode(response.body);
      }

      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        Fluttertoast.showToast(
          msg: decodedBody is Map
              ? decodedBody['message']?.toString() ??
                    'Currency deleted successfully.'
              : 'Currency deleted successfully.',
        );

        return true;
      }

      errorMessage.value = _extractErrorMessage(decodedBody);

      return false;
    } catch (e, stackTrace) {
      debugPrint('Delete currency error: $e');
      debugPrintStack(stackTrace: stackTrace);

      errorMessage.value = 'Unable to delete currency. Please try again.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic body) {
    if (body is! Map) {
      return 'Unable to delete currency.';
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

    return body['message']?.toString() ?? 'Unable to delete currency.';
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';

class MakeTransactionController extends GetxController {
  final GetStorage box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> makeTransaction({
    required dynamic counterpartyAccountId,
    required String transactionType,
    required dynamic amount,
    String? description,
  }) async {
    if (isLoading.value) {
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final String normalizedTransactionType = transactionType
          .trim()
          .toUpperCase();

      if (normalizedTransactionType != 'PAYABLE' &&
          normalizedTransactionType != 'RECEIVABLE') {
        errorMessage.value = 'Invalid transaction type.';
        return false;
      }

      final int? parsedAccountId = int.tryParse(
        counterpartyAccountId.toString().trim(),
      );

      if (parsedAccountId == null || parsedAccountId <= 0) {
        errorMessage.value = 'Invalid counterparty account.';
        return false;
      }

      final double? parsedAmount = double.tryParse(amount.toString().trim());

      if (parsedAmount == null || parsedAmount <= 0) {
        errorMessage.value = 'Amount must be greater than 0.';
        return false;
      }

      final String trimmedDescription = description?.trim() ?? '';

      final String token = box.read('userToken')?.toString() ?? '';

      final Uri url = Uri.parse(
        '${ApiEndPoints.baseUrl}accounting/transactions',
      );

      final Map<String, dynamic> requestBody = {
        'counterparty_account_id': parsedAccountId,
        'transaction_type': normalizedTransactionType,
        'amount': parsedAmount,
        'description': trimmedDescription,
      };

      debugPrint('Make transaction URL: $url');
      debugPrint('Make transaction payload: ${jsonEncode(requestBody)}');

      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Make transaction status code: ${response.statusCode}');
      debugPrint('Make transaction response: ${response.body}');

      dynamic results;

      try {
        results = jsonDecode(response.body);
      } catch (_) {
        errorMessage.value = 'Invalid response received from server.';
        return false;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (results is Map && results['success'] == true) {
          errorMessage.value = '';

          Fluttertoast.showToast(
            msg:
                results['message']?.toString() ??
                'Accounting transaction recorded successfully.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16,
          );

          return true;
        }

        errorMessage.value = _getErrorMessage(results);
        return false;
      }

      errorMessage.value = _getErrorMessage(results);
      return false;
    } catch (e, stackTrace) {
      debugPrint('Make transaction error: $e');
      debugPrintStack(stackTrace: stackTrace);

      errorMessage.value = 'Something went wrong. Please try again.';

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _getErrorMessage(dynamic results) {
    if (results is! Map) {
      return 'Unable to create transaction.';
    }

    final dynamic errors = results['errors'];

    if (errors is Map && errors.isNotEmpty) {
      final List<String> messages = [];

      for (final dynamic value in errors.values) {
        if (value is List) {
          for (final dynamic message in value) {
            if (message != null && message.toString().trim().isNotEmpty) {
              messages.add(message.toString().trim());
            }
          }
        } else if (value != null && value.toString().trim().isNotEmpty) {
          messages.add(value.toString().trim());
        }
      }

      if (messages.isNotEmpty) {
        return messages.join('\n');
      }
    }

    final dynamic message = results['message'];

    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString().trim();
    }

    return 'Unable to create transaction.';
  }
}

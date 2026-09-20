import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import 'counter_party_controller.dart';

class UpdatePartyController extends GetxController {
  final GetStorage box = GetStorage();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  final RxString selectedType = 'supplier'.obs;
  final RxString selectedAccountType = 'saving'.obs;

  final RxString selectedCurrencyCode = ''.obs;
  final RxnInt selectedAccountingCurrencyId = RxnInt();

  final RxBool createDefaultAccount = false.obs;
  final RxnInt selectedOfficeId = RxnInt();

  final RxBool isLoading = false.obs;

  CounterPartyController get counterPartyListController {
    if (Get.isRegistered<CounterPartyController>()) {
      return Get.find<CounterPartyController>();
    }

    return Get.put(CounterPartyController());
  }

  void initializeForm({
    required String? name,
    required String? phone,
    required String? email,
    required String? type,
    required String? currencyCode,
    int? accountingCurrencyId,
    int? officeId,
    String? accountType,
    dynamic openingBalance,
    bool? shouldCreateDefaultAccount,
  }) {
    nameController.text = _cleanNullableString(name);
    phoneController.text = _cleanNullableString(phone);
    emailController.text = _cleanNullableString(email);

    selectedType.value = _normalizeType(type);
    selectedAccountType.value = _normalizeAccountType(accountType);

    selectedCurrencyCode.value = _cleanNullableString(currencyCode);
    selectedAccountingCurrencyId.value = accountingCurrencyId;

    selectedOfficeId.value = officeId;

    createDefaultAccount.value =
        shouldCreateDefaultAccount ??
        officeId != null || accountingCurrencyId != null;

    if (openingBalance == null ||
        openingBalance.toString().trim().isEmpty ||
        openingBalance.toString().toLowerCase() == 'null') {
      balanceController.clear();
    } else {
      balanceController.text = openingBalance.toString();
    }
  }

  String _cleanNullableString(dynamic value) {
    if (value == null) {
      return '';
    }

    final String result = value.toString().trim();

    if (result.toLowerCase() == 'null') {
      return '';
    }

    return result;
  }

  String _normalizeType(String? value) {
    final String normalized = _cleanNullableString(value).toLowerCase();

    if (normalized == 'customer') {
      return 'customer';
    }

    if (normalized == 'distributor') {
      return 'distributor';
    }

    return 'supplier';
  }

  String _normalizeAccountType(String? value) {
    final String normalized = _cleanNullableString(value).toLowerCase();

    if (normalized == 'current') {
      return 'current';
    }

    if (normalized == 'fixed') {
      return 'fixed';
    }

    return 'saving';
  }

  void changeDefaultAccountStatus(bool value) {
    createDefaultAccount.value = value;

    if (!value) {
      selectedOfficeId.value = null;
    }
  }

  void selectOffice(int? officeId) {
    selectedOfficeId.value = officeId;
  }

  void selectCurrency({required int? id, required String code}) {
    selectedAccountingCurrencyId.value = id;
    selectedCurrencyCode.value = code.trim();
  }

  num getOpeningBalance() {
    final String value = balanceController.text.trim();

    if (value.isEmpty) {
      return 0;
    }

    return num.tryParse(value) ?? 0;
  }

  Map<String, dynamic> getCounterPartyData() {
    final Map<String, dynamic> body = {
      'name': nameController.text.trim(),
      'type': selectedType.value.trim().toLowerCase(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'default_currency_code': selectedCurrencyCode.value.trim(),
      'create_default_account': createDefaultAccount.value,
      'currency_code': selectedCurrencyCode.value.trim(),
      'account_type': selectedAccountType.value.trim().toLowerCase(),
      'opening_balance': getOpeningBalance(),
    };

    if (createDefaultAccount.value) {
      if (selectedOfficeId.value != null) {
        body['office_id'] = selectedOfficeId.value;
      }

      if (selectedAccountingCurrencyId.value != null) {
        body['accounting_currency_id'] = selectedAccountingCurrencyId.value;
      }
    }

    return body;
  }

  String getErrorMessage(dynamic responseData) {
    if (responseData is! Map) {
      return 'Something went wrong';
    }

    final dynamic errors = responseData['errors'];

    if (errors is Map && errors.isNotEmpty) {
      for (final dynamic error in errors.values) {
        if (error is List && error.isNotEmpty) {
          return error.first.toString();
        }

        if (error != null) {
          return error.toString();
        }
      }
    }

    return responseData['message']?.toString() ?? 'Something went wrong';
  }

  Future<bool> updateNow({required String partyId}) async {
    if (isLoading.value) {
      return false;
    }

    final String cleanPartyId = partyId.trim();

    if (cleanPartyId.isEmpty || cleanPartyId.toLowerCase() == 'null') {
      Get.snackbar(
        'Error',
        'Counterparty ID was not found.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (createDefaultAccount.value && selectedOfficeId.value == null) {
      Get.snackbar(
        'Error',
        'Please select an office.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    if (createDefaultAccount.value &&
        selectedAccountingCurrencyId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a currency.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    }

    isLoading.value = true;

    try {
      final Uri url = Uri.parse(
        '${ApiEndPoints.baseUrl}accounting/counterparties/$cleanPartyId',
      );

      final Map<String, dynamic> body = getCounterPartyData();

      debugPrint('Update counterparty URL: $url');
      debugPrint('Update counterparty body: ${jsonEncode(body)}');

      final String token = box.read('userToken')?.toString() ?? '';

      final http.Response response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('Update counterparty status: ${response.statusCode}');
      debugPrint('Update counterparty response: ${response.body}');

      dynamic responseData;

      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = {'message': 'Invalid response received from server'};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String message = responseData is Map
            ? responseData['message']?.toString() ?? 'Updated successfully'
            : 'Updated successfully';

        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
        );

        try {
          counterPartyListController.initialpage = 1;
          counterPartyListController.finalList.clear();

          await counterPartyListController.fetchcounterpary();
        } catch (e, stackTrace) {
          debugPrint('Counterparty list refresh error: $e');
          debugPrintStack(stackTrace: stackTrace);
        }

        return true;
      }

      Get.snackbar(
        'Error',
        getErrorMessage(responseData),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } on TimeoutException {
      Get.snackbar(
        'Timeout',
        'The request took too long. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } catch (e, stackTrace) {
      debugPrint('Update counterparty exception: $e');
      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar(
        'Error',
        'Unable to update counterparty. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    balanceController.clear();

    selectedType.value = 'supplier';
    selectedAccountType.value = 'saving';

    selectedCurrencyCode.value = '';
    selectedAccountingCurrencyId.value = null;

    createDefaultAccount.value = false;
    selectedOfficeId.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    balanceController.dispose();

    super.onClose();
  }
}

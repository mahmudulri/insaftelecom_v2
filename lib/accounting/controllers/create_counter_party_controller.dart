import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import 'counter_party_controller.dart';

class CreateCounterPartyController extends GetxController {
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

  String getCounterPartyEmail() {
    final String typedEmail = emailController.text.trim();

    if (typedEmail.isNotEmpty) {
      return typedEmail;
    }

    final String fullName = nameController.text.trim();
    final String phone = phoneController.text.trim();

    String firstName = '';

    if (fullName.isNotEmpty) {
      firstName = fullName.split(RegExp(r'\s+')).first;
    }

    firstName = firstName.toLowerCase();

    firstName = firstName.replaceAll(RegExp(r'[^a-z0-9]'), '');

    if (firstName.isEmpty) {
      firstName = 'user';
    }

    final String phoneDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    String lastDigits = '';

    if (phoneDigits.length >= 4) {
      lastDigits = phoneDigits.substring(phoneDigits.length - 4);
    } else if (phoneDigits.isNotEmpty) {
      lastDigits = phoneDigits;
    } else {
      lastDigits = DateTime.now().millisecondsSinceEpoch.toString().substring(
        DateTime.now().millisecondsSinceEpoch.toString().length - 4,
      );
    }

    return '$firstName.woosat.$lastDigits@gmail.com';
  }

  Map<String, dynamic> getCounterPartyData() {
    final Map<String, dynamic> body = {
      'name': nameController.text.trim(),
      'type': selectedType.value.trim().toLowerCase(),
      'phone': phoneController.text.trim(),

      'email': getCounterPartyEmail(),

      'default_currency_code': selectedCurrencyCode.value.trim(),
      'create_default_account': createDefaultAccount.value,
      'currency_code': selectedCurrencyCode.value.trim(),
      'account_type': selectedAccountType.value.trim(),
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

  Future<bool> createNow() async {
    if (isLoading.value) {
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
        '${ApiEndPoints.baseUrl}accounting/counterparties',
      );

      final Map<String, dynamic> body = getCounterPartyData();

      debugPrint('Create counterparty URL: $url');
      debugPrint('Create counterparty body: ${jsonEncode(body)}');
      debugPrint('Counterparty email: ${body['email']}');

      final String token = box.read('userToken')?.toString() ?? '';

      final http.Response response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('Create counterparty status: ${response.statusCode}');

      debugPrint('Create counterparty response: ${response.body}');

      dynamic responseData;

      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = {'message': 'Invalid response received from server'};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String message = responseData is Map
            ? responseData['message']?.toString() ?? 'Created successfully'
            : 'Created successfully';

        clearForm();

        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
        );

        Future.microtask(() async {
          try {
            counterPartyListController.initialpage = 1;
            counterPartyListController.finalList.clear();

            await counterPartyListController.fetchcounterpary();
          } catch (e, stackTrace) {
            debugPrint('Counterparty list refresh error: $e');

            debugPrintStack(stackTrace: stackTrace);
          }
        });

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
      debugPrint('Create counterparty exception: $e');

      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar(
        'Error',
        'Unable to create counterparty. Please try again.',
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

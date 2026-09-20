import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../global_controller/languages_controller.dart';
import '../../utils/api_endpoints.dart';

class CreateAccountController extends GetxController {
  final GetStorage box = GetStorage();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController openingBalanceController =
      TextEditingController();

  final TextEditingController notesController = TextEditingController();

  final LanguagesController languageController =
      Get.find<LanguagesController>();

  final RxInt selectedCounterpartyId = 0.obs;
  final RxInt selectedOfficeId = 0.obs;

  final RxInt selectedCurrencyId = 0.obs;
  final RxString selectedCurrencyCode = "".obs;

  final RxString selectedAccountType = "".obs;

  final RxBool isLoading = false.obs;

  var createAccountUrl = Uri.parse(
    ApiEndPoints.baseUrl + "accounting/accounts",
  );

  void selectCounterparty(int id) {
    selectedCounterpartyId.value = id;
  }

  void selectOffice(int id) {
    selectedOfficeId.value = id;
  }

  void selectCurrency({required int id, required String code}) {
    selectedCurrencyId.value = id;
    selectedCurrencyCode.value = code;
  }

  Future<void> createAccount() async {
    if (isLoading.value) return;

    if (!_validateForm()) return;

    final double openingBalance =
        double.tryParse(openingBalanceController.text.trim()) ?? 0;

    final Map<String, dynamic> requestBody = {
      "counterparty_id": selectedCounterpartyId.value,
      "office_id": selectedOfficeId.value,
      "accounting_currency_id": selectedCurrencyId.value,
      "currency_code": selectedCurrencyCode.value.trim(),
      "account_type": selectedAccountType.value.trim(),
      "name": nameController.text.trim(),
      "opening_balance": openingBalance,
      "notes": notesController.text.trim(),
    };

    isLoading.value = true;

    try {
      final String token =
          box.read("userToken")?.toString() ??
          box.read("token")?.toString() ??
          "";

      final http.Response response = await http.post(
        Uri.parse(createAccountUrl.toString()),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      dynamic responseData;

      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = null;
      }

      if (response.statusCode == 201) {
        final String message = responseData is Map<String, dynamic>
            ? responseData["message"]?.toString() ??
                  languageController.tr("ACCOUNT_CREATED_SUCCESSFULLY")
            : languageController.tr("ACCOUNT_CREATED_SUCCESSFULLY");

        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
        );

        clearForm();

        Get.back(result: true);
      } else {
        final String message = _extractErrorMessage(
          responseData,
          response.statusCode,
        );

        _showError(message);
      }
    } catch (error) {
      debugPrint("CREATE ACCOUNT ERROR: $error");

      _showError(
        "Something went wrong. Please check your internet connection.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (selectedCounterpartyId.value <= 0) {
      _showError(languageController.tr("SELECT_COUNTER_PARTY"));
      return false;
    }

    if (selectedOfficeId.value <= 0) {
      _showError(languageController.tr("SELECT_OFFICE"));
      return false;
    }

    if (selectedCurrencyId.value <= 0) {
      _showError(languageController.tr("SELECT_CURRENCY"));
      return false;
    }

    if (selectedCurrencyCode.value.trim().isEmpty) {
      _showError(languageController.tr("CURRENCY_CODE_IS_REQUIRED"));
      return false;
    }

    if (selectedAccountType.value.trim().isEmpty) {
      _showError(languageController.tr("SELECT_ACCOUNT_TYPE"));
      return false;
    }

    if (nameController.text.trim().isEmpty) {
      _showError(languageController.tr("ACCOUNT_NAME_IS_REQUIRED"));
      return false;
    }

    final String balanceText = openingBalanceController.text.trim();

    if (balanceText.isNotEmpty && double.tryParse(balanceText) == null) {
      _showError(languageController.tr("ENTER_VALID_OPENING_BALANCE"));
      return false;
    }

    return true;
  }

  String _extractErrorMessage(dynamic responseData, int statusCode) {
    if (responseData is Map<String, dynamic>) {
      final dynamic message = responseData["message"];

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }

      final dynamic errors = responseData["errors"];

      if (errors is Map) {
        for (final dynamic error in errors.values) {
          if (error is List && error.isNotEmpty) {
            return error.first.toString();
          }

          if (error != null) {
            return error.toString();
          }
        }
      }
    }

    return "Account creation failed. Status code: $statusCode";
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
    );
  }

  void clearForm() {
    nameController.clear();
    openingBalanceController.clear();
    notesController.clear();

    selectedCounterpartyId.value = 0;
    selectedOfficeId.value = 0;

    selectedCurrencyId.value = 0;
    selectedCurrencyCode.value = "";

    selectedAccountType.value = "";
  }

  @override
  void onClose() {
    nameController.dispose();
    openingBalanceController.dispose();
    notesController.dispose();

    super.onClose();
  }
}

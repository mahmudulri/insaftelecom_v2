import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insaftelecom/accounting/services/accounting_currency_service.dart';

import '../models/account_currency_model.dart';

class AccountingCurrencyController extends GetxController {
  final RxBool isLoading = false.obs;

  final Rx<AccountCurrencyModel> allcurrencylist = AccountCurrencyModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrencyList();
  }

  Future<void> fetchCurrencyList() async {
    try {
      isLoading.value = true;

      final AccountCurrencyModel value = await AccountingCurrencyApi()
          .fetchCurrency();

      allcurrencylist.value = value;
    } catch (e, stackTrace) {
      debugPrint('Currency list error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}

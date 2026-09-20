import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/allaccount_model.dart';
import '../services/all_accountlist_service.dart';

class AllAccountListController extends GetxController {
  int initialpage = 1;

  final RxBool isLoading = false.obs;

  final RxList<Account> finalList = <Account>[].obs;

  final Rx<AllAccountsModel> accountlist = AllAccountsModel().obs;

  /// API search
  final RxString searchText = ''.obs;

  /// API filters
  final RxnString selectedCurrencyCode = RxnString();
  final RxnInt selectedCounterpartyId = RxnInt();
  final RxnInt selectedOfficeId = RxnInt();
  final RxnString selectedBalanceStatus = RxnString();

  Timer? _searchDebounce;
  bool _pendingSearchRefresh = false;

  int get activeFilterCount {
    int count = 0;

    if (selectedCurrencyCode.value != null &&
        selectedCurrencyCode.value!.trim().isNotEmpty) {
      count++;
    }

    if (selectedCounterpartyId.value != null) {
      count++;
    }

    if (selectedOfficeId.value != null) {
      count++;
    }

    if (selectedBalanceStatus.value != null &&
        selectedBalanceStatus.value!.trim().isNotEmpty) {
      count++;
    }

    return count;
  }

  /// Search is now API-side, so the UI should display the API result directly.
  List<Account> get visibleAccounts => finalList.toList();

  void setSearchText(String value) {
    searchText.value = value;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (isLoading.value) {
        _pendingSearchRefresh = true;
        return;
      }

      await refreshAccounts();
    });
  }

  Future<void> submitSearch(String value) async {
    _searchDebounce?.cancel();
    searchText.value = value;

    if (isLoading.value) {
      _pendingSearchRefresh = true;
      return;
    }

    await refreshAccounts();
  }

  Future<void> fetchaccount({bool reset = false}) async {
    if (isLoading.value) return;

    try {
      if (reset) {
        initialpage = 1;
        finalList.clear();
      }

      isLoading.value = true;

      final AllAccountsModel value = await AllAccountlistApi().fetchaccountlist(
        initialpage,
        search: searchText.value,
        officeId: selectedOfficeId.value,
        currencyCode: selectedCurrencyCode.value,
        counterpartyId: selectedCounterpartyId.value,
        balanceStatus: selectedBalanceStatus.value,
      );

      accountlist.value = value;

      final List<Account> newAccounts = value.data?.accounts ?? <Account>[];

      if (initialpage == 1) {
        finalList.assignAll(newAccounts);
      } else {
        /// Prevent accidental duplicate accounts during pagination.
        final Set<String> existingIds = finalList
            .map((account) => account.id?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toSet();

        for (final Account account in newAccounts) {
          final String id = account.id?.toString() ?? '';

          if (id.isEmpty || !existingIds.contains(id)) {
            finalList.add(account);

            if (id.isNotEmpty) {
              existingIds.add(id);
            }
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Account list error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      isLoading.value = false;

      if (_pendingSearchRefresh) {
        _pendingSearchRefresh = false;
        await refreshAccounts();
      }
    }
  }

  Future<void> applyFilters({
    String? currencyCode,
    int? counterpartyId,
    int? officeId,
    String? balanceStatus,
  }) async {
    final String? cleanCurrencyCode =
        currencyCode == null || currencyCode.trim().isEmpty
        ? null
        : currencyCode.trim();

    final String? cleanBalanceStatus =
        balanceStatus == null || balanceStatus.trim().isEmpty
        ? null
        : balanceStatus.trim();

    selectedCurrencyCode.value = cleanCurrencyCode;
    selectedCounterpartyId.value = counterpartyId;
    selectedOfficeId.value = officeId;
    selectedBalanceStatus.value = cleanBalanceStatus;

    await refreshAccounts();
  }

  Future<void> clearFilters() async {
    selectedCurrencyCode.value = null;
    selectedCounterpartyId.value = null;
    selectedOfficeId.value = null;
    selectedBalanceStatus.value = null;

    await refreshAccounts();
  }

  Future<void> clearSearch() async {
    _searchDebounce?.cancel();
    searchText.value = '';

    await refreshAccounts();
  }

  Future<void> refreshAccounts() async {
    if (isLoading.value) {
      _pendingSearchRefresh = true;
      return;
    }

    initialpage = 1;
    finalList.clear();
    await fetchaccount();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:insaftelecom/accounting/models/counterparty_details_model.dart';
import 'package:insaftelecom/accounting/services/counterparty_details_service.dart';

class CounterpartyDetailsController extends GetxController {
  final RxBool isLoading = false.obs;

  final Rx<CounterPartyDetailsModel> alldata = CounterPartyDetailsModel().obs;

  final RxString errorMessage = ''.obs;

  /// Counterparty shortcut
  Counterparty? get counterparty {
    return alldata.value.data?.counterparty;
  }

  /// Snapshot shortcut
  Snapshot? get snapshot {
    return counterparty?.summary?.snapshot;
  }

  /// All currency balances
  List<SnapshotByCurrency> get balances {
    return snapshot?.byCurrency ?? [];
  }

  /// Data loaded or not
  bool get hasData {
    return counterparty != null;
  }

  /// Fetch counterparty details
  Future<bool> fetchdetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      /// Important:
      /// previous counterparty data clear করে দিচ্ছি
      /// যাতে নতুন API loading-এর সময় old data না আসে।
      alldata.value = CounterPartyDetailsModel();

      final response = await CounterpartyDetailsApi().fetchcounterpary(id);

      alldata.value = response;

      if (response.success == true && response.data?.counterparty != null) {
        return true;
      }

      errorMessage.value =
          response.message ?? 'Unable to fetch counterparty details';

      return false;
    } catch (e) {
      errorMessage.value = e.toString();

      print("Counterparty details error: ${e.toString()}");

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// API status থেকে UI relation translation key
  String getRelationKey(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'receivable':

        /// আমরা তার কাছ থেকে টাকা পাব
        return 'HE_OWE';

      case 'payable':

        /// তাকে আমাদের টাকা দিতে হবে
        return 'HE_OWED';

      case 'settled':
      case 'balanced':
        return 'BALANCE_SETTLED';

      default:
        return 'BALANCE_SETTLED';
    }
  }

  /// Share message balance title
  String getBalanceTitleKey(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'receivable':
        return 'RECEIVABLE_BALANCE';

      case 'payable':
        return 'PAYABLE_BALANCE';

      default:
        return 'BALANCE';
    }
  }

  /// String amount -> double
  double toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().replaceAll(',', '').trim()) ?? 0;
  }

  /// 8321.000000 -> 8,321
  /// 2886.360000 -> 2,886.36
  String formatAmount(dynamic value) {
    final double amount = toDouble(value).abs();

    final bool isWhole = amount == amount.roundToDouble();

    final String raw = isWhole
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);

    final List<String> parts = raw.split('.');

    final String integerPart = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    if (parts.length == 1) {
      return integerPart;
    }

    final String decimalPart = parts[1].replaceFirst(RegExp(r'0+$'), '');

    if (decimalPart.isEmpty) {
      return integerPart;
    }

    return '$integerPart.$decimalPart';
  }
}

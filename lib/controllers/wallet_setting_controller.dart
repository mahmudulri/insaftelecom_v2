import 'package:get/get.dart';
import '../models/walletsettings_model.dart';
import '../services/wallet_setting_service.dart';

class WalletSettingController extends GetxController {
  final WalletSettingsApi _walletSettingsApi = WalletSettingsApi();

  final RxBool isLoading = false.obs;

  final RxBool isUpdatingPreferredCurrency = false.obs;
  final RxBool isUpdatingBundlePriceMode = false.obs;
  final RxBool isUpdatingDeductionMode = false.obs;

  final Rx<WalletSettingsModel> allsettings = WalletSettingsModel().obs;

  final RxnInt selectedPreferredCurrencyId = RxnInt();

  final RxString selectedBundlePriceDisplayMode = ''.obs;
  final RxString selectedWalletDeductionMode = ''.obs;

  final RxString successMessage = ''.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchsettings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final WalletSettingsModel value = await _walletSettingsApi
          .fetchwalletsettings();

      allsettings.value = value;

      _setSelectedValues(value);
    } catch (e) {
      errorMessage.value = _cleanError(e);
      print("Wallet settings fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _setSelectedValues(WalletSettingsModel model) {
    final data = model.data;

    selectedPreferredCurrencyId.value = data?.preferredCurrency?.id;

    selectedBundlePriceDisplayMode.value = data?.bundlePriceDisplayMode ?? '';

    selectedWalletDeductionMode.value =
        data?.effectiveWalletDeductionMode ??
        data?.resellerWalletDeductionMode?.toString() ??
        '';
  }

  Future<bool> changePreferredCurrency({required int currencyId}) async {
    if (isUpdatingPreferredCurrency.value) {
      return false;
    }

    try {
      isUpdatingPreferredCurrency.value = true;
      successMessage.value = '';
      errorMessage.value = '';

      final response = await _walletSettingsApi.updatePreferredCurrency(
        currencyId: currencyId,
      );

      selectedPreferredCurrencyId.value = currencyId;

      successMessage.value =
          response["message"]?.toString() ??
          "Preferred currency updated successfully";

      await fetchsettings();

      return true;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      print("Preferred currency update error: $e");

      return false;
    } finally {
      isUpdatingPreferredCurrency.value = false;
    }
  }

  Future<bool> changeBundlePriceDisplayMode({required String mode}) async {
    if (isUpdatingBundlePriceMode.value) {
      return false;
    }

    final availableModes =
        allsettings.value.data?.availableBundlePriceDisplayModes ?? [];

    if (!availableModes.contains(mode)) {
      errorMessage.value = "Invalid bundle price display mode";
      return false;
    }

    try {
      isUpdatingBundlePriceMode.value = true;
      successMessage.value = '';
      errorMessage.value = '';

      final response = await _walletSettingsApi.updateBundlePriceDisplayMode(
        bundlePriceDisplayMode: mode,
      );

      selectedBundlePriceDisplayMode.value = mode;

      successMessage.value =
          response["message"]?.toString() ??
          "Bundle price display mode updated successfully";

      await fetchsettings();

      return true;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      print("Bundle price mode update error: $e");

      return false;
    } finally {
      isUpdatingBundlePriceMode.value = false;
    }
  }

  Future<bool> changeWalletDeductionMode({required String mode}) async {
    if (isUpdatingDeductionMode.value) {
      return false;
    }

    final data = allsettings.value.data;

    if (data?.canChangeWalletDeductionMode != true) {
      errorMessage.value =
          "You are not allowed to change wallet deduction mode";
      return false;
    }

    final availableModes = data?.availableWalletDeductionModes ?? [];

    if (!availableModes.contains(mode)) {
      errorMessage.value = "Invalid wallet deduction mode";
      return false;
    }

    try {
      isUpdatingDeductionMode.value = true;
      successMessage.value = '';
      errorMessage.value = '';

      final response = await _walletSettingsApi.updateWalletDeductionMode(
        walletDeductionMode: mode,
      );

      selectedWalletDeductionMode.value = mode;

      successMessage.value =
          response["message"]?.toString() ??
          "Wallet deduction mode updated successfully";

      await fetchsettings();

      return true;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      print("Wallet deduction mode update error: $e");

      return false;
    } finally {
      isUpdatingDeductionMode.value = false;
    }
  }

  bool get canChangeWalletDeductionMode {
    return allsettings.value.data?.canChangeWalletDeductionMode == true;
  }

  List<String> get availableBundlePriceModes {
    return allsettings.value.data?.availableBundlePriceDisplayModes ?? [];
  }

  List<String> get availableWalletDeductionModes {
    return allsettings.value.data?.availableWalletDeductionModes ?? [];
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst("Exception: ", "").trim();
  }
}

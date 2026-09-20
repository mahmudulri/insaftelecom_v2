import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/currency_controller.dart';
import '../controllers/wallet_setting_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/drawer.dart';

class WalletSettingScreen extends StatefulWidget {
  const WalletSettingScreen({super.key});

  @override
  State<WalletSettingScreen> createState() => _WalletSettingScreenState();
}

class _WalletSettingScreenState extends State<WalletSettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();

  final WalletSettingController walletSettingController =
      Get.find<WalletSettingController>();

  final CurrencyController currencyController = Get.find<CurrencyController>();

  @override
  void initState() {
    super.initState();

    walletSettingController.fetchsettings();

    if (currencyController.allcurrencylist.value.data?.currencies == null) {
      currencyController.fetchCurrencyList();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homeback.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildHeader(screenSize.width),
              const SizedBox(height: 18),
              Expanded(
                child: Obx(() {
                  if (walletSettingController.isLoading.value &&
                      walletSettingController.allsettings.value.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (walletSettingController.errorMessage.isNotEmpty &&
                      walletSettingController.allsettings.value.data == null) {
                    return _buildErrorState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      walletSettingController.fetchsettings();
                      currencyController.fetchCurrencyList();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 30,
                      ),
                      children: [
                        _buildCurrentWalletCard(),
                        const SizedBox(height: 14),
                        _buildPreferredCurrencyCard(),
                        const SizedBox(height: 14),
                        _buildBundlePriceDisplayCard(),
                        const SizedBox(height: 14),
                        _buildWalletDeductionModeCard(),
                        const SizedBox(height: 14),
                        _buildInformationCard(),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
      child: Row(
        children: [
          GestureDetector(
            onTap: mypagecontroller.handleBack,
            child: _headerButton(
              child: const Icon(
                FontAwesomeIcons.chevronLeft,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          Obx(
            () => Text(
              languagesController.tr("WALLET_SETTINGS"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: _headerButton(
              child: const Icon(Icons.menu_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerButton({required Widget child}) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  Widget _buildCurrentWalletCard() {
    final data = walletSettingController.allsettings.value.data;
    final activeWallet = data?.activeWallet;
    final currency = activeWallet?.currency;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0B3B91), Color(0xff0054C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withOpacity(.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languagesController.tr("ACTIVE_WALLET"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${currency?.code ?? "--"} "
                  "${activeWallet?.availableBalance ?? "0.00"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  currency?.name ??
                      languagesController.tr("CURRENCY_UNAVAILABLE"),
                  style: TextStyle(
                    color: Colors.white.withOpacity(.78),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (activeWallet?.isDefault == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.16),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                languagesController.tr("DEFAULT"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreferredCurrencyCard() {
    return Obx(() {
      final currencies =
          currencyController.allcurrencylist.value.data?.currencies ?? [];

      final selectedId =
          walletSettingController.selectedPreferredCurrencyId.value;

      final bool selectedExists = currencies.any(
        (currency) => currency.id == selectedId,
      );

      return _settingCard(
        icon: Icons.currency_exchange_rounded,
        iconColor: const Color(0xff175CD3),
        title: languagesController.tr("PREFERRED_CURRENCY"),
        subtitle: languagesController.tr(
          "SELECT_THE_CURRENCY_USED_AS_YOUR_PRIMARY_DISPLAY_CURRENCY",
        ),

        trailing: walletSettingController.isUpdatingPreferredCurrency.value
            ? _smallLoader()
            : null,
        child: currencyController.isLoading.value && currencies.isEmpty
            ? _fieldLoading()
            : DropdownButtonFormField<int>(
                value: selectedExists ? selectedId : null,
                isExpanded: true,
                decoration: _dropdownDecoration(
                  hintText: languagesController.tr("SELECT_PREFERRED_CURRENCY"),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: currencies.map((currency) {
                  final String currencyName = currency.name ?? "";
                  final String currencyCode = currency.code ?? "";

                  return DropdownMenuItem<int>(
                    value: currency.id,
                    child: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xffEEF4FF),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            currencyCode,
                            style: const TextStyle(
                              color: Color(0xff175CD3),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currencyName.isEmpty
                                ? currencyCode
                                : "$currencyName ($currencyCode)",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged:
                    walletSettingController.isUpdatingPreferredCurrency.value
                    ? null
                    : (int? currencyId) async {
                        if (currencyId == null || currencyId == selectedId) {
                          return;
                        }

                        final bool success = await walletSettingController
                            .changePreferredCurrency(currencyId: currencyId);

                        _showControllerMessage(success);
                      },
              ),
      );
    });
  }

  Widget _buildBundlePriceDisplayCard() {
    return Obx(() {
      final List<String> modes =
          walletSettingController.availableBundlePriceModes;

      final String selectedMode =
          walletSettingController.selectedBundlePriceDisplayMode.value;

      final bool selectedExists = modes.contains(selectedMode);

      return _settingCard(
        icon: Icons.sell_rounded,
        iconColor: const Color(0xff7A5AF8),
        title: languagesController.tr("BUNDLE_PRICE_DISPLAY"),
        subtitle: languagesController.tr(
          "CHOOSE_WHICH_CURRENCY_SHOULD_BE_USED_TO_DISPLAY_BUNDLE_PRICEV",
        ),

        trailing: walletSettingController.isUpdatingBundlePriceMode.value
            ? _smallLoader()
            : null,
        child: DropdownButtonFormField<String>(
          value: selectedExists ? selectedMode : null,
          isExpanded: true,
          decoration: _dropdownDecoration(
            hintText: languagesController.tr("SELECT_BUNDLE_PRICE_MODE"),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: modes.map((String mode) {
            return DropdownMenuItem<String>(
              value: mode,
              child: Row(
                children: [
                  Icon(
                    _bundlePriceModeIcon(mode),
                    size: 20,
                    color: const Color(0xff7A5AF8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _bundlePriceModeTitle(mode),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: walletSettingController.isUpdatingBundlePriceMode.value
              ? null
              : (String? mode) async {
                  if (mode == null || mode == selectedMode) {
                    return;
                  }

                  final bool success = await walletSettingController
                      .changeBundlePriceDisplayMode(mode: mode);

                  _showControllerMessage(success);
                },
        ),
      );
    });
  }

  Widget _buildWalletDeductionModeCard() {
    return Obx(() {
      final List<String> modes =
          walletSettingController.availableWalletDeductionModes;

      final String selectedMode =
          walletSettingController.selectedWalletDeductionMode.value;

      final bool canChange =
          walletSettingController.canChangeWalletDeductionMode;

      final bool selectedExists = modes.contains(selectedMode);

      return _settingCard(
        icon: Icons.payments_rounded,
        iconColor: const Color(0xff039855),
        title: languagesController.tr("WALLET_DEDUCTION_MODE"),
        subtitle: canChange
            ? languagesController.tr(
                "CHOOSE_HOW_THE_WALLET_BALANCE_WILL_BE_DEDUCTED_DURING_PURCHASE",
              )
            : languagesController.tr(
                "THIS_SETTING_IS_CONTROLLED_BY_THE_ADMINISTRATOR",
              ),

        trailing: walletSettingController.isUpdatingDeductionMode.value
            ? _smallLoader()
            : _permissionBadge(canChange),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedExists ? selectedMode : null,
              isExpanded: true,
              decoration: _dropdownDecoration(
                hintText: languagesController.tr("SELECT_DEDUCTION_MODE"),
                enabled: canChange,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: modes.map((String mode) {
                return DropdownMenuItem<String>(
                  value: mode,
                  child: Row(
                    children: [
                      Icon(
                        _deductionModeIcon(mode),
                        size: 20,
                        color: canChange
                            ? const Color(0xff039855)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _deductionModeTitle(mode),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged:
                  !canChange ||
                      walletSettingController.isUpdatingDeductionMode.value
                  ? null
                  : (String? mode) async {
                      if (mode == null || mode == selectedMode) {
                        return;
                      }

                      final bool success = await walletSettingController
                          .changeWalletDeductionMode(mode: mode);

                      _showControllerMessage(success);
                    },
            ),
            if (!canChange) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xffB54708),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      languagesController.tr(
                        "CONTACT_THE_ADMINISTRATOR_TO_CHANGE_THIS_OPTION",
                      ),

                      style: TextStyle(
                        color: Color(0xffB54708),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildInformationCard() {
    final data = walletSettingController.allsettings.value.data;

    final adminMode = data?.adminWalletDeductionMode;
    final effectiveMode = data?.effectiveWalletDeductionMode;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(.15)),
      ),
      child: Column(
        children: [
          _informationRow(
            title: languagesController.tr("ADMINISTRATOR_MODE"),
            value: _deductionModeTitle(adminMode ?? ""),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.white.withOpacity(.15)),
          const SizedBox(height: 10),
          _informationRow(
            title: languagesController.tr("EFFECTIVE_MODE"),
            value: _deductionModeTitle(effectiveMode ?? ""),
          ),
        ],
      ),
    );
  }

  Widget _settingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 23),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xff101828),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xff667085),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing],
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration({
    required String hintText,
    bool enabled = true,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: enabled ? const Color(0xffF9FAFB) : const Color(0xffF2F4F7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xffD0D5DD)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xffE4E7EC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xff175CD3), width: 1.3),
      ),
    );
  }

  Widget _smallLoader() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _fieldLoading() {
    return Container(
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xffD0D5DD)),
      ),
      child: const SizedBox(
        height: 21,
        width: 21,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _permissionBadge(bool canChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: canChange ? const Color(0xffECFDF3) : const Color(0xffFFF4E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            canChange ? Icons.lock_open_rounded : Icons.lock_rounded,
            size: 13,
            color: canChange
                ? const Color(0xff027A48)
                : const Color(0xffB54708),
          ),
          const SizedBox(width: 4),
          Text(
            canChange
                ? languagesController.tr("ENABLED")
                : languagesController.tr("LOCKED"),
            style: TextStyle(
              color: canChange
                  ? const Color(0xff027A48)
                  : const Color(0xffB54708),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationRow({required String title, required String value}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(.70),
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              walletSettingController.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: walletSettingController.fetchsettings,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  void _showControllerMessage(bool success) {
    if (!mounted) return;

    final String message = success
        ? walletSettingController.successMessage.value
        : walletSettingController.errorMessage.value;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: success
              ? const Color(0xff027A48)
              : const Color(0xffB42318),
          content: Row(
            children: [
              Icon(
                success
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message.isEmpty
                      ? success
                            ? "Setting updated successfully"
                            : "Unable to update setting"
                      : message,
                ),
              ),
            ],
          ),
        ),
      );
  }

  String _bundlePriceModeTitle(String mode) {
    switch (mode) {
      case "preferred_currency":
        return "Preferred Currency";
      case "bundle_currency":
        return "Bundle Currency";
      default:
        return _formatMode(mode);
    }
  }

  IconData _bundlePriceModeIcon(String mode) {
    switch (mode) {
      case "preferred_currency":
        return Icons.account_balance_wallet_outlined;
      case "bundle_currency":
        return Icons.inventory_2_outlined;
      default:
        return Icons.currency_exchange_rounded;
    }
  }

  String _deductionModeTitle(String mode) {
    switch (mode) {
      case "bundle_currency_wallet":
        return "Bundle Currency Wallet";
      case "selected_wallet_conversion":
        return "Selected Wallet Conversion";
      default:
        return _formatMode(mode);
    }
  }

  IconData _deductionModeIcon(String mode) {
    switch (mode) {
      case "bundle_currency_wallet":
        return Icons.account_balance_wallet_rounded;
      case "selected_wallet_conversion":
        return Icons.swap_horiz_rounded;
      default:
        return Icons.payments_outlined;
    }
  }

  String _formatMode(String value) {
    if (value.trim().isEmpty) {
      return "Not available";
    }

    return value
        .split("_")
        .where((word) => word.isNotEmpty)
        .map((word) => "${word[0].toUpperCase()}${word.substring(1)}")
        .join(" ");
  }
}

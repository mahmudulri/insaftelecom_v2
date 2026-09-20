import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_controller/languages_controller.dart';
import '../../helpers/language_changer.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_text.dart';
import '../controllers/accounting_currency_controller.dart';
import '../controllers/add_currency_controller.dart';
import '../controllers/delete_currency_controller.dart';
import '../controllers/update_currency_controller.dart';
import '../models/account_currency_model.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountingCurrencyController currencyController =
      Get.isRegistered<AccountingCurrencyController>()
      ? Get.find<AccountingCurrencyController>()
      : Get.put(AccountingCurrencyController());

  final AddCurrencyController addCurrencyController =
      Get.isRegistered<AddCurrencyController>()
      ? Get.find<AddCurrencyController>()
      : Get.put(AddCurrencyController());

  final UpdateCurrencyController updateCurrencyController =
      Get.isRegistered<UpdateCurrencyController>()
      ? Get.find<UpdateCurrencyController>()
      : Get.put(UpdateCurrencyController());

  final DeleteCurrencyController deleteCurrencyController =
      Get.isRegistered<DeleteCurrencyController>()
      ? Get.find<DeleteCurrencyController>()
      : Get.put(DeleteCurrencyController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currencies =
          currencyController.allcurrencylist.value.data?.currencies ?? [];

      if (currencies.isEmpty && !currencyController.isLoading.value) {
        currencyController.fetchCurrencyList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 7),
          _buildOverviewCard(),
          const SizedBox(height: 9),
          Expanded(child: _buildCurrencyList()),
        ],
      ),
      bottomNavigationBar: _buildAddCurrencyButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 58,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      titleSpacing: 12,
      title: Row(
        children: [
          _appBarButton(icon: Icons.arrow_back_rounded, onTap: Get.back),
          const SizedBox(width: 10),
          Expanded(
            child: KText(
              text: languagesController.tr('CURRENCY'),
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
            ),
            child: const LanguageSelectorButton(size: 38, iconSize: 21),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.primaryColor.withOpacity(0.045),
        ),
      ),
    );
  }

  Widget _appBarButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.afraPayBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.afraPayTurquoise.withOpacity(0.10),
          ),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 21),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(() {
        final currencies =
            currencyController.allcurrencylist.value.data?.currencies ?? [];

        final totalItems =
            currencyController
                .allcurrencylist
                .value
                .data
                ?.pagination
                ?.totalItems ??
            currencies.length;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.16),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: languagesController.tr('ACCOUNTING_CURRENCIES'),
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    KText(
                      text:
                          '$totalItems ${languagesController.tr('CURRENCIES_AVAILABLE')}',
                      color: Colors.white.withOpacity(0.68),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: currencyController.fetchCurrencyList,
                child: Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white.withOpacity(0.09)),
                  ),
                  child: Obx(
                    () => currencyController.isLoading.value
                        ? const SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCurrencyList() {
    return Obx(() {
      final List<Currency> currencies =
          currencyController.allcurrencylist.value.data?.currencies ?? [];

      final isLoading = currencyController.isLoading.value;

      if (isLoading && currencies.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.3,
            color: AppColors.afraPayTurquoise,
          ),
        );
      }

      if (currencies.isEmpty) {
        return RefreshIndicator(
          color: AppColors.afraPayTurquoise,
          onRefresh: currencyController.fetchCurrencyList,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 70),
            children: [_buildEmptyState()],
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.afraPayTurquoise,
        onRefresh: currencyController.fetchCurrencyList,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          itemCount: currencies.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
          itemBuilder: (context, index) {
            return _buildCurrencyCard(currencies[index]);
          },
        ),
      );
    });
  }

  Widget _buildCurrencyCard(Currency currency) {
    final name = currency.name?.trim().isNotEmpty == true
        ? currency.name!.trim()
        : languagesController.tr('UNNAMED_CURRENCY');

    final code = currency.code?.trim().isNotEmpty == true
        ? currency.code!.trim()
        : '---';

    final symbol = currency.symbol?.trim().isNotEmpty == true
        ? currency.symbol!.trim()
        : code;

    final rate = _formatExchangeRate(currency.exchangeRatePerUsd);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showCurrencyActions(currency);
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          padding: const EdgeInsets.fromLTRB(11, 10, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.055),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.035),
                blurRadius: 11,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarycolor2,
                      AppColors.afraPayTurquoise,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: KText(
                  text: symbol,
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: name,
                      color: AppColors.primaryColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.afraPayBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: KText(
                        text: code,
                        color: AppColors.fontColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  KText(
                    text: rate,
                    color: AppColors.afraPayTurquoise,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 4),
                  KText(
                    text: languagesController.tr('EXCHANGE_RATE_PER_USD'),
                    color: AppColors.fontColor,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              const SizedBox(width: 7),
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.afraPayBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.fontColor,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 68,
              width: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.afraPayTurquoise.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.currency_exchange_rounded,
                color: AppColors.afraPayTurquoise,
                size: 31,
              ),
            ),
            const SizedBox(height: 14),
            KText(
              text: languagesController.tr('NO_CURRENCIES_FOUND'),
              color: AppColors.primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            KText(
              text: languagesController.tr(
                'ADD_YOUR_FIRST_ACCOUNTING_CURRENCY',
              ),
              color: AppColors.fontColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCurrencyButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: GestureDetector(
          onTap: _showAddCurrencyDialog,
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primarycolor2, AppColors.afraPayTurquoise],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.afraPayTurquoise.withOpacity(0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 19),
                const SizedBox(width: 6),
                KText(
                  text: languagesController.tr('ADD_NEW_CURRENCY'),
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCurrencyActions(Currency currency) {
    final name = currency.name?.trim().isNotEmpty == true
        ? currency.name!.trim()
        : languagesController.tr('CURRENCY');

    final code = currency.code?.trim().isNotEmpty == true
        ? currency.code!.trim()
        : '---';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.fontColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.afraPayTurquoise.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: KText(
                        text: code,
                        color: AppColors.afraPayTurquoise,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KText(
                        text: name,
                        color: AppColors.primaryColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                _actionTile(
                  icon: Icons.edit_outlined,
                  title: languagesController.tr('EDIT'),
                  color: AppColors.primarycolor2,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showEditCurrencyDialog(currency);
                  },
                ),
                const SizedBox(height: 8),
                _actionTile(
                  icon: Icons.delete_outline_rounded,
                  title: languagesController.tr('DELETE'),
                  color: const Color(0xFFE05263),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showDeleteCurrencyDialog(currency);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KText(
                  text: title,
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCurrencyDialog() async {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final symbolController = TextEditingController();
    final exchangeRateController = TextEditingController();

    addCurrencyController.errorMessage.value = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.88,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHandle(),
                    const SizedBox(height: 12),
                    _sheetHeader(
                      icon: Icons.add_card_rounded,
                      title: languagesController.tr('ADD_NEW_CURRENCY'),
                      onClose: () {
                        Navigator.pop(sheetContext);
                      },
                    ),
                    const SizedBox(height: 16),
                    _formLabel(languagesController.tr('CURRENCY_NAME')),
                    const SizedBox(height: 7),
                    _formField(
                      controller: nameController,
                      hint: languagesController.tr('EXAMPLE_AFGHANI'),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 13),
                    _formLabel(languagesController.tr('CURRENCY_CODE')),
                    const SizedBox(height: 7),
                    _formField(
                      controller: codeController,
                      hint: languagesController.tr('EXAMPLE_AFN'),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 13),
                    _formLabel(languagesController.tr('CURRENCY_SYMBOL')),
                    const SizedBox(height: 7),
                    _formField(
                      controller: symbolController,
                      hint: languagesController.tr('EXAMPLE_CURRENCY_SYMBOL'),
                    ),
                    const SizedBox(height: 13),
                    _formLabel(languagesController.tr('EXCHANGE_RATE_PER_USD')),
                    const SizedBox(height: 7),
                    _formField(
                      controller: exchangeRateController,
                      hint: languagesController.tr('EXAMPLE_EXCHANGE_RATE'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    Obx(() {
                      final error = addCurrencyController.errorMessage.value;

                      if (error.isEmpty) {
                        return const SizedBox(height: 17);
                      }

                      return _errorBox(error);
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: _secondaryButton(
                            title: languagesController.tr('CANCEL'),
                            onTap: () {
                              Navigator.pop(sheetContext);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() {
                            final isLoading =
                                addCurrencyController.isLoading.value;

                            return _primaryButton(
                              title: languagesController.tr('ADD_CURRENCY'),
                              isLoading: isLoading,
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      final success =
                                          await addCurrencyController
                                              .addCurrency(
                                                name: nameController.text,
                                                code: codeController.text,
                                                symbol: symbolController.text,
                                                exchangeRatePerUsd:
                                                    exchangeRateController.text,
                                              );

                                      if (success) {
                                        Navigator.pop(sheetContext);
                                        await currencyController
                                            .fetchCurrencyList();
                                      }
                                    },
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    nameController.dispose();
    codeController.dispose();
    symbolController.dispose();
    exchangeRateController.dispose();
  }

  Future<void> _showEditCurrencyDialog(Currency currency) async {
    final exchangeRateController = TextEditingController(
      text: _formatExchangeRate(currency.exchangeRatePerUsd),
    );

    updateCurrencyController.errorMessage.value = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHandle(),
                    const SizedBox(height: 12),
                    _sheetHeader(
                      icon: Icons.edit_outlined,
                      title:
                          '${languagesController.tr('EDIT')} ${currency.name ?? languagesController.tr('CURRENCY')}',
                      onClose: () {
                        Navigator.pop(sheetContext);
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.afraPayBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          KText(
                            text: currency.code ?? '---',
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.fontColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          KText(
                            text: currency.symbol ?? '---',
                            color: AppColors.fontColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _formLabel(languagesController.tr('EXCHANGE_RATE_PER_USD')),
                    const SizedBox(height: 7),
                    _formField(
                      controller: exchangeRateController,
                      hint: languagesController.tr('ENTER_EXCHANGE_RATE'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    Obx(() {
                      final error = updateCurrencyController.errorMessage.value;

                      if (error.isEmpty) {
                        return const SizedBox(height: 17);
                      }

                      return _errorBox(error);
                    }),
                    Row(
                      children: [
                        Expanded(
                          child: _secondaryButton(
                            title: languagesController.tr('CANCEL'),
                            onTap: () {
                              Navigator.pop(sheetContext);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() {
                            final isLoading =
                                updateCurrencyController.isLoading.value;

                            return _primaryButton(
                              title: languagesController.tr('UPDATE'),
                              isLoading: isLoading,
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      final success =
                                          await updateCurrencyController
                                              .updateCurrency(
                                                currencyId: currency.id,
                                                exchangeRatePerUsd:
                                                    exchangeRateController.text,
                                              );

                                      if (success) {
                                        Navigator.pop(sheetContext);
                                        await currencyController
                                            .fetchCurrencyList();
                                      }
                                    },
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    exchangeRateController.dispose();
  }

  Future<void> _showDeleteCurrencyDialog(Currency currency) async {
    deleteCurrencyController.errorMessage.value = '';

    await Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 58,
                width: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEFF1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE05263),
                  size: 29,
                ),
              ),
              const SizedBox(height: 14),
              KText(
                text: languagesController.tr('DELETE_CURRENCY_QUESTION'),
                color: AppColors.primaryColor,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 7),
              KText(
                text:
                    '${languagesController.tr('ARE_YOU_SURE_YOU_WANT_TO_DELETE')} ${currency.name ?? languagesController.tr('THIS_CURRENCY')}?',
                color: AppColors.fontColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                height: 1.45,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              Obx(() {
                final error = deleteCurrencyController.errorMessage.value;

                if (error.isEmpty) {
                  return const SizedBox(height: 18);
                }

                return _errorBox(error, centered: true);
              }),
              Row(
                children: [
                  Expanded(
                    child: _secondaryButton(
                      title: languagesController.tr('CANCEL'),
                      onTap: Get.back,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() {
                      final isLoading =
                          deleteCurrencyController.isLoading.value;

                      return _dangerButton(
                        title: languagesController.tr('DELETE'),
                        isLoading: isLoading,
                        onTap: isLoading
                            ? null
                            : () async {
                                final success = await deleteCurrencyController
                                    .deleteCurrency(currencyId: currency.id);

                                if (success) {
                                  Get.back();
                                  await currencyController.fetchCurrencyList();
                                }
                              },
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _sheetHandle() {
    return Center(
      child: Container(
        height: 4,
        width: 42,
        decoration: BoxDecoration(
          color: AppColors.fontColor.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _sheetHeader({
    required IconData icon,
    required String title,
    required VoidCallback onClose,
  }) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primarycolor2, AppColors.afraPayTurquoise],
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: KText(
            text: title,
            color: AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Container(
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.fontColor,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _formLabel(String text) {
    return KText(
      text: text,
      color: AppColors.primaryColor,
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      cursorColor: AppColors.afraPayTurquoise,
      style: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.fontColor.withOpacity(0.72),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppColors.primaryColor.withOpacity(0.045),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.afraPayTurquoise,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _errorBox(String message, {bool centered = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 13, bottom: 13),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: KText(
        text: message,
        color: const Color(0xFFE05263),
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        textAlign: centered ? TextAlign.center : TextAlign.start,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _secondaryButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.afraPayBackground,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        ),
        child: KText(
          text: title,
          color: AppColors.primaryColor,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String title,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    AppColors.primarycolor2.withOpacity(0.55),
                    AppColors.afraPayTurquoise.withOpacity(0.55),
                  ]
                : const [AppColors.primarycolor2, AppColors.afraPayTurquoise],
          ),
          borderRadius: BorderRadius.circular(13),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : KText(
                text: title,
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
      ),
    );
  }

  Widget _dangerButton({
    required String title,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading
              ? const Color(0xFFE05263).withOpacity(0.55)
              : const Color(0xFFE05263),
          borderRadius: BorderRadius.circular(13),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : KText(
                text: title,
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
      ),
    );
  }

  String _formatExchangeRate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '0';
    }

    final parsedValue = double.tryParse(value);

    if (parsedValue == null) {
      return value;
    }

    String formattedValue = parsedValue.toStringAsFixed(12);

    formattedValue = formattedValue.replaceFirst(RegExp(r'\.?0+$'), '');

    return formattedValue;
  }
}

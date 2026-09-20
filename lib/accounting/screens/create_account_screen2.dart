import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/counter_party_controller.dart';
import 'package:insaftelecom/accounting/controllers/create_account_controller2.dart';
import 'package:insaftelecom/accounting/create_counterpary_screen.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/accountextfield.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountScreen2 extends StatefulWidget {
  const CreateAccountScreen2({super.key, required this.officeId});

  final int officeId;

  @override
  State<CreateAccountScreen2> createState() => _CreateAccountScreen2State();
}

class _CreateAccountScreen2State extends State<CreateAccountScreen2> {
  late final String controllerTag;

  late final CreateAccountController2 formController;

  final AccountingCurrencyController currencyController =
      Get.find<AccountingCurrencyController>();

  final CounterPartyController counterPartyController =
      Get.isRegistered<CounterPartyController>()
      ? Get.find<CounterPartyController>()
      : Get.put(CounterPartyController());

  final LanguagesController languageController =
      Get.find<LanguagesController>();

  List<Map<String, dynamic>> get accountTypeOptions {
    return [
      {
        'title': languageController.tr('WORK'),
        'value': 'work',
        'icon': Icons.work_outline_rounded,
      },
      {
        'title': languageController.tr('SAVING'),
        'value': 'saving',
        'icon': Icons.savings_outlined,
      },
      {
        'title': languageController.tr('CURRENT'),
        'value': 'current',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': languageController.tr('FIXED'),
        'value': 'fixed',
        'icon': Icons.lock_outline_rounded,
      },
    ];
  }

  @override
  void initState() {
    super.initState();

    controllerTag =
        'create_account_${widget.officeId}_${identityHashCode(this)}';

    formController = Get.put(
      CreateAccountController2(officeId: widget.officeId),
      tag: controllerTag,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (counterPartyController.finalList.isEmpty &&
        !counterPartyController.isLoading.value) {
      counterPartyController.initialpage = 1;
      await counterPartyController.fetchcounterpary();
    }

    final currencies =
        currencyController.allcurrencylist.value.data?.currencies ?? [];

    if (currencies.isEmpty && !currencyController.isLoading.value) {
      await currencyController.fetchCurrencyList();
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<CreateAccountController2>(tag: controllerTag)) {
      Get.delete<CreateAccountController2>(tag: controllerTag);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                children: [
                  _buildIntroCard(),
                  const SizedBox(height: 10),
                  _buildCounterpartyCard(),
                  const SizedBox(height: 10),
                  _buildCurrencyCard(),
                  const SizedBox(height: 10),
                  _buildAccountTypeCard(),
                  const SizedBox(height: 10),
                  _buildAccountInformationCard(),
                  const SizedBox(height: 10),
                  _buildOpeningBalanceCard(),
                  const SizedBox(height: 10),
                  _buildNotesCard(),
                ],
              ),
            ),
            _buildCreateButton(),
          ],
        ),
      ),
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
              text: languageController.tr('CREATE_NEW_ACCOUNT'),
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

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.14),
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
              Icons.add_card_rounded,
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
                  text: languageController.tr('CREATE_NEW_ACCOUNT'),
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                KText(
                  text:
                      '${languageController.tr('OFFICE')} #${widget.officeId}',
                  color: Colors.white.withOpacity(0.68),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.business_outlined,
              color: Colors.white,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterpartyCard() {
    return _sectionCard(
      icon: Icons.people_outline_rounded,
      title: languageController.tr('COUNTER_PARTY'),
      trailing: GestureDetector(
        onTap: _createCounterparty,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primarycolor2, AppColors.afraPayTurquoise],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 15,
              ),
              const SizedBox(width: 4),
              KText(
                text: languageController.tr('ADD'),
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
      child: _buildCounterpartyDropdown(),
    );
  }

  Future<void> _createCounterparty() async {
    final bool? created = await Get.bottomSheet<bool>(
      const CreateCounterparyScreen(isPopup: true),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
    );

    if (created == true) {
      counterPartyController.initialpage = 1;
      counterPartyController.finalList.clear();

      await counterPartyController.fetchcounterpary();
    }
  }

  Widget _buildCurrencyCard() {
    return _sectionCard(
      icon: Icons.currency_exchange_rounded,
      title: languageController.tr('CURRENCY'),
      trailing: GestureDetector(
        onTap: () async {
          await currencyController.fetchCurrencyList();
        },
        child: Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.refresh_rounded,
            size: 16,
            color: AppColors.afraPayTurquoise,
          ),
        ),
      ),
      child: _buildCurrencyDropdown(),
    );
  }

  Widget _buildAccountTypeCard() {
    return _sectionCard(
      icon: Icons.category_outlined,
      title: languageController.tr('ACCOUNT_TYPE'),
      child: _buildAccountTypeSelector(),
    );
  }

  Widget _buildAccountInformationCard() {
    return _sectionCard(
      icon: Icons.badge_outlined,
      title: languageController.tr('ACCOUNT_NAME'),
      child: Accountextfield(
        controller: formController.nameController,
        label: languageController.tr('ACCOUNT_NAME'),
        hint: languageController.tr('ENTER_ACCOUNT_NAME'),
        height: 55,
      ),
    );
  }

  Widget _buildOpeningBalanceCard() {
    return _sectionCard(
      icon: Icons.payments_outlined,
      title: languageController.tr('OPENING_BALANCE'),
      child: Accountextfield(
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        controller: formController.openingBalanceController,
        label: languageController.tr('OPENING_BALANCE'),
        hint: languageController.tr('ENTER_OPENING_BALANCE'),
        height: 55,
      ),
    );
  }

  Widget _buildNotesCard() {
    return _sectionCard(
      icon: Icons.notes_rounded,
      title: languageController.tr('NOTES'),
      child: TextField(
        controller: formController.notesController,
        minLines: 3,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
        cursorColor: AppColors.afraPayTurquoise,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: languageController.tr('ENTER_ACCOUNT_NOTES'),
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
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.afraPayTurquoise.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.afraPayTurquoise),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KText(
                  text: title,
                  color: AppColors.primaryColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCounterpartyDropdown() {
    return Obx(() {
      if (counterPartyController.isLoading.value &&
          counterPartyController.finalList.isEmpty) {
        return _loadingDropdown(label: languageController.tr('COUNTER_PARTY'));
      }

      final Map<int, dynamic> uniqueMap = {};

      for (final item in counterPartyController.finalList) {
        final int? id = item.id;

        if (id != null && !uniqueMap.containsKey(id)) {
          uniqueMap[id] = item;
        }
      }

      final counterpartyList = uniqueMap.values.toList();

      final selectedId = formController.selectedCounterpartyId.value;

      final selectedExists = counterpartyList.any(
        (item) => item.id == selectedId,
      );

      return DropdownButtonFormField<int>(
        value: selectedId > 0 && selectedExists ? selectedId : null,
        isExpanded: true,
        menuMaxHeight: 350,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.fontColor,
        ),
        decoration: _dropdownDecoration(
          label: languageController.tr('COUNTER_PARTY'),
          hint: languageController.tr('SELECT_COUNTER_PARTY'),
        ),
        items: counterpartyList.map<DropdownMenuItem<int>>((counterparty) {
          final name = counterparty.name?.toString().trim() ?? '';

          return DropdownMenuItem<int>(
            value: counterparty.id,
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.afraPayTurquoise.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: KText(
                    text: _firstLetter(name),
                    color: AppColors.afraPayTurquoise,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: KText(
                    text: name.isEmpty ? '--' : name,
                    color: AppColors.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (id) {
          if (id != null) {
            formController.selectCounterparty(id);
          }
        },
      );
    });
  }

  Widget _buildCurrencyDropdown() {
    return Obx(() {
      final currencies =
          currencyController.allcurrencylist.value.data?.currencies ?? [];

      if (currencyController.isLoading.value && currencies.isEmpty) {
        return _loadingDropdown(label: languageController.tr('CURRENCY'));
      }

      final selectedId = formController.selectedCurrencyId.value;

      final selectedExists = currencies.any((item) => item.id == selectedId);

      return DropdownButtonFormField<int>(
        value: selectedId > 0 && selectedExists ? selectedId : null,
        isExpanded: true,
        menuMaxHeight: 350,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.fontColor,
        ),
        decoration: _dropdownDecoration(
          label: languageController.tr('CURRENCY'),
          hint: languageController.tr('SELECT_CURRENCY'),
        ),
        items: currencies.map((currency) {
          final code = currency.code?.toString().trim() ?? '';

          final name = currency.name?.toString().trim() ?? '';

          return DropdownMenuItem<int>(
            value: currency.id,
            child: Row(
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: 38),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 5,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.afraPayTurquoise.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: KText(
                    text: code.isEmpty ? '--' : code,
                    color: AppColors.afraPayTurquoise,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: KText(
                    text: name.isEmpty ? '--' : name,
                    color: AppColors.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (id) {
          if (id == null) {
            return;
          }

          final selectedCurrency = currencies.firstWhereOrNull(
            (currency) => currency.id == id,
          );

          if (selectedCurrency == null) {
            return;
          }

          formController.selectCurrency(
            id: selectedCurrency.id ?? 0,
            code: selectedCurrency.code ?? '',
          );
        },
      );
    });
  }

  Widget _buildAccountTypeSelector() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(accountTypeOptions.length, (index) {
            final item = accountTypeOptions[index];

            final value = item['value']?.toString() ?? '';

            final title = item['title']?.toString() ?? '';

            final icon = item['icon'] as IconData;

            final isSelected =
                formController.selectedAccountType.value == value;

            return Padding(
              padding: EdgeInsetsDirectional.only(
                end: index == accountTypeOptions.length - 1 ? 0 : 7,
              ),
              child: GestureDetector(
                onTap: () {
                  formController.selectAccountType(value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minWidth: 92),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.035),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.055),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 15,
                        color: isSelected
                            ? Colors.white
                            : AppColors.afraPayTurquoise,
                      ),
                      const SizedBox(width: 5),
                      KText(
                        text: title,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  InputDecoration _dropdownDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.045),
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      hintStyle: TextStyle(
        color: AppColors.fontColor.withOpacity(0.72),
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.07)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.afraPayTurquoise,
          width: 1,
        ),
      ),
    );
  }

  Widget _loadingDropdown({required String label}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.035),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),
      child: Row(
        children: [
          Expanded(
            child: KText(
              text: label,
              color: AppColors.fontColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.afraPayTurquoise,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Obx(() {
          final isLoading = formController.isLoading.value;

          return GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    formController.createAccount();
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLoading
                      ? [
                          AppColors.primarycolor2.withOpacity(0.55),
                          AppColors.afraPayTurquoise.withOpacity(0.55),
                        ]
                      : const [
                          AppColors.primarycolor2,
                          AppColors.afraPayTurquoise,
                        ],
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
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_card_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        KText(
                          text: languageController.tr('CREATE_NOW'),
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }

  String _firstLetter(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return '?';
    }

    return text.substring(0, 1).toUpperCase();
  }
}

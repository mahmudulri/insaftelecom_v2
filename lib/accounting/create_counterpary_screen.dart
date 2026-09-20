import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/create_counter_party_controller.dart';
import 'package:insaftelecom/accounting/controllers/office_list_controller.dart';
import 'package:insaftelecom/accounting/models/office_list_model.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/accountextfield.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateCounterparyScreen extends StatefulWidget {
  const CreateCounterparyScreen({super.key, this.isPopup = false});

  final bool isPopup;

  @override
  State<CreateCounterparyScreen> createState() =>
      _CreateCounterparyScreenState();
}

class _CreateCounterparyScreenState extends State<CreateCounterparyScreen> {
  late final CreateCounterPartyController formController;
  late final AccountingCurrencyController currencyController;
  late final OfficeListController officeListController;
  late final LanguagesController languageController;

  int selectedCurrencyIndex = -1;

  @override
  void initState() {
    super.initState();

    formController = Get.isRegistered<CreateCounterPartyController>()
        ? Get.find<CreateCounterPartyController>()
        : Get.put(CreateCounterPartyController());

    currencyController = Get.find<AccountingCurrencyController>();

    languageController = Get.find<LanguagesController>();

    officeListController = Get.isRegistered<OfficeListController>()
        ? Get.find<OfficeListController>()
        : Get.put(OfficeListController());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final currencies =
        currencyController.allcurrencylist.value.data?.currencies ?? [];

    if (currencies.isEmpty && !currencyController.isLoading.value) {
      await currencyController.fetchCurrencyList();
    }

    await _loadOfficeList();
    _restoreCurrencySelection();
  }

  Future<void> _loadOfficeList() async {
    if (officeListController.isLoading.value) {
      return;
    }

    if (officeListController.finalList.isNotEmpty) {
      return;
    }

    officeListController.initialpage = 1;
    await officeListController.fetchofficelist();
  }

  void _restoreCurrencySelection() {
    final currencies =
        currencyController.allcurrencylist.value.data?.currencies ?? [];

    final selectedCode = formController.selectedCurrencyCode.value.trim();

    if (selectedCode.isEmpty) {
      return;
    }

    final index = currencies.indexWhere(
      (item) =>
          item.code?.toString().trim().toLowerCase() ==
          selectedCode.toLowerCase(),
    );

    if (index >= 0 && mounted) {
      setState(() {
        selectedCurrencyIndex = index;
      });
    }
  }

  List<Map<String, String>> get _typeOptions => [
    {'title': languageController.tr('SUPPLIER'), 'value': 'supplier'},
    {'title': languageController.tr('CUSTOMER'), 'value': 'customer'},
  ];

  List<Map<String, String>> get _accountTypeOptions => [
    {'title': languageController.tr('SAVING'), 'value': 'saving'},
    {'title': languageController.tr('CURRENT'), 'value': 'current'},
    {'title': languageController.tr('FIXED'), 'value': 'fixed'},
  ];

  void showValidationToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
    );
  }

  Future<void> validateAndCreate() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final name = formController.nameController.text.trim();
    final phone = formController.phoneController.text.trim();
    final currency = formController.selectedCurrencyCode.value.trim();

    if (name.isEmpty) {
      showValidationToast(languageController.tr('NAME_IS_REQUIRED'));
      return;
    }

    if (phone.isEmpty) {
      showValidationToast(languageController.tr('PHONE_NUMBER_IS_REQUIRED'));
      return;
    }

    if (!RegExp(r'^[0-9]{6,15}$').hasMatch(phone)) {
      showValidationToast(languageController.tr('ENTER_A_VALID_PHONE_NUMBER'));
      return;
    }

    if (currency.isEmpty) {
      showValidationToast(languageController.tr('PLEASE_SELECT_A_CURRENCY'));
      return;
    }

    if (formController.createDefaultAccount.value &&
        formController.selectedOfficeId.value == null) {
      showValidationToast(languageController.tr('PLEASE_SELECT_AN_OFFICE'));
      return;
    }

    final success = await formController.createNow();

    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        selectedCurrencyIndex = -1;
      });

      if (widget.isPopup) {
        Get.back(result: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPopup) {
      return _buildPopupLayout();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
              text: languageController.tr('CREATE_COUNTER_PARTY'),
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

  Widget _buildPopupLayout() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.afraPayBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.fontColor.withOpacity(0.24),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 8),
            child: Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primarycolor2,
                        AppColors.afraPayTurquoise,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: KText(
                    text: languageController.tr('CREATE_COUNTER_PARTY'),
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.05),
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.fontColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.primaryColor.withOpacity(0.045),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              children: [
                _buildIntroCard(),
                const SizedBox(height: 10),
                _buildContactCard(),
                const SizedBox(height: 10),
                _buildTypeCard(),
                const SizedBox(height: 10),
                _buildDefaultAccountCard(),
                const SizedBox(height: 10),
                _buildCurrencyCard(),
                const SizedBox(height: 10),
                _buildBalanceCard(),
              ],
            ),
          ),
          _buildCreateButton(),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
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
              Icons.person_add_alt_1_rounded,
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
                  text: languageController.tr('CREATE_COUNTER_PARTY'),
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                KText(
                  text: languageController.tr('COUNTER_PARTY'),
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
              Icons.people_outline_rounded,
              color: Colors.white,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return _sectionCard(
      icon: Icons.badge_outlined,
      title: languageController.tr('COUNTER_PARTY'),
      child: Column(
        children: [
          Accountextfield(
            controller: formController.nameController,
            label: languageController.tr('NAME'),
            hint: languageController.tr('COUNTER_PARTY_NAME'),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            keyboardType: TextInputType.phone,
            controller: formController.phoneController,
            label: languageController.tr('PHONE_NUMBER'),
            hint: languageController.tr('ENTER_PHONE_NUMBER'),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            keyboardType: TextInputType.emailAddress,
            controller: formController.emailController,
            label: languageController.tr('EMAIL'),
            hint: languageController.tr('ENTER_EMAIL_ADDRESS'),
            height: 55,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard() {
    return _sectionCard(
      icon: Icons.tune_rounded,
      title: languageController.tr('TYPE'),
      child: Column(
        children: [
          Obx(
            () => DropdownButtonFormField<String>(
              value: formController.selectedType.value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.fontColor,
              ),
              decoration: _dropdownDecoration(languageController.tr('TYPE')),
              items: _typeOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item['value'],
                      child: KText(
                        text: item['title'] ?? '',
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  formController.selectedType.value = value;
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => DropdownButtonFormField<String>(
              value: formController.selectedAccountType.value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.fontColor,
              ),
              decoration: _dropdownDecoration(
                languageController.tr('ACCOUNT_TYPE'),
              ),
              items: _accountTypeOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item['value'],
                      child: KText(
                        text: item['title'] ?? '',
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  formController.selectedAccountType.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAccountCard() {
    return _sectionCard(
      icon: Icons.account_balance_wallet_outlined,
      title: languageController.tr('CREATE_DEFAULT_ACCOUNT'),
      child: Obx(() {
        final enabled = formController.createDefaultAccount.value;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                final nextValue = !enabled;

                formController.changeDefaultAccountStatus(nextValue);

                if (nextValue) {
                  _loadOfficeList();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.fromLTRB(11, 9, 9, 9),
                decoration: BoxDecoration(
                  color: enabled
                      ? AppColors.afraPayTurquoise.withOpacity(0.07)
                      : AppColors.primaryColor.withOpacity(0.035),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: enabled
                        ? AppColors.afraPayTurquoise.withOpacity(0.16)
                        : AppColors.primaryColor.withOpacity(0.055),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 34,
                      width: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: enabled
                            ? AppColors.afraPayTurquoise.withOpacity(0.12)
                            : AppColors.afraPayBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        enabled
                            ? Icons.check_circle_outline_rounded
                            : Icons.pause_circle_outline_rounded,
                        color: enabled
                            ? AppColors.afraPayTurquoise
                            : AppColors.fontColor,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KText(
                        text: languageController.tr('CREATE_DEFAULT_ACCOUNT'),
                        color: enabled
                            ? AppColors.afraPayTurquoise
                            : AppColors.primaryColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Switch(
                      value: enabled,
                      activeThumbColor: Colors.white,
                      activeTrackColor: AppColors.afraPayTurquoise,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.fontColor.withOpacity(0.24),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        formController.changeDefaultAccountStatus(value);

                        if (value) {
                          _loadOfficeList();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (enabled) ...[const SizedBox(height: 12), buildOfficeDropdown()],
          ],
        );
      }),
    );
  }

  Widget _buildCurrencyCard() {
    return _sectionCard(
      icon: Icons.currency_exchange_rounded,
      title: languageController.tr('CURRENCY'),
      trailing: GestureDetector(
        onTap: () async {
          await currencyController.fetchCurrencyList();
          _restoreCurrencySelection();
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
      child: Obx(() {
        final currencies =
            currencyController.allcurrencylist.value.data?.currencies ?? [];

        if (currencyController.isLoading.value && currencies.isEmpty) {
          return Container(
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.035),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.afraPayTurquoise,
              ),
            ),
          );
        }

        if (currencies.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.035),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.055),
              ),
            ),
            child: KText(
              text: languageController.tr('NO_CURRENCY_FOUND'),
              color: AppColors.fontColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          );
        }

        return SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: currencies.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 7);
            },
            itemBuilder: (context, index) {
              final currency = currencies[index];

              final code = currency.code?.toString().trim() ?? '';

              final isSelected = selectedCurrencyIndex == index;

              return GestureDetector(
                onTap: () {
                  formController.selectCurrency(id: currency.id, code: code);

                  setState(() {
                    selectedCurrencyIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minWidth: 64),
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  alignment: Alignment.center,
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
                    children: [
                      if (isSelected) ...[
                        const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                      ],
                      KText(
                        text: code.isEmpty ? '--' : code,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCard() {
    return _sectionCard(
      icon: Icons.payments_outlined,
      title: languageController.tr('OPENING_BALANCE'),
      child: Accountextfield(
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        controller: formController.balanceController,
        label: languageController.tr('OPENING_BALANCE'),
        hint: languageController.tr('ENTER_OPENING_BALANCE'),
        height: 55,
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

  Widget buildOfficeDropdown() {
    return Obx(() {
      if (officeListController.isLoading.value &&
          officeListController.finalList.isEmpty) {
        return Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.035),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.055),
            ),
          ),
          child: const SizedBox(
            width: 19,
            height: 19,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.afraPayTurquoise,
            ),
          ),
        );
      }

      final List<Office> offices = officeListController.finalList
          .where((office) => office.id != null)
          .toList();

      if (offices.isEmpty) {
        return Container(
          constraints: const BoxConstraints(minHeight: 50),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.035),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.055),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: KText(
                  text: languageController.tr('NO_OFFICE_FOUND'),
                  color: AppColors.fontColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  officeListController.initialpage = 1;
                  officeListController.finalList.clear();
                  await officeListController.fetchofficelist();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                    color: AppColors.afraPayTurquoise,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final selectedOfficeId = formController.selectedOfficeId.value;

      final selectedOfficeExists = offices.any(
        (office) => office.id == selectedOfficeId,
      );

      return DropdownButtonFormField<int>(
        value: selectedOfficeExists ? selectedOfficeId : null,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.fontColor,
        ),
        decoration: _dropdownDecoration(languageController.tr('SELECT_OFFICE')),
        hint: KText(
          text: languageController.tr('PLEASE_SELECT_AN_OFFICE'),
          color: AppColors.fontColor,
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        items: offices.map((office) {
          final name = office.name?.trim().isNotEmpty == true
              ? office.name!.trim()
              : 'Office #${office.id}';

          final code = office.code?.trim() ?? '';

          return DropdownMenuItem<int>(
            value: office.id,
            child: KText(
              text: code.isEmpty ? name : '$name ($code)',
              color: AppColors.primaryColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (officeId) {
          formController.selectOffice(officeId);
        },
      );
    });
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.045),
      labelStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w600,
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

  Widget _buildCreateButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Obx(() {
          final isLoading = formController.isLoading.value;

          return GestureDetector(
            onTap: isLoading ? null : validateAndCreate,
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
                          Icons.person_add_alt_1_rounded,
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
}

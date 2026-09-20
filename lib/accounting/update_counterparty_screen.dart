import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../widgets/accountextfield.dart';
import 'controllers/accounting_currency_controller.dart';
import 'controllers/office_list_controller.dart';
import 'controllers/update_party_controller.dart';
import 'models/office_list_model.dart';

class UpdateCounterpartyScreen extends StatefulWidget {
  const UpdateCounterpartyScreen({
    super.key,
    this.partyID,
    this.partyName,
    this.partyType,
    this.phoneNumber,
    this.emailaddress,
    this.currency,
    this.accountingCurrencyId,
    this.officeId,
    this.accountType,
    this.openingBalance,
    this.createDefaultAccount,
  });

  final String? partyID;
  final String? partyName;
  final String? partyType;
  final String? phoneNumber;
  final String? emailaddress;
  final String? currency;
  final int? accountingCurrencyId;
  final int? officeId;
  final String? accountType;
  final dynamic openingBalance;
  final bool? createDefaultAccount;

  @override
  State<UpdateCounterpartyScreen> createState() =>
      _UpdateCounterpartyScreenState();
}

class _UpdateCounterpartyScreenState extends State<UpdateCounterpartyScreen> {
  late final UpdatePartyController updatePartyController;
  late final AccountingCurrencyController currencyController;
  late final OfficeListController officeListController;
  late final LanguagesController languageController;

  final List<Map<String, String>> accountTypeOptions = [];
  final List<Map<String, String>> typeOptions = [];

  int selectedCurrencyIndex = -1;

  @override
  void initState() {
    super.initState();

    updatePartyController = Get.isRegistered<UpdatePartyController>()
        ? Get.find<UpdatePartyController>()
        : Get.put(UpdatePartyController());

    currencyController = Get.find<AccountingCurrencyController>();
    languageController = Get.find<LanguagesController>();

    officeListController = Get.isRegistered<OfficeListController>()
        ? Get.find<OfficeListController>()
        : Get.put(OfficeListController());

    accountTypeOptions.addAll([
      {'title': languageController.tr('SAVING'), 'value': 'saving'},
      {'title': languageController.tr('CURRENT'), 'value': 'current'},
      {'title': languageController.tr('FIXED'), 'value': 'fixed'},
    ]);

    typeOptions.addAll([
      {'title': languageController.tr('SUPPLIER'), 'value': 'supplier'},
      {'title': languageController.tr('CUSTOMER'), 'value': 'customer'},
    ]);

    updatePartyController.initializeForm(
      name: widget.partyName,
      phone: widget.phoneNumber,
      email: widget.emailaddress,
      type: widget.partyType,
      currencyCode: widget.currency,
      accountingCurrencyId: widget.accountingCurrencyId,
      officeId: widget.officeId,
      accountType: widget.accountType,
      openingBalance: widget.openingBalance,
      shouldCreateDefaultAccount: widget.createDefaultAccount,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadCurrencyList(), _loadOfficeList()]);

    _restoreCurrencySelection();
  }

  Future<void> _loadCurrencyList() async {
    final currencies =
        currencyController.allcurrencylist.value.data?.currencies ?? [];

    if (currencies.isEmpty && !currencyController.isLoading.value) {
      await currencyController.fetchCurrencyList();
    }
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

    if (currencies.isEmpty) {
      return;
    }

    int index = -1;

    final selectedId = updatePartyController.selectedAccountingCurrencyId.value;

    if (selectedId != null) {
      index = currencies.indexWhere((currency) => currency.id == selectedId);
    }

    if (index == -1) {
      final selectedCode = updatePartyController.selectedCurrencyCode.value
          .trim()
          .toLowerCase();

      if (selectedCode.isNotEmpty) {
        index = currencies.indexWhere(
          (currency) =>
              currency.code?.toString().trim().toLowerCase() == selectedCode,
        );
      }
    }

    if (index != -1) {
      final currency = currencies[index];

      updatePartyController.selectCurrency(
        id: currency.id,
        code: currency.code?.toString() ?? '',
      );

      if (mounted) {
        setState(() {
          selectedCurrencyIndex = index;
        });
      }
    }
  }

  void showValidationToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      gravity: ToastGravity.CENTER,
    );
  }

  Future<void> validateAndUpdate() async {
    FocusScope.of(context).unfocus();

    final partyId = widget.partyID?.toString().trim() ?? '';
    final name = updatePartyController.nameController.text.trim();
    final phone = updatePartyController.phoneController.text.trim();
    final email = updatePartyController.emailController.text.trim();
    final currency = updatePartyController.selectedCurrencyCode.value.trim();

    if (partyId.isEmpty || partyId.toLowerCase() == 'null') {
      showValidationToast('Counterparty ID was not found.');
      return;
    }

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

    if (email.isEmpty) {
      showValidationToast(languageController.tr('EMAIL_IS_REQUIRED'));
      return;
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      showValidationToast(languageController.tr('ENTER_A_VALID_EMAIL_ADDRESS'));
      return;
    }

    if (currency.isEmpty) {
      showValidationToast(languageController.tr('PLEASE_SELECT_A_CURRENCY'));
      return;
    }

    if (updatePartyController.createDefaultAccount.value &&
        updatePartyController.selectedOfficeId.value == null) {
      showValidationToast(languageController.tr('PLEASE_SELECT_AN_OFFICE'));
      return;
    }

    if (updatePartyController.createDefaultAccount.value &&
        updatePartyController.selectedAccountingCurrencyId.value == null) {
      showValidationToast(languageController.tr('PLEASE_SELECT_A_CURRENCY'));
      return;
    }

    final success = await updatePartyController.updateNow(partyId: partyId);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 92),
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 10),
            _buildBasicInformationCard(),
            const SizedBox(height: 10),
            _buildAccountConfigurationCard(),
            const SizedBox(height: 10),
            _buildCurrencyCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildUpdateButton(),
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
              text: languageController.tr('UPDATE_COUNTER_PARTY'),
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
    final name = widget.partyName?.trim() ?? '';
    final type = widget.partyType?.trim() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
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
            height: 46,
            width: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: name.isNotEmpty
                      ? name
                      : languageController.tr('COUNTER_PARTY'),
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (type.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  KText(
                    text: languageController.tr(type.toUpperCase()),
                    color: Colors.white.withOpacity(0.66),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Obx(
              () => KText(
                text: updatePartyController.createDefaultAccount.value
                    ? languageController.tr('CREATE_DEFAULT_ACCOUNT')
                    : languageController.tr('ACCOUNT_TYPE'),
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationCard() {
    return _sectionCard(
      icon: Icons.person_outline_rounded,
      title: languageController.tr('COUNTER_PARTY_DETAILS'),
      child: Column(
        children: [
          Accountextfield(
            controller: updatePartyController.nameController,
            label: languageController.tr('NAME'),
            hint: languageController.tr('COUNTER_PARTY_NAME'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            keyboardType: TextInputType.phone,
            controller: updatePartyController.phoneController,
            label: languageController.tr('PHONE_NUMBER'),
            hint: languageController.tr('ENTER_PHONE_NUMBER'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Accountextfield(
            keyboardType: TextInputType.emailAddress,
            controller: updatePartyController.emailController,
            label: languageController.tr('EMAIL'),
            hint: languageController.tr('ENTER_EMAIL_ADDRESS'),
            height: 55,
          ),
          const SizedBox(height: 13),
          Obx(
            () => DropdownButtonFormField<String>(
              value: updatePartyController.selectedType.value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.fontColor,
              ),
              decoration: _dropdownDecoration(languageController.tr('TYPE')),
              items: typeOptions.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: KText(
                    text: item['title'] ?? '',
                    color: AppColors.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                updatePartyController.selectedType.value = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountConfigurationCard() {
    return _sectionCard(
      icon: Icons.account_balance_wallet_outlined,
      title: languageController.tr('ACCOUNT_TYPE'),
      child: Column(
        children: [
          Obx(
            () => DropdownButtonFormField<String>(
              value: updatePartyController.selectedAccountType.value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.fontColor,
              ),
              decoration: _dropdownDecoration(
                languageController.tr('ACCOUNT_TYPE'),
              ),
              items: accountTypeOptions.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: KText(
                    text: item['title'] ?? '',
                    color: AppColors.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                updatePartyController.selectedAccountType.value = value;
              },
            ),
          ),
          const SizedBox(height: 11),
          Obx(() {
            final enabled = updatePartyController.createDefaultAccount.value;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(11, 9, 9, 9),
              decoration: BoxDecoration(
                color: AppColors.afraPayBackground,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.05),
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
                          ? AppColors.afraPayTurquoise.withOpacity(0.08)
                          : AppColors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      enabled
                          ? Icons.add_circle_outline_rounded
                          : Icons.account_balance_wallet_outlined,
                      color: enabled
                          ? AppColors.afraPayTurquoise
                          : AppColors.fontColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: KText(
                      text: languageController.tr('CREATE_DEFAULT_ACCOUNT'),
                      color: AppColors.primaryColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Switch(
                    value: enabled,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.afraPayTurquoise,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.fontColor.withOpacity(0.34),
                    onChanged: (value) {
                      updatePartyController.changeDefaultAccountStatus(value);

                      if (value) {
                        _loadOfficeList();
                      }
                    },
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            if (!updatePartyController.createDefaultAccount.value) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 11),
              child: _buildOfficeDropdown(),
            );
          }),
          const SizedBox(height: 11),
          Accountextfield(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: updatePartyController.balanceController,
            label: languageController.tr('OPENING_BALANCE'),
            hint: languageController.tr('ENTER_OPENING_BALANCE'),
            height: 55,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard() {
    return _sectionCard(
      icon: Icons.currency_exchange_rounded,
      title: languageController.tr('CURRENCY'),
      child: Obx(() {
        if (currencyController.isLoading.value) {
          return Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.afraPayTurquoise,
              ),
            ),
          );
        }

        final currencies =
            currencyController.allcurrencylist.value.data?.currencies ?? [];

        if (currencies.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.afraPayBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: KText(
              text: languageController.tr('NO_CURRENCY_FOUND'),
              color: AppColors.fontColor,
              fontSize: 10,
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
              return const SizedBox(width: 6);
            },
            itemBuilder: (context, index) {
              final currency = currencies[index];

              final isSelected =
                  selectedCurrencyIndex == index ||
                  updatePartyController.selectedAccountingCurrencyId.value ==
                      currency.id;

              return GestureDetector(
                onTap: () {
                  final code = currency.code?.toString().trim() ?? '';

                  updatePartyController.selectCurrency(
                    id: currency.id,
                    code: code,
                  );

                  setState(() {
                    selectedCurrencyIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  constraints: const BoxConstraints(minWidth: 60),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.afraPayTurquoise
                        : AppColors.afraPayBackground,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.afraPayTurquoise
                          : AppColors.primaryColor.withOpacity(0.07),
                    ),
                  ),
                  child: KText(
                    text: currency.code?.toString() ?? '--',
                    color: isSelected ? Colors.white : AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
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
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildOfficeDropdown() {
    return Obx(() {
      if (officeListController.isLoading.value &&
          officeListController.finalList.isEmpty) {
        return Container(
          height: 52,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.07)),
          ),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.afraPayTurquoise,
            ),
          ),
        );
      }

      final offices = officeListController.finalList
          .where((office) => office.id != null)
          .toList();

      if (offices.isEmpty) {
        return Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.07)),
          ),
          child: Row(
            children: [
              Expanded(
                child: KText(
                  text: languageController.tr('NO_OFFICE_FOUND'),
                  color: AppColors.fontColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  officeListController.initialpage = 1;
                  officeListController.finalList.clear();
                  officeListController.fetchofficelist();
                },
                child: Container(
                  height: 34,
                  width: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.afraPayTurquoise.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 17,
                    color: AppColors.afraPayTurquoise,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final selectedOfficeId = updatePartyController.selectedOfficeId.value;

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
          fontSize: 11,
          fontWeight: FontWeight.w500,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        items: offices.map((Office office) {
          final name = office.name?.trim().isNotEmpty == true
              ? office.name!.trim()
              : '${languageController.tr("OFFICE")} #${office.id}';

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
          updatePartyController.selectOffice(officeId);
        },
      );
    });
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.045),
      label: KText(
        text: label,
        color: AppColors.fontColor,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
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

  Widget _buildUpdateButton() {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
        child: Obx(() {
          final isLoading = updatePartyController.isLoading.value;

          return GestureDetector(
            onTap: isLoading ? null : validateAndUpdate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLoading
                      ? [
                          AppColors.primarycolor2.withOpacity(0.58),
                          AppColors.afraPayTurquoise.withOpacity(0.58),
                        ]
                      : const [
                          AppColors.primarycolor2,
                          AppColors.afraPayTurquoise,
                        ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.afraPayTurquoise.withOpacity(0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        KText(
                          text: languageController.tr('UPDATE_NOW'),
                          color: Colors.white,
                          fontSize: 12.5,
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

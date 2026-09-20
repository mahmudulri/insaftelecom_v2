import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/create_office_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/accountextfield.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateOfficeScreen extends StatefulWidget {
  const CreateOfficeScreen({super.key});

  @override
  State<CreateOfficeScreen> createState() => _CreateOfficeScreenState();
}

class _CreateOfficeScreenState extends State<CreateOfficeScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountingCurrencyController currencyController =
      Get.find<AccountingCurrencyController>();

  final CreateOfficeController createOfficeController = Get.put(
    CreateOfficeController(),
  );

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currencies =
          currencyController.allcurrencylist.value.data?.currencies ?? [];

      if (currencies.isEmpty && !currencyController.isLoading.value) {
        await currencyController.fetchCurrencyList();
      }

      _syncSelectedCurrency();
    });
  }

  void _syncSelectedCurrency() {
    final currentCode = createOfficeController.currencyController.text.trim();

    if (currentCode.isEmpty) {
      return;
    }

    final currencies =
        currencyController.allcurrencylist.value.data?.currencies ?? [];

    final index = currencies.indexWhere(
      (currency) =>
          currency.code?.toString().trim().toLowerCase() ==
          currentCode.toLowerCase(),
    );

    if (index >= 0 && mounted) {
      setState(() {
        selectedIndex = index;
      });
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                children: [
                  _buildIntroCard(),
                  const SizedBox(height: 10),
                  _buildOfficeInformationCard(),
                  const SizedBox(height: 10),
                  _buildStatusCard(),
                  const SizedBox(height: 10),
                  _buildCurrencyCard(),
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
              text: languagesController.tr("ADD_NEW_OFFICE"),
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
              Icons.add_business_rounded,
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
                  text: languagesController.tr("ADD_NEW_OFFICE"),
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                KText(
                  text: languagesController.tr("OFFICE"),
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

  Widget _buildOfficeInformationCard() {
    return _sectionCard(
      icon: Icons.business_outlined,
      title: languagesController.tr("OFFICE"),
      child: Column(
        children: [
          Accountextfield(
            controller: createOfficeController.nameController,
            label: languagesController.tr("NAME"),
            hint: languagesController.tr("NAME_OF_THE_OFFICE"),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            controller: createOfficeController.defaultnameController,
            label: languagesController.tr("DEFAULT_ACCOUNT_NAME"),
            hint: languagesController.tr("ENTER_DEFAULT_ACCOUNT_NAME"),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            keyboardType: TextInputType.phone,
            controller: createOfficeController.phoneController,
            label: languagesController.tr("PHONE_NUMBER"),
            hint: languagesController.tr("ENTER_PHONE_NUMBER"),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            controller: createOfficeController.idController,
            label: languagesController.tr("ID_NUMBER"),
            hint: languagesController.tr("ENTER_ID_NUMBER"),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            controller: createOfficeController.locationController,
            label: languagesController.tr("LOCATION"),
            hint: languagesController.tr("ENTER_LOCATION"),
            height: 55,
          ),
          const SizedBox(height: 14),
          Accountextfield(
            controller: createOfficeController.addressController,
            label: languagesController.tr("ADDRESS"),
            hint: languagesController.tr("ENTER_ADDRESS"),
            height: 96,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return _sectionCard(
      icon: Icons.toggle_on_outlined,
      title: languagesController.tr("ACTIVE"),
      child: Obx(() {
        final isActive = createOfficeController.isactive.value;

        return GestureDetector(
          onTap: () {
            createOfficeController.isactive.value = !isActive;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.fromLTRB(11, 9, 9, 9),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.afraPayTurquoise.withOpacity(0.07)
                  : AppColors.primaryColor.withOpacity(0.035),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: isActive
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
                    color: isActive
                        ? AppColors.afraPayTurquoise.withOpacity(0.12)
                        : AppColors.afraPayBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isActive
                        ? Icons.check_circle_outline_rounded
                        : Icons.pause_circle_outline_rounded,
                    color: isActive
                        ? AppColors.afraPayTurquoise
                        : AppColors.fontColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KText(
                    text: isActive
                        ? languagesController.tr("ACTIVE")
                        : languagesController.tr("IN_ACTIVE"),
                    color: isActive
                        ? AppColors.afraPayTurquoise
                        : AppColors.primaryColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Switch(
                  value: isActive,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.afraPayTurquoise,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.fontColor.withOpacity(0.24),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) {
                    createOfficeController.isactive.value = value;
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrencyCard() {
    return _sectionCard(
      icon: Icons.currency_exchange_rounded,
      title: languagesController.tr("CURRENCY"),
      trailing: GestureDetector(
        onTap: () async {
          await currencyController.fetchCurrencyList();
          _syncSelectedCurrency();
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
              text: languagesController.tr("NO_CURRENCIES_FOUND"),
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

              final code = currency.code?.toString().trim().isNotEmpty == true
                  ? currency.code.toString().trim()
                  : "--";

              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  createOfficeController.currencyController.text = code;
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
                        text: code,
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

  Widget _buildOpeningBalanceCard() {
    return _sectionCard(
      icon: Icons.account_balance_wallet_outlined,
      title: languagesController.tr("OPENING_BALANCE"),
      child: Accountextfield(
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        controller: createOfficeController.amountController,
        label: languagesController.tr("OPENING_BALANCE"),
        hint: languagesController.tr("ENTER_OPENING_BALANCE"),
        height: 55,
      ),
    );
  }

  Widget _buildNotesCard() {
    return _sectionCard(
      icon: Icons.notes_rounded,
      title: languagesController.tr("NOTES"),
      child: Accountextfield(
        controller: createOfficeController.notesController,
        label: languagesController.tr("NOTES"),
        hint: languagesController.tr("ENTER_NOTES"),
        height: 110,
        maxLines: 5,
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

  Widget _buildCreateButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Obx(() {
          final isLoading = createOfficeController.isLoading.value;

          return GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    createOfficeController.createnow();
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
                          Icons.add_business_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        KText(
                          text: languagesController.tr("CREATE_OFFICE_NOW"),
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

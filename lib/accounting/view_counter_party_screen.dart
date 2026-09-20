import 'package:insaftelecom/accounting/controllers/party_accountslist_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/helpers/money_format_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCounterPartyScreen extends StatefulWidget {
  const ViewCounterPartyScreen({
    super.key,
    this.partyID,
    this.partyName,
    this.partyType,
    this.phoneNumber,
    this.emailaddress,
    this.defaultCurrency,
    this.notes,
  });

  final String? partyID;
  final String? partyName;
  final String? partyType;
  final String? phoneNumber;
  final String? emailaddress;
  final String? defaultCurrency;
  final String? notes;

  @override
  State<ViewCounterPartyScreen> createState() => _ViewCounterPartyScreenState();
}

class _ViewCounterPartyScreenState extends State<ViewCounterPartyScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final PartyAccountslistController accountslistController = Get.put(
    PartyAccountslistController(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAccounts();
    });
  }

  Future<void> _refreshAccounts() async {
    await accountslistController.fetchaccount(widget.partyID.toString());
  }

  String _displayValue(dynamic value, {String fallback = '-'}) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return fallback;
    }

    return text;
  }

  String _typeLabel() {
    final type = _displayValue(widget.partyType, fallback: '');

    if (type.isEmpty) {
      return '-';
    }

    final key = type.trim().toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]+'),
      '_',
    );

    final translated = languagesController.tr(key).trim();

    if (translated.isNotEmpty && translated != key) {
      return translated;
    }

    return type.capitalizeFirst ?? type;
  }

  Color _getTypeColor() {
    final type = _displayValue(widget.partyType, fallback: '').toLowerCase();

    switch (type) {
      case 'customer':
        return AppColors.afraPayTurquoise;
      case 'supplier':
        return AppColors.primarycolor2;
      case 'both':
        return AppColors.primaryColor;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getTypeIcon() {
    final type = _displayValue(widget.partyType, fallback: '').toLowerCase();

    switch (type) {
      case 'customer':
        return Icons.person_outline_rounded;
      case 'supplier':
        return Icons.inventory_2_outlined;
      case 'both':
        return Icons.people_alt_outlined;
      default:
        return Icons.account_circle_outlined;
    }
  }

  Color _getBalanceColor(dynamic balance) {
    final parsedBalance = double.tryParse(balance?.toString() ?? '0') ?? 0;

    if (parsedBalance < 0) {
      return const Color(0xFFE05263);
    }

    if (parsedBalance > 0) {
      return AppColors.afraPayTurquoise;
    }

    return const Color(0xFF667085);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              _buildProfileCard(),
              const SizedBox(height: 9),
              _buildQuickInfoRow(),
              const SizedBox(height: 9),
              Expanded(child: _buildAccountsSection()),
            ],
          ),
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
              text: languagesController.tr('COUNTER_PARTY_DETAILS'),
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

  Widget _buildProfileCard() {
    final typeColor = _getTypeColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(_getTypeIcon(), color: Colors.white, size: 23),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: _displayValue(
                    widget.partyName,
                    fallback: 'Unnamed counterparty',
                  ),
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                      child: KText(
                        text: _typeLabel(),
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: KText(
                          text:
                              '${accountslistController.isLoading.value ? '...' : accountslistController.accountlist.length} ${languagesController.tr("TOTAL_ACCOUNTS")}',
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _refreshAccounts,
            child: Container(
              height: 36,
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.11),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Obx(
                () => accountslistController.isLoading.value
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _compactInfoTile(
                icon: Icons.phone_outlined,
                label: languagesController.tr('PHONE'),
                value: _displayValue(widget.phoneNumber),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _compactInfoTile(
                icon: Icons.currency_exchange_rounded,
                label: languagesController.tr('CURRENCY'),
                value: _displayValue(widget.defaultCurrency),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _compactInfoTile(
          icon: Icons.email_outlined,
          label: languagesController.tr('EMAIL_ADDRESS'),
          value: _displayValue(widget.emailaddress),
          fullWidth: true,
        ),
        if (_displayValue(widget.notes, fallback: '').isNotEmpty) ...[
          const SizedBox(height: 8),
          _compactInfoTile(
            icon: Icons.notes_rounded,
            label: languagesController.tr('NOTES'),
            value: _displayValue(widget.notes),
            fullWidth: true,
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _compactInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
    int maxLines = 1,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
            child: Icon(icon, size: 16, color: AppColors.afraPayTurquoise),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: label,
                  color: AppColors.fontColor,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                KText(
                  text: value,
                  color: AppColors.primaryColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsSection() {
    return Container(
      width: double.infinity,
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
        children: [
          _buildAccountsHeader(),
          Container(
            height: 1,
            color: AppColors.primaryColor.withOpacity(0.045),
          ),
          Expanded(
            child: Obx(() {
              if (accountslistController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: AppColors.afraPayTurquoise,
                  ),
                );
              }

              if (accountslistController.accountlist.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.afraPayTurquoise,
                  onRefresh: _refreshAccounts,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 55),
                    children: [_buildEmptyAccounts()],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.afraPayTurquoise,
                onRefresh: _refreshAccounts,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                  itemCount: accountslistController.accountlist.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    return _buildAccountCard(
                      accountslistController.accountlist[index],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
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
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 16,
              color: AppColors.afraPayTurquoise,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: KText(
              text: languagesController.tr('ACCOUNTS'),
              color: AppColors.primaryColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          Obx(
            () => Container(
              constraints: const BoxConstraints(minWidth: 28),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.afraPayBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: KText(
                text: accountslistController.isLoading.value
                    ? '...'
                    : accountslistController.accountlist.length.toString(),
                color: AppColors.primaryColor,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAccounts() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 62,
            width: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 28,
              color: AppColors.afraPayTurquoise,
            ),
          ),
          const SizedBox(height: 12),
          KText(
            text: languagesController.tr('NO_ACCOUNTS_FOUND'),
            color: AppColors.fontColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(dynamic data) {
    final balanceValue =
        double.tryParse(data.currentBalance?.toString() ?? '0') ?? 0;

    final isBalanceSettled = balanceValue == 0;

    final heOwes = balanceValue < 0;

    final balanceColor = _getBalanceColor(data.currentBalance);

    final balanceRelationText = isBalanceSettled
        ? languagesController.tr('BALANCE_SETTLED')
        : heOwes
        ? languagesController.tr('HE_OWE')
        : languagesController.tr('HE_OWED');

    final balanceRelationIcon = isBalanceSettled
        ? Icons.check_circle_outline_rounded
        : heOwes
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    final currency = _displayValue(data.currencyCode, fallback: '--');

    final accountName = _displayValue(data.name, fallback: 'Unnamed Account');

    final accountType = _displayValue(data.accountType, fallback: '-');

    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: AppColors.afraPayBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.045)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rightWidth = (constraints.maxWidth * 0.38)
              .clamp(112.0, 150.0)
              .toDouble();

          return Row(
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarycolor2,
                      AppColors.afraPayTurquoise,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: KText(
                  text: currency,
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: accountName,
                      color: AppColors.primaryColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: KText(
                        text: accountType,
                        color: AppColors.fontColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: rightWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: KText(
                        text: '${formatMoney(data.currentBalance)} $currency',
                        color: balanceColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            balanceRelationIcon,
                            size: 11,
                            color: balanceColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: KText(
                              text: balanceRelationText,
                              color: balanceColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

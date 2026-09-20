import 'package:insaftelecom/accounting/controllers/account_details_controller.dart';
import 'package:insaftelecom/accounting/controllers/make_transaction_controller.dart';
import 'package:insaftelecom/accounting/controllers/transactions_of_account_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import '../../helpers/money_format_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({
    super.key,
    this.accountID,
    this.accountName,
    this.accountType,
    this.balance,
    this.currency,
    this.category,
    this.partyName,
    this.partyPhone,
  });

  final String? accountID;
  final String? accountName;
  final String? accountType;
  final String? balance;
  final String? currency;
  final String? category;
  final String? partyName;
  final String? partyPhone;

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final LanguagesController languageController =
      Get.find<LanguagesController>();

  final TransactionsOfAccountController transactionListController = Get.put(
    TransactionsOfAccountController(),
  );

  final AccountDetailsController accountDetailsController = Get.put(
    AccountDetailsController(),
  );

  final MakeTransactionController makeTransactionController = Get.put(
    MakeTransactionController(),
  );

  static const Color redColor = Color(0xFFE05263);
  static const Color orangeColor = Color(0xFFF7903D);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final accountId = widget.accountID;

    if (accountId == null || accountId.trim().isEmpty) {
      return;
    }

    await Future.wait([
      accountDetailsController.fetchdata(accountId),
      transactionListController.fetchdata(accountId),
    ]);
  }

  String _safeText(dynamic value, {String fallback = '--'}) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return fallback;
    }

    return text;
  }

  Future<void> _shareToWhatsApp() async {
    final text = _generateAccountShareText();

    if (text.trim().isEmpty) {
      return;
    }

    final whatsappUrl = Uri.https('wa.me', '/', {'text': text});

    final opened = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      Get.snackbar(
        languageController.tr('ERROR'),
        languageController.tr('UNABLE_TO_OPEN_WHATSAPP'),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: redColor,
        colorText: Colors.white,
      );
    }
  }

  String _generateAccountShareText() {
    final account = accountDetailsController.alldata.value.data?.account;

    final officeName = _safeText(account?.office?.name);

    final name = _safeText(widget.partyName);

    final phone = _safeText(widget.partyPhone);

    final accountName = _safeText(widget.accountName);

    final category = _translateShareValue(widget.category);

    final accountType = _translateShareValue(widget.accountType);

    final currency = _translateShareValue(
      widget.currency,
      fallbackToOriginal: true,
    );

    final balanceValue = widget.balance ?? '0';

    final balanceAmount =
        double.tryParse(balanceValue.replaceAll(',', '').trim()) ?? 0;

    final formattedBalance = formatMoney(balanceAmount.abs());

    final now = DateTime.now();

    final date =
        '${now.year}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.day.toString().padLeft(2, '0')}';

    final balanceTitle = balanceAmount < 0
        ? languageController.tr('DEBT_BALANCE')
        : languageController.tr('AVAILABLE_BALANCE');

    final balanceSign = balanceAmount < 0 ? '-' : '';

    return '''
$officeName
${languageController.tr("DATE")}: $date

${languageController.tr("NAME")}: $name
${languageController.tr("PHONE")}: $phone

${languageController.tr("ACCOUNT")}: $accountName
${languageController.tr("CATEGORY")}: $category
${languageController.tr("ACCOUNT_TYPE")}: $accountType

*$balanceTitle: $balanceSign$formattedBalance $currency*
'''
        .trim();
  }

  String _translateShareValue(
    String? value, {
    bool fallbackToOriginal = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '--';
    }

    final originalValue = value.trim();

    final translationKey = originalValue.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]+'),
      '_',
    );

    final translatedValue = languageController.tr(translationKey).trim();

    if (translatedValue.isEmpty || translatedValue == translationKey) {
      if (fallbackToOriginal) {
        return originalValue;
      }

      return _formatText(originalValue);
    }

    return translatedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              _buildAccountOverview(),
              const SizedBox(height: 9),
              _buildTransactionsHeader(),
              const SizedBox(height: 7),
              Expanded(child: _buildTransactionsList()),
              _buildTransactionActions(),
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
              text: languageController.tr('ACCOUNT_DETAILS'),
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          _appBarButton(icon: Icons.share_rounded, onTap: _showShareActions),
          const SizedBox(width: 6),
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
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
    );
  }

  Widget _buildAccountOverview() {
    return Obx(() {
      if (accountDetailsController.isLoading.value) {
        return Container(
          height: 174,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.3,
              color: Colors.white,
            ),
          ),
        );
      }

      final data = accountDetailsController.alldata.value.data;
      final account = data?.account;
      final statistics = data?.statistics;

      if (account == null) {
        return _buildAccountEmptyState();
      }

      final currencyCode = account.currencyCode?.toString().trim() ?? '--';

      final currentBalance = _toDouble(
        account.currentBalance ?? statistics?.currentBalance,
      );

      final receivableAmount = _toDouble(statistics?.receivablesCreated);

      final payableAmount = _toDouble(statistics?.payablesCreated);

      final accountName = _safeText(
        account.name,
        fallback: languageController.tr('UNNAMED_ACCOUNT'),
      );

      final counterpartyName = _safeText(
        account.counterparty?.name,
        fallback: languageController.tr('COUNTERPARTY'),
      );

      final balanceStatus =
          account.balanceStatus?.toString().trim().toLowerCase() ??
          statistics?.status?.toString().trim().toLowerCase() ??
          '';

      final isBalanceSettled =
          currentBalance == 0 ||
          balanceStatus == 'settled' ||
          balanceStatus == 'balanced';

      final youOweCounterparty =
          !isBalanceSettled &&
          (balanceStatus == 'receivable' ||
              (balanceStatus.isEmpty && currentBalance > 0));

      final String balanceRelationText;
      final IconData balanceRelationIcon;

      if (isBalanceSettled) {
        balanceRelationText = languageController.tr('BALANCE_SETTLED');
        balanceRelationIcon = Icons.check_circle_outline_rounded;
      } else if (youOweCounterparty) {
        balanceRelationText = languageController.tr('HE_OWED');
        balanceRelationIcon = Icons.north_east_rounded;
      } else {
        balanceRelationText = languageController.tr('HE_OWE');
        balanceRelationIcon = Icons.south_west_rounded;
      }

      final formattedCurrentBalance =
          '$currencyCode ${formatMoney(currentBalance.abs())}';

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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: KText(
                    text: currencyCode,
                    color: Colors.white,
                    fontSize: 9.5,
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
                        text: accountName,
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      KText(
                        text: counterpartyName,
                        color: Colors.white.withOpacity(0.64),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showAccountDetailsSheet(
                      account: account,
                      statistics: statistics,
                    );
                  },
                  child: Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _fetchData,
                  child: Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 34,
                  width: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    balanceRelationIcon,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KText(
                        text: balanceRelationText,
                        color: Colors.white.withOpacity(0.70),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      KText(
                        text: formattedCurrentBalance,
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _overviewMetricCard(
                    icon: Icons.north_east_rounded,
                    label:
                        '${languageController.tr("TOTAL_I_PAID_TO")} $accountName',
                    amount: '$currencyCode ${formatMoney(payableAmount.abs())}',
                    amountColor: redColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _overviewMetricCard(
                    icon: Icons.south_west_rounded,
                    label:
                        '${languageController.tr("TOTAL_I_RECEIVED_FROM")} $accountName',
                    amount:
                        '$currencyCode ${formatMoney(receivableAmount.abs())}',
                    amountColor: AppColors.afraPayTurquoise,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _overviewMetricCard({
    required IconData icon,
    required String label,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 31,
            width: 31,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: amountColor, size: 15),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: label,
                  color: AppColors.fontColor,
                  fontSize: 7.8,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  height: 1.2,
                ),
                const SizedBox(height: 3),
                KText(
                  text: amount,
                  color: amountColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 58,
            width: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.afraPayTurquoise,
              size: 27,
            ),
          ),
          const SizedBox(height: 11),
          KText(
            text: languageController.tr('ACCOUNT_INFORMATION_NOT_FOUND'),
            color: AppColors.fontColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader() {
    return Obx(() {
      final transactions =
          transactionListController.alltransactions.value.data?.transactions ??
          [];

      final totalItems =
          transactionListController
              .alltransactions
              .value
              .payload
              ?.pagination
              ?.totalItems ??
          transactions.length;

      return Row(
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
              Icons.receipt_long_outlined,
              color: AppColors.afraPayTurquoise,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: KText(
              text: languageController.tr('TRANSACTIONS'),
              color: AppColors.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 30),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.045),
              borderRadius: BorderRadius.circular(9),
            ),
            child: KText(
              text: totalItems.toString(),
              color: AppColors.primaryColor,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionsList() {
    return Obx(() {
      if (transactionListController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: AppColors.afraPayTurquoise,
          ),
        );
      }

      final transactions =
          transactionListController.alltransactions.value.data?.transactions ??
          [];

      if (transactions.isEmpty) {
        return RefreshIndicator(
          color: AppColors.afraPayTurquoise,
          onRefresh: _fetchData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 48),
            children: [_emptyTransactions()],
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.afraPayTurquoise,
        onRefresh: _fetchData,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: transactions.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 7);
          },
          itemBuilder: (context, index) {
            return _buildTransactionCard(transactions[index]);
          },
        ),
      );
    });
  }

  Widget _emptyTransactions() {
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
              Icons.receipt_long_outlined,
              color: AppColors.afraPayTurquoise,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          KText(
            text: languageController.tr('NO_TRANSACTIONS_FOUND'),
            color: AppColors.fontColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    final transactionType =
        transaction.transactionType?.toString() ?? 'TRANSACTION';

    final balanceEffect = _toDouble(transaction.balanceEffect);

    final amount = _toDouble(transaction.amount);

    final isPositive = balanceEffect >= 0;

    final currencyCode = transaction.currencyCode?.toString() ?? '--';

    final visual = _getTransactionVisual(transactionType, isPositive);

    final status = transaction.status?.toString() ?? '--';

    final normalizedStatus = status.toLowerCase();

    final isPosted = normalizedStatus == 'posted';

    final hasReference =
        transaction.reference != null &&
        transaction.reference.toString().trim().isNotEmpty;

    final transactionTitle = transactionType == 'PAYABLE'
        ? '${languageController.tr("I_PAID_TO")} ${_currentAccountName()}'
        : '${languageController.tr("I_RECEIVED_FROM")} ${_currentAccountName()}';

    final description =
        transaction.description?.toString().trim().isNotEmpty == true
        ? transaction.description.toString()
        : languageController.tr('NO_DESCRIPTION');

    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 42,
            width: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: visual.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(visual.icon, color: visual.iconColor, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: transactionTitle,
                  color: AppColors.primaryColor,
                  fontSize: 11.8,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                KText(
                  text: description,
                  color: AppColors.fontColor,
                  fontSize: 8.8,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 10,
                      color: AppColors.fontColor,
                    ),
                    const SizedBox(width: 4),
                    KText(
                      text: _formatDate(transaction.transactionDate),
                      color: AppColors.fontColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasReference) ...[
                      const SizedBox(width: 6),
                      Container(
                        height: 3,
                        width: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.fontColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: KText(
                          text: transaction.reference.toString(),
                          color: AppColors.fontColor,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else
                      const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              KText(
                text:
                    '${isPositive ? '+' : '-'}$currencyCode ${formatMoney(amount.abs())}',
                color: isPositive ? AppColors.afraPayTurquoise : redColor,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: isPosted
                      ? AppColors.afraPayTurquoise.withOpacity(0.08)
                      : orangeColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: KText(
                  text: status.toUpperCase(),
                  color: isPosted ? AppColors.afraPayTurquoise : orangeColor,
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionActions() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
        child: Row(
          children: [
            Expanded(
              child: _transactionActionButton(
                title: languageController.tr('I_PAY'),
                icon: Icons.north_east_rounded,
                backgroundColor: redColor,
                onTap: () {
                  _showMakeTransactionSheet(initialTransactionType: 'PAYABLE');
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _transactionActionButton(
                title: languageController.tr('I_RECEIVE'),
                icon: Icons.south_west_rounded,
                backgroundColor: AppColors.afraPayTurquoise,
                onTap: () {
                  _showMakeTransactionSheet(
                    initialTransactionType: 'RECEIVABLE',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionActionButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.16),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            KText(
              text: title,
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  String _currentAccountName() {
    final account = accountDetailsController.alldata.value.data?.account;

    final name = account?.name?.toString().trim();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    return languageController.tr('UNNAMED_ACCOUNT');
  }

  Future<void> _showMakeTransactionSheet({
    required String initialTransactionType,
  }) async {
    final accountId = widget.accountID;

    if (accountId == null || accountId.trim().isEmpty) {
      Get.snackbar(
        languageController.tr('ERROR'),
        languageController.tr('COUNTERPARTY_ACCOUNT_ID_NOT_FOUND'),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEDEC),
        colorText: redColor,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();

    final amountController = TextEditingController();

    final descriptionController = TextEditingController();

    final selectedTransactionType =
        initialTransactionType.toUpperCase() == 'PAYABLE'
        ? 'PAYABLE'
        : 'RECEIVABLE';

    final account = accountDetailsController.alldata.value.data?.account;

    final currencyCode = account?.currencyCode?.toString() ?? '--';

    final isPayable = selectedTransactionType == 'PAYABLE';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.30),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.90,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sheetHandle(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isPayable
                                  ? redColor.withOpacity(0.08)
                                  : AppColors.afraPayTurquoise.withOpacity(
                                      0.08,
                                    ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isPayable
                                  ? Icons.north_east_rounded
                                  : Icons.south_west_rounded,
                              color: isPayable
                                  ? redColor
                                  : AppColors.afraPayTurquoise,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: languageController.tr(
                                    'MAKE_TRANSACTION',
                                  ),
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                KText(
                                  text: _safeText(
                                    account?.name,
                                    fallback: languageController.tr(
                                      'COUNTER_PARTY_ACCOUNT',
                                    ),
                                  ),
                                  color: AppColors.fontColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: makeTransactionController.isLoading.value
                                  ? null
                                  : () {
                                      Navigator.pop(sheetContext);
                                    },
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
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _formLabel(languageController.tr('TRANSACTION_TYPE')),
                      const SizedBox(height: 7),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isPayable
                              ? redColor.withOpacity(0.06)
                              : AppColors.afraPayTurquoise.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPayable
                                ? redColor.withOpacity(0.14)
                                : AppColors.afraPayTurquoise.withOpacity(0.14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(
                                isPayable
                                    ? Icons.north_east_rounded
                                    : Icons.south_west_rounded,
                                color: isPayable
                                    ? redColor
                                    : AppColors.afraPayTurquoise,
                                size: 17,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: isPayable
                                        ? languageController.tr('I_PAY')
                                        : languageController.tr('I_RECEIVE'),
                                    color: isPayable
                                        ? redColor
                                        : AppColors.afraPayTurquoise,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 2),
                                  KText(
                                    text: isPayable
                                        ? languageController.tr('RECEIVEABLE')
                                        : languageController.tr('PAYABLE'),
                                    color: AppColors.fontColor,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: isPayable
                                  ? redColor
                                  : AppColors.afraPayTurquoise,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _formLabel(languageController.tr('AMOUNT')),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,6}'),
                          ),
                        ],
                        cursorColor: AppColors.afraPayTurquoise,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _formDecoration(
                          hint: languageController.tr('ENTER_AMOUNT'),
                          prefixIcon: const Icon(
                            Icons.payments_outlined,
                            color: AppColors.fontColor,
                            size: 19,
                          ),
                          suffixText: currencyCode,
                        ),
                        validator: (value) {
                          final amountText = value?.trim() ?? '';

                          if (amountText.isEmpty) {
                            return languageController.tr('ENTER_AMOUNT');
                          }

                          final amount = double.tryParse(amountText);

                          if (amount == null) {
                            return languageController.tr(
                              'ENTER_A_VALID_AMOUNT',
                            );
                          }

                          if (amount <= 0) {
                            return languageController.tr(
                              'AMOUNT_MUST_BE_GREATER_THAN_ZERO',
                            );
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: _formLabel(
                              languageController.tr('DESCRIPTION'),
                            ),
                          ),
                          KText(
                            text: languageController.tr('OPTIONAL'),
                            color: AppColors.fontColor,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        cursorColor: AppColors.afraPayTurquoise,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: _formDecoration(
                          hint: languageController.tr(
                            'WRITE_TRANSACTION_DESCRIPTION',
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      Obx(() {
                        final isSubmitting =
                            makeTransactionController.isLoading.value;

                        return Row(
                          children: [
                            Expanded(
                              child: _secondaryButton(
                                title: languageController.tr('CANCEL'),
                                onTap: isSubmitting
                                    ? null
                                    : () {
                                        Navigator.pop(sheetContext);
                                      },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _primarySheetButton(
                                title: isPayable
                                    ? languageController.tr('CONFIRM_PAYMENT')
                                    : languageController.tr('CONFIRM_RECEIVED'),
                                icon: isPayable
                                    ? Icons.north_east_rounded
                                    : Icons.south_west_rounded,
                                color: isPayable
                                    ? redColor
                                    : AppColors.afraPayTurquoise,
                                isLoading: isSubmitting,
                                onTap: isSubmitting
                                    ? null
                                    : () async {
                                        final isValid =
                                            formKey.currentState?.validate() ??
                                            false;

                                        if (!isValid) {
                                          return;
                                        }

                                        final success =
                                            await makeTransactionController
                                                .makeTransaction(
                                                  counterpartyAccountId:
                                                      widget.accountID,
                                                  transactionType:
                                                      selectedTransactionType,
                                                  amount: amountController.text
                                                      .trim(),
                                                  description:
                                                      descriptionController.text
                                                          .trim(),
                                                );

                                        if (!mounted) {
                                          return;
                                        }

                                        if (success) {
                                          if (Navigator.of(
                                            sheetContext,
                                          ).canPop()) {
                                            Navigator.pop(sheetContext);
                                          }

                                          await _fetchData();
                                        } else {
                                          final transactionError =
                                              makeTransactionController
                                                  .errorMessage
                                                  .value
                                                  .trim();

                                          Get.snackbar(
                                            languageController.tr(
                                              'TRANSACTION_FAILED',
                                            ),
                                            transactionError.isNotEmpty
                                                ? transactionError
                                                : languageController.tr(
                                                    'UNABLE_TO_CREATE_TRANSACTION',
                                                  ),
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: const Color(
                                              0xFFFFEDEC,
                                            ),
                                            colorText: redColor,
                                            margin: const EdgeInsets.all(12),
                                            duration: const Duration(
                                              seconds: 4,
                                            ),
                                            icon: const Icon(
                                              Icons.error_outline_rounded,
                                              color: redColor,
                                            ),
                                          );
                                        }
                                      },
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    amountController.dispose();
    descriptionController.dispose();
  }

  Widget _formLabel(String text) {
    return KText(
      text: text,
      color: AppColors.primaryColor,
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
    );
  }

  InputDecoration _formDecoration({
    required String hint,
    Widget? prefixIcon,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(
        color: AppColors.fontColor.withOpacity(0.70),
        fontSize: 11.5,
      ),
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.045),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: redColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: redColor, width: 1),
      ),
    );
  }

  Widget _secondaryButton({required String title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.afraPayBackground,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        ),
        child: KText(
          text: title,
          color: onTap == null ? AppColors.fontColor : AppColors.primaryColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _primarySheetButton({
    required String title,
    required IconData icon,
    required Color color,
    required bool isLoading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 47,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading ? color.withOpacity(0.55) : color,
          borderRadius: BorderRadius.circular(13),
        ),
        child: isLoading
            ? const SizedBox(
                height: 19,
                width: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 17),
                  const SizedBox(width: 5),
                  Flexible(
                    child: KText(
                      text: title,
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showAccountDetailsSheet({
    required dynamic account,
    required dynamic statistics,
  }) {
    final currencyCode = account.currencyCode?.toString() ?? '--';

    final details = [
      {
        'icon': Icons.person_outline_rounded,
        'label': languageController.tr('ACCOUNT_NAME'),
        'value': account.name ?? '--',
      },
      {
        'icon': Icons.people_outline_rounded,
        'label': languageController.tr('COUNTERPARTY'),
        'value': account.counterparty?.name ?? '--',
      },
      {
        'icon': Icons.business_outlined,
        'label': languageController.tr('OFFICE'),
        'value': account.office?.name ?? '--',
      },
      {
        'icon': Icons.category_outlined,
        'label': languageController.tr('ACCOUNT_TYPE'),
        'value': _formatText(account.accountType),
      },
      {
        'icon': Icons.currency_exchange_rounded,
        'label': languageController.tr('CURRENCY'),
        'value': currencyCode,
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'label': languageController.tr('OPENING_BALANCE'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(account.openingBalance).abs())}',
      },
      {
        'icon': Icons.payments_outlined,
        'label': languageController.tr('CURRENT_BALANCE'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(account.currentBalance).abs())}',
      },
      {
        'icon': Icons.receipt_long_outlined,
        'label': languageController.tr('TOTAL_TRANSACTIONS'),
        'value': '${statistics?.totalTransactions ?? 0}',
      },
      {
        'icon': Icons.add_chart_rounded,
        'label': languageController.tr('POSITIVE_EFFECT'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.positiveEffect).abs())}',
      },
      {
        'icon': Icons.trending_down_rounded,
        'label': languageController.tr('NEGATIVE_EFFECT'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.negativeEffect).abs())}',
      },
      {
        'icon': Icons.analytics_outlined,
        'label': languageController.tr('NET_EFFECT'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.netEffect).abs())}',
      },
      {
        'icon': Icons.south_west_rounded,
        'label': languageController.tr('RECEIVABLES_CREATED'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.receivablesCreated).abs())}',
      },
      {
        'icon': Icons.payment_rounded,
        'label': languageController.tr('RECEIVABLE_PAYMENTS'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.receivablePayments).abs())}',
      },
      {
        'icon': Icons.north_east_rounded,
        'label': languageController.tr('PAYABLES_CREATED'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.payablesCreated).abs())}',
      },
      {
        'icon': Icons.credit_card_rounded,
        'label': languageController.tr('PAYABLE_PAYMENTS'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.payablePayments).abs())}',
      },
      {
        'icon': Icons.tune_rounded,
        'label': languageController.tr('ADJUSTMENT_EFFECT'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.adjustmentEffect).abs())}',
      },
      {
        'icon': Icons.undo_rounded,
        'label': languageController.tr('REVERSAL_EFFECT'),
        'value':
            '$currencyCode ${formatMoney(_toDouble(statistics?.reversalEffect).abs())}',
      },
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.86,
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primarycolor2,
                            AppColors.afraPayTurquoise,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: KText(
                        text: languageController.tr('ACCOUNT_DETAILS'),
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(sheetContext);
                      },
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
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: details.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 7);
                    },
                    itemBuilder: (context, index) {
                      final item = details[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.afraPayBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.afraPayTurquoise.withOpacity(
                                  0.08,
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: AppColors.afraPayTurquoise,
                                size: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: KText(
                                text: item['label'].toString(),
                                color: AppColors.fontColor,
                                fontSize: 8.8,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: KText(
                                text: item['value'].toString(),
                                color: AppColors.primaryColor,
                                fontSize: 9.8,
                                fontWeight: FontWeight.w700,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareActions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      height: 38,
                      width: 38,
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
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: KText(
                        text: languageController.tr('SHARE'),
                        color: AppColors.primaryColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(sheetContext);
                      },
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
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _shareAction(
                  icon: Icons.copy_rounded,
                  title: languageController.tr('COPY_AS_TEXT'),
                  iconColor: AppColors.primarycolor2,
                  iconBackground: AppColors.primarycolor2.withOpacity(0.08),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    final text = _generateAccountShareText();

                    await Clipboard.setData(ClipboardData(text: text));

                    Get.snackbar(
                      languageController.tr('COPPIED'),
                      languageController.tr(
                        'ACCOUNT_INFORMATION_COPIED_TO_CLIPBOARD',
                      ),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(12),
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 7),
                _shareAction(
                  icon: Icons.chat_rounded,
                  title: languageController.tr('SEND_TO_WHATSAPP'),
                  iconColor: const Color(0xFF25D366),
                  iconBackground: const Color(0xFFEAFBF0),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _shareToWhatsApp();
                  },
                ),
                const SizedBox(height: 7),
                _shareAction(
                  icon: Icons.image_outlined,
                  title: languageController.tr('GENERATE_IMAGE'),
                  iconColor: const Color(0xFF7A5AF8),
                  iconBackground: const Color(0xFFF1EEFF),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                const SizedBox(height: 7),
                _shareAction(
                  icon: Icons.picture_as_pdf_outlined,
                  title: languageController.tr('GENERATE_PDF'),
                  iconColor: redColor,
                  iconBackground: const Color(0xFFFFEDEC),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareAction({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.045),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 17),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: KText(
                  text: title,
                  color: AppColors.primaryColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.fontColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
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

  TransactionVisual _getTransactionVisual(
    String transactionType,
    bool isPositive,
  ) {
    switch (transactionType.toUpperCase()) {
      case 'OPENING_BALANCE':
        return TransactionVisual(
          icon: Icons.account_balance_wallet_outlined,
          iconColor: AppColors.primarycolor2,
          backgroundColor: AppColors.primarycolor2.withOpacity(0.08),
        );
      case 'RECEIVABLE':
        return TransactionVisual(
          icon: Icons.south_west_rounded,
          iconColor: AppColors.afraPayTurquoise,
          backgroundColor: AppColors.afraPayTurquoise.withOpacity(0.08),
        );
      case 'RECEIVABLE_PAYMENT':
        return const TransactionVisual(
          icon: Icons.payments_outlined,
          iconColor: Color(0xFF7A5AF8),
          backgroundColor: Color(0xFFF1EEFF),
        );
      case 'PAYABLE':
        return TransactionVisual(
          icon: Icons.north_east_rounded,
          iconColor: redColor,
          backgroundColor: redColor.withOpacity(0.08),
        );
      case 'PAYABLE_PAYMENT':
        return TransactionVisual(
          icon: Icons.payment_rounded,
          iconColor: AppColors.primarycolor2,
          backgroundColor: AppColors.primarycolor2.withOpacity(0.08),
        );
      case 'ADJUSTMENT':
        return const TransactionVisual(
          icon: Icons.tune_rounded,
          iconColor: Color(0xFF7A5AF8),
          backgroundColor: Color(0xFFF1EEFF),
        );
      case 'REVERSAL':
        return const TransactionVisual(
          icon: Icons.undo_rounded,
          iconColor: redColor,
          backgroundColor: Color(0xFFFFEDEC),
        );
      default:
        return TransactionVisual(
          icon: isPositive
              ? Icons.add_card_rounded
              : Icons.credit_card_off_outlined,
          iconColor: isPositive ? AppColors.afraPayTurquoise : redColor,
          backgroundColor: isPositive
              ? AppColors.afraPayTurquoise.withOpacity(0.08)
              : redColor.withOpacity(0.08),
        );
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().replaceAll(',', '').trim()) ?? 0;
  }

  String _formatText(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '--';
    }

    return value
        .toString()
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _formatDate(dynamic date) {
    if (date == null) {
      return '--';
    }

    DateTime? parsedDate;

    if (date is DateTime) {
      parsedDate = date;
    } else {
      parsedDate = DateTime.tryParse(date.toString());
    }

    if (parsedDate == null) {
      return '--';
    }

    final localDate = parsedDate.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');

    final month = localDate.month.toString().padLeft(2, '0');

    final year = localDate.year.toString();

    return '$day/$month/$year';
  }
}

class TransactionVisual {
  const TransactionVisual({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
}

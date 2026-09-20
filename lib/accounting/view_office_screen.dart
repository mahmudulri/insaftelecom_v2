import 'package:insaftelecom/accounting/controllers/office_details_controller.dart';
import 'package:insaftelecom/accounting/screens/account_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/languages_controller.dart';
import '../helpers/language_changer.dart';
import '../helpers/money_format_helper.dart';
import '../utils/colors.dart';
import '../widgets/custom_text.dart';
import 'controllers/accounts_of_office_controller.dart';
import 'controllers/transactions_of_office_controller.dart';
import 'screens/create_account_screen2.dart';
import 'screens/transaction_details_screen.dart';

class ViewOfficeScreen extends StatefulWidget {
  const ViewOfficeScreen({
    super.key,
    this.officeName,
    this.officeId,
    this.location,
    this.phone,
    this.address,
    this.defaultName,
    this.isactive,
    this.notes,
    this.currency,
    this.openingbalance,
    this.id,
  });

  final String? officeName;
  final String? officeId;
  final String? location;
  final String? phone;
  final String? address;
  final String? defaultName;
  final String? isactive;
  final String? notes;
  final String? currency;
  final String? openingbalance;
  final String? id;

  @override
  State<ViewOfficeScreen> createState() => _ViewOfficeScreenState();
}

class _ViewOfficeScreenState extends State<ViewOfficeScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountsofOfficeController accountsofOfficeController = Get.put(
    AccountsofOfficeController(),
  );

  final TransactionsOfOfficeController transactionlistController = Get.put(
    TransactionsOfOfficeController(),
  );

  final OfficeDetailsController officeDetailsController = Get.put(
    OfficeDetailsController(),
  );

  final GetStorage box = GetStorage();

  final RxInt selectedBalanceCurrencyIndex = 0.obs;

  static const Color redColor = Color(0xFFE05263);
  static const Color orangeColor = Color(0xFFF7903D);

  @override
  void initState() {
    super.initState();

    _refreshAll();

    box.write('officeID', widget.id?.toString() ?? '');
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      accountsofOfficeController.fetchdata(widget.id),
      transactionlistController.fetchdata(widget.id),
      officeDetailsController.fetchdata(widget.id.toString()),
    ]);
  }

  String _text(dynamic value, {String fallback = '--'}) {
    if (value == null) {
      return fallback;
    }

    final result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return fallback;
    }

    return result;
  }

  String _number(dynamic value, {String fallback = '0'}) {
    if (value == null) {
      return fallback;
    }

    final rawValue = value.toString().trim();

    if (rawValue.isEmpty || rawValue.toLowerCase() == 'null') {
      return fallback;
    }

    final amount = double.tryParse(rawValue.replaceAll(',', ''));

    if (amount == null) {
      return rawValue;
    }

    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }

    return amount.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String _money(dynamic value, dynamic currencyCode) {
    final amount = formatMoney(value);
    final code = _text(currencyCode, fallback: '');

    return code.isEmpty ? amount : '$amount $code';
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return '--';
    }

    DateTime? date;

    if (value is DateTime) {
      date = value;
    } else {
      date = DateTime.tryParse(value.toString());
    }

    if (date == null) {
      return _text(value);
    }

    final localDate = date.toLocal();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = localDate.day.toString().padLeft(2, '0');
    final month = months[localDate.month - 1];
    final year = localDate.year.toString();

    final hour = localDate.hour == 0
        ? 12
        : localDate.hour > 12
        ? localDate.hour - 12
        : localDate.hour;

    final minute = localDate.minute.toString().padLeft(2, '0');

    final period = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$day $month $year, $hour:$minute $period';
  }

  Color _balanceColor(dynamic value) {
    final amount = double.tryParse(value?.toString() ?? '0') ?? 0;

    if (amount > 0) {
      return AppColors.afraPayTurquoise;
    }

    if (amount < 0) {
      return redColor;
    }

    return AppColors.fontColor;
  }

  String _balanceText(dynamic value) {
    final amount = double.tryParse(value?.toString() ?? '0') ?? 0;

    if (amount > 0) {
      return languagesController.tr('HE_OWED');
    }

    if (amount < 0) {
      return languagesController.tr('HE_OWE');
    }

    return languagesController.tr('BALANCE_SETTLED');
  }

  Color _transactionTypeColor(dynamic value) {
    final type = _text(value, fallback: '').toUpperCase();

    if (type.contains('RECEIVABLE')) {
      return AppColors.afraPayTurquoise;
    }

    if (type.contains('PAYABLE')) {
      return redColor;
    }

    if (type.contains('OPENING')) {
      return AppColors.primarycolor2;
    }

    if (type.contains('REVERSAL')) {
      return orangeColor;
    }

    return const Color(0xFF7556D8);
  }

  IconData _transactionTypeIcon(dynamic value) {
    final type = _text(value, fallback: '').toUpperCase();

    if (type.contains('RECEIVABLE')) {
      return Icons.south_west_rounded;
    }

    if (type.contains('PAYABLE')) {
      return Icons.north_east_rounded;
    }

    if (type.contains('OPENING')) {
      return Icons.account_balance_wallet_outlined;
    }

    if (type.contains('REVERSAL')) {
      return Icons.undo_rounded;
    }

    return Icons.swap_horiz_rounded;
  }

  String _transactionTitle(dynamic value) {
    final type = _text(value, fallback: '').toUpperCase();

    if (type == 'PAYABLE') {
      return languagesController.tr('I_RECEIVED');
    }

    if (type == 'RECEIVABLE') {
      return languagesController.tr('I_PAID');
    }

    return type
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.afraPayBackground,
        appBar: _buildAppBar(),
        body: SafeArea(
          top: false,
          child: Obx(() {
            if (accountsofOfficeController.isLoading.value ||
                officeDetailsController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: AppColors.afraPayTurquoise,
                ),
              );
            }

            final accountModel =
                accountsofOfficeController.accountsdetails.value;

            final accountData = accountModel.data;

            final office = accountData?.office;

            final officeDetailsData =
                officeDetailsController.allofficedata.value.data;

            final officeDetails = officeDetailsData?.office;

            final officeBalanceSummary =
                officeDetailsData?.summary?.balanceSummary ?? [];

            if (accountData == null || officeDetailsData == null) {
              return _buildErrorView();
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: _buildBalanceSummaryCard(
                    officeDetails ?? office,
                    officeBalanceSummary,
                    officeDetailsData?.summary?.counts,
                  ),
                ),
                const SizedBox(height: 9),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildTabBar(),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TabBarView(
                      children: [
                        _buildAccountsTab(office?.accounts ?? []),
                        Obx(() {
                          if (transactionlistController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: AppColors.afraPayTurquoise,
                              ),
                            );
                          }

                          final transactionModel =
                              transactionlistController.alltransactions.value;

                          final transactions =
                              transactionModel.data?.office?.transactions ?? [];

                          return _buildTransactionsTab(transactions);
                        }),
                      ],
                    ),
                  ),
                ),
                _buildAddAccountButton(),
              ],
            );
          }),
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
              text: widget.officeName?.trim().isNotEmpty == true
                  ? widget.officeName!
                  : languagesController.tr('OFFICE_DETAILS'),
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

  Widget _buildBalanceSummaryCard(
    dynamic office,
    List<dynamic> balanceSummary,
    dynamic counts,
  ) {
    return Obx(() {
      if (balanceSummary.isEmpty) {
        final accountsCount = counts?.accounts ?? 0;

        final counterpartiesCount = counts?.counterparties ?? 0;

        return _summaryCardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryTopRow(
                office: office,
                relationText: languagesController.tr('BALANCE_SETTLED'),
                relationIcon: Icons.check_circle_outline_rounded,
                amountText: formatMoney(0),
              ),
              const SizedBox(height: 8),
              _summaryCountRow(
                accountsCount: accountsCount,
                counterpartiesCount: counterpartiesCount,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _summaryMetricCard(
                      icon: Icons.south_west_rounded,
                      label: languagesController.tr('TOTAL_I_RECEIVED'),
                      amount: formatMoney(0),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _summaryMetricCard(
                      icon: Icons.north_east_rounded,
                      label: languagesController.tr('TOTAL_I_PAID'),
                      amount: formatMoney(0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Center(
                child: KText(
                  text: languagesController.tr('NO_BALANCE_SUMMARY_FOUND'),
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }

      if (selectedBalanceCurrencyIndex.value >= balanceSummary.length) {
        selectedBalanceCurrencyIndex.value = 0;
      }

      final selectedBalance =
          balanceSummary[selectedBalanceCurrencyIndex.value];

      final currencyCode = _text(selectedBalance.currencyCode, fallback: '');

      final netBalance =
          double.tryParse(selectedBalance.netBalance?.toString() ?? '0') ?? 0;

      final receivableBalance =
          double.tryParse(
            selectedBalance.receivableBalance?.toString() ?? '0',
          ) ??
          0;

      final payableBalance =
          double.tryParse(selectedBalance.payableBalance?.toString() ?? '0') ??
          0;

      final isSettled = netBalance == 0;

      final youAreOwed = netBalance > 0;

      final formattedNetBalance = currencyCode.isEmpty
          ? formatMoney(netBalance.abs())
          : '${formatMoney(netBalance.abs())} $currencyCode';

      final String relationText;
      final IconData relationIcon;

      if (isSettled) {
        relationText = languagesController.tr('BALANCE_SETTLED');

        relationIcon = Icons.check_circle_outline_rounded;
      } else if (youAreOwed) {
        relationText = languagesController.tr('YOU_OWE');

        relationIcon = Icons.south_west_rounded;
      } else {
        relationText = languagesController.tr('YOU_ARE_OWED');

        relationIcon = Icons.north_east_rounded;
      }

      final accountsCount =
          counts?.accounts ??
          int.tryParse(_number(selectedBalance.accountsCount)) ??
          0;

      final counterpartiesCount = counts?.counterparties ?? 0;

      return _summaryCardShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryTopRow(
              office: office,
              relationText: relationText,
              relationIcon: relationIcon,
              amountText: formattedNetBalance,
            ),
            const SizedBox(height: 8),
            _summaryCountRow(
              accountsCount: accountsCount,
              counterpartiesCount: counterpartiesCount,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _summaryMetricCard(
                    icon: Icons.south_west_rounded,
                    label: languagesController.tr('TOTAL_I_RECEIVED'),
                    amount: currencyCode.isEmpty
                        ? formatMoney(receivableBalance.abs())
                        : '$currencyCode ${formatMoney(receivableBalance.abs())}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _summaryMetricCard(
                    icon: Icons.north_east_rounded,
                    label: languagesController.tr('TOTAL_I_PAID'),
                    amount: currencyCode.isEmpty
                        ? formatMoney(payableBalance.abs())
                        : '$currencyCode ${formatMoney(payableBalance.abs())}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildCurrencySelector(balanceSummary),
          ],
        ),
      );
    });
  }

  Widget _summaryCardShell({required Widget child}) {
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
      child: child,
    );
  }

  Widget _summaryTopRow({
    required dynamic office,
    required String relationText,
    required IconData relationIcon,
    required String amountText,
  }) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(relationIcon, color: Colors.white, size: 19),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: relationText,
                color: Colors.white.withOpacity(0.70),
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              KText(
                text: amountText,
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            _showOfficeDetails(office);
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
          onTap: _refreshAll,
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
    );
  }

  Widget _summaryCountRow({
    required int accountsCount,
    required int counterpartiesCount,
  }) {
    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: [
        _summaryCountChip(
          text: '$accountsCount ${languagesController.tr("ACCOUNTS")}',
        ),
        _summaryCountChip(
          text:
              '$counterpartiesCount ${languagesController.tr("COUNTER_PARTY")}',
        ),
      ],
    );
  }

  Widget _summaryCountChip({required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: KText(
        text: text,
        color: Colors.white.withOpacity(0.75),
        fontSize: 8.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _summaryMetricCard({
    required IconData icon,
    required String label,
    required String amount,
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
            height: 32,
            width: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.afraPayTurquoise, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: label,
                  color: AppColors.fontColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                KText(
                  text: amount,
                  color: AppColors.primaryColor,
                  fontSize: 11.5,
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

  Widget _buildCurrencySelector(List<dynamic> balanceSummary) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: balanceSummary.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 6);
        },
        itemBuilder: (context, index) {
          final balance = balanceSummary[index];

          final isSelected = selectedBalanceCurrencyIndex.value == index;

          return GestureDetector(
            onTap: () {
              selectedBalanceCurrencyIndex.value = index;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              constraints: const BoxConstraints(minWidth: 54),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.afraPayTurquoise
                    : Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.afraPayTurquoise
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: KText(
                text: _text(balance.currencyCode, fallback: '--'),
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primarycolor2, AppColors.afraPayTurquoise],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        tabs: [
          Tab(
            child: KText(
              text: languagesController.tr('ACCOUNTS'),
              color: AppColors.primaryColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          Tab(
            child: KText(
              text: languagesController.tr('TRANSACTIONS'),
              color: AppColors.primaryColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsTab(List<dynamic> accounts) {
    if (accounts.isEmpty) {
      return RefreshIndicator(
        color: AppColors.afraPayTurquoise,
        onRefresh: _refreshAll,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            _emptyState(
              icon: Icons.account_balance_wallet_outlined,
              text: languagesController.tr('NO_ACCOUNTS_FOUNDS'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.afraPayTurquoise,
      onRefresh: _refreshAll,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: accounts.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (context, index) {
          return _buildAccountCard(accounts[index]);
        },
      ),
    );
  }

  Widget _buildAccountCard(dynamic account) {
    final accountName = _text(account.name, fallback: 'Unnamed Account');

    final counterpartyName = _text(
      account.counterparty?.name,
      fallback: 'Unknown Counterparty',
    );

    final currencyCode = _text(
      account.currencyCode ?? account.currency?.code,
      fallback: '--',
    );

    final accountType = _text(account.accountType, fallback: '--');

    final balanceValue =
        double.tryParse(account.currentBalance?.toString() ?? '0') ?? 0;

    final balanceColor = _balanceColor(account.currentBalance);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(
            () => AccountDetailsScreen(
              accountID: account.id.toString(),
              accountName: account.name.toString(),
              partyName: account.counterparty.name.toString(),
              partyPhone: account.counterparty.phone.toString(),
              category: account.counterparty.type.toString(),
              accountType: account.accountType.toString(),
              balance: account.currentBalance.toString(),
              currency: account.currencyCode.toString(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(17),
        child: Container(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final rightWidth = (constraints.maxWidth * 0.36)
                  .clamp(110.0, 145.0)
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
                      text: currencyCode,
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
                        Row(
                          children: [
                            Flexible(
                              child: KText(
                                text: counterpartyName,
                                color: AppColors.fontColor,
                                fontSize: 8.5,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.afraPayBackground,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: KText(
                                text: accountType,
                                color: AppColors.fontColor,
                                fontSize: 7.5,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox(
                    width: rightWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: KText(
                            text: _money(account.currentBalance, currencyCode),
                            color: balanceColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              balanceValue == 0
                                  ? Icons.check_circle_outline_rounded
                                  : balanceValue < 0
                                  ? Icons.south_west_rounded
                                  : Icons.north_east_rounded,
                              size: 11,
                              color: balanceColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: KText(
                                text: _balanceText(account.currentBalance),
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
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsTab(List<dynamic> transactions) {
    if (transactions.isEmpty) {
      return RefreshIndicator(
        color: AppColors.afraPayTurquoise,
        onRefresh: _refreshAll,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            _emptyState(
              icon: Icons.receipt_long_outlined,
              text: languagesController.tr('NO_TRANSACTIONS_FOUND'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.afraPayTurquoise,
      onRefresh: _refreshAll,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: transactions.length,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (context, index) {
          return _buildTransactionCard(transactions[index]);
        },
      ),
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    final currencyCode = _text(
      transaction.currencyCode ?? transaction.currency?.code,
      fallback: '--',
    );

    final status = _text(transaction.status, fallback: 'Unknown');

    final isPosted = status.toLowerCase() == 'posted';

    final transactionColor = _transactionTypeColor(transaction.transactionType);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(() => TransactionDetailsScreen(transaction: transaction));
        },
        borderRadius: BorderRadius.circular(17),
        child: Container(
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
            children: [
              Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: transactionColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  _transactionTypeIcon(transaction.transactionType),
                  color: transactionColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: _transactionTitle(transaction.transactionType),
                      color: AppColors.primaryColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    KText(
                      text: _text(
                        transaction.counterparty?.name,
                        fallback: 'Unknown Counterparty',
                      ),
                      color: AppColors.fontColor,
                      fontSize: 8.8,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    KText(
                      text: _formatDate(transaction.transactionDate),
                      color: AppColors.fontColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    text: _money(transaction.amount, currencyCode),
                    color: transactionColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPosted
                          ? AppColors.afraPayTurquoise.withOpacity(0.08)
                          : orangeColor.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: KText(
                      text: status.toUpperCase(),
                      color: isPosted
                          ? AppColors.afraPayTurquoise
                          : orangeColor,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.fontColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState({required IconData icon, required String text}) {
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
            child: Icon(icon, size: 28, color: AppColors.afraPayTurquoise),
          ),
          const SizedBox(height: 12),
          KText(
            text: text,
            color: AppColors.fontColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: GestureDetector(
          onTap: () {
            final officeId = int.tryParse(widget.id.toString());

            if (officeId == null) {
              return;
            }

            Get.to(() => CreateAccountScreen2(officeId: officeId));
          },
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
                  text: languagesController.tr('ADD_NEW_ACCOUNT'),
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

  void _showOfficeDetails(dynamic office) {
    final officeName = _text(
      office?.name ?? widget.officeName,
      fallback: 'Office',
    );

    final officeCode = _text(office?.code ?? widget.officeId);

    final phone = _text(office?.phone ?? widget.phone);

    final location = _text(office?.location ?? widget.location);

    final address = _text(office?.address ?? widget.address);

    final notes = _text(office?.notes ?? widget.notes);

    final accountsCount = _number(office?.accountsCount);

    final transactionsCount = _number(office?.transactionsCount);

    final isActive = office?.isActive ?? false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
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
                Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.fontColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
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
                        Icons.business_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: officeName,
                            color: AppColors.primaryColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          KText(
                            text: officeCode,
                            color: AppColors.fontColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
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
                const SizedBox(height: 14),
                _detailRow(
                  icon: isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.pause_circle_outline_rounded,
                  label: languagesController.tr('STATUS'),
                  value: isActive
                      ? languagesController.tr('ACTIVE')
                      : languagesController.tr('IN_ACTIVE'),
                  valueColor: isActive ? AppColors.afraPayTurquoise : redColor,
                ),
                _detailRow(
                  icon: Icons.phone_outlined,
                  label: languagesController.tr('PHONE'),
                  value: phone,
                ),
                _detailRow(
                  icon: Icons.location_on_outlined,
                  label: languagesController.tr('LOCATION'),
                  value: location,
                ),
                _detailRow(
                  icon: Icons.home_work_outlined,
                  label: languagesController.tr('ADDRESS'),
                  value: address,
                ),
                _detailRow(
                  icon: Icons.account_balance_wallet_outlined,
                  label: languagesController.tr('ACCOUNTS'),
                  value: accountsCount,
                ),
                _detailRow(
                  icon: Icons.receipt_long_outlined,
                  label: languagesController.tr('TRANSACTIONS'),
                  value: transactionsCount,
                ),
                if (notes != '--') ...[
                  const SizedBox(height: 7),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.afraPayBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KText(
                          text: languagesController.tr('NOTES'),
                          color: AppColors.fontColor,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        KText(
                          text: notes,
                          color: AppColors.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          height: 1.35,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: AppColors.afraPayTurquoise, size: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: KText(
              text: label,
              color: AppColors.fontColor,
              fontSize: 9,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: KText(
              text: value,
              color: valueColor ?? AppColors.primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return RefreshIndicator(
      color: AppColors.afraPayTurquoise,
      onRefresh: _refreshAll,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(25),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 66,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: redColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: redColor,
                    size: 31,
                  ),
                ),
                const SizedBox(height: 14),
                KText(
                  text: languagesController.tr('NO_OFFICE_DETAILS_FOUND'),
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _refreshAll,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primarycolor2,
                          AppColors.afraPayTurquoise,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        KText(
                          text: languagesController.tr('TRY_AGAIN'),
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

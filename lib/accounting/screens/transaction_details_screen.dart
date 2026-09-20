import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import '../../helpers/money_format_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailsScreen extends StatelessWidget {
  TransactionDetailsScreen({super.key, required this.transaction});

  final dynamic transaction;

  final LanguagesController languageController =
      Get.find<LanguagesController>();

  static const Color redColor = Color(0xFFE05263);
  static const Color orangeColor = Color(0xFFF7903D);

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

  String _language(String key, {String fallback = '--'}) {
    final value = languageController.tr(key).trim();

    if (value.isEmpty || value == key) {
      return fallback;
    }

    return value;
  }

  String _translateEnum(dynamic value, {String fallback = '--'}) {
    final raw = _text(value, fallback: '');

    if (raw.isEmpty) {
      return fallback;
    }

    final key = raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_');

    final translated = languageController.tr(key).trim();

    if (translated.isNotEmpty && translated != key) {
      return translated;
    }

    return raw
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _transactionTitle() {
    final type = _text(
      transaction?.transactionType,
      fallback: '',
    ).toUpperCase();

    if (type == 'PAYABLE') {
      return _language('I_RECEIVED', fallback: _translateEnum(type));
    }

    if (type == 'RECEIVABLE') {
      return _language('I_PAID', fallback: _translateEnum(type));
    }

    return _translateEnum(
      type,
      fallback: _language('TRANSACTION', fallback: '--'),
    );
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

  Color _statusColor(dynamic value) {
    final status = _text(value, fallback: '').toLowerCase();

    if (status == 'posted') {
      return AppColors.afraPayTurquoise;
    }

    if (status == 'reversed') {
      return redColor;
    }

    return orangeColor;
  }

  IconData _transactionIcon() {
    final type = _text(
      transaction?.transactionType,
      fallback: '',
    ).toUpperCase();

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

    if (type.contains('ADJUSTMENT')) {
      return Icons.tune_rounded;
    }

    return Icons.receipt_long_outlined;
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
              text: languageController.tr('TRANSACTION_DETAILS'),
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

  Widget _buildHeroCard({
    required String currencyCode,
    required String status,
  }) {
    final amountColor = _balanceColor(transaction?.balanceEffect);

    final statusColor = _statusColor(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
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
                child: Icon(_transactionIcon(), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: _transactionTitle(),
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    KText(
                      text: _text(
                        transaction?.counterparty?.name,
                        fallback: _language(
                          'UNKNOWN_COUNTERPARTY',
                          fallback: '--',
                        ),
                      ),
                      color: Colors.white.withOpacity(0.66),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: KText(
                  text: _translateEnum(status),
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                KText(
                  text: languageController.tr('TRANSACTION_AMOUNT'),
                  color: AppColors.fontColor,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                KText(
                  text: _money(transaction?.amount, currencyCode),
                  color: amountColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _detailsRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.afraPayBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: AppColors.afraPayTurquoise),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: KText(
                  text: title,
                  color: AppColors.fontColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
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
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 39),
            color: AppColors.primaryColor.withOpacity(0.04),
          ),
      ],
    );
  }

  Widget _buildDetailsCard({required String currencyCode}) {
    final details = <Map<String, dynamic>>[
      {
        'icon': Icons.tag_rounded,
        'title': languageController.tr('TRANSACTION_ID'),
        'value': _text(transaction?.id),
      },
      {
        'icon': Icons.link_rounded,
        'title': languageController.tr('REFERENCE'),
        'value': _text(transaction?.reference),
      },
      {
        'icon': Icons.category_outlined,
        'title': languageController.tr('CATEGORY'),
        'value': _translateEnum(transaction?.category),
      },
      {
        'icon': Icons.account_balance_wallet_outlined,
        'title': languageController.tr('ACCOUNT'),
        'value': _text(transaction?.counterpartyAccount?.name),
      },
      {
        'icon': Icons.people_outline_rounded,
        'title': languageController.tr('COUNTER_PARTY'),
        'value': _text(transaction?.counterparty?.name),
      },
      {
        'icon': Icons.currency_exchange_rounded,
        'title': languageController.tr('CURRENCY'),
        'value': currencyCode.isEmpty ? '--' : currencyCode,
      },
      {
        'icon': Icons.calculate_outlined,
        'title': languageController.tr('EXCHANGE_RATE'),
        'value': _number(transaction?.exchangeRate),
      },
      {
        'icon': Icons.swap_vert_rounded,
        'title': languageController.tr('BALANCE_EFFECT'),
        'value': _money(transaction?.balanceEffect, currencyCode),
        'valueColor': _balanceColor(transaction?.balanceEffect),
      },
      {
        'icon': Icons.history_rounded,
        'title': languageController.tr('BEFORE_BALANCE'),
        'value': _money(transaction?.balanceBefore, currencyCode),
      },
      {
        'icon': Icons.update_rounded,
        'title': languageController.tr('AFTER_BALANCE'),
        'value': _money(transaction?.balanceAfter, currencyCode),
      },
      {
        'icon': Icons.event_outlined,
        'title': languageController.tr('TRANSACTION_DATE'),
        'value': _formatDate(transaction?.transactionDate),
      },
      {
        'icon': Icons.schedule_rounded,
        'title': languageController.tr('POSTED_AT'),
        'value': _formatDate(transaction?.postedAt),
      },
      {
        'icon': Icons.person_outline_rounded,
        'title': languageController.tr('CREATED_BY'),
        'value': _text(transaction?.creator?.name),
      },
      {
        'icon': Icons.verified_user_outlined,
        'title': languageController.tr('POSTED_BY'),
        'value': _text(transaction?.poster?.name),
      },
    ];

    return _sectionCard(
      icon: Icons.receipt_long_outlined,
      title: languageController.tr('TRANSACTION_INFORMATION'),
      child: Column(
        children: List.generate(details.length, (index) {
          final item = details[index];

          return _detailsRow(
            icon: item['icon'] as IconData,
            title: item['title'].toString(),
            value: item['value'].toString(),
            valueColor: item['valueColor'] as Color?,
            showDivider: index != details.length - 1,
          );
        }),
      ),
    );
  }

  Widget _textContentCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return _sectionCard(
      icon: icon,
      title: title,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.035),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
        ),
        child: KText(
          text: value,
          color: AppColors.primaryColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          height: 1.45,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyCode = _text(
      transaction?.currencyCode ?? transaction?.currency?.code,
      fallback: '',
    );

    final status = _text(transaction?.status, fallback: 'UNKNOWN');

    final description = _text(transaction?.description, fallback: '');

    final notes = _text(transaction?.notes, fallback: '');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          children: [
            _buildHeroCard(currencyCode: currencyCode, status: status),
            const SizedBox(height: 10),
            _buildDetailsCard(currencyCode: currencyCode),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 10),
              _textContentCard(
                icon: Icons.description_outlined,
                title: languageController.tr('DESCRIPTION'),
                value: description,
              ),
            ],
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              _textContentCard(
                icon: Icons.notes_rounded,
                title: languageController.tr('NOTES'),
                value: notes,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

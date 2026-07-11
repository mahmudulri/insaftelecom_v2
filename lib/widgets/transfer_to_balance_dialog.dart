import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/transfer_to_balance_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/languages_controller.dart';

class TransferToBalanceDialog extends StatefulWidget {
  const TransferToBalanceDialog({super.key});

  @override
  State<TransferToBalanceDialog> createState() =>
      _TransferToBalanceDialogState();
}

class _TransferToBalanceDialogState extends State<TransferToBalanceDialog> {
  final WalletsController walletsController = Get.find<WalletsController>();

  final TransferToBalanceController transferController = Get.put(
    TransferToBalanceController(),
  );

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedWallet = walletsController.selectedWallet;
    final String currencyCode = selectedWallet?.currency?.code ?? "";
    final String currencySymbol = selectedWallet?.currency?.symbol ?? "";
    final String paymentAmount = selectedWallet?.payment ?? "0";
    final String balanceAmount = selectedWallet?.balance ?? "0";
    final String availableAmount = selectedWallet?.availableBalance ?? "0";

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Column(
                children: [
                  _walletInfoCard(
                    currencyCode: currencyCode,
                    currencySymbol: currencySymbol,
                    paymentAmount: paymentAmount,
                    balanceAmount: balanceAmount,
                    availableAmount: availableAmount,
                  ),

                  const SizedBox(height: 10),

                  _amountField(currencySymbol),

                  const SizedBox(height: 10),

                  _bottomButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff011A52), Color(0xff7A5AF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.move_up_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languagesController.tr("TRANSFER_TO_BALANCE"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  languagesController.tr("MOVE_PAYMENT_TO_BALANCE"),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffF0E9FF),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(Get.context!, rootNavigator: true).pop(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletInfoCard({
    required String currencyCode,
    required String currencySymbol,
    required String paymentAmount,
    required String balanceAmount,
    required String availableAmount,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _amountBox(
                  title: languagesController.tr("PAYMENT"),
                  amount: paymentAmount,
                  symbol: currencySymbol,
                  icon: Icons.payments_rounded,
                  color: const Color(0xff7A5AF8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _amountBox(
                  title: languagesController.tr("BALANCE"),
                  amount: balanceAmount,
                  symbol: currencySymbol,
                  icon: Icons.account_balance_rounded,
                  color: const Color(0xff004AAD),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _amountBox(
            title: languagesController.tr("AVAILABLE_BALANCE"),
            amount: availableAmount,
            symbol: currencySymbol,
            icon: Icons.verified_rounded,
            color: const Color(0xff12B76A),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _amountBox({
    required String title,
    required String amount,
    required String symbol,
    required IconData icon,
    required Color color,
    bool fullWidth = false,
  }) {
    final double value =
        double.tryParse(amount.toString().replaceAll(",", "")) ?? 0.0;

    final String formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(value);

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffEEF2F6)),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff667085),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$formatted $symbol",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff101828),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountField(String currencySymbol) {
    return TextField(
      controller: amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: Color(0xff101828),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF8FAFC),
        hintText: languagesController.tr("ENTER_AMOUNT"),
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff98A2B3),
        ),
        prefixIcon: Container(
          width: 54,
          alignment: Alignment.center,
          child: Text(
            currencySymbol,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xff7A5AF8),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xff7A5AF8), width: 1.5),
        ),
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 48),
              side: const BorderSide(color: Color(0xffD0D5DD)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              languagesController.tr("CANCEL"),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xff344054),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Obx(() {
            final bool loading = transferController.isLoading.value;

            return ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      final selectedWallet = walletsController.selectedWallet;

                      if (selectedWallet == null) {
                        Fluttertoast.showToast(msg: "No wallet selected");
                        return;
                      }

                      final int walletId =
                          walletsController.selectedWalletId.value ?? 0;

                      final String amount = amountController.text.trim();

                      if (walletId == 0) {
                        Fluttertoast.showToast(msg: "Invalid wallet");
                        return;
                      }

                      if (amount.isEmpty) {
                        Fluttertoast.showToast(
                          msg: languagesController.tr("PLEASE_ENTER_AMOUNT"),
                        );
                        return;
                      }

                      final double enteredAmount =
                          double.tryParse(amount) ?? 0.0;

                      if (enteredAmount <= 0) {
                        Fluttertoast.showToast(
                          msg: languagesController.tr(
                            "PLEASE_ENTER_VALID_AMOUNT",
                          ),
                        );
                        return;
                      }

                      final bool success = await transferController
                          .transferToBalance(
                            walletId: walletId,
                            amount: amount,
                          );

                      Fluttertoast.showToast(
                        msg: transferController.responseMessage.value,
                      );

                      if (success) {
                        await Future.delayed(const Duration(milliseconds: 150));

                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: const Color(0xff7A5AF8),
                disabledBackgroundColor: const Color(0xff98A2B3),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 19,
                      width: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      languagesController.tr("TRANSFER"),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
            );
          }),
        ),
      ],
    );
  }
}

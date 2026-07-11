import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/transfer_between_wallet_controller.dart';
import '../controllers/wallets_controller.dart';

class TransferBetweenWalletDialog extends StatefulWidget {
  const TransferBetweenWalletDialog({super.key});

  @override
  State<TransferBetweenWalletDialog> createState() =>
      _TransferBetweenWalletDialogState();
}

class _TransferBetweenWalletDialogState
    extends State<TransferBetweenWalletDialog> {
  final WalletsController walletsController = Get.find<WalletsController>();

  final TransferBetweenWalletController exchangeController = Get.put(
    TransferBetweenWalletController(),
  );

  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final int fromWalletId = walletsController.selectedWalletId.value ?? 0;

    final toWallets = walletsController.wallets
        .where((wallet) => wallet.walletId != fromWalletId)
        .toList();

    if (toWallets.isNotEmpty) {
      exchangeController.setToWalletId(toWallets.first.walletId ?? 0);
    } else {
      exchangeController.setToWalletId(0);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromWallet = walletsController.selectedWallet;

    final String fromCurrencyCode = fromWallet?.currency?.code ?? "";
    final String fromCurrencySymbol = fromWallet?.currency?.symbol ?? "";
    final String fromBalance = fromWallet?.balance ?? "0";
    final String fromAvailableBalance = fromWallet?.availableBalance ?? "0";

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    _fromWalletInfoCard(
                      currencyCode: fromCurrencyCode,
                      currencySymbol: fromCurrencySymbol,
                      balanceAmount: fromBalance,
                      availableAmount: fromAvailableBalance,
                    ),

                    const SizedBox(height: 10),

                    _toWalletDropdown(),

                    const SizedBox(height: 10),

                    _amountField(fromCurrencySymbol),

                    const SizedBox(height: 10),

                    _bottomButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff011A52), Color(0xff12B76A)],
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
              Icons.currency_exchange_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Exchange Wallet",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Transfer amount between wallets",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffE9FFF3),
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

  Widget _fromWalletInfoCard({
    required String currencyCode,
    required String currencySymbol,
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
                  title: "From Wallet",
                  amount: balanceAmount,
                  symbol: currencySymbol,
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xff004AAD),
                  currencyCode: currencyCode,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _amountBox(
                  title: "Available",
                  amount: availableAmount,
                  symbol: currencySymbol,
                  icon: Icons.verified_rounded,
                  color: const Color(0xff12B76A),
                ),
              ),
            ],
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
    String currencyCode = "",
  }) {
    final double value =
        double.tryParse(amount.toString().replaceAll(",", "")) ?? 0.0;

    final String formatted = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(value);

    return Container(
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
                  currencyCode.isEmpty ? title : "$title ($currencyCode)",
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

  Widget _toWalletDropdown() {
    final int fromWalletId = walletsController.selectedWalletId.value ?? 0;

    final toWallets = walletsController.wallets
        .where((wallet) => wallet.walletId != fromWalletId)
        .toList();

    if (toWallets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xffFFF4F3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffFDA29B)),
        ),
        child: const Text(
          "No other wallet found",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xffB42318),
          ),
        ),
      );
    }

    return Obx(() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: DropdownButtonFormField<int>(
          value: exchangeController.selectedToWalletId.value == 0
              ? null
              : exchangeController.selectedToWalletId.value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xff12B76A),
          ),
          decoration: const InputDecoration(
            labelText: "To Wallet",
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff667085),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            prefixIcon: Icon(
              Icons.move_down_rounded,
              color: Color(0xff12B76A),
              size: 22,
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          items: toWallets.map((wallet) {
            final code = wallet.currency?.code ?? "";
            final symbol = wallet.currency?.symbol ?? "";

            return DropdownMenuItem<int>(
              value: wallet.walletId,
              child: Text(
                "$code ($symbol)",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff101828),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              exchangeController.setToWalletId(value);
            }
          },
        ),
      );
    });
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
        hintText: "Enter amount",
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
              color: Color(0xff12B76A),
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
          borderSide: const BorderSide(color: Color(0xff12B76A), width: 1.5),
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
            child: const Text(
              "Cancel",
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
            final bool loading = exchangeController.isLoading.value;

            return ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      final int fromWalletId =
                          walletsController.selectedWalletId.value ?? 0;

                      final int toWalletId =
                          exchangeController.selectedToWalletId.value;

                      final String amount = amountController.text.trim();

                      if (fromWalletId == 0) {
                        Fluttertoast.showToast(msg: "Invalid from wallet");
                        return;
                      }

                      if (toWalletId == 0) {
                        Fluttertoast.showToast(msg: "Please select to wallet");
                        return;
                      }

                      if (fromWalletId == toWalletId) {
                        Fluttertoast.showToast(
                          msg: "From wallet and to wallet cannot be same",
                        );
                        return;
                      }

                      if (amount.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter amount");
                        return;
                      }

                      final double enteredAmount =
                          double.tryParse(amount) ?? 0.0;

                      if (enteredAmount <= 0) {
                        Fluttertoast.showToast(
                          msg: "Please enter valid amount",
                        );
                        return;
                      }

                      final bool success = await exchangeController
                          .transferBetweenWallet(
                            fromWalletId: fromWalletId,
                            toWalletId: toWalletId,
                            amount: amount,
                          );

                      Fluttertoast.showToast(
                        msg: exchangeController.responseMessage.value,
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
                backgroundColor: const Color(0xff12B76A),
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
                  : const Text(
                      "Exchange",
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

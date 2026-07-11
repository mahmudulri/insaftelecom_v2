import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/switch_active_wallet_controller.dart';
import '../controllers/wallets_controller.dart';
import '../global_controller/languages_controller.dart';

class SwitchActiveWalletDialog extends StatefulWidget {
  const SwitchActiveWalletDialog({super.key});

  @override
  State<SwitchActiveWalletDialog> createState() =>
      _SwitchActiveWalletDialogState();
}

class _SwitchActiveWalletDialogState extends State<SwitchActiveWalletDialog> {
  final WalletsController walletsController = Get.find<WalletsController>();

  final SwitchActiveWalletController switchController = Get.put(
    SwitchActiveWalletController(),
  );

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  @override
  void initState() {
    super.initState();

    final currentId = walletsController.selectedWalletId.value;
    switchController.setWalletId(currentId ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
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
            _dialogHeader(),

            Flexible(
              child: Obx(() {
                final wallets = walletsController.wallets;

                if (wallets.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      languagesController.tr("NO_WALLET_FOUND"),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff667085),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  itemCount: wallets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final wallet = wallets[index];

                    final int walletId = wallet.walletId ?? 0;

                    final String code = wallet.currency?.code ?? "";
                    final String symbol = wallet.currency?.symbol ?? "";

                    final String balance =
                        wallet.availableBalance ?? wallet.balance ?? "0";

                    final bool isCurrent =
                        walletsController.selectedWalletId.value == walletId;

                    return Obx(() {
                      final bool isSelected =
                          switchController.selectedSwitchWalletId.value ==
                          walletId;

                      return _walletTile(
                        walletId: walletId,
                        code: code,
                        symbol: symbol,
                        balance: balance,
                        isSelected: isSelected,
                        isCurrent: isCurrent,
                        onTap: () {
                          switchController.setWalletId(walletId);
                        },
                      );
                    });
                  },
                );
              }),
            ),

            _bottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _dialogHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff011A52), Color(0xff004AAD)],
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
              Icons.swap_horiz_rounded,
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
                  languagesController.tr("SWITCH_ACTIVE_WALLET"),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  languagesController.tr("SELECT_A_WALLET_TO_ACTIVE"),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffD9E8FF),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
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

  Widget _walletTile({
    required int walletId,
    required String code,
    required String symbol,
    required String balance,
    required bool isSelected,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    final double amount =
        double.tryParse(balance.toString().replaceAll(",", "")) ?? 0.0;

    final String formattedBalance = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 2,
    ).format(amount);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffEEF4FF) : const Color(0xffF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xff004AAD)
                : const Color(0xffE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xff004AAD).withOpacity(0.12)
                  : Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected
                      ? const [Color(0xff011A52), Color(0xff004AAD)]
                      : const [Color(0xffE9EEF5), Color(0xffF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: isSelected ? Colors.white : const Color(0xff667085),
                size: 23,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "$code ($symbol)",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff101828),
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff12B76A).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            languagesController.tr("ACTIVE"),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff12B76A),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${languagesController.tr("AVAILABLE")}: $formattedBalance $symbol",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xff004AAD)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff004AAD)
                      : const Color(0xffCBD5E1),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 17,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: Color(0xffD0D5DD)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                languagesController.tr("CANCEL"),
                style: const TextStyle(
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
              final bool loading = switchController.isLoading.value;

              return ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        final int walletId =
                            switchController.selectedSwitchWalletId.value;

                        if (walletId == 0) {
                          Fluttertoast.showToast(msg: "Please select a wallet");
                          return;
                        }

                        final bool success = await switchController
                            .switchActiveWallet(walletId: walletId);

                        Fluttertoast.showToast(
                          msg: switchController.responseMessage,
                        );

                        if (success) {
                          await Future.delayed(
                            const Duration(milliseconds: 150),
                          );

                          if (context.mounted) {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  backgroundColor: const Color(0xff004AAD),
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
                        languagesController.tr("SWITCH"),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/wallet_details_controller.dart';
import '../global_controller/languages_controller.dart';

class WalletDetailsDialog extends StatelessWidget {
  WalletDetailsDialog({super.key});

  final WalletDetailsController walletDetailsController =
      Get.find<WalletDetailsController>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Obx(() {
        if (walletDetailsController.isLoading.value) {
          return Container(
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xff011A52)),
            ),
          );
        }

        final data = walletDetailsController.alldetails.value.data;
        final wallet = data?.wallet;
        final transactions = data?.recentTransactions ?? [];
        final symbol = wallet?.currency?.symbol ?? "";
        final code = wallet?.currency?.code ?? "";

        if (wallet == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              languagesController.tr("NO_WALLET_DETAILS_FOUND"),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          );
        }

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff011A52), Color(0xff004AAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                              ),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_rounded,
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
                                  languagesController.tr("WALLET_DETAILS"),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                // const SizedBox(height: 3),
                                // Text(
                                //   "$code Wallet • ID #${wallet.walletId ?? ""}",
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.w600,
                                //     color: Colors.white.withOpacity(0.78),
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: _topAmountBox(
                              title: languagesController.tr("BALANCE"),
                              value: "${wallet.balance ?? "0.00"} $symbol",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _topAmountBox(
                              title: languagesController.tr("AVAILABLE"),
                              value:
                                  "${wallet.availableBalance ?? "0.00"} $symbol",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _infoBox(
                                icon: Icons.payments_rounded,
                                title: languagesController.tr("PAYMENT"),
                                value: "${wallet.payment ?? "0.00"} $symbol",
                                iconColor: const Color(0xff12B76A),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _infoBox(
                                icon: Icons.trending_down_rounded,
                                title: languagesController.tr("LOAN"),
                                value:
                                    "${wallet.loanBalance ?? "0.00"} $symbol",
                                iconColor: const Color(0xffF79009),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _infoBox(
                                icon: Icons.trending_up_rounded,
                                title: languagesController.tr("EARNING"),
                                value:
                                    "${wallet.totalEarnings ?? "0.00"} $symbol",
                                iconColor: const Color(0xff12B76A),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _infoBox(
                                icon: wallet.isActive == true
                                    ? Icons.verified_rounded
                                    : Icons.block_rounded,
                                title: languagesController.tr("STATUS"),
                                value: wallet.isActive == true
                                    ? "Active"
                                    : "Inactive",
                                iconColor: wallet.isActive == true
                                    ? const Color(0xff12B76A)
                                    : const Color(0xffF04438),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _detailsRow(
                          icon: Icons.call_made_rounded,
                          title: languagesController.tr("TOTAL_HAWALA_SENT"),
                          value: "${wallet.totalHawalaSent ?? "0.00"} $symbol",
                        ),

                        const SizedBox(height: 8),

                        _detailsRow(
                          icon: Icons.call_received_rounded,
                          title: languagesController.tr(
                            "TOTAL_HAWALA_RECEIVED",
                          ),
                          value:
                              "${wallet.totalHawalaReceived ?? "0.00"} $symbol",
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                languagesController.tr("RECENT_TRANSACTIONS"),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xff101828),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffEEF4FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${transactions.length}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff004AAD),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        if (transactions.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xffEAECF0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                languagesController.tr(
                                  "NO_RECENT_TRANSACTIONS",
                                ),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff667085),
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            itemCount: transactions.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = transactions[index];
                              final isCredit = item.type == "credit";

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xffEAECF0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        color: isCredit
                                            ? const Color(0xffECFDF3)
                                            : const Color(0xffFEF3F2),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Icon(
                                        isCredit
                                            ? Icons.arrow_downward_rounded
                                            : Icons.arrow_upward_rounded,
                                        size: 19,
                                        color: isCredit
                                            ? const Color(0xff12B76A)
                                            : const Color(0xffF04438),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.description ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xff101828),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            _formatDate(item.createdAt),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff667085),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${isCredit ? "+" : "-"}${item.amount ?? "0.00"} $symbol",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: isCredit
                                                ? const Color(0xff12B76A)
                                                : const Color(0xffF04438),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          item.category ?? "",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff667085),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _topAmountBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xff667085),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xff101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffEAECF0)),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: const Color(0xffEEF4FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: const Color(0xff004AAD)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xff344054),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xff101828),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return "";

    return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
  }
}

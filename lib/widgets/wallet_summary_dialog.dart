import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wallet_summary_controller.dart';

class WalletSummaryDialog extends StatelessWidget {
  WalletSummaryDialog({super.key});

  final WalletSummaryController walletSummaryController =
      Get.find<WalletSummaryController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      child: Obx(() {
        if (walletSummaryController.isLoading.value) {
          return Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xff011A52)),
            ),
          );
        }

        final data = walletSummaryController.allsummary.value.data;
        final summary = data?.summary;
        final symbol = data?.preferredCurrency?.symbol ?? "";

        if (summary == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              "No summary found",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff011A52), Color(0xff0066CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.pie_chart_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wallet Summary",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff101828),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "All wallet overview",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff667085),
                            ),
                          ),
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
                          color: const Color(0xffF2F4F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Color(0xff344054),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff011A52), Color(0xff004AAD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Net Worth",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${summary.netWorth ?? "0.00"} $symbol",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Available: ${summary.availableBalance ?? "0.00"} $symbol",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _summaryMiniBox(
                        icon: Icons.account_balance_wallet_rounded,
                        title: "Balance",
                        value: "${summary.totalBalance ?? "0.00"} $symbol",
                        iconColor: const Color(0xff004AAD),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _summaryMiniBox(
                        icon: Icons.payments_rounded,
                        title: "Payment",
                        value: "${summary.totalPayment ?? "0.00"} $symbol",
                        iconColor: const Color(0xff12B76A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _summaryMiniBox(
                        icon: Icons.trending_down_rounded,
                        title: "Loan",
                        value: "${summary.totalLoan ?? "0.00"} $symbol",
                        iconColor: const Color(0xffF79009),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _summaryMiniBox(
                        icon: Icons.trending_up_rounded,
                        title: "Earning",
                        value: "${summary.totalEarning ?? "0.00"} $symbol",
                        iconColor: const Color(0xff12B76A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                _summaryRow(
                  icon: Icons.call_made_rounded,
                  title: "Total Hawala Sent",
                  value: "${summary.totalHawalaSent ?? "0.00"} $symbol",
                ),

                const SizedBox(height: 8),

                _summaryRow(
                  icon: Icons.call_received_rounded,
                  title: "Total Hawala Received",
                  value: "${summary.totalHawalaReceived ?? "0.00"} $symbol",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _summaryMiniBox({
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

  Widget _summaryRow({
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
}

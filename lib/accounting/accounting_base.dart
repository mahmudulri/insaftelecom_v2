import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/statistic_controller.dart';
import 'package:insaftelecom/accounting/pages/accounts.dart';
import 'package:insaftelecom/accounting/pages/alltransactions.dart';
import 'package:insaftelecom/accounting/pages/counter_party.dart';
import 'package:insaftelecom/accounting/pages/offices.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AccountingBaseScreen extends StatefulWidget {
  const AccountingBaseScreen({super.key});

  @override
  State<AccountingBaseScreen> createState() => _AccountingBaseScreenState();
}

class _AccountingBaseScreenState extends State<AccountingBaseScreen> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountingCurrencyController currencyController = Get.put(
    AccountingCurrencyController(),
  );

  final StatisticController statisticController = Get.put(
    StatisticController(),
  );

  late final List<Widget> _pages;

  bool showMain = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = [Offices(), AccountsPage(), CounterParty(), Alltransactions()];

    _showIntroAnimation();
  }

  void _showIntroAnimation() {
    setState(() {
      showMain = false;
    });

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }

      setState(() {
        showMain = true;
      });
    });
  }

  Future<bool> _onWillPop() async {
    if (!mounted) {
      return true;
    }

    setState(() {
      showMain = false;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 650),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.97,
                  end: 1,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          child: showMain ? _mainScaffold() : _introView(),
        ),
      ),
    );
  }

  Widget _introView() {
    return Container(
      key: const ValueKey("accounting_intro"),
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primarycolor2,
            AppColors.afraPayTurquoise,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: Colors.white.withOpacity(0.14)),
                  ),
                  child: Lottie.asset(
                    "assets/loties/accounting.json",
                    key: const ValueKey("accounting_lottie"),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 22),
                KText(
                  text: languagesController.tr("MY_ACCOUNTING"),
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 9),
                Container(
                  width: 56,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mainScaffold() {
    return Scaffold(
      key: const ValueKey("accounting_main"),
      backgroundColor: AppColors.afraPayBackground,
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: Container(
        height: 80,
        margin: const EdgeInsets.fromLTRB(8, 6, 8, 0),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _navItem(
                icon: Icons.business_rounded,
                index: 0,
                label: languagesController.tr("OFFICES"),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.account_balance_wallet_rounded,
                index: 1,
                label: languagesController.tr("ACCOUNTS"),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.people_alt_rounded,
                index: 2,
                label: languagesController.tr("COUNTER_PARTY"),
              ),
            ),
            Expanded(
              child: _navItem(
                icon: Icons.swap_horiz_rounded,
                index: 3,
                label: languagesController.tr("TRANSACTIONS"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (currentIndex == index) {
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.afraPayTurquoise.withOpacity(0.09)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 30,
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [
                            AppColors.primarycolor2,
                            AppColors.afraPayTurquoise,
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: isActive ? Colors.white : AppColors.fontColor,
                ),
              ),
              const SizedBox(height: 3),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: KText(
                    text: label,
                    color: isActive
                        ? AppColors.primaryColor
                        : AppColors.fontColor,
                    fontSize: 10.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

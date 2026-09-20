import 'package:insaftelecom/controllers/dashboard_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/money_format_helper.dart';
import '../controllers/delete_office_controller.dart';
import '../controllers/office_list_controller.dart';
import '../controllers/office_transactions_controller.dart';
import '../controllers/statistic_controller.dart';
import '../create_counterpary_screen.dart';
import '../create_office_screen.dart';
import '../screens/currency_screen.dart';
import '../update_office_screen.dart';
import '../view_office_screen.dart';

class Offices extends StatefulWidget {
  const Offices({super.key});

  @override
  State<Offices> createState() => _OfficesState();
}

class _OfficesState extends State<Offices> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final StatisticController statisticController =
      Get.find<StatisticController>();

  final OfficeListController officeListController = Get.put(
    OfficeListController(),
  );

  final OfficeTransactionsListController transactionsListController = Get.put(
    OfficeTransactionsListController(),
  );

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final DeleteOfficeController deleteOfficeController = Get.put(
    DeleteOfficeController(),
  );

  final ScrollController scrollController = ScrollController();

  bool isQuickMenuOpen = false;

  @override
  void initState() {
    super.initState();

    officeListController.initialpage = 1;
    officeListController.finalList.clear();

    officeListController.fetchofficelist();
    statisticController.fetchstatistic();

    scrollController.addListener(_loadMoreOffices);
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreOffices);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreOffices() async {
    if (!scrollController.hasClients || officeListController.isLoading.value) {
      return;
    }

    final reachedBottom =
        scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 80;

    if (!reachedBottom) {
      return;
    }

    final totalItems =
        officeListController.allofficelist.value.data?.pagination?.totalItems ??
        0;

    if (totalItems <= 0 ||
        officeListController.finalList.length >= totalItems) {
      return;
    }

    officeListController.initialpage++;
    officeListController.fetchofficelist();
  }

  Future<void> _refreshPage() async {
    officeListController.initialpage = 1;
    officeListController.finalList.clear();

    officeListController.fetchofficelist();
    statisticController.fetchstatistic();

    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 7),
              _buildStatisticsSection(),
              const SizedBox(height: 8),
              _buildMainActions(),
              const SizedBox(height: 8),
              Expanded(child: _buildOfficeList()),
            ],
          ),
          if (isQuickMenuOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    isQuickMenuOpen = false;
                  });
                },
                child: Container(color: Colors.black.withOpacity(0.16)),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            right: isQuickMenuOpen ? 15 : -340,
            bottom: 82,
            child: _buildQuickActionMenu(),
          ),
        ],
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
            child: Obx(() {
              final resellerName =
                  dashboardController
                      .alldashboardData
                      .value
                      .data
                      ?.userInfo
                      ?.resellerName
                      ?.toString() ??
                  "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KText(
                    text: languagesController.tr("OFFICES"),
                    color: AppColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (resellerName.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    KText(
                      text: resellerName,
                      color: AppColors.fontColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              );
            }),
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

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(() {
        if (statisticController.isLoading.value) {
          return Container(
            height: 178,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final currencies = statisticController.currencyList;
        final selectedData = statisticController.selectedCurrencyData;

        final netBalance =
            double.tryParse(selectedData?.netBalance?.toString() ?? "0") ?? 0;

        final totalReceivable =
            double.tryParse(selectedData?.totalReceivable?.toString() ?? "0") ??
            0;

        final totalPayable =
            double.tryParse(selectedData?.totalPayable?.toString() ?? "0") ?? 0;

        final accountsCount =
            int.tryParse(selectedData?.accountsCount?.toString() ?? "0") ?? 0;

        final counterpartiesCount =
            int.tryParse(
              selectedData?.counterpartiesCount?.toString() ?? "0",
            ) ??
            0;

        final selectedCurrencyCode =
            selectedData?.currencyCode?.toString().trim() ?? "";

        final firstCurrencyCode = currencies.isNotEmpty
            ? currencies.first.currencyCode?.toString().trim() ?? ""
            : "";

        final currencyCode = selectedCurrencyCode.isNotEmpty
            ? selectedCurrencyCode
            : firstCurrencyCode;

        final balanceStatus =
            selectedData?.status?.toString().trim().toLowerCase() ?? "";

        final isBalanceSettled =
            netBalance == 0 ||
            balanceStatus == "settled" ||
            balanceStatus == "balanced";

        final iWillReceive =
            !isBalanceSettled &&
            (balanceStatus == "receivable" ||
                (balanceStatus.isEmpty && netBalance > 0));

        final relationText = isBalanceSettled
            ? languagesController.tr("BALANCE_SETTLED")
            : iWillReceive
            ? languagesController.tr("YOU_OWE")
            : languagesController.tr("YOU_ARE_OWED");

        final relationColor = isBalanceSettled
            ? const Color(0xFF667085)
            : iWillReceive
            ? AppColors.afraPayTurquoise
            : const Color(0xFFE05263);

        final relationIcon = isBalanceSettled
            ? Icons.check_circle_outline_rounded
            : iWillReceive
            ? Icons.south_west_rounded
            : Icons.north_east_rounded;

        final formattedNetBalance = currencyCode.isEmpty
            ? formatMoney(netBalance.abs())
            : "${formatMoney(netBalance.abs())} $currencyCode";

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.16),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(relationIcon, color: Colors.white, size: 21),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KText(
                          text: relationText,
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        KText(
                          text: formattedNetBalance,
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.10)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        KText(
                          text: accountsCount.toString(),
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(
                    child: _compactMetric(
                      icon: Icons.south_west_rounded,
                      label: languagesController.tr("TOTAL_I_RECEIVED"),
                      amount: currencyCode.isEmpty
                          ? formatMoney(totalReceivable.abs())
                          : "$currencyCode ${formatMoney(totalReceivable.abs())}",
                      accent: AppColors.afraPayTurquoise,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactMetric(
                      icon: Icons.north_east_rounded,
                      label: languagesController.tr("TOTAL_I_PAID"),
                      amount: currencyCode.isEmpty
                          ? formatMoney(totalPayable.abs())
                          : "$currencyCode ${formatMoney(totalPayable.abs())}",
                      accent: const Color(0xFFE05263),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _miniStatChip(
                      icon: Icons.people_outline_rounded,
                      value: counterpartiesCount.toString(),
                      label: languagesController.tr("COUNTER_PARTY"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: _buildCurrencySelector(currencies)),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _compactMetric({
    required IconData icon,
    required String label,
    required String amount,
    required Color accent,
  }) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: accent, size: 16),
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
                  fontSize: 8.5,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                KText(
                  text: amount,
                  color: accent,
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

  Widget _miniStatChip({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          KText(
            text: value,
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: KText(
              text: label,
              color: Colors.white.withOpacity(0.72),
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(dynamic currencies) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: currencies.length + 1,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 5);
        },
        itemBuilder: (context, index) {
          if (index == currencies.length) {
            return GestureDetector(
              onTap: () {
                Get.to(() => CurrencyScreen());
              },
              child: Container(
                height: 36,
                width: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarycolor2,
                      AppColors.afraPayTurquoise,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            );
          }

          final currency = currencies[index];
          final isSelected =
              statisticController.selectedCurrencyIndex.value == index;

          return GestureDetector(
            onTap: () {
              statisticController.selectCurrency(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 36,
              constraints: const BoxConstraints(minWidth: 56),
              padding: const EdgeInsets.symmetric(horizontal: 11),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.white.withOpacity(0.10),
                ),
              ),
              child: KText(
                text: currency.currencyCode?.toString() ?? "--",
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(() {
        if (statisticController.isLoading.value) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.055),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStatisticAction(
                  icon: Icons.add_business_rounded,
                  title: languagesController.tr("OFFICE"),
                  onTap: () {
                    Get.to(() => CreateOfficeScreen());
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildStatisticAction(
                  icon: Icons.person_add_alt_1_rounded,
                  title: languagesController.tr("COUNTER_PARTY"),
                  onTap: () {
                    Get.to(() => CreateCounterparyScreen());
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildStatisticAction(
                  icon: Icons.bar_chart_rounded,
                  title: languagesController.tr("REPORTS"),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildStatisticAction(
                  icon: Icons.currency_exchange_rounded,
                  title: languagesController.tr("CURRENCY"),
                  onTap: () {
                    Get.to(() => CurrencyScreen());
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatisticAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.045),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.afraPayTurquoise.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.afraPayTurquoise, size: 14),
              ),
              const SizedBox(height: 3),
              KText(
                text: title,
                color: AppColors.primaryColor,
                fontSize: 8.2,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfficeList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(() {
        final offices = officeListController.finalList;

        final isLoading = officeListController.isLoading.value;

        if (isLoading && offices.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.afraPayTurquoise),
          );
        }

        if (offices.isEmpty) {
          return RefreshIndicator(
            color: AppColors.afraPayTurquoise,
            onRefresh: _refreshPage,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 70),
              children: [
                Column(
                  children: [
                    Container(
                      height: 68,
                      width: 68,
                      decoration: BoxDecoration(
                        color: AppColors.afraPayTurquoise.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.business_outlined,
                        color: AppColors.afraPayTurquoise,
                        size: 31,
                      ),
                    ),
                    const SizedBox(height: 14),
                    KText(
                      text: languagesController.tr("NO_DATA_FOUND"),
                      color: AppColors.fontColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.afraPayTurquoise,
          onRefresh: _refreshPage,
          child: ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: offices.length + (isLoading ? 1 : 0),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              if (index >= offices.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.afraPayTurquoise,
                      ),
                    ),
                  ),
                );
              }

              return _buildOfficeCard(offices[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOfficeCard(dynamic data) {
    final location = data.location?.toString().trim() ?? "";

    return GestureDetector(
      onTap: () {
        transactionsListController.finalList.clear();
        transactionsListController.initialpage = 1;

        transactionsListController.fetchtransactions(
          int.parse(data.id.toString()),
        );

        Get.to(
          () => ViewOfficeScreen(
            id: data.id.toString(),
            officeId: data.code,
            officeName: data.name,
            location: data.location,
            phone: data.phone,
            address: data.address,
            notes: data.notes,
            isactive: data.isActive.toString(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(11, 11, 10, 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.035),
              blurRadius: 11,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.afraPayTurquoise.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                "assets/icons/office.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.business_outlined,
                    color: AppColors.afraPayTurquoise,
                    size: 22,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: KText(
                          text: data.name?.toString() ?? "",
                          color: AppColors.primaryColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (data.code != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.afraPayBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: KText(
                            text: data.code.toString(),
                            color: AppColors.fontColor,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOfficeInfoChip(
                          icon: Icons.account_balance_wallet_outlined,
                          value: data.accountsCount?.toString() ?? "0",
                          label: languagesController.tr("ACCOUNTS"),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildOfficeInfoChip(
                          icon: Icons.swap_horiz_rounded,
                          value: data.transactionCount?.toString() ?? "0",
                          label: languagesController.tr("TRANSACTIONS"),
                        ),
                      ),
                    ],
                  ),
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.fontColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: KText(
                            text: location,
                            color: AppColors.fontColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showOfficeActions(data);
              },
              child: Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.045),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.more_horiz_rounded,
                  size: 20,
                  color: AppColors.fontColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficeInfoChip({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.afraPayBackground,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.afraPayTurquoise),
          const SizedBox(width: 4),
          KText(
            text: value,
            color: AppColors.primaryColor,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(width: 3),
          Expanded(
            child: KText(
              text: label,
              color: AppColors.fontColor,
              fontSize: 8.5,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showOfficeActions(dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
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
                const SizedBox(height: 14),
                KText(
                  text: data.name?.toString() ?? "",
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                _officeActionTile(
                  icon: Icons.edit_outlined,
                  title: languagesController.tr("EDIT_OFFICE"),
                  color: AppColors.primarycolor2,
                  onTap: () {
                    Navigator.pop(bottomSheetContext);

                    Get.to(
                      () => UpdateOfficeScreen(
                        officeid: data.id.toString(),
                        officeName: data.name,
                        phoneNumber: data.phone,
                        codeNumber: data.code.toString(),
                        location: data.location,
                        address: data.address,
                        isActive: data.isActive.toString(),
                        notes: data.notes,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _officeActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: languagesController.tr("DELETE_OFFICE"),
                  color: const Color(0xFFE05263),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);

                    deleteOfficeController.deleteoffice(data.id.toString());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _officeActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KText(
                  text: title,
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 19),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionMenu() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isQuickMenuOpen ? 1 : 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.76,
        padding: const EdgeInsets.fromLTRB(14, 15, 14, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.11),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickMenuItem(
              title: "I Received Money",
              icon: Icons.south_west_rounded,
              onTap: () {
                setState(() {
                  isQuickMenuOpen = false;
                });
              },
            ),
            const SizedBox(height: 7),
            _buildQuickMenuItem(
              title: "I Gave Money",
              icon: Icons.north_east_rounded,
              onTap: () {
                setState(() {
                  isQuickMenuOpen = false;
                });
              },
            ),
            const SizedBox(height: 7),
            _buildQuickMenuItem(
              title: "Product Purchased",
              icon: Icons.shopping_cart_checkout_rounded,
              onTap: () {
                setState(() {
                  isQuickMenuOpen = false;
                });
              },
            ),
            const SizedBox(height: 7),
            _buildQuickMenuItem(
              title: "Product Sold",
              icon: Icons.sell_outlined,
              onTap: () {
                setState(() {
                  isQuickMenuOpen = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primarycolor2,
                      AppColors.afraPayTurquoise,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: Colors.white, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: KText(
                  text: title,
                  color: AppColors.primaryColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
}

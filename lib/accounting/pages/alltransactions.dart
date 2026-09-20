import 'package:insaftelecom/accounting/controllers/account_transaction_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/helpers/localtime_helper.dart';
import '../../helpers/money_format_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alltransactions extends StatefulWidget {
  const Alltransactions({super.key});

  @override
  State<Alltransactions> createState() => _AlltransactionsState();
}

class _AlltransactionsState extends State<Alltransactions> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AccountTransactionController controller = Get.put(
    AccountTransactionController(),
  );

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();

  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    controller.initialpage = 1;
    controller.finalList.clear();
    controller.fetchtransactions();

    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();

    super.dispose();
  }

  Future<void> _refreshTransactions() async {
    if (_isRefreshing) {
      return;
    }

    _isRefreshing = true;

    try {
      controller.initialpage = 1;
      controller.finalList.clear();

      await controller.fetchtransactions();
    } finally {
      _isRefreshing = false;
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    if (scrollController.position.extentAfter < 250) {
      _loadMoreTransactions();
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore || controller.isLoading.value) {
      return;
    }

    final totalPages =
        controller.alltransactions.value.payload?.pagination?.totalPages ?? 0;

    final currentPage = controller.initialpage;

    if (totalPages <= 0 || currentPage >= totalPages) {
      return;
    }

    final nextPage = currentPage + 1;

    if (mounted) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      controller.initialpage = nextPage;
      await controller.fetchtransactions();
    } catch (_) {
      controller.initialpage = currentPage;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  List<dynamic> _visibleTransactions() {
    final filteredByType = controller.finalList.where((item) {
      final type = item.transactionType?.toString().trim() ?? "";

      return type.isNotEmpty && type.toLowerCase() != "null";
    }).toList();

    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return filteredByType;
    }

    return filteredByType.where((item) {
      final accountName =
          item.counterpartyAccount?.name?.toString().toLowerCase() ?? "";

      final amount = item.amount?.toString().toLowerCase() ?? "";

      final type = item.transactionType?.toString().toLowerCase() ?? "";

      final date = convertToDate(item.createdAt.toString()).toLowerCase();

      return accountName.contains(query) ||
          amount.contains(query) ||
          type.contains(query) ||
          date.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 7),
          _buildSearchBar(),
          const SizedBox(height: 8),
          Expanded(child: _buildTransactionsContent()),
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
          Container(
            height: 34,
            width: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.afraPayTurquoise,
              size: 18,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: KText(
              text: languagesController.tr("TRANSACTIONS"),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.045),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.afraPayTurquoise,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                        textInputAction: TextInputAction.search,
                        cursorColor: AppColors.afraPayTurquoise,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: languagesController.tr("SEARCH_AMOUNT"),
                          isDense: true,
                          hintStyle: TextStyle(
                            color: AppColors.fontColor.withOpacity(0.75),
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                    if (_searchText.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          searchController.clear();

                          setState(() {
                            _searchText = "";
                          });
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.afraPayBackground,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppColors.fontColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 7),
            GestureDetector(
              onTap: _refreshTransactions,
              child: Container(
                height: 46,
                width: 46,
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
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsContent() {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      final hasRawData = controller.finalList.isNotEmpty;

      final visibleTransactions = _visibleTransactions();

      if (isLoading && !hasRawData) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.afraPayTurquoise),
        );
      }

      if (visibleTransactions.isEmpty) {
        return RefreshIndicator(
          color: AppColors.afraPayTurquoise,
          onRefresh: _refreshTransactions,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 70),
            children: [_buildEmptyState()],
          ),
        );
      }

      return Column(
        children: [
          _buildTransactionCount(),
          const SizedBox(height: 7),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.afraPayTurquoise,
              onRefresh: _refreshTransactions,
              child: ListView.separated(
                controller: scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemCount:
                    visibleTransactions.length + (_isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  if (index == visibleTransactions.length) {
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

                  return _buildTransactionCard(visibleTransactions[index]);
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionCount() {
    final totalItems =
        controller.alltransactions.value.payload?.pagination?.totalItems
            ?.toString() ??
        "0";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.afraPayTurquoise.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.afraPayTurquoise,
                  size: 14,
                ),
                const SizedBox(width: 5),
                KText(
                  text: totalItems,
                  color: AppColors.primaryColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(width: 4),
                KText(
                  text: languagesController.tr("TRANSACTIONS"),
                  color: AppColors.fontColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(dynamic data) {
    final transactionType =
        data.transactionType?.toString().trim().toUpperCase() ?? "";

    final isReceivable = transactionType == "RECEIVABLE";

    final isPayable = transactionType == "PAYABLE";

    final transactionTitle = isReceivable
        ? languagesController.tr("I_PAID")
        : isPayable
        ? languagesController.tr("I_RECEIVED")
        : transactionType;

    final transactionColor = isReceivable
        ? const Color(0xFFE05263)
        : isPayable
        ? AppColors.afraPayTurquoise
        : AppColors.fontColor;

    final icon = isReceivable
        ? Icons.north_east_rounded
        : isPayable
        ? Icons.south_west_rounded
        : Icons.receipt_long_outlined;

    final directionIcon = isReceivable
        ? Icons.arrow_upward_rounded
        : isPayable
        ? Icons.arrow_downward_rounded
        : Icons.swap_vert_rounded;

    final accountName = data.counterpartyAccount?.name?.toString() ?? "--";

    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.055)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.035),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: transactionColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: transactionColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(
                  text: accountName,
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: transactionColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: KText(
                        text: transactionTitle,
                        color: transactionColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppColors.fontColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: KText(
                        text: convertToDate(data.createdAt.toString()),
                        color: AppColors.fontColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              KText(
                text: formatMoney(data.amount),
                color: transactionColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 5),
              Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: transactionColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(directionIcon, color: transactionColor, size: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 68,
              width: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.afraPayTurquoise.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 31,
                color: AppColors.afraPayTurquoise,
              ),
            ),
            const SizedBox(height: 14),
            KText(
              text: languagesController.tr("NO_TRANSACTIONS_FOUND"),
              color: AppColors.fontColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

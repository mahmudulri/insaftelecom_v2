import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/allaccount_list_controller.dart';
import 'package:insaftelecom/accounting/controllers/counter_party_controller.dart';
import 'package:insaftelecom/accounting/controllers/office_list_controller.dart';
import 'package:insaftelecom/accounting/create_account_screen.dart';
import 'package:insaftelecom/accounting/models/allaccount_model.dart';
import 'package:insaftelecom/accounting/screens/account_details_screen.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import '../../helpers/money_format_helper.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AllAccountListController accountListController =
      Get.isRegistered<AllAccountListController>()
      ? Get.find<AllAccountListController>()
      : Get.put(AllAccountListController());

  final OfficeListController officeListController =
      Get.isRegistered<OfficeListController>()
      ? Get.find<OfficeListController>()
      : Get.put(OfficeListController());

  final AccountingCurrencyController currencyController =
      Get.isRegistered<AccountingCurrencyController>()
      ? Get.find<AccountingCurrencyController>()
      : Get.put(AccountingCurrencyController());

  final CounterPartyController counterPartyController =
      Get.isRegistered<CounterPartyController>()
      ? Get.find<CounterPartyController>()
      : Get.put(CounterPartyController());

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    searchController.text = accountListController.searchText.value;

    accountListController.initialpage = 1;
    accountListController.finalList.clear();

    await accountListController.fetchaccount();

    if ((currencyController.allcurrencylist.value.data?.currencies?.isEmpty ??
            true) &&
        !currencyController.isLoading.value) {
      currencyController.fetchCurrencyList();
    }

    if (counterPartyController.finalList.isEmpty &&
        !counterPartyController.isLoading.value) {
      counterPartyController.initialpage = 1;
      counterPartyController.fetchcounterpary();
    }

    if (officeListController.finalList.isEmpty &&
        !officeListController.isLoading.value) {
      officeListController.initialpage = 1;
      officeListController.fetchofficelist();
    }
  }

  Future<void> _refreshAccounts() async {
    accountListController.initialpage = 1;
    accountListController.finalList.clear();

    await accountListController.fetchaccount();
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    if (scrollController.position.extentAfter < 250) {
      _loadMoreAccounts();
    }
  }

  Future<void> _loadMoreAccounts() async {
    if (_isLoadingMore || accountListController.isLoading.value) {
      return;
    }

    final totalPages =
        accountListController
            .accountlist
            .value
            .payload
            ?.pagination
            ?.totalPages ??
        0;

    final currentPage = accountListController.initialpage;

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
      accountListController.initialpage = nextPage;
      await accountListController.fetchaccount();
    } catch (_) {
      accountListController.initialpage = currentPage;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.afraPayBackground,
      appBar: _buildAppBar(),
      body: Obx(() {
        final isLoading = accountListController.isLoading.value;

        final hasRawData = accountListController.finalList.isNotEmpty;

        final List<Account> visibleAccounts =
            accountListController.visibleAccounts;

        final activeFilterCount = accountListController.activeFilterCount;

        return Column(
          children: [
            const SizedBox(height: 7),
            _buildSearchAndFilter(activeFilterCount),
            if (activeFilterCount > 0) ...[
              const SizedBox(height: 7),
              _buildActiveFilters(),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: _buildAccountContent(
                isLoading: isLoading,
                hasRawData: hasRawData,
                visibleAccounts: visibleAccounts,
              ),
            ),
            _buildAddAccountButton(),
          ],
        );
      }),
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
          // _appBarButton(icon: Icons.arrow_back_rounded, onTap: Get.back),
          // const SizedBox(width: 10),
          Expanded(
            child: KText(
              text: languagesController.tr("ACCOUNTS"),
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

  Widget _buildSearchAndFilter(int activeFilterCount) {
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
                        onChanged: accountListController.setSearchText,
                        onSubmitted: accountListController.submitSearch,
                        textInputAction: TextInputAction.search,
                        cursorColor: AppColors.afraPayTurquoise,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: languagesController.tr("NAME"),
                          isDense: true,
                          hintStyle: TextStyle(
                            color: AppColors.fontColor.withOpacity(0.75),
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                    if (accountListController.searchText.value.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          searchController.clear();
                          await accountListController.clearSearch();
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
              onTap: _showFilterSheet,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
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
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (activeFilterCount > 0)
                    Positioned(
                      right: -4,
                      top: -5,
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 19,
                          minWidth: 19,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE05263),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: KText(
                          text: activeFilterCount.toString(),
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (accountListController.selectedCurrencyCode.value != null)
              _activeFilterChip(
                icon: Icons.currency_exchange_rounded,
                label: accountListController.selectedCurrencyCode.value ?? "",
                onDeleted: () async {
                  await accountListController.applyFilters(
                    currencyCode: null,
                    counterpartyId:
                        accountListController.selectedCounterpartyId.value,
                    officeId: accountListController.selectedOfficeId.value,
                    balanceStatus:
                        accountListController.selectedBalanceStatus.value,
                  );
                },
              ),
            if (accountListController.selectedCounterpartyId.value != null)
              _activeFilterChip(
                icon: Icons.person_outline_rounded,
                label: _selectedCounterpartyName(),
                onDeleted: () async {
                  await accountListController.applyFilters(
                    currencyCode:
                        accountListController.selectedCurrencyCode.value,
                    counterpartyId: null,
                    officeId: accountListController.selectedOfficeId.value,
                    balanceStatus:
                        accountListController.selectedBalanceStatus.value,
                  );
                },
              ),
            if (accountListController.selectedOfficeId.value != null)
              _activeFilterChip(
                icon: Icons.business_outlined,
                label: _selectedOfficeName(),
                onDeleted: () async {
                  await accountListController.applyFilters(
                    currencyCode:
                        accountListController.selectedCurrencyCode.value,
                    counterpartyId:
                        accountListController.selectedCounterpartyId.value,
                    officeId: null,
                    balanceStatus:
                        accountListController.selectedBalanceStatus.value,
                  );
                },
              ),
            if (accountListController.selectedBalanceStatus.value != null)
              _activeFilterChip(
                icon: Icons.account_balance_wallet_outlined,
                label: _selectedBalanceStatusLabel(),
                onDeleted: () async {
                  await accountListController.applyFilters(
                    currencyCode:
                        accountListController.selectedCurrencyCode.value,
                    counterpartyId:
                        accountListController.selectedCounterpartyId.value,
                    officeId: accountListController.selectedOfficeId.value,
                    balanceStatus: null,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountContent({
    required bool isLoading,
    required bool hasRawData,
    required List<Account> visibleAccounts,
  }) {
    if (isLoading && !hasRawData) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.afraPayTurquoise),
      );
    }

    if (visibleAccounts.isEmpty) {
      return RefreshIndicator(
        color: AppColors.afraPayTurquoise,
        onRefresh: _refreshAccounts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 70),
          children: [
            Column(
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
                    Icons.account_balance_wallet_outlined,
                    size: 31,
                    color: AppColors.afraPayTurquoise,
                  ),
                ),
                const SizedBox(height: 14),
                KText(
                  text: languagesController.tr("NO_ACCOUNTS_FOUND"),
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
      onRefresh: _refreshAccounts,
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
        itemCount: visibleAccounts.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (context, index) {
          if (index == visibleAccounts.length) {
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

          return _buildAccountCard(visibleAccounts[index]);
        },
      ),
    );
  }

  Widget _buildAccountCard(Account account) {
    final balanceValue =
        double.tryParse(account.currentBalance?.toString() ?? "0") ?? 0;

    final isBalanceSettled = balanceValue == 0;

    final heOwes = balanceValue < 0;

    final balanceRelationText = isBalanceSettled
        ? languagesController.tr("BALANCE_SETTLED")
        : heOwes
        ? languagesController.tr("HE_OWE")
        : languagesController.tr("HE_OWED");

    final balanceColor = isBalanceSettled
        ? const Color(0xFF667085)
        : heOwes
        ? const Color(0xFFE05263)
        : AppColors.afraPayTurquoise;

    final balanceRelationIcon = isBalanceSettled
        ? Icons.check_circle_outline_rounded
        : heOwes
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    final currencyCode = account.currencyCode ?? "--";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(() => AccountDetailsScreen(accountID: account.id.toString()));
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.055),
            ),
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
                height: 46,
                width: 46,
                alignment: Alignment.center,
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
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: KText(
                  text: account.name ?? "---",
                  color: AppColors.primaryColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  height: 1.25,
                ),
              ),

              const Spacer(),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  KText(
                    text:
                        "${account.currency?.symbol ?? currencyCode} "
                        "${formatMoney(account.currentBalance)}",
                    color: balanceColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(balanceRelationIcon, size: 12, color: balanceColor),
                      const SizedBox(width: 4),
                      KText(
                        text: balanceRelationText,
                        color: balanceColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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
            Get.to(() => CreateAccountScreen());
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
                  text: languagesController.tr("ADD_NEW_ACCOUNT"),
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

  Future<void> _showFilterSheet() async {
    if ((currencyController.allcurrencylist.value.data?.currencies?.isEmpty ??
            true) &&
        !currencyController.isLoading.value) {
      currencyController.fetchCurrencyList();
    }

    if (counterPartyController.finalList.isEmpty &&
        !counterPartyController.isLoading.value) {
      counterPartyController.initialpage = 1;
      counterPartyController.fetchcounterpary();
    }

    if (officeListController.finalList.isEmpty &&
        !officeListController.isLoading.value) {
      officeListController.initialpage = 1;
      officeListController.fetchofficelist();
    }

    String? tempCurrencyCode = accountListController.selectedCurrencyCode.value;

    int? tempCounterpartyId =
        accountListController.selectedCounterpartyId.value;

    int? tempOfficeId = accountListController.selectedOfficeId.value;

    String? tempBalanceStatus =
        accountListController.selectedBalanceStatus.value;

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.88,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.fontColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          height: 34,
                          width: 34,
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
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: KText(
                            text: languagesController.tr("FILTER"),
                            color: AppColors.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        GestureDetector(
                          onTap: Get.back,
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
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _filterLabel(languagesController.tr("CURRENCY")),
                    const SizedBox(height: 7),
                    Obx(() {
                      final currencies =
                          currencyController
                              .allcurrencylist
                              .value
                              .data
                              ?.currencies ??
                          [];

                      final Map<String, dynamic> uniqueCurrencyMap = {};

                      for (final currency in currencies) {
                        final code = currency.code?.trim() ?? "";

                        if (code.isNotEmpty) {
                          uniqueCurrencyMap[code] = currency;
                        }
                      }

                      final uniqueCurrencies = uniqueCurrencyMap.values
                          .toList();

                      if (currencyController.isLoading.value &&
                          uniqueCurrencies.isEmpty) {
                        return _filterLoadingBox();
                      }

                      final dropdownValue = tempCurrencyCode ?? "";

                      return DropdownButtonFormField<String>(
                        value: uniqueCurrencyMap.containsKey(dropdownValue)
                            ? dropdownValue
                            : "",
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.fontColor,
                        ),
                        decoration: _filterInputDecoration(),
                        items: [
                          DropdownMenuItem<String>(
                            value: "",
                            child: KText(
                              text: languagesController.tr("SELECT_CURRENCY"),
                              color: AppColors.fontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...uniqueCurrencies.map(
                            (currency) => DropdownMenuItem<String>(
                              value: currency.code.toString(),
                              child: KText(
                                text:
                                    "${currency.name ?? currency.code ?? ""} (${currency.code ?? ""})",
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setSheetState(() {
                            tempCurrencyCode = value == null || value.isEmpty
                                ? null
                                : value;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 15),
                    _filterLabel(languagesController.tr("COUNTER_PARTY")),
                    const SizedBox(height: 7),
                    Obx(() {
                      final counterparties = counterPartyController.finalList;

                      final Map<int, dynamic> uniqueCounterpartyMap = {};

                      for (final counterparty in counterparties) {
                        final id = counterparty.id;

                        if (id != null) {
                          uniqueCounterpartyMap[id] = counterparty;
                        }
                      }

                      final uniqueCounterparties = uniqueCounterpartyMap.values
                          .toList();

                      if (counterPartyController.isLoading.value &&
                          uniqueCounterparties.isEmpty) {
                        return _filterLoadingBox();
                      }

                      final dropdownValue = tempCounterpartyId ?? 0;

                      return DropdownButtonFormField<int>(
                        value: uniqueCounterpartyMap.containsKey(dropdownValue)
                            ? dropdownValue
                            : 0,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.fontColor,
                        ),
                        decoration: _filterInputDecoration(),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: KText(
                              text: languagesController.tr(
                                "SELECT_COUNTER_PARTY",
                              ),
                              color: AppColors.fontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...uniqueCounterparties.map(
                            (counterparty) => DropdownMenuItem<int>(
                              value: counterparty.id,
                              child: KText(
                                text: counterparty.name ?? "---",
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setSheetState(() {
                            tempCounterpartyId = value == null || value == 0
                                ? null
                                : value;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 15),
                    _filterLabel(languagesController.tr("OFFICE")),
                    const SizedBox(height: 7),
                    Obx(() {
                      final offices = officeListController.finalList;

                      final Map<int, dynamic> uniqueOfficeMap = {};

                      for (final office in offices) {
                        final id = office.id;

                        if (id != null) {
                          uniqueOfficeMap[id] = office;
                        }
                      }

                      final uniqueOffices = uniqueOfficeMap.values.toList();

                      if (officeListController.isLoading.value &&
                          uniqueOffices.isEmpty) {
                        return _filterLoadingBox();
                      }

                      final dropdownValue = tempOfficeId ?? 0;

                      return DropdownButtonFormField<int>(
                        value: uniqueOfficeMap.containsKey(dropdownValue)
                            ? dropdownValue
                            : 0,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.fontColor,
                        ),
                        decoration: _filterInputDecoration(),
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: KText(
                              text: languagesController.tr("SELECT_OFFICE"),
                              color: AppColors.fontColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...uniqueOffices.map(
                            (office) => DropdownMenuItem<int>(
                              value: office.id,
                              child: KText(
                                text: office.name ?? "---",
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setSheetState(() {
                            tempOfficeId = value == null || value == 0
                                ? null
                                : value;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 15),
                    _filterLabel(languagesController.tr("BALANCE_STATUS")),
                    const SizedBox(height: 7),
                    DropdownButtonFormField<String>(
                      value: tempBalanceStatus ?? "",
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.fontColor,
                      ),
                      decoration: _filterInputDecoration(),
                      items: [
                        DropdownMenuItem<String>(
                          value: "",
                          child: KText(
                            text: languagesController.tr(
                              "SELECT_BALANCE_STATUS",
                            ),
                            color: AppColors.fontColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "receivable",
                          child: KText(
                            text: languagesController.tr("RECEIVABLE"),
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "payable",
                          child: KText(
                            text: languagesController.tr("PAYABLE"),
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(() {
                          tempBalanceStatus = value == null || value.isEmpty
                              ? null
                              : value;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();

                              await accountListController.clearFilters();
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.afraPayBackground,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.06,
                                  ),
                                ),
                              ),
                              child: KText(
                                text: languagesController.tr("REMOVE_FILTER"),
                                color: AppColors.primaryColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();

                              await accountListController.applyFilters(
                                currencyCode: tempCurrencyCode,
                                counterpartyId: tempCounterpartyId,
                                officeId: tempOfficeId,
                                balanceStatus: tempBalanceStatus,
                              );
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primarycolor2,
                                    AppColors.afraPayTurquoise,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: KText(
                                text: languagesController.tr("APPLY_FILTER"),
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _filterLabel(String text) {
    return KText(
      text: text,
      color: AppColors.primaryColor,
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
    );
  }

  InputDecoration _filterInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primaryColor.withOpacity(0.045),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.07)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.afraPayTurquoise,
          width: 1,
        ),
      ),
    );
  }

  Widget _filterLoadingBox() {
    return Container(
      height: 52,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.045),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.07)),
      ),
      child: const SizedBox(
        height: 19,
        width: 19,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.afraPayTurquoise,
        ),
      ),
    );
  }

  Widget _activeFilterChip({
    required IconData icon,
    required String label,
    required Future<void> Function() onDeleted,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 4, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.afraPayTurquoise),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 145),
            child: KText(
              text: label,
              color: AppColors.primaryColor,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 3),
          GestureDetector(
            onTap: () {
              onDeleted();
            },
            child: Container(
              height: 23,
              width: 23,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.afraPayBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 13,
                color: AppColors.fontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _selectedCounterpartyName() {
    final selectedId = accountListController.selectedCounterpartyId.value;

    if (selectedId == null) {
      return "";
    }

    for (final counterparty in counterPartyController.finalList) {
      if (counterparty.id == selectedId) {
        return counterparty.name ?? selectedId.toString();
      }
    }

    return selectedId.toString();
  }

  String _selectedOfficeName() {
    final selectedId = accountListController.selectedOfficeId.value;

    if (selectedId == null) {
      return "";
    }

    for (final office in officeListController.finalList) {
      if (office.id == selectedId) {
        return office.name ?? selectedId.toString();
      }
    }

    return selectedId.toString();
  }

  String _selectedBalanceStatusLabel() {
    final status = accountListController.selectedBalanceStatus.value;

    if (status == "receivable") {
      return languagesController.tr("RECEIVABLE");
    }

    if (status == "payable") {
      return languagesController.tr("PAYABLE");
    }

    return status ?? "";
  }

  void _showAccountDetails(Account account) {
    Get.bottomSheet(
      SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.fontColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
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
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: KText(
                        text: account.currencyCode ?? "--",
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: account.name ?? "---",
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          KText(
                            text: account.accountType ?? "---",
                            color: AppColors.fontColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: Get.back,
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
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _detailRow(
                  title: languagesController.tr("ACCOUNT_NAME"),
                  value: account.name ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("ACCOUNT_TYPE"),
                  value: account.accountType ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("CURRENCY"),
                  value:
                      "${account.currency?.name ?? "---"} (${account.currencyCode ?? "---"})",
                ),
                _detailRow(
                  title: languagesController.tr("OPENING_BALANCE"),
                  value:
                      "${account.currency?.symbol ?? account.currencyCode ?? ""} ${formatMoney(account.openingBalance)}",
                ),
                _detailRow(
                  title: languagesController.tr("CURRENT_BALANCE"),
                  value:
                      "${account.currency?.symbol ?? account.currencyCode ?? ""} ${formatMoney(account.currentBalance)}",
                ),
                _detailRow(
                  title: languagesController.tr("COUNTER_PARTY"),
                  value: account.counterparty?.name ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("PHONE"),
                  value: account.counterparty?.phone ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("EMAIL"),
                  value: account.counterparty?.email ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("OFFICE"),
                  value: account.office?.name ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("OFFICE_CODE"),
                  value: account.office?.code ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("LOCATION"),
                  value: account.office?.location ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("ADDRESS"),
                  value: account.office?.address ?? "---",
                ),
                _detailRow(
                  title: languagesController.tr("NOTES"),
                  value: account.notes ?? "---",
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _detailRow({
    required String title,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: KText(
                  text: title,
                  color: AppColors.fontColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: KText(
                  text: value,
                  color: AppColors.primaryColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.end,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: AppColors.primaryColor.withOpacity(0.05)),
      ],
    );
  }
}

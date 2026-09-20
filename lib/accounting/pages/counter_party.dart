import 'package:insaftelecom/accounting/controllers/accounting_currency_controller.dart';
import 'package:insaftelecom/accounting/controllers/counter_party_controller.dart';
import 'package:insaftelecom/accounting/controllers/counterparty_details_controller.dart';
import 'package:insaftelecom/accounting/controllers/delete_counterparty_controller.dart';
import 'package:insaftelecom/accounting/create_counterpary_screen.dart';
import 'package:insaftelecom/accounting/update_counterparty_screen.dart';
import 'package:insaftelecom/accounting/view_counter_party_screen.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/helpers/language_changer.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CounterParty extends StatefulWidget {
  const CounterParty({super.key, this.officeName});

  final String? officeName;

  @override
  State<CounterParty> createState() => _CounterPartyState();
}

class _CounterPartyState extends State<CounterParty> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final CounterPartyController counterPartyController = Get.put(
    CounterPartyController(),
  );

  final AccountingCurrencyController accountingCurrencyController =
      Get.find<AccountingCurrencyController>();

  final DeleteCounterpartyController deleteCounterpartyController = Get.put(
    DeleteCounterpartyController(),
  );

  final CounterpartyDetailsController detailsController = Get.put(
    CounterpartyDetailsController(),
  );

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool _isLoadingMore = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    counterPartyController.initialpage = 1;
    counterPartyController.finalList.clear();
    counterPartyController.fetchcounterpary();

    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    if (scrollController.position.extentAfter < 250) {
      _loadMoreCounterParties();
    }
  }

  Future<void> _loadMoreCounterParties() async {
    if (_isLoadingMore || counterPartyController.isLoading.value) {
      return;
    }

    final totalPages =
        counterPartyController
            .counterparties
            .value
            .payload
            ?.pagination
            ?.totalPages ??
        0;

    final currentPage = counterPartyController.initialpage;

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
      counterPartyController.initialpage = nextPage;
      await counterPartyController.fetchcounterpary();
    } catch (_) {
      counterPartyController.initialpage = currentPage;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _refreshCounterParties() async {
    counterPartyController.initialpage = 1;
    counterPartyController.finalList.clear();

    await counterPartyController.fetchcounterpary();
  }

  List<dynamic> _visibleCounterParties(List<dynamic> source) {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return source;
    }

    return source.where((data) {
      final name = getDisplayValue(data.name, fallback: "").toLowerCase();

      final phone = getDisplayValue(data.phone, fallback: "").toLowerCase();

      final type = getDisplayValue(data.type, fallback: "").toLowerCase();

      return name.contains(query) ||
          phone.contains(query) ||
          type.contains(query);
    }).toList();
  }

  String getDisplayValue(dynamic value, {String fallback = "N/A"}) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == "null") {
      return fallback;
    }

    return text;
  }

  Color getTypeColor(String type) {
    switch (type.trim().toLowerCase()) {
      case "customer":
        return AppColors.afraPayTurquoise;
      case "supplier":
        return AppColors.primarycolor2;
      case "both":
        return AppColors.primaryColor;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type.trim().toLowerCase()) {
      case "customer":
        return Icons.person_outline_rounded;
      case "supplier":
        return Icons.inventory_2_outlined;
      case "both":
        return Icons.people_alt_outlined;
      default:
        return Icons.account_circle_outlined;
    }
  }

  void openCounterPartyDetails(dynamic data) {
    Get.to(
      () => ViewCounterPartyScreen(
        partyID: data.id.toString(),
        partyName: data.name.toString(),
        partyType: data.type.toString(),
        phoneNumber: data.phone.toString(),
        emailaddress: data.email.toString(),
        defaultCurrency: data.defaultCurrencyCode.toString(),
      ),
    );
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
          Expanded(
            child: Obx(() {
              final isLoading = counterPartyController.isLoading.value;

              final source = counterPartyController.finalList;

              final visibleData = _visibleCounterParties(source);

              if (isLoading && source.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.afraPayTurquoise,
                  ),
                );
              }

              if (visibleData.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.afraPayTurquoise,
                  onRefresh: _refreshCounterParties,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 70),
                    children: [buildEmptyState()],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.afraPayTurquoise,
                onRefresh: _refreshCounterParties,
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 10),
                  itemCount: visibleData.length + (_isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    if (index == visibleData.length) {
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

                    return buildCounterPartyCard(
                      context: context,
                      data: visibleData[index],
                    );
                  },
                ),
              );
            }),
          ),
          _buildAddButton(),
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
          // _appBarButton(icon: Icons.arrow_back_rounded, onTap: Get.back),
          // const SizedBox(width: 10),
          Expanded(
            child: KText(
              text: languagesController.tr("COUNTER_PARTY"),
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
                          hintText: languagesController.tr("NAME"),
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
              onTap: _refreshCounterParties,
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

  Widget buildCounterPartyCard({
    required BuildContext context,
    required dynamic data,
  }) {
    final name = getDisplayValue(data.name);
    final type = getDisplayValue(data.type);
    final phone = getDisplayValue(data.phone);
    final totalAccounts = getDisplayValue(data.accountsCount, fallback: "0");

    final typeColor = getTypeColor(type);
    final typeIcon = getTypeIcon(type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          openCounterPartyDetails(data);
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          padding: const EdgeInsets.fromLTRB(11, 10, 9, 10),
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
                  color: typeColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: typeColor.withOpacity(0.12)),
                ),
                child: Icon(typeIcon, size: 21, color: typeColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: name,
                      color: AppColors.primaryColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: KText(
                            text: phone,
                            color: AppColors.fontColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: KText(
                            text: _translateApiValue(type, fallback: type),
                            color: typeColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.afraPayBackground,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: KText(
                      text: totalAccounts,
                      color: AppColors.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _cardActionButton(
                        icon: Icons.share_rounded,
                        iconColor: const Color(0xFF25D366),
                        backgroundColor: const Color(0xFFEAFBF0),
                        onTap: () async {
                          await _prepareShare(data);
                        },
                      ),
                      const SizedBox(width: 5),
                      _cardActionButton(
                        icon: Icons.more_horiz_rounded,
                        iconColor: AppColors.fontColor,
                        backgroundColor: AppColors.afraPayBackground,
                        onTap: () {
                          openActionDialog(context, data);
                        },
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

  Widget _cardActionButton({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 17, color: iconColor),
      ),
    );
  }

  Future<void> _prepareShare(dynamic data) async {
    _showCalculatingDialog();

    final success = await detailsController.fetchdetails(data.id.toString());

    _hideCalculatingDialog();

    if (!mounted) {
      return;
    }

    if (success) {
      openShareDialog(context);
      return;
    }

    Get.snackbar(
      languagesController.tr("ERROR"),
      detailsController.errorMessage.value,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Widget buildEmptyState() {
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
                Icons.people_outline_rounded,
                size: 31,
                color: AppColors.afraPayTurquoise,
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
      ),
    );
  }

  Widget _buildAddButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: GestureDetector(
          onTap: () {
            Get.to(() => CreateCounterparyScreen());
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
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 7),
                KText(
                  text: languagesController.tr("ADD_COUNTER_PARTY"),
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

  void openActionDialog(BuildContext context, dynamic data) {
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
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.afraPayTurquoise.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.business_center_outlined,
                        color: AppColors.afraPayTurquoise,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: getDisplayValue(data.name),
                            color: AppColors.primaryColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          KText(
                            text: getDisplayValue(data.phone),
                            color: AppColors.fontColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                _actionTile(
                  icon: Icons.edit_outlined,
                  title: languagesController.tr("EDIT"),
                  color: AppColors.primarycolor2,
                  onTap: () {
                    Navigator.pop(bottomSheetContext);

                    Get.to(
                      () => UpdateCounterpartyScreen(
                        partyID: data.id.toString(),
                        partyName: data.name.toString(),
                        partyType: data.type.toString(),
                        phoneNumber: data.phone.toString(),
                        emailaddress: data.email.toString(),
                        currency: data.defaultCurrencyCode.toString(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _actionTile(
                  icon: Icons.delete_outline_rounded,
                  title: languagesController.tr("DELETE"),
                  color: const Color(0xFFE05263),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);

                    deleteCounterpartyController.deleteparty(
                      data.id.toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionTile({
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

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().replaceAll(",", "").trim()) ?? 0;
  }

  String _formatAmount(dynamic value) {
    final amount = _toDouble(value).abs();

    final isWholeNumber = amount == amount.roundToDouble();

    final rawValue = isWholeNumber
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);

    final parts = rawValue.split(".");

    final formattedInteger = parts.first.replaceAllMapped(
      RegExp(r"\B(?=(\d{3})+(?!\d))"),
      (match) => ",",
    );

    if (parts.length == 1) {
      return formattedInteger;
    }

    final decimalPart = parts[1].replaceFirst(RegExp(r"0+$"), "");

    if (decimalPart.isEmpty) {
      return formattedInteger;
    }

    return "$formattedInteger.$decimalPart";
  }

  String _translationKey(dynamic value) {
    final raw = getDisplayValue(value, fallback: "").trim();

    if (raw.isEmpty) {
      return "";
    }

    return raw
        .toUpperCase()
        .replaceAll(RegExp(r"[^A-Z0-9]+"), "_")
        .replaceAll(RegExp(r"^_+|_+$"), "");
  }

  String _formatApiLabel(String value) {
    final raw = value.trim();

    if (raw.isEmpty) {
      return raw;
    }

    if (raw.length <= 5 && raw == raw.toUpperCase()) {
      return raw;
    }

    return raw
        .replaceAll("_", " ")
        .split(RegExp(r"\s+"))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}",
        )
        .join(" ");
  }

  String _translateApiValue(dynamic value, {String fallback = "--"}) {
    final raw = getDisplayValue(value, fallback: "").trim();

    if (raw.isEmpty) {
      return fallback;
    }

    final key = _translationKey(raw);

    if (key.isEmpty) {
      return _formatApiLabel(raw);
    }

    final translated = languagesController.tr(key).trim();

    if (translated.isEmpty || translated == key) {
      return _formatApiLabel(raw);
    }

    return translated;
  }

  String _currentDate() {
    final now = DateTime.now();

    return "${now.year}/"
        "${now.month.toString().padLeft(2, "0")}/"
        "${now.day.toString().padLeft(2, "0")}";
  }

  String _balanceTitle(String? status) {
    switch (status?.trim().toLowerCase()) {
      case "receivable":
        return languagesController.tr("HE_OWE");
      case "payable":
        return languagesController.tr("HE_OWED");
      default:
        return languagesController.tr("BALANCE_SETTLED");
    }
  }

  String _translatedOrFallback(String key, String fallback) {
    final translated = languagesController.tr(key).trim();

    if (translated.isEmpty || translated == key) {
      return fallback;
    }

    return translated;
  }

  void _showCalculatingDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.afraPayTurquoise.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const SizedBox(
                    height: 21,
                    width: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.afraPayTurquoise,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KText(
                        text: _translatedOrFallback(
                          "CALCULATING",
                          "Calculating...",
                        ),
                        color: AppColors.primaryColor,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(height: 4),
                      KText(
                        text: _translatedOrFallback(
                          "PLEASE_WAIT",
                          "Please wait while we prepare the account summary.",
                        ),
                        color: AppColors.fontColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _hideCalculatingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  String generateCounterPartyShareText() {
    final counterparty = detailsController.alldata.value.data?.counterparty;

    if (counterparty == null) {
      return "";
    }

    final balances = counterparty.summary?.snapshot?.byCurrency ?? [];

    final name = getDisplayValue(counterparty.name, fallback: "--");

    final phone = getDisplayValue(counterparty.phone, fallback: "--");

    final category = _translateApiValue(counterparty.type, fallback: "--");

    final officeName = getDisplayValue(widget.officeName, fallback: "");

    final buffer = StringBuffer();

    if (officeName.isNotEmpty) {
      buffer.writeln(officeName);
    }

    buffer.writeln('${languagesController.tr("DATE")}: ${_currentDate()}');

    buffer.writeln();

    buffer.writeln('${languagesController.tr("NAME")}: $name');

    buffer.writeln('${languagesController.tr("PHONE")}: $phone');

    buffer.writeln('${languagesController.tr("CATEGORY")}: $category');

    for (final item in balances) {
      final status = item.status?.toString().trim().toLowerCase() ?? "";

      final currency = _translateApiValue(item.currencyCode, fallback: "--");

      final amount = _formatAmount(item.netBalance);

      final title = _balanceTitle(status);

      buffer.writeln();

      buffer.writeln("*$title: $amount $currency*");
    }

    return buffer.toString().trim();
  }

  Future<void> shareCounterPartyToWhatsApp() async {
    final text = generateCounterPartyShareText();

    if (text.trim().isEmpty) {
      Get.snackbar(
        languagesController.tr("ERROR"),
        languagesController.tr("ACCOUNT_INFORMATION_NOT_FOUND"),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    final whatsappUrl = Uri.https("wa.me", "/", {"text": text});

    final opened = await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      Get.snackbar(
        languagesController.tr("ERROR"),
        languagesController.tr("UNABLE_TO_OPEN_WHATSAPP"),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void openShareDialog(BuildContext context) {
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
                _buildShareAction(
                  icon: Icons.copy_rounded,
                  title: languagesController.tr("COPY_AS_TEXT"),
                  iconColor: AppColors.primarycolor2,
                  iconBackground: AppColors.primarycolor2.withOpacity(0.08),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    final text = generateCounterPartyShareText();

                    await Clipboard.setData(ClipboardData(text: text));

                    Get.snackbar(
                      languagesController.tr("COPPIED"),
                      languagesController.tr(
                        "ACCOUNT_INFORMATION_COPIED_TO_CLIPBOARD",
                      ),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(12),
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildShareAction(
                  icon: Icons.chat_rounded,
                  title: languagesController.tr("SEND_TO_WHATSAPP"),
                  iconColor: const Color(0xFF25D366),
                  iconBackground: const Color(0xFFEAFBF0),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    await shareCounterPartyToWhatsApp();
                  },
                ),
                const SizedBox(height: 8),
                _buildShareAction(
                  icon: Icons.image_outlined,
                  title: languagesController.tr("GENERATE_IMAGE"),
                  iconColor: const Color(0xFF7A5AF8),
                  iconBackground: const Color(0xFFF1EEFF),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                const SizedBox(height: 8),
                _buildShareAction(
                  icon: Icons.picture_as_pdf_outlined,
                  title: languagesController.tr("GENERATE_PDF"),
                  iconColor: const Color(0xFFD92D20),
                  iconBackground: const Color(0xFFFFEDEC),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareAction({
    required IconData icon,
    required String title,
    required Color iconColor,
    required Color iconBackground,
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
            color: AppColors.afraPayBackground,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.045),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 17, color: iconColor),
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

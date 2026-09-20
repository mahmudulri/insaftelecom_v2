import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/confirm_pin_controller.dart';
import 'package:insaftelecom/controllers/drawer_controller.dart';
import 'package:insaftelecom/controllers/service_controller.dart';
import 'package:insaftelecom/global_controller/languages_controller.dart';
import 'package:insaftelecom/global_controller/page_controller.dart';
import 'package:insaftelecom/helpers/price.dart';
import 'package:insaftelecom/utils/colors.dart';
import 'package:insaftelecom/widgets/drawer.dart';
import 'package:lottie/lottie.dart';

import '../global_controller/font_controller.dart';

class SocialBundles extends StatefulWidget {
  const SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final ServiceController serviceController = Get.find<ServiceController>();
  final BundleController bundleController = Get.find<BundleController>();
  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  final ConfirmPinController confirmPinController =
      Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GetStorage box = GetStorage();

  final MyDrawerController drawerController = Get.put(MyDrawerController());

  String search = "";
  String inputNumber = "";

  int selectedIndex = -1;
  int duration_selectedIndex = -1;

  List countryCode = ["+93", "+880", "+91"];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    confirmPinController.numberController.clear();
    bundleController.finalList.clear();
    bundleController.initialpage = 1;

    scrollController.addListener(refresh);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(refresh);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    if (!scrollController.hasClients) {
      return;
    }

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 20) {
      bundleController.initialpage++;

      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage = totalPages;
        print("Already on the last page");
      }
    }
  }

  String? get _currentFont {
    if (box.read("language").toString() == "Fa") {
      return Get.find<FontController>().currentFont;
    }
    return null;
  }

  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value.toString() == 'null') return '';
    return value.toString();
  }

  void _openBundleDialog(BuildContext context, dynamic data) {
    box.write("bundleID", _safeString(data.id));

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: SocialdialogBox(
            companyname: _safeString(data.service?.company?.companyName),
            title: _safeString(data.bundleTitle),
            validity: _safeString(data.validityType),
            buyingprice: _safeString(data.buyingPrice),
            sellingprice: _safeString(data.sellingPrice),
            imagelink: _safeString(data.service?.company?.companyLogo),
            currencyCode: _safeString(data.currencyCode),
          ),
        );
      },
    );
  }

  Widget _buildBundleCard(BuildContext context, dynamic data) {
    final String bundleTitle = _safeString(data.bundleTitle);
    final String companyName = _safeString(data.service?.company?.companyName);
    final String logo = _safeString(data.service?.company?.companyLogo);
    final String sellingPrice = _safeString(data.sellingPrice);
    final String buyingPrice = _safeString(data.buyingPrice);
    final String currencyCode = _safeString(data.currencyCode);

    return GestureDetector(
      onTap: () => _openBundleDialog(context, data),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Container(
          constraints: const BoxConstraints(minHeight: 86),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56,
                width: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: logo,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.business,
                      color: Colors.grey.shade400,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [
                        bundleTitle,
                        companyName,
                      ].where((e) => e.trim().isNotEmpty).join('  '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: _currentFont,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactPrice(
                            label: languagesController.tr("SALE"),
                            price: sellingPrice,
                            currencyCode: currencyCode,
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildCompactPrice(
                            label: languagesController.tr("BUY"),
                            price: buyingPrice,
                            currencyCode: currencyCode,
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactPrice({
    required String label,
    required String price,
    required String currencyCode,
    required Color color,
    required Alignment alignment,
    required TextAlign textAlign,
  }) {
    return Align(
      alignment: alignment,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label : ',
              textAlign: textAlign,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: color,
                fontFamily: _currentFont,
              ),
            ),
            PriceTextView(
              price: price,
              textStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: _currentFont,
              ),
            ),
            if (currencyCode.isNotEmpty) ...[
              const SizedBox(width: 3),
              Text(
                currencyCode,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                  fontFamily: _currentFont,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBundleList() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 2),
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: bundleController.finalList.length,
        itemBuilder: (context, index) {
          final data = bundleController.finalList[index];
          return _buildBundleCard(context, data);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find<Mypagecontroller>();
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      drawer: DrawerWidget(),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/homeback.webp'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        mypagecontroller.handleBack();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(FontAwesomeIcons.chevronLeft),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(
                        () => Text(
                          languagesController.tr("COMMUNICATION_PACKAGES"),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth * 0.045)
                                .clamp(14.0, 18.0)
                                .toDouble(),
                            color: Colors.white,
                            fontFamily: _currentFont,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.menu, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Obx(
                              () => Text(
                                languagesController.tr("PACKAGE_SELECTION"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.045)
                                      .clamp(14.0, 18.0)
                                      .toDouble(),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff8082ED),
                                  fontFamily: _currentFont,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_sharp,
                              color: Colors.grey,
                              size: (screenHeight * 0.040)
                                  .clamp(20.0, 28.0)
                                  .toDouble(),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  onChanged: (value) {
                                    search = value;
                                  },
                                  style: TextStyle(
                                    fontFamily: _currentFont,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: languagesController.tr(
                                      "SEARCH_PACKAGE_NAME",
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: (screenWidth * 0.040)
                                          .clamp(13.0, 16.0)
                                          .toDouble(),
                                      fontFamily: _currentFont,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Obx(() {
                          final services =
                              serviceController
                                  .allserviceslist
                                  .value
                                  .data
                                  ?.services ??
                              [];

                          final filteredServices = inputNumber.isEmpty
                              ? services
                              : services.where((service) {
                                  return service.company?.companycodes?.any((
                                        code,
                                      ) {
                                        final reservedDigit =
                                            code.reservedDigit ?? '';
                                        return inputNumber.startsWith(
                                          reservedDigit,
                                        );
                                      }) ??
                                      false;
                                }).toList();

                          if (serviceController.isLoading.value) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 5),
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final data = filteredServices[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bundleController.initialpage = 1;
                                    bundleController.finalList.clear();
                                    selectedIndex = index;
                                    box.write("company_id", data.companyId);
                                    bundleController.fetchallbundles();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? const Color(0xff34495e)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        data.company?.companyLogo?.toString() ??
                                        '',
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.5,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Obx(() {
                    if (bundleController.finalList.isEmpty) {
                      return Center(
                        child: bundleController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.grey,
                              )
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [SizedBox(height: 200)],
                                ),
                              ),
                      );
                    }

                    return Stack(
                      children: [
                        Positioned.fill(child: _buildBundleList()),
                        if (bundleController.isLoading.value)
                          const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 8,
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  const SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
    this.currencyCode,
  });

  final String? companyname;
  final String? title;
  final String? validity;
  final String? buyingprice;
  final String? sellingprice;
  final String? imagelink;
  final String? currencyCode;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  final ConfirmPinController confirmPinController =
      Get.find<ConfirmPinController>();
  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  final GetStorage box = GetStorage();

  String? get _currentFont {
    if (box.read("language").toString() == "Fa") {
      return Get.find<FontController>().currentFont;
    }
    return null;
  }

  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value.toString() == 'null') return '';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    final double dialogWidth = screenWidth < 560 ? screenWidth * 0.90 : 500;
    final double dialogHeight = screenHeight < 680 ? screenHeight * 0.78 : 520;

    return SizedBox(
      height: dialogHeight,
      width: dialogWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Obx(
          () => confirmPinController.isLoading.value == false
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    children: [
                      _buildHeaderCard(),
                      const SizedBox(height: 10),
                      _buildIdInput(),
                      const SizedBox(height: 8),
                      _buildPinInput(),
                      const SizedBox(height: 12),
                      _buildActionButtons(),
                      const SizedBox(height: 4),
                    ],
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: 220,
                    width: 220,
                    child: Lottie.asset('assets/loties/recharge.json'),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final String companyName = _safeString(widget.companyname);
    final String bundleTitle = _safeString(widget.title);
    final String validity = _safeString(widget.validity);
    final String imageUrl = _safeString(widget.imagelink);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1890FF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 76,
            width: 76,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              errorWidget: (context, url, error) =>
                  Icon(Icons.business, color: Colors.grey.shade400, size: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            companyName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              fontFamily: _currentFont,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    languagesController.tr("BUNDLE_TITLE"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFamily: _currentFont,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(
                    bundleTitle,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: _currentFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (validity.isNotEmpty) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  validity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: _currentFont,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDialogPriceRow(
                  icon: Icons.shopping_bag_outlined,
                  iconColor: const Color(0xff1890FF),
                  label: languagesController.tr("BUY"),
                  price: _safeString(widget.buyingprice),
                  priceColor: Colors.black,
                ),
                Divider(height: 12, color: Colors.grey.shade200),
                _buildDialogPriceRow(
                  icon: Icons.sell_outlined,
                  iconColor: Colors.green,
                  label: languagesController.tr("SALE"),
                  price: _safeString(widget.sellingprice),
                  priceColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogPriceRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String price,
    required Color priceColor,
  }) {
    final String currency = _safeString(widget.currencyCode);

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: _currentFont,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: _currentFont,
                  ),
                ),
                if (currency.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    currency,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                      fontFamily: _currentFont,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.phone_android, color: Color(0xff1890FF), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: confirmPinController.numberController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: languagesController.tr("ENTER_ID"),
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                  fontFamily: _currentFont,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: _currentFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinInput() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.5, color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: TextField(
            maxLength: 4,
            controller: confirmPinController.pinController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            obscureText: true,
            decoration: InputDecoration(
              counterText: '',
              hintText: languagesController.tr("PIN"),
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
                fontFamily: _currentFont,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: _currentFont,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool stackButtons = constraints.maxWidth < 300;

        final Widget confirmButton = _dialogButton(
          onTap: () {
            if (confirmPinController.numberController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: languagesController.tr("ENTER_ID"),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              return;
            }

            if (confirmPinController.pinController.text.isEmpty) {
              Fluttertoast.showToast(
                msg: languagesController.tr("ENTER_YOUR_PIN"),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              return;
            }

            print("ready for recharge...");
            confirmPinController.placeOrder(context);
          },
          icon: Icons.check_circle_outline,
          text: languagesController.tr("CONFIRMATION"),
          foregroundColor: Colors.white,
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
          ),
          shadowColor: Colors.green.withOpacity(0.3),
        );

        final Widget cancelButton = _dialogButton(
          onTap: () {
            Navigator.pop(context);
          },
          icon: Icons.close,
          text: languagesController.tr("CANCEL"),
          foregroundColor: Colors.grey.shade700,
          backgroundColor: Colors.grey.shade100,
          borderColor: Colors.grey.shade300,
        );

        if (stackButtons) {
          return Column(
            children: [
              SizedBox(width: double.infinity, child: confirmButton),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: cancelButton),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: confirmButton),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: cancelButton),
          ],
        );
      },
    );
  }

  Widget _dialogButton({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
    required Color foregroundColor,
    Gradient? gradient,
    Color? backgroundColor,
    Color? borderColor,
    Color? shadowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          border: borderColor == null
              ? null
              : Border.all(width: 1.5, color: borderColor),
          boxShadow: shadowColor == null
              ? null
              : [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foregroundColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: _currentFont,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

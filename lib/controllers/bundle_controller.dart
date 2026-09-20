import 'package:get/get.dart';
import 'package:insaftelecom/services/bundle_service.dart';

import '../models/bundle_model.dart';

class BundleController extends GetxController {
  int initialpage = 1;

  final RxList<Bundle> finalList = <Bundle>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLookupLoading = false.obs;

  final Rx<BundleModel> allbundleslist = BundleModel().obs;

  /// Normal bundle API
  Future<void> fetchallbundles() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final BundleModel response = await BundlesApi().fetchBundles(initialpage);

      allbundleslist.value = response;

      final List<Bundle> bundles = response.data?.bundles ?? <Bundle>[];

      final int totalPages = response.payload?.pagination.totalPages ?? 0;

      print("✅ Bundle API Response");
      print("📄 Current Page : $initialpage");
      print("📚 Total Pages  : $totalPages");
      print("📦 Bundles received : ${bundles.length}");

      if (initialpage == 1) {
        finalList.clear();
      }

      finalList.addAll(bundles);

      print("📦 Total bundles in list : ${finalList.length}");
      print("======================================");
    } catch (e) {
      if (initialpage == 1) {
        finalList.clear();
      }

      print("❌ Normal bundle API error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Operator lookup bundle API
  Future<void> fetchlookupbundles(String phoneNumber) async {
    final String cleanPhoneNumber = phoneNumber.trim();

    if (cleanPhoneNumber.isEmpty) {
      return;
    }

    if (isLookupLoading.value) {
      return;
    }

    try {
      isLookupLoading.value = true;

      final BundleModel response = await BundlesApi().fetchlookupBundles(
        cleanPhoneNumber,
      );

      allbundleslist.value = response;

      final List<Bundle> bundles = response.data?.bundles ?? <Bundle>[];

      // Lookup result সবসময় নতুন result হিসেবে দেখাবে।
      initialpage = 1;
      finalList.clear();
      finalList.addAll(bundles);
    } catch (e) {
      finalList.clear();

      print("Lookup bundle API error: $e");
    } finally {
      isLookupLoading.value = false;
    }
  }

  void resetBundles() {
    initialpage = 1;
    finalList.clear();
    allbundleslist.value = BundleModel();

    isLoading.value = false;
    isLookupLoading.value = false;
  }
}

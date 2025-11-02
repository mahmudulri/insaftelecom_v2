import 'package:get/get.dart';
import 'package:insaftelecom/controllers/add_sub_reseller_controller.dart';
import 'package:insaftelecom/controllers/confirm_pin_controller.dart';
import 'package:insaftelecom/controllers/custom_history_controller.dart';
import 'package:insaftelecom/controllers/order_list_controller.dart';
import 'package:insaftelecom/controllers/subreseller_details_controller.dart';
import '../controllers/bundle_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/district_controller.dart';
import '../controllers/hawala_list_controller.dart';
import '../controllers/help_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/payments_controller.dart';
import '../controllers/province_controller.dart';
import '../controllers/service_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../controllers/slider_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../controllers/transaction_controller.dart';

class Basebinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TransactionController>(() => TransactionController());
    Get.lazyPut<OrderlistController>(() => OrderlistController());
    Get.lazyPut<SubresellerController>(() => SubresellerController());
    Get.lazyPut<SubresellerDetailsController>(
      () => SubresellerDetailsController(),
    );

    Get.lazyPut<AddSubResellerController>(() => AddSubResellerController());

    Get.lazyPut<CountryListController>(() => CountryListController());
    Get.lazyPut<ProvinceController>(() => ProvinceController());
    Get.lazyPut<DistrictController>(() => DistrictController());
    Get.lazyPut<ServiceController>(() => ServiceController());
    Get.lazyPut<CategorisListController>(() => CategorisListController());
    Get.lazyPut<SliderController>(() => SliderController());
    Get.lazyPut<BundleController>(() => BundleController());
    Get.lazyPut<ConfirmPinController>(() => ConfirmPinController());
    Get.lazyPut<CustomHistoryController>(() => CustomHistoryController());
    Get.lazyPut<HawalaListController>(() => HawalaListController());
    Get.lazyPut<CommissionGroupController>(() => CommissionGroupController());
    Get.lazyPut<PaymentsController>(() => PaymentsController());
    Get.lazyPut<CompanyController>(() => CompanyController());
    Get.lazyPut<HelpController>(() => HelpController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}

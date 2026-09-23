import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/history_model.dart';
import '../services/history_service.dart';

class HistoryController extends GetxController {
  final RxList<Order> finalList = <Order>[].obs;

  final RxBool isLoading = false.obs;

  final Rx<HistoryModel> allorderlist = HistoryModel().obs;

  int initialpage = 1;

  Future<void> fetchHistory({bool reset = false}) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      if (reset) {
        initialpage = 1;
        finalList.clear();
      }

      final HistoryModel value = await HistoryServiceApi().fetchorderList(
        initialpage,
      );

      allorderlist.value = value;

      final List<Order> newOrders = value.data?.orders ?? <Order>[];

      if (reset) {
        finalList.assignAll(newOrders);
      } else {
        _addOrdersWithoutDuplicate(newOrders);
      }

      debugPrint('History loaded: ${finalList.length} orders');
    } catch (error, stackTrace) {
      debugPrint('History fetch error: $error');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  void _addOrdersWithoutDuplicate(List<Order> newOrders) {
    for (final Order newOrder in newOrders) {
      final bool alreadyExists = finalList.any(
        (Order existingOrder) => existingOrder.id == newOrder.id,
      );

      if (!alreadyExists) {
        finalList.add(newOrder);
      }
    }
  }

  /// Firebase order_status notification এলে
  /// এই method call করা হবে।
  bool updateOrderStatusFromNotification({
    required String orderId,
    required String status,
    String? rejectReason,
  }) {
    final String normalizedOrderId = orderId.trim();

    final String normalizedStatus = status.trim();

    if (normalizedOrderId.isEmpty || normalizedStatus.isEmpty) {
      debugPrint(
        'Order status update failed: '
        'orderId অথবা status empty',
      );

      return false;
    }

    final int index = finalList.indexWhere(
      (Order order) => order.id?.toString() == normalizedOrderId,
    );

    if (index == -1) {
      debugPrint('Notification order current history list-এ পাওয়া যায়নি');

      debugPrint('Order ID: $normalizedOrderId');

      /*
       * Current list-এ order না থাকলে পরে চাইলে
       * fresh API call করতে পারি।
       *
       * আপাতত শুধু false return করছি।
       */
      return false;
    }

    final Order currentOrder = finalList[index];

    final Order updatedOrder = currentOrder.copyWith(
      status: normalizedStatus,

      /*
       * Backend আলাদা reject_reason পাঠালে update হবে।
       * না পাঠালে আগের rejectReason থাকবে।
       */
      rejectReason: rejectReason != null && rejectReason.trim().isNotEmpty
          ? rejectReason.trim()
          : currentOrder.rejectReason,
    );

    finalList[index] = updatedOrder;

    /*
     * RxList listener-কে নিশ্চিতভাবে notify করবে।
     */
    finalList.refresh();

    debugPrint('========== ORDER STATUS UPDATED ==========');

    debugPrint('Order ID: $normalizedOrderId');

    debugPrint('Old status: ${currentOrder.status}');

    debugPrint('New status: $normalizedStatus');

    debugPrint('List index: $index');

    debugPrint('==========================================');

    return true;
  }

  /// প্রয়োজন হলে notification data সরাসরি pass করা যাবে।
  bool updateOrderFromNotificationData(Map<String, dynamic> data) {
    final String type = data['type']?.toString() ?? '';

    if (type != 'order_status') {
      debugPrint('Ignored notification type: $type');

      return false;
    }

    final String orderId = data['order_id']?.toString() ?? '';

    final String status = data['status']?.toString() ?? '';

    final String? rejectReason = data['reject_reason']?.toString();

    return updateOrderStatusFromNotification(
      orderId: orderId,
      status: status,
      rejectReason: rejectReason,
    );
  }

  Future<void> refreshHistory() async {
    await fetchHistory(reset: true);
  }
}

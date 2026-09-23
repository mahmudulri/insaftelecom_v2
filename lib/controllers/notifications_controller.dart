import 'package:get/get.dart';

import '../models/notifications_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationApi notificationApi = NotificationApi();

  final RxBool isLoading = false.obs;
  final RxBool isMarkingAsRead = false.obs;

  final RxInt unreadlength = 0.obs;

  final Rx<NotificationModel> allnotificationlist = NotificationModel().obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final value = await notificationApi.fetchnotificationData();

      allnotificationlist.value = value;

      _calculateUnreadCount();
    } catch (e) {
      print("Notification fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateUnreadCount() {
    final notifications = allnotificationlist.value.data?.notifications ?? [];

    unreadlength.value = notifications
        .where((notification) => notification.isRead == false)
        .length;
  }

  Future<bool> markAsRead(int? notificationId) async {
    if (notificationId == null) {
      print("Notification ID is null");
      return false;
    }

    if (isMarkingAsRead.value) {
      return false;
    }

    try {
      isMarkingAsRead.value = true;

      final success = await notificationApi.markNotificationAsRead(
        notificationId,
      );

      if (success) {
        await fetchData();
        return true;
      }

      return false;
    } catch (e) {
      print("Mark notification as read error: $e");
      return false;
    } finally {
      isMarkingAsRead.value = false;
    }
  }

  bool isNotificationUnread(int? notificationId) {
    if (notificationId == null) return false;

    final notifications = allnotificationlist.value.data?.notifications ?? [];

    for (final notification in notifications) {
      if (notification.id == notificationId) {
        return notification.isRead == false;
      }
    }

    return false;
  }

  Future<void> refreshNotifications() async {
    await fetchData();
  }
}

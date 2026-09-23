import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/notifications_controller.dart';
import '../global_controller/languages_controller.dart';
import '../models/notifications_model.dart';
import '../utils/colors.dart';
import 'notification_details_page.dart';

class AllNotificationsPage extends StatefulWidget {
  const AllNotificationsPage({super.key});

  @override
  State<AllNotificationsPage> createState() => _AllNotificationsPageState();
}

class _AllNotificationsPageState extends State<AllNotificationsPage> {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.fetchData();
    });
  }

  Future<void> _openNotificationDetails(Notification notification) async {
    await Get.to(() => NotificationDetailsPage(notification: notification));

    await notificationController.fetchData();
  }

  Future<void> _refreshNotifications() async {
    await notificationController.fetchData();
  }

  String _formatNotificationDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }

    return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            ),
          ),
          title: Text(
            languagesController.tr("NOTIFICATIONS"),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Obx(() {
              return IconButton(
                onPressed: notificationController.isLoading.value
                    ? null
                    : () {
                        notificationController.fetchData();
                      },
                icon: const Icon(Icons.refresh_rounded, color: Colors.black),
              );
            }),
          ],
        ),
        body: Obx(() {
          final isLoading = notificationController.isLoading.value;

          final notifications =
              notificationController
                  .allnotificationlist
                  .value
                  .data
                  ?.notifications ??
              [];

          if (isLoading && notifications.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: AppColors.primaryColor,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 75,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          languagesController.tr("NO_NOTIFICATIONS"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshNotifications,
            color: AppColors.primaryColor,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              itemCount: notifications.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final notification = notifications[index];

                final isUnread = notification.isRead == false;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      _openNotificationDetails(notification);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUnread
                            ? AppColors.primaryColor.withOpacity(0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isUnread
                              ? AppColors.primaryColor.withOpacity(0.20)
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.035),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: isUnread
                                      ? AppColors.primaryColor.withOpacity(0.14)
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_rounded,
                                  size: 23,
                                  color: isUnread
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade500,
                                ),
                              ),
                              if (isUnread)
                                Positioned(
                                  right: 1,
                                  top: 1,
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.35,
                                          fontWeight: isUnread
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification.message ?? "",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.45,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        _formatNotificationDate(
                                          notification.createdAt,
                                        ),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    if (isUnread)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          languagesController.tr("NEW"),
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
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
              },
            ),
          );
        }),
      ),
    );
  }
}

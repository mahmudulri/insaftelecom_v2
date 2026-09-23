import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/notifications_controller.dart';
import '../global_controller/languages_controller.dart';
import '../models/notifications_model.dart';
import '../utils/colors.dart';

class NotificationDetailsPage extends StatefulWidget {
  final Notification notification;

  const NotificationDetailsPage({super.key, required this.notification});

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  bool _isClosing = false;

  Future<bool> _handleBack() async {
    if (_isClosing) {
      return true;
    }

    _isClosing = true;

    final notificationId = widget.notification.id;
    final wasUnread = widget.notification.isRead == false;

    if (wasUnread && notificationId != null) {
      await notificationController.markAsRead(notificationId);
    }

    return true;
  }

  Future<void> _onBackPressed() async {
    final canPop = await _handleBack();

    if (canPop && mounted) {
      Get.back(result: true);
    }
  }

  final LanguagesController languagesController =
      Get.find<LanguagesController>();
  @override
  Widget build(BuildContext context) {
    final notification = widget.notification;

    final formattedDate = notification.createdAt == null
        ? ""
        : DateFormat(
            "dd MMM yyyy, hh:mm a",
          ).format(notification.createdAt!.toLocal());

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: _onBackPressed,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            ),
          ),
          title: Text(
            languagesController.tr("NOTIFICATIONS_DETAILS"),
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() {
          final isMarkingAsRead = notificationController.isMarkingAsRead.value;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: AppColors.primaryColor,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title ?? "",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    height: 1.4,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (formattedDate.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 18),

                      Text(
                        notification.message ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.7,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      if (notification.media != null &&
                          notification.media.toString().isNotEmpty &&
                          notification.media.toString() != "null") ...[
                        const SizedBox(height: 20),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            notification.media.toString(),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return Container(
                                height: 180,
                                alignment: Alignment.center,
                                color: Colors.grey.shade100,
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox();
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (isMarkingAsRead)
                Container(
                  color: Colors.black.withOpacity(0.08),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

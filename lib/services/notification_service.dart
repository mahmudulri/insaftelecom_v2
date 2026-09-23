import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/notifications_model.dart';
import '../utils/api_endpoints.dart';

class NotificationApi {
  final GetStorage box = GetStorage();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${box.read("userToken")}',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<NotificationModel> fetchnotificationData() async {
    final url = Uri.parse("${ApiEndPoints.baseUrl}notifications");

    print("Notifications API: $url");

    final response = await http.get(url, headers: _headers);

    print("Notifications status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final decodedBody = json.decode(response.body);

      return NotificationModel.fromJson(decodedBody);
    }

    throw Exception(
      'Failed to fetch notifications. Status: ${response.statusCode}',
    );
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    final url = Uri.parse(
      "${ApiEndPoints.baseUrl}notifications/$notificationId/read",
    );

    // print("Mark notification read API: $url");

    final response = await http.post(url, headers: _headers);

    // print("Mark notification read status: ${response.statusCode}");
    // print("Mark notification read response: ${response.body}");

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    }

    throw Exception(
      'Failed to mark notification as read. '
      'Status: ${response.statusCode}',
    );
  }
}

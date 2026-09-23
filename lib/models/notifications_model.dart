import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  NotificationModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: List<dynamic>.from(json["payload"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
    "payload": List<dynamic>.from(payload!.map((x) => x)),
  };
}

class Data {
  final List<Notification>? notifications;

  Data({this.notifications});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: List<Notification>.from(
      json["notifications"].map((x) => Notification.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "notifications": List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class Notification {
  final int? id;
  final String? title;
  final String? message;
  final dynamic media;
  final DateTime? createdAt;
  final bool? isRead;

  Notification({
    this.id,
    this.title,
    this.message,
    this.media,
    this.createdAt,
    this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
    id: json["id"],
    title: json["title"],
    message: json["message"],
    media: json["media"],
    createdAt: DateTime.parse(json["created_at"]),
    isRead: json["is_read"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "message": message,
    "media": media,
    "created_at": createdAt!.toIso8601String(),
    "is_read": isRead,
  };
}

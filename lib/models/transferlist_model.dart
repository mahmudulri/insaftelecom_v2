import 'dart:convert';

TransferListModel transferListModelFromJson(String str) =>
    TransferListModel.fromJson(json.decode(str));

String transferListModelToJson(TransferListModel data) =>
    json.encode(data.toJson());

class TransferListModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  TransferListModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory TransferListModel.fromJson(Map<String, dynamic> json) =>
      TransferListModel(
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
  final List<Request>? requests;

  Data({
    this.requests,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        requests: List<Request>.from(
            json["requests"].map((x) => Request.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "requests": List<dynamic>.from(requests!.map((x) => x.toJson())),
      };
}

class Request {
  final int? id;
  final String? amount;
  final String? status;
  final dynamic? adminNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Request({
    this.id,
    this.amount,
    this.status,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"] == null ? null : json["id"],
        amount: json["amount"] == null ? null : json["amount"],
        status: json["status"] == null ? null : json["status"],
        adminNotes: json["admin_notes"] == null ? null : json["admin_notes"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "admin_notes": adminNotes,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

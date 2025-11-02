// To parse this JSON data, do
//
//     final comissionGroupModel = comissionGroupModelFromJson(jsonString);

import 'dart:convert';

ComissionGroupModel comissionGroupModelFromJson(String str) =>
    ComissionGroupModel.fromJson(json.decode(str));

String comissionGroupModelToJson(ComissionGroupModel data) =>
    json.encode(data.toJson());

class ComissionGroupModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  ComissionGroupModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory ComissionGroupModel.fromJson(Map<String, dynamic> json) =>
      ComissionGroupModel(
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
  final List<Group>? groups;

  Data({
    this.groups,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groups": List<dynamic>.from(groups!.map((x) => x.toJson())),
      };
}

class Group {
  final int? id;
  final String? resellerId;
  final String? groupName;
  final String? commissionType;
  final String? amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Group({
    this.id,
    this.resellerId,
    this.groupName,
    this.commissionType,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        groupName: json["group_name"] == null ? null : json["group_name"],
        commissionType:
            json["commission_type"] == null ? null : json["commission_type"],
        amount: json["amount"] == null ? null : json["amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "group_name": groupName,
        "commission_type": commissionType,
        "amount": amount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

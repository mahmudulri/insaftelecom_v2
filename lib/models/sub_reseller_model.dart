// To parse this JSON data, do
//
//     final subResellerModel = subResellerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubResellerModel subResellerModelFromJson(String str) =>
    SubResellerModel.fromJson(json.decode(str));

String subResellerModelToJson(SubResellerModel data) =>
    json.encode(data.toJson());

class SubResellerModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  SubResellerModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory SubResellerModel.fromJson(Map<String, dynamic> json) =>
      SubResellerModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  final List<Reseller> resellers;

  Data({
    required this.resellers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        resellers: List<Reseller>.from(
            json["resellers"].map((x) => Reseller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resellers": List<dynamic>.from(resellers.map((x) => x.toJson())),
      };
}

class Reseller {
  final int? id;
  final String? userId;

  final String? resellerName;
  final String? contactName;
  final String? resellerType;

  final String? profileImageUrl;

  final String? phone;
  final String? countryId;
  final String? provinceId;
  final String? districtsId;
  final dynamic? isResellerVerified;
  final dynamic? status;
  final String? balance;
  final String? loanBalance;
  final String? subResellerCommissionGroupId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final String? code;
  final dynamic? country;
  final dynamic? province;
  final String? districts;

  Reseller({
    this.id,
    this.userId,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.profileImageUrl,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.balance,
    this.loanBalance,
    this.subResellerCommissionGroupId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.code,
    this.country,
    this.province,
    this.districts,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resellerName:
            json["reseller_name"] == null ? null : json["reseller_name"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        resellerType:
            json["reseller_type"] == null ? null : json["reseller_type"],
        profileImageUrl: json["profile_image_url"],
        phone: json["phone"] == null ? null : json["phone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtsId: json["districts_id"] == null ? null : json["districts_id"],
        isResellerVerified: json["is_reseller_verified"] == null
            ? null
            : json["is_reseller_verified"],
        status: json["status"] == null ? null : json["status"],
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        subResellerCommissionGroupId:
            json["sub_reseller_commission_group_id"] == null
                ? null
                : json["sub_reseller_commission_group_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        code: json["code"] == null ? null : json["code"],
        country: json["country"] == null ? null : json["country"],
        province: json["province"] == null ? null : json["province"],
        districts: json["districts"] == null ? null : json["districts"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "reseller_name": resellerName,
        "contact_name": contactName,
        "reseller_type": resellerType,
        "profile_image_url": profileImageUrl,
        "phone": phone,
        "country_id": countryId,
        "province_id": provinceId,
        "districts_id": districtsId,
        "is_reseller_verified": isResellerVerified,
        "status": status,
        "balance": balance,
        "loan_balance": loanBalance,
        "sub_reseller_commission_group_id": subResellerCommissionGroupId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "code": code,
        "country": country,
        "province": province,
        "districts": districts,
      };
}

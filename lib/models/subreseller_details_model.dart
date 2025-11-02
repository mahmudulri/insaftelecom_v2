// To parse this JSON data, do
//
//     final subresellerDetailsModel = subresellerDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubresellerDetailsModel subresellerDetailsModelFromJson(String str) =>
    SubresellerDetailsModel.fromJson(json.decode(str));

String subresellerDetailsModelToJson(SubresellerDetailsModel data) =>
    json.encode(data.toJson());

class SubresellerDetailsModel {
  final bool? success;

  final String? message;
  final Data? data;

  SubresellerDetailsModel({
    this.success,
    this.message,
    this.data,
  });

  factory SubresellerDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubresellerDetailsModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  final Reseller? reseller;

  Data({
    this.reseller,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        reseller: Reseller.fromJson(json["reseller"]),
      );

  Map<String, dynamic> toJson() => {
        "reseller": reseller!.toJson(),
      };
}

class Reseller {
  final dynamic todayOrders;
  final dynamic totalOrders;
  final dynamic totalSale;
  final dynamic totalProfit;
  final dynamic todaySale;
  final dynamic todayProfit;
  final String? resellerName;
  final String? contactName;
  final String? balance;
  final String? email;
  final String? phone;
  final String? countryId;
  final String? provinceId;
  final String? districtsId;
  final String? profileImageUrl;

  Reseller({
    this.todayOrders,
    this.totalOrders,
    this.totalSale,
    this.totalProfit,
    this.todaySale,
    this.todayProfit,
    this.resellerName,
    this.contactName,
    this.balance,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.profileImageUrl,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        todayOrders: json["today_orders"],
        totalOrders: json["total_orders"],
        totalSale: json["total_sale"],
        totalProfit: json["total_profit"],
        todaySale: json["today_sale"],
        todayProfit: json["today_profit"],
        resellerName:
            json["reseller_name"] == null ? null : json["reseller_name"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        balance: json["balance"] == null ? null : json["balance"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        districtsId: json["districts_id"] == null ? null : json["districts_id"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "today_orders": todayOrders,
        "total_orders": totalOrders,
        "total_sale": totalSale,
        "total_profit": totalProfit,
        "today_sale": todaySale,
        "today_profit": todayProfit,
        "reseller_name": resellerName,
        "contact_name": contactName,
        "balance": balance,
        "email": email,
        "phone": phone,
        "country_id": countryId,
        "province_id": provinceId,
        "districts_id": districtsId,
        "profile_image_url": profileImageUrl,
      };
}

// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) =>
    DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) =>
    json.encode(data.toJson());

class DashboardDataModel {
  final bool? success;

  final String? message;
  final Data? data;

  DashboardDataModel({
    this.success,
    this.message,
    this.data,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
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
  final UserInfo? userInfo;
  final List<AdvertisementSlider>? advertisementSliders;
  final dynamic? balance;
  final dynamic? loanBalance;
  final dynamic? totalSoldAmount;
  final dynamic? totalRevenue;
  final dynamic? todaySale;
  final dynamic? todayProfit;
  final String? resellerGroup;

  Data({
    this.userInfo,
    this.advertisementSliders,
    this.balance,
    this.loanBalance,
    this.totalSoldAmount,
    this.totalRevenue,
    this.todaySale,
    this.todayProfit,
    this.resellerGroup,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userInfo: UserInfo.fromJson(json["user_info"]),
        advertisementSliders: List<AdvertisementSlider>.from(
            json["advertisement_sliders"]
                .map((x) => AdvertisementSlider.fromJson(x))),
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        totalSoldAmount: json["total_sold_amount"] == null
            ? null
            : json["total_sold_amount"],
        totalRevenue:
            json["total_revenue"] == null ? null : json["total_revenue"],
        todaySale: json["today_sale"] == null ? null : json["today_sale"],
        todayProfit: json["today_profit"] == null ? null : json["today_profit"],
        resellerGroup:
            json["reseller_group"] == null ? null : json["reseller_group"],
      );

  Map<String, dynamic> toJson() => {
        "user_info": userInfo!.toJson(),
        "advertisement_sliders":
            List<dynamic>.from(advertisementSliders!.map((x) => x.toJson())),
        "balance": balance,
        "loan_balance": loanBalance,
        "total_sold_amount": totalSoldAmount,
        "total_revenue": totalRevenue,
        "today_sale": todaySale,
        "today_profit": todayProfit,
        "reseller_group": resellerGroup,
      };
}

class AdvertisementSlider {
  final dynamic? id;
  final String? advertisementTitle;
  final String? adSliderImageUrl;

  AdvertisementSlider({
    this.id,
    this.advertisementTitle,
    this.adSliderImageUrl,
  });

  factory AdvertisementSlider.fromJson(Map<String, dynamic> json) =>
      AdvertisementSlider(
        id: json["id"],
        advertisementTitle: json["advertisement_title"] == null
            ? null
            : json["advertisement_title"],
        adSliderImageUrl: json["ad_slider_image_url"] == null
            ? null
            : json["ad_slider_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "advertisement_title": advertisementTitle,
        "ad_slider_image_url": adSliderImageUrl,
      };
}

class UserInfo {
  final dynamic? id;
  final dynamic? userId;

  final String? resellerName;
  final String? contactName;
  final String? resellerType;

  final String? profileImageUrl;
  final String? email;
  final String? phone;
  final dynamic? countryId;
  final dynamic? provinceId;
  final dynamic? districtsId;
  final dynamic? isResellerVerified;
  final dynamic? status;
  final dynamic? balance;
  final dynamic? loanBalance;
  final String? totalearning;

  UserInfo({
    this.id,
    this.userId,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.profileImageUrl,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.balance,
    this.loanBalance,
    this.totalearning,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        resellerName:
            json["reseller_name"] == null ? null : json["reseller_name"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        resellerType:
            json["reseller_type"] == null ? null : json["reseller_type"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        email: json["email"] == null ? null : json["email"],
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
        totalearning: json["total_earning_balance"] == null
            ? null
            : json["total_earning_balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "reseller_name": resellerName,
        "contact_name": contactName,
        "reseller_type": resellerType,
        "profile_image_url": profileImageUrl,
        "email": email,
        "phone": phone,
        "country_id": countryId,
        "province_id": provinceId,
        "districts_id": districtsId,
        "is_reseller_verified": isResellerVerified,
        "status": status,
        "balance": balance,
        "loan_balance": loanBalance,
        "total_earning_balance": totalearning,
      };
}

// To parse this JSON data, do
//
//     final sellingpriceModel = sellingpriceModelFromJson(jsonString);

import 'dart:convert';

SellingpriceModel sellingpriceModelFromJson(String str) =>
    SellingpriceModel.fromJson(json.decode(str));

String sellingpriceModelToJson(SellingpriceModel data) =>
    json.encode(data.toJson());

class SellingpriceModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  SellingpriceModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory SellingpriceModel.fromJson(Map<String, dynamic> json) =>
      SellingpriceModel(
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
  final List<Pricing>? pricings;

  Data({
    this.pricings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pricings: List<Pricing>.from(
            json["pricings"].map((x) => Pricing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pricings": List<dynamic>.from(pricings!.map((x) => x.toJson())),
      };
}

class Pricing {
  final int? id;
  final String? resellerId;
  final String? serviceId;
  final String? commissionType;
  final String? amount;

  final Service? service;

  Pricing({
    this.id,
    this.resellerId,
    this.serviceId,
    this.commissionType,
    this.amount,
    this.service,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        serviceId: json["service_id"] == null ? null : json["service_id"],
        commissionType:
            json["commission_type"] == null ? null : json["commission_type"],
        amount: json["amount"] == null ? null : json["amount"],
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "service_id": serviceId,
        "commission_type": commissionType,
        "amount": amount,
        "service": service!.toJson(),
      };
}

class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;

  final dynamic performedBy;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.performedBy,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        companyId: json["company_id"] == null ? null : json["company_id"],
        performedBy: json["performed_by"] == null ? null : json["performed_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "company_id": companyId,
        "performed_by": performedBy,
      };
}

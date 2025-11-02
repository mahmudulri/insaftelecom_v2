// To parse this JSON data, do
//
//     final customHistoryModel = customHistoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomHistoryModel customHistoryModelFromJson(String str) =>
    CustomHistoryModel.fromJson(json.decode(str));

String customHistoryModelToJson(CustomHistoryModel data) =>
    json.encode(data.toJson());

class CustomHistoryModel {
  final bool? success;

  final Data? data;
  final Payload? payload;

  CustomHistoryModel({
    this.success,
    this.data,
    this.payload,
  });

  factory CustomHistoryModel.fromJson(Map<String, dynamic> json) =>
      CustomHistoryModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "payload": payload!.toJson(),
      };
}

class Data {
  final List<Order> orders;

  Data({
    required this.orders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  final int? id;

  final String? rechargebleAccount;
  final Bundle? bundle;

  final String? orderType;
  final String? transactionId;
  final String? status;
  final dynamic rejectReason;

  final DateTime? createdAt;

  Order({
    this.id,
    this.rechargebleAccount,
    this.bundle,
    this.orderType,
    this.transactionId,
    this.status,
    this.rejectReason,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        rechargebleAccount: json["rechargeble_account"] == null
            ? null
            : json["rechargeble_account"],
        bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
        orderType: json["order_type"] == null ? null : json["order_type"],
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        status: json["status"] == null ? null : json["status"],
        rejectReason:
            json["reject_reason"] == null ? null : json["reject_reason"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rechargeble_account": rechargebleAccount,
        "bundle": bundle!.toJson(),
        "order_type": orderType,
        "transaction_id": transactionId,
        "status": status,
        "reject_reason": rejectReason,
        "created_at": createdAt!.toIso8601String(),
      };
}

class Bundle {
  final String? bundleTitle;

  final String? bundleType;

  final String? amount;
  final String? buyingPrice;

  // final double? adminBuyingPrice;
  final String? sellingPrice;
  final int? currencyId;
  final Currency? preferedCurrency;
  final Currency? currency;
  final Service? service;

  Bundle({
    this.bundleTitle,
    this.bundleType,
    this.amount,
    this.buyingPrice,
    // this.adminBuyingPrice,
    this.sellingPrice,
    this.currencyId,
    this.preferedCurrency,
    this.currency,
    this.service,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        bundleTitle: json["bundle_title"] == null ? null : json["bundle_title"],
        bundleType: json["bundle_type"] == null ? null : json["bundle_type"],
        amount: json["amount"] == null ? null : json["amount"],
        buyingPrice: json["buying_price"] == null ? null : json["buying_price"],
        // adminBuyingPrice: json["admin_buying_price"] == null
        //     ? null
        //     : json["admin_buying_price"]?.toDouble(),
        sellingPrice:
            json["selling_price"] == null ? null : json["selling_price"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        preferedCurrency: json["prefered_currency"] == null
            ? null
            : Currency.fromJson(json["prefered_currency"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "bundle_title": bundleTitle,
        "bundle_type": bundleType,
        "amount": amount,
        "buying_price": buyingPrice,
        // "admin_buying_price": adminBuyingPrice,
        "selling_price": sellingPrice,
        "currency_id": currencyId,
        "prefered_currency": preferedCurrency!.toJson(),
        "currency": currency!.toJson(),
        "service": service!.toJson(),
      };
}

class Currency {
  final String? code;

  Currency({
    this.code,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
      };
}

class Service {
  final int? id;
  final dynamic? serviceCategoryId;
  final dynamic? companyId;

  final Company? company;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        companyId: json["company_id"] == null ? null : json["company_id"],
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "company_id": companyId,
        "company": company!.toJson(),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
      };
}

class Payload {
  final Pagination? pagination;

  Payload({
    this.pagination,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  final int? currentPage;
  final int? totalItems;
  final int? totalPages;

  Pagination({
    this.currentPage,
    this.totalItems,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        totalItems: json["total_items"] == null ? null : json["total_items"],
        totalPages: json["total_pages"] == null ? null : json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}

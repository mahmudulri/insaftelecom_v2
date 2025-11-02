// To parse this JSON data, do
//
//     final OrderListModel = OrderListModelFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'package:meta/meta.dart';
import 'dart:convert';

OrderListModel OrderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String OrderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  final bool? success;

  final String? message;
  final Data? data;
  final Payload? payload;

  OrderListModel({
    this.success,
    this.message,
    this.data,
    this.payload,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
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
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  final int? id;
  final dynamic? resellerId;
  final String? rechargebleAccount;
  final Bundle? bundle;
  final dynamic? transactionId;
  final dynamic? isPaid;
  final dynamic? status;
  final dynamic? rejectReason;
  final DateTime? createdAt;

  Order({
    this.id,
    this.resellerId,
    this.rechargebleAccount,
    this.bundle,
    this.transactionId,
    this.isPaid,
    this.status,
    this.rejectReason,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        rechargebleAccount: json["rechargeble_account"] == null
            ? null
            : json["rechargeble_account"],
        bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        isPaid: json["is_paid"] == null ? null : json["is_paid"],
        status: json["status"] == null ? null : json["status"],
        rejectReason:
            json["reject_reason"] == null ? null : json["reject_reason"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "rechargeble_account": rechargebleAccount,
        "bundle": bundle!.toJson(),
        "transaction_id": transactionId,
        "is_paid": isPaid,
        "status": status,
        "reject_reason": rejectReason,
        "created_at": createdAt!.toIso8601String(),
      };
}

class Bundle {
  final int? id;
  final String? bundleCode;
  final dynamic? serviceId;
  final String? bundleTitle;
  final String? bundleDescription;
  final String? validityType;

  final String? buyingPrice;
  final String? sellingPrice;

  final dynamic? currencyId;

  final DateTime? createdAt;

  final Currency? preferedCurrency;
  final Service? service;
  final Currency? currency;

  Bundle({
    this.id,
    this.bundleCode,
    this.serviceId,
    this.bundleTitle,
    this.bundleDescription,
    this.validityType,
    this.buyingPrice,
    this.sellingPrice,
    this.currencyId,
    this.createdAt,
    this.preferedCurrency,
    this.service,
    this.currency,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        id: json["id"] == null ? null : json["id"],
        bundleCode: json["bundle_code"] == null ? null : json["bundle_code"],
        serviceId: json["service_id"] == null ? null : json["service_id"],
        bundleTitle: json["bundle_title"] == null ? null : json["bundle_title"],
        bundleDescription: json["bundle_description"] == null
            ? null
            : json["bundle_description"],
        validityType:
            json["validity_type"] == null ? null : json["validity_type"],
        buyingPrice: json["buying_price"] == null ? null : json["buying_price"],
        sellingPrice:
            json["selling_price"] == null ? null : json["selling_price"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        preferedCurrency: json["prefered_currency"] == null
            ? null
            : Currency.fromJson(json["prefered_currency"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bundle_code": bundleCode,
        "service_id": serviceId,
        "bundle_title": bundleTitle,
        "bundle_description": bundleDescription,
        "validity_type": validityType,
        "buying_price": buyingPrice,
        "selling_price": sellingPrice,
        "currency_id": currencyId,
        "created_at": createdAt!.toIso8601String(),
        "prefered_currency": preferedCurrency!.toJson(),
        "service": service!.toJson(),
        "currency": currency!.toJson(),
      };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;
  final String? exchangeRatePerUsd;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
            ? null
            : json["exchange_rate_per_usd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
        "exchange_rate_per_usd": exchangeRatePerUsd,
      };
}

class Service {
  final int? id;
  final dynamic? serviceCategoryId;
  final dynamic? companyId;

  final ServiceCategory? serviceCategory;
  final Company? company;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.serviceCategory,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"] == null ? null : json["id"],
        serviceCategoryId: json["service_category_id"] == null
            ? null
            : json["service_category_id"],
        companyId: json["company_id"] == null ? null : json["company_id"],
        serviceCategory: json["service_category"] == null
            ? null
            : ServiceCategory.fromJson(json["service_category"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "company_id": companyId,
        "service_category": serviceCategory!.toJson(),
        "company": company!.toJson(),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final dynamic? countryId;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.countryId,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
        countryId: json["country_id"] == null ? null : json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
        "country_id": countryId,
      };
}

class ServiceCategory {
  final int? id;
  final String? categoryName;
  final String? type;

  ServiceCategory({
    this.id,
    this.categoryName,
    this.type,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"] == null ? null : json["id"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "type": type,
      };
}

class Payload {
  final Pagination pagination;

  Payload({
    required this.pagination,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
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
        currentPage: json["current_page"],
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}

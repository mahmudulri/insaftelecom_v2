import 'dart:convert';

ResultModel resultModelFromJson(String str) =>
    ResultModel.fromJson(json.decode(str));

String resultModelToJson(ResultModel data) => json.encode(data.toJson());

class ResultModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  ResultModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final Order? order;
  final String? statusMessage;

  Data({
    this.order,
    this.statusMessage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
        statusMessage: json["statusMessage"],
      );

  Map<String, dynamic> toJson() => {
        "order": order?.toJson(),
        "statusMessage": statusMessage,
      };
}

class Order {
  final String? rechargebleAccount;
  final Bundle? bundle;
  final String? orderType;

  final int? status;

  final DateTime? createdAt;
  final int? id;

  final Reseller? reseller;

  Order({
    this.rechargebleAccount,
    this.bundle,
    this.orderType,
    this.status,
    this.createdAt,
    this.id,
    this.reseller,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        rechargebleAccount: json["rechargeble_account"],
        bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
        orderType: json["order_type"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        reseller: json["reseller"] == null
            ? null
            : Reseller.fromJson(json["reseller"]),
      );

  Map<String, dynamic> toJson() => {
        "rechargeble_account": rechargebleAccount,
        "bundle": bundle?.toJson(),
        "order_type": orderType,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "reseller": reseller?.toJson(),
      };
}

class Bundle {
  final String? bundleTitle;
  final String? bundleDescription;
  final dynamic bundleType;
  final String? validityType;

  final double? buyingPrice;
  final double? sellingPrice;
  final dynamic amount;

  final Service? service;

  Bundle({
    this.bundleTitle,
    this.bundleDescription,
    this.bundleType,
    this.validityType,
    this.buyingPrice,
    this.sellingPrice,
    this.amount,
    this.service,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        bundleTitle: json["bundle_title"],
        bundleDescription: json["bundle_description"],
        bundleType: json["bundle_type"],
        validityType: json["validity_type"],
        buyingPrice: json["buying_price"] != null
            ? double.tryParse(json["buying_price"].toString())
            : null,
        sellingPrice: json["selling_price"] != null
            ? double.tryParse(json["selling_price"].toString())
            : null,
        amount: json["amount"],
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "bundle_title": bundleTitle,
        "bundle_description": bundleDescription,
        "bundle_type": bundleType,
        "validity_type": validityType,
        "buying_price": buyingPrice,
        "selling_price": sellingPrice,
        "amount": amount,
        "service": service?.toJson(),
      };
}

class Service {
  final Company? company;

  Service({
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "company": company?.toJson(),
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
        id: json["id"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
      };
}

class Reseller {
  final String? resellerName;
  final String? contactName;

  final String? phone;

  Reseller({
    this.resellerName,
    this.contactName,
    this.phone,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        resellerName: json["reseller_name"],
        contactName: json["contact_name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "reseller_name": resellerName,
        "contact_name": contactName,
        "phone": phone,
      };
}

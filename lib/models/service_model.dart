// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  final bool? success;

  final Data? data;

  ServiceModel({
    this.success,
    this.data,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
      };
}

class Data {
  final List<Service> services;

  Data({
    required this.services,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;

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
        company: Company.fromJson(json["company"]),
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
  final List<Companycode>? companycodes;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.companycodes,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        companyName: json["company_name"] == null ? null : json["company_name"],
        companyLogo: json["company_logo"] == null ? null : json["company_logo"],
        companycodes: json["companycodes"] == null
            ? null
            : List<Companycode>.from(
                json["companycodes"].map((x) => Companycode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
        "companycodes":
            List<dynamic>.from(companycodes!.map((x) => x.toJson())),
      };
}

class Companycode {
  final String? reservedDigit;

  Companycode({
    this.reservedDigit,
  });

  factory Companycode.fromJson(Map<String, dynamic> json) => Companycode(
        reservedDigit:
            json["reserved_digit"] == null ? null : json["reserved_digit"],
      );

  Map<String, dynamic> toJson() => {
        "reserved_digit": reservedDigit,
      };
}

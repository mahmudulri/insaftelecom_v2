import 'package:meta/meta.dart';
import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  CategoriesModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
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
  final List<Servicecategory>? servicecategories;

  Data({
    this.servicecategories,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        servicecategories: List<Servicecategory>.from(
            json["servicecategories"].map((x) => Servicecategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "servicecategories":
            List<dynamic>.from(servicecategories!.map((x) => x.toJson())),
      };
}

class Servicecategory {
  final int? id;
  final String? categoryName;
  final String? type;
  final dynamic categoryImageUrl;
  final List<Service>? services; // Ensure this field exists

  Servicecategory({
    this.id,
    this.categoryName,
    this.type,
    this.categoryImageUrl,
    this.services,
  });

  factory Servicecategory.fromJson(Map<String, dynamic> json) =>
      Servicecategory(
        id: json["id"],
        categoryName: json["category_name"],
        type: json["type"],
        categoryImageUrl: json["category_image_url"],
        services: json["services"] != null
            ? List<Service>.from(
                json["services"].map((x) => Service.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "type": type,
        "category_image_url": categoryImageUrl,
        "services": List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

// Define the Service model
class Service {
  final int? id;
  final String? serviceCategoryId;
  final String? companyId;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        serviceCategoryId: json["service_category_id"],
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_category_id": serviceCategoryId,
        "company_id": companyId,
      };
}

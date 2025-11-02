// To parse this JSON data, do
//
//     final provincesModel = provincesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProvincesModel provincesModelFromJson(String str) =>
    ProvincesModel.fromJson(json.decode(str));

String provincesModelToJson(ProvincesModel data) => json.encode(data.toJson());

class ProvincesModel {
  final bool? success;

  final String? message;
  final Data? data;

  ProvincesModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProvincesModel.fromJson(Map<String, dynamic> json) => ProvincesModel(
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
  final List<Province> provinces;

  Data({
    required this.provinces,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        provinces: List<Province>.from(
            json["provinces"].map((x) => Province.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
      };
}

class Province {
  final int? id;
  final String? provinceName;

  Province({
    this.id,
    this.provinceName,
  });

  factory Province.fromJson(Map<String, dynamic> json) => Province(
        id: json["id"] == null ? null : json["id"],
        provinceName:
            json["province_name"] == null ? null : json["province_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_name": provinceName,
      };
}

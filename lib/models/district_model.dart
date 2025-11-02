// To parse this JSON data, do
//
//     final districtModel = districtModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DistrictModel districtModelFromJson(String str) =>
    DistrictModel.fromJson(json.decode(str));

String districtModelToJson(DistrictModel data) => json.encode(data.toJson());

class DistrictModel {
  final bool? success;

  final String? message;
  final Data? data;

  DistrictModel({
    this.success,
    this.message,
    this.data,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
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
  final List<District> districts;

  Data({
    required this.districts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        districts: List<District>.from(
            json["districts"].map((x) => District.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
      };
}

class District {
  final int? id;
  final String? districtName;

  District({
    this.id,
    this.districtName,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        districtName: json["district_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_name": districtName,
      };
}

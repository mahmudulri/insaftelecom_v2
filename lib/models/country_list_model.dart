// To parse this JSON data, do
//
//     final countryListModel = countryListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CountryListModel countryListModelFromJson(String str) =>
    CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) =>
    json.encode(data.toJson());

class CountryListModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  CountryListModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) =>
      CountryListModel(
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
  final List<Country> countries;

  Data({
    required this.countries,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        countries: List<Country>.from(
            json["countries"].map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}

class Country {
  final int? id;
  final String? countryName;
  final String? countryFlagImageUrl;
  final String? languageId;
  String? phoneNumberLength;
  final String? countryTelecomCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;

  Country({
    this.id,
    this.countryName,
    this.countryFlagImageUrl,
    this.languageId,
    this.phoneNumberLength,
    this.countryTelecomCode,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"] == null ? null : json["id"],
        countryName: json["country_name"] == null ? null : json["country_name"],
        countryFlagImageUrl: json["country_flag_image_url"] == null
            ? null
            : json["country_flag_image_url"],
        languageId: json["language_id"] == null ? null : json["language_id"],
        phoneNumberLength: json["phone_number_length"] == null
            ? null
            : json["phone_number_length"],
        countryTelecomCode: json["country_telecom_code"] == null
            ? null
            : json["country_telecom_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryName,
        "country_flag_image_url": countryFlagImageUrl,
        "language_id": languageId,
        "phone_number_length": phoneNumberLength,
        "country_telecom_code": countryTelecomCode,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

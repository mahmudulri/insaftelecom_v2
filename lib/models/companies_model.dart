// To parse this JSON data, do
//
//     final companiesModel = companiesModelFromJson(jsonString);

import 'dart:convert';

CompaniesModel companiesModelFromJson(String str) =>
    CompaniesModel.fromJson(json.decode(str));

String companiesModelToJson(CompaniesModel data) => json.encode(data.toJson());

class CompaniesModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  CompaniesModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CompaniesModel.fromJson(Map<String, dynamic> json) => CompaniesModel(
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
  final List<Company>? companies;

  Data({
    this.companies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        companies: List<Company>.from(
            json["companies"].map((x) => Company.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "companies": List<dynamic>.from(companies!.map((x) => x.toJson())),
      };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final List<CompanyCode>? companyCodes;
  final Country? country;

  Company({
    this.id,
    this.companyName,
    this.companyLogo,
    this.companyCodes,
    this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"],
        companyCodes: List<CompanyCode>.from(
            json["company_codes"].map((x) => CompanyCode.fromJson(x))),
        country: Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_logo": companyLogo,
        "company_codes":
            List<dynamic>.from(companyCodes!.map((x) => x.toJson())),
        "country": country!.toJson(),
      };
}

class CompanyCode {
  final int? id;
  final String? reservedDigit;

  CompanyCode({
    this.id,
    this.reservedDigit,
  });

  factory CompanyCode.fromJson(Map<String, dynamic> json) => CompanyCode(
        id: json["id"],
        reservedDigit: json["reserved_digit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reserved_digit": reservedDigit,
      };
}

class Country {
  final int? id;
  final CountryName? countryName;
  final String? countryFlagImageUrl;

  Country({
    this.id,
    this.countryName,
    this.countryFlagImageUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: countryNameValues.map[json["country_name"]]!,
        countryFlagImageUrl: json["country_flag_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_name": countryNameValues.reverse[countryName],
        "country_flag_image_url": countryFlagImageUrl,
      };
}

enum CountryName { AFGHANISTAN, IRAN, TURKEY }

final countryNameValues = EnumValues({
  "Afghanistan": CountryName.AFGHANISTAN,
  "Iran": CountryName.IRAN,
  "Turkey": CountryName.TURKEY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

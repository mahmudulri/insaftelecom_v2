import 'dart:convert';

CountryListModel countryListModelFromJson(String str) =>
    CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) =>
    json.encode(data.toJson());

bool parseBoolean(dynamic value) {
  if (value == true || value == 1) {
    return true;
  }

  if (value == false || value == 0 || value == null) {
    return false;
  }

  final String normalizedValue = value.toString().trim().toLowerCase();

  return normalizedValue == "true" ||
      normalizedValue == "1" ||
      normalizedValue == "yes";
}

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

  factory CountryListModel.fromJson(Map<String, dynamic> json) {
    return CountryListModel(
      success: json["success"],
      code: json["code"],
      message: json["message"],
      data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      payload: json["payload"] != null
          ? List<dynamic>.from(json["payload"])
          : <dynamic>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "code": code,
      "message": message,
      "data": data?.toJson(),
      "payload": payload ?? <dynamic>[],
    };
  }
}

class Data {
  final List<Country> countries;

  Data({required this.countries});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      countries: json["countries"] != null
          ? List<Country>.from(
              json["countries"].map((x) => Country.fromJson(x)),
            )
          : <Country>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "countries": List<dynamic>.from(
        countries.map((country) => country.toJson()),
      ),
    };
  }
}

class Country {
  final int? id;
  final String? countryName;
  final String? countryFlagImageUrl;
  final String? languageId;
  final String? phoneNumberLength;
  final String? countryTelecomCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final bool enableOperatorLookup;

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
    this.enableOperatorLookup = false,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: int.tryParse(json["id"]?.toString() ?? ""),
      countryName: json["country_name"]?.toString(),
      countryFlagImageUrl: json["country_flag_image_url"]?.toString(),
      languageId: json["language_id"]?.toString(),
      phoneNumberLength: json["phone_number_length"]?.toString(),
      countryTelecomCode: json["country_telecom_code"]?.toString(),
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString())
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"].toString())
          : null,
      deletedAt: json["deleted_at"],
      enableOperatorLookup: parseBoolean(json["enable_operator_lookup"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "country_name": countryName,
      "country_flag_image_url": countryFlagImageUrl,
      "language_id": languageId,
      "phone_number_length": phoneNumberLength,
      "country_telecom_code": countryTelecomCode,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "enable_operator_lookup": enableOperatorLookup,
    };
  }
}

import 'dart:convert';

RechargeConfigModel rechargeConfigModelFromJson(String str) =>
    RechargeConfigModel.fromJson(json.decode(str));

String rechargeConfigModelToJson(RechargeConfigModel data) =>
    json.encode(data.toJson());

class RechargeConfigModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  RechargeConfigModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory RechargeConfigModel.fromJson(Map<String, dynamic> json) =>
      RechargeConfigModel(
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
  final String? source;
  final String? adjustType;
  final String? adjustMode;
  final String? adjustValue;
  final dynamic sellingAdjustType;
  final dynamic sellingAdjustMode;
  final dynamic sellingAdjustValue;

  Data({
    this.source,
    this.adjustType,
    this.adjustMode,
    this.adjustValue,
    this.sellingAdjustMode,
    this.sellingAdjustType,
    this.sellingAdjustValue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    source: json["source"] == null ? null : json["source"],
    adjustType: json["adjust_type"] == null ? null : json["adjust_type"],
    adjustMode: json["adjust_mode"] == null ? null : json["adjust_mode"],
    adjustValue: json["adjust_value"] == null ? null : json["adjust_value"],
    sellingAdjustType: json["selling_adjust_type"] == null
        ? null
        : json["selling_adjust_type"],
    sellingAdjustMode: json["selling_adjust_mode"] == null
        ? null
        : json["selling_adjust_mode"],
    sellingAdjustValue: json["selling_adjust_value"] == null
        ? null
        : json["selling_adjust_value"],
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "adjust_type": adjustType,
    "adjust_mode": adjustMode,
    "adjust_value": adjustValue,
    "selling_adjust_type": sellingAdjustType,
    "selling_adjust_mode": sellingAdjustMode,
    "selling_adjust_value": sellingAdjustValue,
  };
}

// To parse this JSON data, do
//
//     final paymentTypeModel = paymentTypeModelFromJson(jsonString);

import 'dart:convert';

PaymentTypeModel paymentTypeModelFromJson(String str) =>
    PaymentTypeModel.fromJson(json.decode(str));

String paymentTypeModelToJson(PaymentTypeModel data) =>
    json.encode(data.toJson());

class PaymentTypeModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  PaymentTypeModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) =>
      PaymentTypeModel(
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
  final List<PaymentType>? paymentTypes;

  Data({
    this.paymentTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentTypes: List<PaymentType>.from(
            json["payment_types"].map((x) => PaymentType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_types":
            List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
      };
}

class PaymentType {
  final int? id;
  final String? name;

  PaymentType({
    this.id,
    this.name,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

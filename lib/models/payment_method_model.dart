import 'dart:convert';

PaymentMethodModel paymentMethodModelFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  PaymentMethodModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
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
  final List<PaymentMethod>? paymentMethods;

  Data({
    this.paymentMethods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentMethods: List<PaymentMethod>.from(
            json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_methods":
            List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class PaymentMethod {
  final int? id;
  final String? methodName;

  PaymentMethod({
    this.id,
    this.methodName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"] == null ? null : json["id"],
        methodName: json["method_name"] == null ? null : json["method_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_name": methodName,
      };
}

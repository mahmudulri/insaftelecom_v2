import 'dart:convert';

PaymentsModel paymentsModelFromJson(String str) =>
    PaymentsModel.fromJson(json.decode(str));

String paymentsModelToJson(PaymentsModel data) => json.encode(data.toJson());

class PaymentsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  PaymentsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory PaymentsModel.fromJson(Map<String, dynamic> json) => PaymentsModel(
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
  final List<Payment> payments;

  Data({
    required this.payments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
      };
}

class Payment {
  final int? id;
  final String? resellerId;
  final String? amount;
  final String? status;
  final String? notes;
  final DateTime? paymentDate;
  final String? performedByName;
  final String? paymentImageUrl;
  final String? extraImage1Url;
  final dynamic extraImage2Url;
  final PaymentMethod? paymentMethod;
  final Currency? currency;
  final dynamic paymentType;

  Payment({
    this.id,
    this.resellerId,
    this.amount,
    this.status,
    this.notes,
    this.paymentDate,
    this.performedByName,
    this.paymentImageUrl,
    this.extraImage1Url,
    this.extraImage2Url,
    this.paymentMethod,
    this.currency,
    this.paymentType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        amount: json["amount"] == null ? null : json["amount"],
        status: json["status"] == null ? null : json["status"],
        notes: json["notes"] == null ? null : json["notes"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
        performedByName: json["performed_by_name"] == null
            ? null
            : json["performed_by_name"],
        paymentImageUrl: json["payment_image_url"] == null
            ? null
            : json["payment_image_url"],
        extraImage1Url: json["extra_image_1_url"] == null
            ? null
            : json["extra_image_1_url"],
        extraImage2Url: json["extra_image_2_url"] == null
            ? null
            : json["extra_image_2_url"],
        paymentMethod: json["payment_method"] == null
            ? null
            : PaymentMethod.fromJson(json["payment_method"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
        paymentType: json["payment_type"] == null ? null : json["payment_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "amount": amount,
        "status": status,
        "notes": notes,
        "payment_date": paymentDate!.toIso8601String(),
        "performed_by_name": performedByName,
        "payment_image_url": paymentImageUrl,
        "extra_image_1_url": extraImage1Url,
        "extra_image_2_url": extraImage2Url,
        "payment_method": paymentMethod!.toJson(),
        "currency": currency!.toJson(),
        "payment_type": paymentType,
      };
}

class Currency {
  final int? id;
  final String? code;
  final String? symbol;

  Currency({
    this.id,
    this.code,
    this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        symbol: json["symbol"] == null ? null : json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "symbol": symbol,
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

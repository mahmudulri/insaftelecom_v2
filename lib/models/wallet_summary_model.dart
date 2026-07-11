import 'dart:convert';

WalletSummaryModel walletSummaryModelFromJson(String str) =>
    WalletSummaryModel.fromJson(json.decode(str));

String walletSummaryModelToJson(WalletSummaryModel data) =>
    json.encode(data.toJson());

class WalletSummaryModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  WalletSummaryModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory WalletSummaryModel.fromJson(Map<String, dynamic> json) =>
      WalletSummaryModel(
        success: json["success"] == null ? null : json["success"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        payload: json["payload"] == null
            ? null
            : List<dynamic>.from(json["payload"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "payload": payload == null
        ? null
        : List<dynamic>.from(payload!.map((x) => x)),
  };
}

class Data {
  final PreferredCurrency? preferredCurrency;
  final Summary? summary;

  Data({this.preferredCurrency, this.summary});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    preferredCurrency: json["preferred_currency"] == null
        ? null
        : PreferredCurrency.fromJson(json["preferred_currency"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "preferred_currency": preferredCurrency?.toJson(),
    "summary": summary?.toJson(),
  };
}

class PreferredCurrency {
  final String? code;
  final String? symbol;

  PreferredCurrency({this.code, this.symbol});

  factory PreferredCurrency.fromJson(Map<String, dynamic> json) =>
      PreferredCurrency(
        code: json["code"] == null ? null : json["code"],
        symbol: json["symbol"] == null ? null : json["symbol"],
      );

  Map<String, dynamic> toJson() => {"code": code, "symbol": symbol};
}

class Summary {
  final String? totalBalance;
  final String? totalPayment;
  final String? totalLoan;
  final String? totalEarning;
  final String? totalHawalaSent;
  final String? totalHawalaReceived;
  final String? netWorth;
  final String? availableBalance;

  Summary({
    this.totalBalance,
    this.totalPayment,
    this.totalLoan,
    this.totalEarning,
    this.totalHawalaSent,
    this.totalHawalaReceived,
    this.netWorth,
    this.availableBalance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalBalance: json["total_balance"] == null ? null : json["total_balance"],
    totalPayment: json["total_payment"] == null ? null : json["total_payment"],
    totalLoan: json["total_loan"] == null ? null : json["total_loan"],
    totalEarning: json["total_earning"] == null ? null : json["total_earning"],
    totalHawalaSent: json["total_hawala_sent"] == null
        ? null
        : json["total_hawala_sent"],
    totalHawalaReceived: json["total_hawala_received"] == null
        ? null
        : json["total_hawala_received"],
    netWorth: json["net_worth"] == null ? null : json["net_worth"],
    availableBalance: json["available_balance"] == null
        ? null
        : json["available_balance"],
  );

  Map<String, dynamic> toJson() => {
    "total_balance": totalBalance,
    "total_payment": totalPayment,
    "total_loan": totalLoan,
    "total_earning": totalEarning,
    "total_hawala_sent": totalHawalaSent,
    "total_hawala_received": totalHawalaReceived,
    "net_worth": netWorth,
    "available_balance": availableBalance,
  };
}

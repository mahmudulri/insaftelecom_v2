import 'dart:convert';

BalanceModel balanceModelFromJson(String str) =>
    BalanceModel.fromJson(json.decode(str));

String balanceModelToJson(BalanceModel data) => json.encode(data.toJson());

class BalanceModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  BalanceModel({this.success, this.code, this.message, this.data});

  factory BalanceModel.fromJson(Map<String, dynamic> json) => BalanceModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  final Office? office;

  Data({this.office});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(office: Office.fromJson(json["office"]));

  Map<String, dynamic> toJson() => {"office": office!.toJson()};
}

class Office {
  final Summary? summary;

  Office({this.summary});

  factory Office.fromJson(Map<String, dynamic> json) =>
      Office(summary: Summary.fromJson(json["summary"]));

  Map<String, dynamic> toJson() => {"summary": summary!.toJson()};
}

class Summary {
  final List<Overall>? byCurrency;
  final Overall? overall;

  Summary({this.byCurrency, this.overall});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    byCurrency: List<Overall>.from(
      json["by_currency"].map((x) => Overall.fromJson(x)),
    ),
    overall: Overall.fromJson(json["overall"]),
  );

  Map<String, dynamic> toJson() => {
    "by_currency": List<dynamic>.from(byCurrency!.map((x) => x.toJson())),
    "overall": overall!.toJson(),
  };
}

class Overall {
  final String? currencyCode;
  final double? netBalance;
  final double? totalReceivable;
  final int? totalPayable;
  final String? status;

  Overall({
    this.currencyCode,
    this.netBalance,
    this.totalReceivable,
    this.totalPayable,
    this.status,
  });

  factory Overall.fromJson(Map<String, dynamic> json) => Overall(
    currencyCode: json["currency_code"],
    netBalance: json["net_balance"].toDouble(),
    totalReceivable: json["total_receivable"].toDouble(),
    totalPayable: json["total_payable"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode,
    "net_balance": netBalance,
    "total_receivable": totalReceivable,
    "total_payable": totalPayable,
    "status": status,
  };
}

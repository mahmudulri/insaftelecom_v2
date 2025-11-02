import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  CurrencyModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
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
  final List<Currency>? currencies;

  Data({
    this.currencies,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currencies": List<dynamic>.from(currencies!.map((x) => x.toJson())),
      };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;

  final String? exchangeRatePerUsd;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        symbol: json["symbol"],
        exchangeRatePerUsd: json["exchange_rate_per_usd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
        "exchange_rate_per_usd": exchangeRatePerUsd,
      };
}

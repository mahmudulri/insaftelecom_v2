import 'dart:convert';

HawalaCurrencyModel HawalaCurrencyModelFromJson(String str) =>
    HawalaCurrencyModel.fromJson(json.decode(str));

String HawalaCurrencyModelToJson(HawalaCurrencyModel data) =>
    json.encode(data.toJson());

class HawalaCurrencyModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  HawalaCurrencyModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory HawalaCurrencyModel.fromJson(Map<String, dynamic> json) =>
      HawalaCurrencyModel(
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
  final List<Rate>? rates;

  Data({
    this.rates,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rates": List<dynamic>.from(rates!.map((x) => x.toJson())),
      };
}

class Rate {
  final int? id;
  final String? fromCurrencyId;
  final String? toCurrencyId;
  final String? amount;
  final String? buyRate;
  final String? sellRate;

  final Currency? fromCurrency;
  final Currency? toCurrency;

  Rate({
    this.id,
    this.fromCurrencyId,
    this.toCurrencyId,
    this.amount,
    this.buyRate,
    this.sellRate,
    this.fromCurrency,
    this.toCurrency,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        id: json["id"] == null ? null : json["id"],
        fromCurrencyId:
            json["from_currency_id"] == null ? null : json["from_currency_id"],
        toCurrencyId:
            json["to_currency_id"] == null ? null : json["to_currency_id"],
        amount: json["amount"] == null ? null : json["amount"],
        buyRate: json["buy_rate"] == null ? null : json["buy_rate"],
        sellRate: json["sell_rate"] == null ? null : json["sell_rate"],
        fromCurrency: json["from_currency"] == null
            ? null
            : Currency.fromJson(json["from_currency"]),
        toCurrency: json["to_currency"] == null
            ? null
            : Currency.fromJson(json["to_currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_currency_id": fromCurrencyId,
        "to_currency_id": toCurrencyId,
        "amount": amount,
        "buy_rate": buyRate,
        "sell_rate": sellRate,
        "from_currency": fromCurrency!.toJson(),
        "to_currency": toCurrency!.toJson(),
      };
}

class Currency {
  final int id;
  final String name;
  final String code;
  final String symbol;
  final String? ignoreDigitsCount;
  final String exchangeRatePerUsd;

  Currency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
    required this.ignoreDigitsCount,
    required this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        ignoreDigitsCount: json["ignore_digits_count"] == null
            ? null
            : json["ignore_digits_count"],
        exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
            ? null
            : json["exchange_rate_per_usd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
        "ignore_digits_count": ignoreDigitsCount,
        "exchange_rate_per_usd": exchangeRatePerUsd,
      };
}

import 'dart:convert';

AccountCurrencyModel accountCurrencyModelFromJson(String str) =>
    AccountCurrencyModel.fromJson(json.decode(str));

String accountCurrencyModelToJson(AccountCurrencyModel data) =>
    json.encode(data.toJson());

class AccountCurrencyModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  AccountCurrencyModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory AccountCurrencyModel.fromJson(Map<String, dynamic> json) =>
      AccountCurrencyModel(
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
  final Pagination? pagination;

  Data({this.currencies, this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currencies: json["currencies"] == null
        ? null
        : List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x)),
          ),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "currencies": List<dynamic>.from(currencies!.map((x) => x.toJson())),
    "pagination": pagination!.toJson(),
  };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;
  final int? ignoreDigitsCount;
  final String? exchangeRatePerUsd;
  final String? resellerId;
  final String? createdBy;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? accountsCount;
  final String? transactionsCount;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.ignoreDigitsCount,
    this.exchangeRatePerUsd,
    this.resellerId,
    this.createdBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.accountsCount,
    this.transactionsCount,
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
    resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    transactionsCount: json["transactions_count"] == null
        ? null
        : json["transactions_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "ignore_digits_count": ignoreDigitsCount,
    "exchange_rate_per_usd": exchangeRatePerUsd,
    "reseller_id": resellerId,
    "created_by": createdBy,
    "deleted_at": deletedAt,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "accounts_count": accountsCount,
    "transactions_count": transactionsCount,
  };
}

class Pagination {
  final int? currentPage;
  final int? perPage;
  final int? totalItems;
  final int? totalPages;

  Pagination({
    this.currentPage,
    this.perPage,
    this.totalItems,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"] == null ? null : json["current_page"],
    perPage: json["per_page"] == null ? null : json["per_page"],
    totalItems: json["total_items"] == null ? null : json["total_items"],
    totalPages: json["total_pages"] == null ? null : json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total_items": totalItems,
    "total_pages": totalPages,
  };
}

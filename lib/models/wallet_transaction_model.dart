import 'dart:convert';

WalletTransactionModel walletTransactionModelFromJson(String str) =>
    WalletTransactionModel.fromJson(json.decode(str));

String walletTransactionModelToJson(WalletTransactionModel data) =>
    json.encode(data.toJson());

class WalletTransactionModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  WalletTransactionModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      WalletTransactionModel(
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
  final Wallet? wallet;
  final List<Transaction>? transactions;
  final Filters? filters;

  Data({this.wallet, this.transactions, this.filters});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
    transactions: json["transactions"] == null
        ? null
        : List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x)),
          ),
    filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet?.toJson(),
    "transactions": transactions == null
        ? null
        : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "filters": filters?.toJson(),
  };
}

class Filters {
  final String? category;
  final dynamic startDate;
  final dynamic endDate;

  Filters({this.category, this.startDate, this.endDate});

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    category: json["category"] == null ? null : json["category"],
    startDate: json["start_date"] == null ? null : json["start_date"],
    endDate: json["end_date"] == null ? null : json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "start_date": startDate,
    "end_date": endDate,
  };
}

class Transaction {
  final int? id;
  final String? type;
  final String? amount;
  final String? category;
  final String? description;
  final String? balanceBefore;
  final String? balanceAfter;
  final DateTime? createdAt;

  Transaction({
    this.id,
    this.type,
    this.amount,
    this.category,
    this.description,
    this.balanceBefore,
    this.balanceAfter,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    amount: json["amount"] == null ? null : json["amount"],
    category: json["category"] == null ? null : json["category"],
    description: json["description"] == null ? null : json["description"],
    balanceBefore: json["balance_before"] == null
        ? null
        : json["balance_before"],
    balanceAfter: json["balance_after"] == null ? null : json["balance_after"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "amount": amount,
    "category": category,
    "description": description,
    "balance_before": balanceBefore,
    "balance_after": balanceAfter,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Wallet {
  final int? id;
  final String? currencyCode;
  final String? currentBalance;

  Wallet({this.id, this.currencyCode, this.currentBalance});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"] == null ? null : json["id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    currentBalance: json["current_balance"] == null
        ? null
        : json["current_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency_code": currencyCode,
    "current_balance": currentBalance,
  };
}

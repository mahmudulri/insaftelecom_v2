import 'dart:convert';

WalletDetailsModel walletDetailsModelFromJson(String str) =>
    WalletDetailsModel.fromJson(json.decode(str));

String walletDetailsModelToJson(WalletDetailsModel data) =>
    json.encode(data.toJson());

class WalletDetailsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  WalletDetailsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory WalletDetailsModel.fromJson(Map<String, dynamic> json) =>
      WalletDetailsModel(
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
  final List<RecentTransaction>? recentTransactions;

  Data({this.wallet, this.recentTransactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
    recentTransactions: json["recent_transactions"] == null
        ? null
        : List<RecentTransaction>.from(
            json["recent_transactions"].map(
              (x) => RecentTransaction.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet?.toJson(),
    "recent_transactions": recentTransactions == null
        ? null
        : List<dynamic>.from(recentTransactions!.map((x) => x.toJson())),
  };
}

class RecentTransaction {
  final int? id;
  final String? type;
  final String? amount;
  final String? category;
  final String? description;
  final String? balanceBefore;
  final String? balanceAfter;
  final DateTime? createdAt;

  RecentTransaction({
    this.id,
    this.type,
    this.amount,
    this.category,
    this.description,
    this.balanceBefore,
    this.balanceAfter,
    this.createdAt,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        amount: json["amount"] == null ? null : json["amount"],
        category: json["category"] == null ? null : json["category"],
        description: json["description"] == null ? null : json["description"],
        balanceBefore: json["balance_before"] == null
            ? null
            : json["balance_before"],
        balanceAfter: json["balance_after"] == null
            ? null
            : json["balance_after"],
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
  final int? walletId;
  final Currency? currency;
  final String? balance;
  final String? payment;
  final String? loanBalance;
  final String? availableBalance;
  final String? totalEarnings;
  final String? totalHawalaSent;
  final String? totalHawalaReceived;
  final bool? isDefault;
  final bool? isActive;

  Wallet({
    this.walletId,
    this.currency,
    this.balance,
    this.payment,
    this.loanBalance,
    this.availableBalance,
    this.totalEarnings,
    this.totalHawalaSent,
    this.totalHawalaReceived,
    this.isDefault,
    this.isActive,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    walletId: json["wallet_id"] == null ? null : json["wallet_id"],
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    balance: json["balance"] == null ? null : json["balance"],
    payment: json["payment"] == null ? null : json["payment"],
    loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
    availableBalance: json["available_balance"] == null
        ? null
        : json["available_balance"],
    totalEarnings: json["total_earnings"] == null
        ? null
        : json["total_earnings"],
    totalHawalaSent: json["total_hawala_sent"] == null
        ? null
        : json["total_hawala_sent"],
    totalHawalaReceived: json["total_hawala_received"] == null
        ? null
        : json["total_hawala_received"],
    isDefault: json["is_default"] == null ? null : json["is_default"],
    isActive: json["is_active"] == null ? null : json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "wallet_id": walletId,
    "currency": currency?.toJson(),
    "balance": balance,
    "payment": payment,
    "loan_balance": loanBalance,
    "available_balance": availableBalance,
    "total_earnings": totalEarnings,
    "total_hawala_sent": totalHawalaSent,
    "total_hawala_received": totalHawalaReceived,
    "is_default": isDefault,
    "is_active": isActive,
  };
}

class Currency {
  final int? id;
  final String? code;
  final String? symbol;

  Currency({this.id, this.code, this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    symbol: json["symbol"] == null ? null : json["symbol"],
  );

  Map<String, dynamic> toJson() => {"id": id, "code": code, "symbol": symbol};
}

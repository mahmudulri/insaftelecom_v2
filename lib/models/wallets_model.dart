import 'dart:convert';

WalletsModel walletsModelFromJson(String str) =>
    WalletsModel.fromJson(json.decode(str));

String walletsModelToJson(WalletsModel data) => json.encode(data.toJson());

class WalletsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  WalletsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory WalletsModel.fromJson(Map<String, dynamic> json) => WalletsModel(
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
  final List<Wallet>? wallets;
  final ActiveWallet? activeWallet;
  final Summary? summary;

  Data({this.wallets, this.activeWallet, this.summary});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    wallets: List<Wallet>.from(json["wallets"].map((x) => Wallet.fromJson(x))),
    activeWallet: ActiveWallet.fromJson(json["active_wallet"]),
    summary: Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "wallets": List<dynamic>.from(wallets!.map((x) => x.toJson())),
    "active_wallet": activeWallet!.toJson(),
    "summary": summary!.toJson(),
  };
}

class ActiveWallet {
  final int? walletId;
  final String? currencyCode;
  final String? currencySymbol;
  final String? balance;
  final String? availableBalance;

  ActiveWallet({
    this.walletId,
    this.currencyCode,
    this.currencySymbol,
    this.balance,
    this.availableBalance,
  });

  factory ActiveWallet.fromJson(Map<String, dynamic> json) => ActiveWallet(
    walletId: json["wallet_id"] == null ? null : json["wallet_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    currencySymbol: json["currency_symbol"] == null
        ? null
        : json["currency_symbol"],
    balance: json["balance"] == null ? null : json["balance"],
    availableBalance: json["available_balance"] == null
        ? null
        : json["available_balance"],
  );

  Map<String, dynamic> toJson() => {
    "wallet_id": walletId,
    "currency_code": currencyCode,
    "currency_symbol": currencySymbol,
    "balance": balance,
    "available_balance": availableBalance,
  };
}

class Summary {
  final String? totalBalance;
  final String? preferredCurrency;

  Summary({this.totalBalance, this.preferredCurrency});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalBalance: json["total_balance"] == null ? null : json["total_balance"],
    preferredCurrency: json["preferred_currency"] == null
        ? null
        : json["preferred_currency"],
  );

  Map<String, dynamic> toJson() => {
    "total_balance": totalBalance,
    "preferred_currency": preferredCurrency,
  };
}

class Wallet {
  final int? walletId;
  final Currency? currency;
  final String? balance;
  final String? payment;
  final String? loanBalance;
  final String? availableBalance;
  final String? totalAvailable;
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
    this.totalAvailable,
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
    totalAvailable: json["total_available"] == null
        ? null
        : json["total_available"],
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
    "currency": currency!.toJson(),
    "balance": balance,
    "payment": payment,
    "loan_balance": loanBalance,
    "available_balance": availableBalance,
    "total_available": totalAvailable,
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
  final String? exchangeRate;

  Currency({this.id, this.code, this.symbol, this.exchangeRate});

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    exchangeRate: json["exchange_rate"] == null ? null : json["exchange_rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "symbol": symbol,
    "exchange_rate": exchangeRate,
  };
}

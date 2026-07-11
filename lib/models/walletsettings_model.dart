import 'dart:convert';

WalletSettingsModel walletSettingsModelFromJson(String str) =>
    WalletSettingsModel.fromJson(json.decode(str));

String walletSettingsModelToJson(WalletSettingsModel data) =>
    json.encode(data.toJson());

class WalletSettingsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  WalletSettingsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory WalletSettingsModel.fromJson(Map<String, dynamic> json) =>
      WalletSettingsModel(
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
  final Currency? preferredCurrency;
  final ActiveWallet? activeWallet;
  final String? adminWalletDeductionMode;
  final dynamic resellerWalletDeductionMode;
  final String? effectiveWalletDeductionMode;
  final bool? canChangeWalletDeductionMode;
  final List<String>? availableWalletDeductionModes;
  final String? bundlePriceDisplayMode;
  final List<String>? availableBundlePriceDisplayModes;
  final List<Wallet>? wallets;

  Data({
    this.preferredCurrency,
    this.activeWallet,
    this.adminWalletDeductionMode,
    this.resellerWalletDeductionMode,
    this.effectiveWalletDeductionMode,
    this.canChangeWalletDeductionMode,
    this.availableWalletDeductionModes,
    this.bundlePriceDisplayMode,
    this.availableBundlePriceDisplayModes,
    this.wallets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    preferredCurrency: json["preferred_currency"] == null
        ? null
        : Currency.fromJson(json["preferred_currency"]),
    activeWallet: json["active_wallet"] == null
        ? null
        : ActiveWallet.fromJson(json["active_wallet"]),
    adminWalletDeductionMode: json["admin_wallet_deduction_mode"] == null
        ? null
        : json["admin_wallet_deduction_mode"],
    resellerWalletDeductionMode: json["reseller_wallet_deduction_mode"] == null
        ? null
        : json["reseller_wallet_deduction_mode"],
    effectiveWalletDeductionMode:
        json["effective_wallet_deduction_mode"] == null
        ? null
        : json["effective_wallet_deduction_mode"],
    canChangeWalletDeductionMode:
        json["can_change_wallet_deduction_mode"] == null
        ? null
        : json["can_change_wallet_deduction_mode"],
    availableWalletDeductionModes:
        json["available_wallet_deduction_modes"] == null
        ? null
        : List<String>.from(
            json["available_wallet_deduction_modes"].map((x) => x),
          ),
    bundlePriceDisplayMode: json["bundle_price_display_mode"] == null
        ? null
        : json["bundle_price_display_mode"],
    availableBundlePriceDisplayModes:
        json["available_bundle_price_display_modes"] == null
        ? null
        : List<String>.from(
            json["available_bundle_price_display_modes"].map((x) => x),
          ),
    wallets: json["wallets"] == null
        ? null
        : List<Wallet>.from(json["wallets"].map((x) => Wallet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "preferred_currency": preferredCurrency?.toJson(),
    "active_wallet": activeWallet?.toJson(),
    "admin_wallet_deduction_mode": adminWalletDeductionMode,
    "reseller_wallet_deduction_mode": resellerWalletDeductionMode,
    "effective_wallet_deduction_mode": effectiveWalletDeductionMode,
    "can_change_wallet_deduction_mode": canChangeWalletDeductionMode,
    "available_wallet_deduction_modes": availableWalletDeductionModes == null
        ? null
        : List<dynamic>.from(availableWalletDeductionModes!.map((x) => x)),
    "bundle_price_display_mode": bundlePriceDisplayMode,
    "available_bundle_price_display_modes":
        availableBundlePriceDisplayModes == null
        ? null
        : List<dynamic>.from(availableBundlePriceDisplayModes!.map((x) => x)),
    "wallets": wallets == null
        ? null
        : List<dynamic>.from(wallets!.map((x) => x.toJson())),
  };
}

class ActiveWallet {
  final int? walletId;
  final Currency? currency;
  final String? balance;
  final String? availableBalance;
  final bool? isDefault;

  ActiveWallet({
    this.walletId,
    this.currency,
    this.balance,
    this.availableBalance,
    this.isDefault,
  });

  factory ActiveWallet.fromJson(Map<String, dynamic> json) => ActiveWallet(
    walletId: json["wallet_id"] == null ? null : json["wallet_id"],
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    balance: json["balance"] == null ? null : json["balance"],
    availableBalance: json["available_balance"] == null
        ? null
        : json["available_balance"],
    isDefault: json["is_default"] == null ? null : json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "wallet_id": walletId,
    "currency": currency?.toJson(),
    "balance": balance,
    "available_balance": availableBalance,
    "is_default": isDefault,
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
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
        ? null
        : json["exchange_rate_per_usd"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "exchange_rate_per_usd": exchangeRatePerUsd,
  };
}

class Wallet {
  final int? walletId;
  final Currency? currency;
  final String? balance;
  final String? payment;
  final String? loanBalance;
  final String? availableBalance;
  final bool? isDefault;
  final bool? isActive;

  Wallet({
    this.walletId,
    this.currency,
    this.balance,
    this.payment,
    this.loanBalance,
    this.availableBalance,
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
    "is_default": isDefault,
    "is_active": isActive,
  };
}

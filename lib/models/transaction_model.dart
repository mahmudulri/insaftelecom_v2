import 'package:meta/meta.dart';
import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  TransactionModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
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
  final List<ResellerBalanceTransaction> resellerBalanceTransactions;

  Data({
    required this.resellerBalanceTransactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        resellerBalanceTransactions: List<ResellerBalanceTransaction>.from(
            json["reseller_balance_transactions"]
                .map((x) => ResellerBalanceTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reseller_balance_transactions": List<dynamic>.from(
            resellerBalanceTransactions.map((x) => x.toJson())),
      };
}

class ResellerBalanceTransaction {
  final int? id;
  final String? resellerId;
  final String? amount;
  final dynamic? currencyCode;
  final String? currencyId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final Reseller? reseller;
  final Currency? currency;

  ResellerBalanceTransaction({
    this.id,
    this.resellerId,
    this.amount,
    this.currencyCode,
    this.currencyId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.reseller,
    this.currency,
  });

  factory ResellerBalanceTransaction.fromJson(Map<String, dynamic> json) =>
      ResellerBalanceTransaction(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        amount: json["amount"] == null ? null : json["amount"],
        currencyCode:
            json["currency_code"] == null ? null : json["currency_code"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        reseller: json["reseller"] == null
            ? null
            : Reseller.fromJson(json["reseller"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "amount": amount,
        "currency_code": currencyCode,
        "currency_id": currencyId,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "reseller": reseller!.toJson(),
        "currency": currency!.toJson(),
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

class Reseller {
  final int? id;
  final String? userId;
  final dynamic? parentId;
  final String? resellerName;
  final String? contactName;
  final String? resellerType;
  final String? status;
  final String? balance;
  final String? loanBalance;
  final dynamic? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? deletedAt;
  final User? user;

  Reseller({
    this.id,
    this.userId,
    this.parentId,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.status,
    this.balance,
    this.loanBalance,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Reseller.fromJson(Map<String, dynamic> json) => Reseller(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        resellerName:
            json["reseller_name"] == null ? null : json["reseller_name"],
        contactName: json["contact_name"] == null ? null : json["contact_name"],
        resellerType:
            json["reseller_type"] == null ? null : json["reseller_type"],
        status: json["status"] == null ? null : json["status"],
        balance: json["balance"] == null ? null : json["balance"],
        loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
        fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "parent_id": parentId,
        "reseller_type": resellerType,
        "status": status,
        "balance": balance,
        "loan_balance": loanBalance,
        "fcm_token": fcmToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user!.toJson(),
      };
}

class User {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final Currency? currency;

  User({
    this.id,
    this.name,
    this.createdAt,
    this.currency,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt!.toIso8601String(),
        "currency": currency!.toJson(),
      };
}

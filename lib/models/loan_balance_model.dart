import 'dart:convert';

LoanBalanceModel loanBalanceModelFromJson(String str) =>
    LoanBalanceModel.fromJson(json.decode(str));

String loanBalanceModelToJson(LoanBalanceModel data) =>
    json.encode(data.toJson());

class LoanBalanceModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  LoanBalanceModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory LoanBalanceModel.fromJson(Map<String, dynamic> json) =>
      LoanBalanceModel(
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
  final Balances? balances;

  Data({
    this.balances,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        balances: Balances.fromJson(json["balances"]),
      );

  Map<String, dynamic> toJson() => {
        "balances": balances!.toJson(),
      };
}

class Balances {
  final int? currentPage;
  final List<Datum>? data;

  Balances({
    this.currentPage,
    this.data,
  });

  factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? id;
  final String? resellerId;
  final String? transactionType;
  final String? paymentId;
  final dynamic isResellerLoanRequest;
  final String? amount;
  final String? remainingBalance;
  final String? currencyId;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? performedBy;
  final String? performedByName;
  final Currency? currency;

  Datum({
    this.id,
    this.resellerId,
    this.transactionType,
    this.paymentId,
    this.isResellerLoanRequest,
    this.amount,
    this.remainingBalance,
    this.currencyId,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.performedBy,
    this.performedByName,
    this.currency,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        transactionType:
            json["transaction_type"] == null ? null : json["transaction_type"],
        paymentId: json["payment_id"] == null ? null : json["payment_id"],
        isResellerLoanRequest: json["is_reseller_loan_request"] == null
            ? null
            : json["is_reseller_loan_request"],
        amount: json["amount"] == null ? null : json["amount"],
        remainingBalance: json["remaining_balance"] == null
            ? null
            : json["remaining_balance"],
        currencyId: json["currency_id"] == null ? null : json["currency_id"],
        description: json["description"] == null ? null : json["description"],
        status: json["status"] == null ? null : json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        performedBy: json["performed_by"] == null ? null : json["performed_by"],
        performedByName: json["performed_by_name"] == null
            ? null
            : json["performed_by_name"],
        currency: json["currency"] == null
            ? null
            : Currency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "transaction_type": transactionType,
        "payment_id": paymentId,
        "is_reseller_loan_request": isResellerLoanRequest,
        "amount": amount,
        "remaining_balance": remainingBalance,
        "currency_id": currencyId,
        "description": description,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "performed_by": performedBy,
        "performed_by_name": performedByName,
        "currency": currency!.toJson(),
      };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        symbol: json["symbol"] == null ? null : json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "symbol": symbol,
      };
}

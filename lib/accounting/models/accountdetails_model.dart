import 'dart:convert';

AccountDetailsModel accountDetailsModelFromJson(String str) =>
    AccountDetailsModel.fromJson(json.decode(str));

String accountDetailsModelToJson(AccountDetailsModel data) =>
    json.encode(data.toJson());

class AccountDetailsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  AccountDetailsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory AccountDetailsModel.fromJson(Map<String, dynamic> json) =>
      AccountDetailsModel(
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
    "data": data!.toJson(),
    "payload": List<dynamic>.from(payload!.map((x) => x)),
  };
}

class Data {
  final Account? account;
  final Statistics? statistics;
  final List<TransactionTypeBreakdown>? transactionTypeBreakdown;

  final Filters? filters;

  Data({
    this.account,
    this.statistics,
    this.transactionTypeBreakdown,

    this.filters,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    statistics: json["statistics"] == null
        ? null
        : Statistics.fromJson(json["statistics"]),
    transactionTypeBreakdown: json["transaction_type_breakdown"] == null
        ? null
        : List<TransactionTypeBreakdown>.from(
            json["transaction_type_breakdown"].map(
              (x) => TransactionTypeBreakdown.fromJson(x),
            ),
          ),

    filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
  );

  Map<String, dynamic> toJson() => {
    "account": account!.toJson(),
    "statistics": statistics!.toJson(),
    "transaction_type_breakdown": List<dynamic>.from(
      transactionTypeBreakdown!.map((x) => x.toJson()),
    ),

    "filters": filters!.toJson(),
  };
}

class Account {
  final int? id;
  final String? uuid;
  final String? name;
  final String? accountType;
  final Counterparty? counterparty;
  final Counterparty? office;
  final String? accountingCurrencyId;
  final String? currencyCode;
  final String? openingBalance;
  final String? currentBalance;
  final String? balanceStatus;

  Account({
    this.id,
    this.uuid,
    this.name,
    this.accountType,
    this.counterparty,
    this.office,
    this.accountingCurrencyId,
    this.currencyCode,
    this.openingBalance,
    this.currentBalance,
    this.balanceStatus,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    counterparty: json["counterparty"] == null
        ? null
        : Counterparty.fromJson(json["counterparty"]),
    office: json["office"] == null
        ? null
        : Counterparty.fromJson(json["office"]),
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    openingBalance: json["opening_balance"] == null
        ? null
        : json["opening_balance"],
    currentBalance: json["current_balance"] == null
        ? null
        : json["current_balance"],
    balanceStatus: json["balance_status"] == null
        ? null
        : json["balance_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "account_type": accountType,
    "counterparty": counterparty!.toJson(),
    "office": office!.toJson(),
    "accounting_currency_id": accountingCurrencyId,
    "currency_code": currencyCode,
    "opening_balance": openingBalance,
    "current_balance": currentBalance,
    "balance_status": balanceStatus,
  };
}

class Counterparty {
  final int? id;
  final String? name;

  Counterparty({this.id, this.name});

  factory Counterparty.fromJson(Map<String, dynamic> json) => Counterparty(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Filters {
  final dynamic from;
  final dynamic to;

  Filters({this.from, this.to});

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
  );

  Map<String, dynamic> toJson() => {"from": from, "to": to};
}

class Statistics {
  final int? totalTransactions;
  final String? positiveEffect;
  final String? negativeEffect;
  final String? netEffect;
  final String? receivablesCreated;
  final String? receivablePayments;
  final String? payablesCreated;
  final String? payablePayments;
  final String? openingBalanceEffect;
  final String? adjustmentEffect;
  final String? reversalEffect;
  final String? currentBalance;
  final String? status;

  Statistics({
    this.totalTransactions,
    this.positiveEffect,
    this.negativeEffect,
    this.netEffect,
    this.receivablesCreated,
    this.receivablePayments,
    this.payablesCreated,
    this.payablePayments,
    this.openingBalanceEffect,
    this.adjustmentEffect,
    this.reversalEffect,
    this.currentBalance,
    this.status,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    totalTransactions: json["total_transactions"] == null
        ? null
        : json["total_transactions"],
    positiveEffect: json["positive_effect"] == null
        ? null
        : json["positive_effect"],
    negativeEffect: json["negative_effect"] == null
        ? null
        : json["negative_effect"],
    netEffect: json["net_effect"] == null ? null : json["net_effect"],
    receivablesCreated: json["receivables_created"] == null
        ? null
        : json["receivables_created"],
    receivablePayments: json["receivable_payments"] == null
        ? null
        : json["receivable_payments"],
    payablesCreated: json["payables_created"] == null
        ? null
        : json["payables_created"],
    payablePayments: json["payable_payments"] == null
        ? null
        : json["payable_payments"],
    openingBalanceEffect: json["opening_balance_effect"] == null
        ? null
        : json["opening_balance_effect"],
    adjustmentEffect: json["adjustment_effect"] == null
        ? null
        : json["adjustment_effect"],
    reversalEffect: json["reversal_effect"] == null
        ? null
        : json["reversal_effect"],
    currentBalance: json["current_balance"] == null
        ? null
        : json["current_balance"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "total_transactions": totalTransactions,
    "positive_effect": positiveEffect,
    "negative_effect": negativeEffect,
    "net_effect": netEffect,
    "receivables_created": receivablesCreated,
    "receivable_payments": receivablePayments,
    "payables_created": payablesCreated,
    "payable_payments": payablePayments,
    "opening_balance_effect": openingBalanceEffect,
    "adjustment_effect": adjustmentEffect,
    "reversal_effect": reversalEffect,
    "current_balance": currentBalance,
    "status": status,
  };
}

class TransactionTypeBreakdown {
  final String? transactionType;
  final int? transactionsCount;
  final String? totalAmount;
  final String? netEffect;

  TransactionTypeBreakdown({
    this.transactionType,
    this.transactionsCount,
    this.totalAmount,
    this.netEffect,
  });

  factory TransactionTypeBreakdown.fromJson(Map<String, dynamic> json) =>
      TransactionTypeBreakdown(
        transactionType: json["transaction_type"] == null
            ? null
            : json["transaction_type"],
        transactionsCount: json["transactions_count"] == null
            ? null
            : json["transactions_count"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        netEffect: json["net_effect"] == null ? null : json["net_effect"],
      );

  Map<String, dynamic> toJson() => {
    "transaction_type": transactionType,
    "transactions_count": transactionsCount,
    "total_amount": totalAmount,
    "net_effect": netEffect,
  };
}

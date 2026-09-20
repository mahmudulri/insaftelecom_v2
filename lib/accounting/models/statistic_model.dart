import 'dart:convert';

StatisticsModel statisticsModelFromJson(String str) =>
    StatisticsModel.fromJson(json.decode(str));

String statisticsModelToJson(StatisticsModel data) =>
    json.encode(data.toJson());

class StatisticsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  StatisticsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) =>
      StatisticsModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        payload: json["payload"] == null
            ? []
            : List<dynamic>.from(json["payload"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "payload": payload == null
        ? []
        : List<dynamic>.from(payload!.map((x) => x)),
  };
}

class Data {
  final Counts? counts;
  final BalanceSummary? balanceSummary;
  final TransactionSummary? transactionSummary;
  final List<RecentTransaction>? recentTransactions;
  final Filters? filters;

  Data({
    this.counts,
    this.balanceSummary,
    this.transactionSummary,
    this.recentTransactions,
    this.filters,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
    balanceSummary: json["balance_summary"] == null
        ? null
        : BalanceSummary.fromJson(json["balance_summary"]),
    transactionSummary: json["transaction_summary"] == null
        ? null
        : TransactionSummary.fromJson(json["transaction_summary"]),
    recentTransactions: json["recent_transactions"] == null
        ? []
        : List<RecentTransaction>.from(
            json["recent_transactions"]!.map(
              (x) => RecentTransaction.fromJson(x),
            ),
          ),
    filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
  );

  Map<String, dynamic> toJson() => {
    "counts": counts?.toJson(),
    "balance_summary": balanceSummary?.toJson(),
    "transaction_summary": transactionSummary?.toJson(),
    "recent_transactions": recentTransactions == null
        ? []
        : List<dynamic>.from(recentTransactions!.map((x) => x.toJson())),
    "filters": filters?.toJson(),
  };
}

class BalanceSummary {
  final List<BalanceSummaryByCurrency>? byCurrency;
  final int? accountsCount;
  final int? currenciesCount;
  final int? receivableAccountsCount;
  final int? payableAccountsCount;
  final int? settledAccountsCount;

  BalanceSummary({
    this.byCurrency,
    this.accountsCount,
    this.currenciesCount,
    this.receivableAccountsCount,
    this.payableAccountsCount,
    this.settledAccountsCount,
  });

  factory BalanceSummary.fromJson(Map<String, dynamic> json) => BalanceSummary(
    byCurrency: json["by_currency"] == null
        ? []
        : List<BalanceSummaryByCurrency>.from(
            json["by_currency"]!.map(
              (x) => BalanceSummaryByCurrency.fromJson(x),
            ),
          ),
    accountsCount: json["accounts_count"],
    currenciesCount: json["currencies_count"],
    receivableAccountsCount: json["receivable_accounts_count"],
    payableAccountsCount: json["payable_accounts_count"],
    settledAccountsCount: json["settled_accounts_count"],
  );

  Map<String, dynamic> toJson() => {
    "by_currency": byCurrency == null
        ? []
        : List<dynamic>.from(byCurrency!.map((x) => x.toJson())),
    "accounts_count": accountsCount,
    "currencies_count": currenciesCount,
    "receivable_accounts_count": receivableAccountsCount,
    "payable_accounts_count": payableAccountsCount,
    "settled_accounts_count": settledAccountsCount,
  };
}

class BalanceSummaryByCurrency {
  final String? accountingCurrencyId;
  final String? currencyCode;
  final int? accountsCount;
  final int? counterpartiesCount;
  final int? receivableAccountsCount;
  final int? payableAccountsCount;
  final int? settledAccountsCount;
  final String? totalReceivable;
  final String? totalPayable;
  final String? netBalance;
  final String? status;

  BalanceSummaryByCurrency({
    this.accountingCurrencyId,
    this.currencyCode,
    this.accountsCount,
    this.counterpartiesCount,
    this.receivableAccountsCount,
    this.payableAccountsCount,
    this.settledAccountsCount,
    this.totalReceivable,
    this.totalPayable,
    this.netBalance,
    this.status,
  });

  factory BalanceSummaryByCurrency.fromJson(
    Map<String, dynamic> json,
  ) => BalanceSummaryByCurrency(
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    counterpartiesCount: json["counterparties_count"] == null
        ? null
        : json["counterparties_count"],
    receivableAccountsCount: json["receivable_accounts_count"] == null
        ? null
        : json["receivable_accounts_count"],
    payableAccountsCount: json["payable_accounts_count"] == null
        ? null
        : json["payable_accounts_count"],
    settledAccountsCount: json["settled_accounts_count"] == null
        ? null
        : json["settled_accounts_count"],
    totalReceivable: json["total_receivable"] == null
        ? null
        : json["total_receivable"],
    totalPayable: json["total_payable"] == null ? null : json["total_payable"],
    netBalance: json["net_balance"] == null ? null : json["net_balance"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "accounting_currency_id": accountingCurrencyId,
    "currency_code": currencyCode,
    "accounts_count": accountsCount,
    "counterparties_count": counterpartiesCount,
    "receivable_accounts_count": receivableAccountsCount,
    "payable_accounts_count": payableAccountsCount,
    "settled_accounts_count": settledAccountsCount,
    "total_receivable": totalReceivable,
    "total_payable": totalPayable,
    "net_balance": netBalance,
    "status": status,
  };
}

class Counts {
  final int? counterpartiesCount;
  final int? accountsCount;
  final int? transactionsCount;
  final int? officesCount;
  final int? currenciesCount;

  Counts({
    this.counterpartiesCount,
    this.accountsCount,
    this.transactionsCount,
    this.officesCount,
    this.currenciesCount,
  });

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
    counterpartiesCount: json["counterparties_count"] == null
        ? null
        : json["counterparties_count"],
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    transactionsCount: json["transactions_count"] == null
        ? null
        : json["transactions_count"],
    officesCount: json["offices_count"] == null ? null : json["offices_count"],
    currenciesCount: json["currencies_count"] == null
        ? null
        : json["currencies_count"],
  );

  Map<String, dynamic> toJson() => {
    "counterparties_count": counterpartiesCount,
    "accounts_count": accountsCount,
    "transactions_count": transactionsCount,
    "offices_count": officesCount,
    "currencies_count": currenciesCount,
  };
}

class Filters {
  final dynamic currencyCode;
  final dynamic accountingCurrencyId;
  final dynamic officeId;
  final dynamic from;
  final dynamic to;

  Filters({
    this.currencyCode,
    this.accountingCurrencyId,
    this.officeId,
    this.from,
    this.to,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    officeId: json["office_id"] == null ? null : json["office_id"],
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode,
    "accounting_currency_id": accountingCurrencyId,
    "office_id": officeId,
    "from": from,
    "to": to,
  };
}

class RecentTransaction {
  final int? id;
  final String? uuid;
  final String? groupUuid;
  final dynamic reversalOfTransactionId;
  final String? resellerId;
  final String? officeId;
  final String? counterpartyId;
  final String? counterpartyAccountId;
  final dynamic moneyAccountId;
  final String? accountingCurrencyId;
  final String? reference;
  final String? transactionType;
  final String? category;
  final String? description;
  final String? currencyCode;
  final String? exchangeRate;
  final String? amount;
  final String? balanceEffect;
  final String? balanceBefore;
  final String? balanceAfter;
  final String? status;
  final DateTime? transactionDate;
  final DateTime? postedAt;
  final String? postedBy;
  final dynamic notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Counterparty? counterparty;
  final CounterpartyAccount? counterpartyAccount;
  final Office? office;

  RecentTransaction({
    this.id,
    this.uuid,
    this.groupUuid,
    this.reversalOfTransactionId,
    this.resellerId,
    this.officeId,
    this.counterpartyId,
    this.counterpartyAccountId,
    this.moneyAccountId,
    this.accountingCurrencyId,
    this.reference,
    this.transactionType,
    this.category,
    this.description,
    this.currencyCode,
    this.exchangeRate,
    this.amount,
    this.balanceEffect,
    this.balanceBefore,
    this.balanceAfter,
    this.status,
    this.transactionDate,
    this.postedAt,
    this.postedBy,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.counterparty,
    this.counterpartyAccount,
    this.office,
  });

  factory RecentTransaction.fromJson(
    Map<String, dynamic> json,
  ) => RecentTransaction(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    groupUuid: json["group_uuid"] == null ? null : json["group_uuid"],
    reversalOfTransactionId: json["reversal_of_transaction_id"] == null
        ? null
        : json["reversal_of_transaction_id"],
    resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
    officeId: json["office_id"] == null ? null : json["office_id"],
    counterpartyId: json["counterparty_id"] == null
        ? null
        : json["counterparty_id"],
    counterpartyAccountId: json["counterparty_account_id"] == null
        ? null
        : json["counterparty_account_id"],
    moneyAccountId: json["money_account_id"] == null
        ? null
        : json["money_account_id"],
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    reference: json["reference"] == null ? null : json["reference"],
    transactionType: json["transaction_type"] == null
        ? null
        : json["transaction_type"],
    category: json["category"] == null ? null : json["category"],
    description: json["description"] == null ? null : json["description"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    exchangeRate: json["exchange_rate"] == null ? null : json["exchange_rate"],
    amount: json["amount"] == null ? null : json["amount"],

    balanceEffect: json["balance_effect"] == null
        ? null
        : json["balance_effect"],
    balanceBefore: json["balance_before"] == null
        ? null
        : json["balance_before"],
    balanceAfter: json["balance_after"] == null ? null : json["balance_after"],
    status: json["status"] == null ? null : json["status"],

    transactionDate: json["transaction_date"] == null
        ? null
        : DateTime.parse(json["transaction_date"]),
    postedAt: json["posted_at"] == null
        ? null
        : DateTime.parse(json["posted_at"]),
    postedBy: json["posted_by"] == null ? null : json["posted_by"],
    notes: json["notes"] == null ? null : json["notes"],
    createdBy: json["created_by"] == null ? null : json["created_by"],

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],

    counterparty: json["counterparty"] == null
        ? null
        : Counterparty.fromJson(json["counterparty"]),
    counterpartyAccount: json["counterparty_account"] == null
        ? null
        : CounterpartyAccount.fromJson(json["counterparty_account"]),
    office: json["office"] == null ? null : Office.fromJson(json["office"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "group_uuid": groupUuid,
    "reversal_of_transaction_id": reversalOfTransactionId,
    "reseller_id": resellerId,
    "office_id": officeId,
    "counterparty_id": counterpartyId,
    "counterparty_account_id": counterpartyAccountId,
    "money_account_id": moneyAccountId,
    "accounting_currency_id": accountingCurrencyId,
    "reference": reference,
    "transaction_type": transactionType,
    "category": category,
    "description": description,
    "currency_code": currencyCode,
    "exchange_rate": exchangeRate,
    "amount": amount,
    "balance_effect": balanceEffect,
    "balance_before": balanceBefore,
    "balance_after": balanceAfter,
    "status": status,
    "transaction_date": transactionDate?.toIso8601String(),
    "posted_at": postedAt?.toIso8601String(),
    "posted_by": postedBy,
    "notes": notes,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "counterparty": counterparty?.toJson(),
    "counterparty_account": counterpartyAccount?.toJson(),
    "office": office?.toJson(),
  };
}

class Counterparty {
  final int? id;
  final String? uuid;
  final String? resellerId;
  final String? name;
  final String? type;
  final String? phone;
  final String? email;
  final dynamic address;
  final String? defaultCurrencyCode;
  final bool? isFavorite;
  final dynamic profileImageUrl;
  final dynamic notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Counterparty({
    this.id,
    this.uuid,
    this.resellerId,
    this.name,
    this.type,
    this.phone,
    this.email,
    this.address,
    this.defaultCurrencyCode,
    this.isFavorite,
    this.profileImageUrl,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Counterparty.fromJson(Map<String, dynamic> json) => Counterparty(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
    name: json["name"] == null ? null : json["name"],
    type: json["type"] == null ? null : json["type"],
    phone: json["phone"] == null ? null : json["phone"],
    email: json["email"] == null ? null : json["email"],
    address: json["address"] == null ? null : json["address"],
    defaultCurrencyCode: json["default_currency_code"] == null
        ? null
        : json["default_currency_code"],
    isFavorite: json["is_favorite"] == null ? null : json["is_favorite"],
    profileImageUrl: json["profile_image_url"] == null
        ? null
        : json["profile_image_url"],
    notes: json["notes"] == null ? null : json["notes"],
    createdBy: json["created_by"] == null ? null : json["created_by"],

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "reseller_id": resellerId,
    "name": name,
    "type": type,
    "phone": phone,
    "email": email,
    "address": address,
    "default_currency_code": defaultCurrencyCode,
    "is_favorite": isFavorite,
    "profile_image_url": profileImageUrl,
    "notes": notes,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class CounterpartyAccount {
  final int? id;
  final String? uuid;
  final String? resellerId;
  final String? counterpartyId;
  final String? officeId;
  final String? accountingCurrencyId;
  final String? currencyCode;
  final String? accountType;
  final String? name;
  final String? openingBalance;
  final String? currentBalance;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  CounterpartyAccount({
    this.id,
    this.uuid,
    this.resellerId,
    this.counterpartyId,
    this.officeId,
    this.accountingCurrencyId,
    this.currencyCode,
    this.accountType,
    this.name,
    this.openingBalance,
    this.currentBalance,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CounterpartyAccount.fromJson(Map<String, dynamic> json) =>
      CounterpartyAccount(
        id: json["id"] == null ? null : json["id"],
        uuid: json["uuid"] == null ? null : json["uuid"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        counterpartyId: json["counterparty_id"] == null
            ? null
            : json["counterparty_id"],
        officeId: json["office_id"] == null ? null : json["office_id"],
        accountingCurrencyId: json["accounting_currency_id"] == null
            ? null
            : json["accounting_currency_id"],
        currencyCode: json["currency_code"] == null
            ? null
            : json["currency_code"],
        accountType: json["account_type"] == null ? null : json["account_type"],
        name: json["name"] == null ? null : json["name"],
        openingBalance: json["opening_balance"] == null
            ? null
            : json["opening_balance"],
        currentBalance: json["current_balance"] == null
            ? null
            : json["current_balance"],
        notes: json["notes"] == null ? null : json["notes"],
        createdBy: json["created_by"] == null ? null : json["created_by"],

        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "reseller_id": resellerId,
    "counterparty_id": counterpartyId,
    "office_id": officeId,
    "accounting_currency_id": accountingCurrencyId,
    "currency_code": currencyCode,
    "account_type": accountType,
    "name": name,
    "opening_balance": openingBalance,
    "current_balance": currentBalance,
    "notes": notes,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Office {
  final int? id;
  final String? uuid;
  final String? resellerId;
  final String? name;
  final String? code;
  final String? location;
  final String? address;
  final String? phone;
  final bool? isActive;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Office({
    this.id,
    this.uuid,
    this.resellerId,
    this.name,
    this.code,
    this.location,
    this.address,
    this.phone,
    this.isActive,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
    location: json["location"] == null ? null : json["location"],
    address: json["address"] == null ? null : json["address"],
    phone: json["phone"] == null ? null : json["phone"],
    isActive: json["is_active"] == null ? null : json["is_active"],
    notes: json["notes"] == null ? null : json["notes"],
    createdBy: json["created_by"] == null ? null : json["created_by"],

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "reseller_id": resellerId,
    "name": name,
    "code": code,
    "location": location,
    "address": address,
    "phone": phone,
    "is_active": isActive,
    "notes": notes,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class TransactionSummary {
  final dynamic from;
  final dynamic to;
  final List<TransactionSummaryByCurrency>? byCurrency;
  final int? transactionsCount;
  final int? currenciesCount;

  TransactionSummary({
    this.from,
    this.to,
    this.byCurrency,
    this.transactionsCount,
    this.currenciesCount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      TransactionSummary(
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],

        byCurrency: json["by_currency"] == null
            ? []
            : List<TransactionSummaryByCurrency>.from(
                json["by_currency"]!.map(
                  (x) => TransactionSummaryByCurrency.fromJson(x),
                ),
              ),
        transactionsCount: json["transactions_count"],
        currenciesCount: json["currencies_count"],
      );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "by_currency": byCurrency == null
        ? []
        : List<dynamic>.from(byCurrency!.map((x) => x.toJson())),
    "transactions_count": transactionsCount,
    "currencies_count": currenciesCount,
  };
}

class TransactionSummaryByCurrency {
  final String? accountingCurrencyId;
  final String? currencyCode;
  final int? transactionsCount;
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

  TransactionSummaryByCurrency({
    this.accountingCurrencyId,
    this.currencyCode,
    this.transactionsCount,
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
  });

  factory TransactionSummaryByCurrency.fromJson(Map<String, dynamic> json) =>
      TransactionSummaryByCurrency(
        accountingCurrencyId: json["accounting_currency_id"] == null
            ? null
            : json["accounting_currency_id"],
        currencyCode: json["currency_code"] == null
            ? null
            : json["currency_code"],
        transactionsCount: json["transactions_count"] == null
            ? null
            : json["transactions_count"],
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
      );

  Map<String, dynamic> toJson() => {
    "accounting_currency_id": accountingCurrencyId,
    "currency_code": currencyCode,
    "transactions_count": transactionsCount,
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
  };
}

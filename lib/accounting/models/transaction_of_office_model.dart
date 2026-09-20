import 'dart:convert';

TransactionsofOfficeModel transactionsofOfficeModelFromJson(String str) =>
    TransactionsofOfficeModel.fromJson(json.decode(str));

String transactionsofOfficeModelToJson(TransactionsofOfficeModel data) =>
    json.encode(data.toJson());

class TransactionsofOfficeModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  TransactionsofOfficeModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory TransactionsofOfficeModel.fromJson(Map<String, dynamic> json) =>
      TransactionsofOfficeModel(
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
  final Office? office;
  final Summary? summary;

  Data({this.office, this.summary});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    office: json["office"] == null ? null : Office.fromJson(json["office"]),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "office": office!.toJson(),
    "summary": summary!.toJson(),
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
  final String? accountsCount;
  final String? transactionsCount;
  final List<Transaction>? transactions;

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
    this.accountsCount,
    this.transactionsCount,
    this.transactions,
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
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    transactionsCount: json["transactions_count"] == null
        ? null
        : json["transactions_count"],
    transactions: json["transactions"] == null
        ? null
        : List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x)),
          ),
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
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "accounts_count": accountsCount,
    "transactions_count": transactionsCount,
    "transactions": List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}

class Transaction {
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
  final Currency? currency;
  final Creator? creator;
  final Creator? poster;

  Transaction({
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
    this.currency,
    this.creator,
    this.poster,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
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
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    poster: json["poster"] == null ? null : Creator.fromJson(json["poster"]),
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
    "transaction_date": transactionDate!.toIso8601String(),
    "posted_at": postedAt!.toIso8601String(),
    "posted_by": postedBy,
    "notes": notes,
    "created_by": createdBy,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "counterparty": counterparty!.toJson(),
    "counterparty_account": counterpartyAccount!.toJson(),
    "currency": currency!.toJson(),
    "creator": creator?.toJson(),
    "poster": poster?.toJson(),
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
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
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
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Creator {
  final int? id;
  final String? uuid;
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;
  final dynamic emailVerifiedAt;
  final String? currencyPreferenceCode;
  final String? currencyPreferenceId;
  final dynamic fcmToken;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Creator({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.emailVerifiedAt,
    this.currencyPreferenceCode,
    this.currencyPreferenceId,
    this.fcmToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    id: json["id"] == null ? null : json["id"],
    uuid: json["uuid"] == null ? null : json["uuid"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    userType: json["user_type"] == null ? null : json["user_type"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : json["email_verified_at"],
    currencyPreferenceCode: json["currency_preference_code"] == null
        ? null
        : json["currency_preference_code"],
    currencyPreferenceId: json["currency_preference_id"] == null
        ? null
        : json["currency_preference_id"],
    fcmToken: json["fcm_token"] == null ? null : json["fcm_token"],
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "email": email,
    "phone": phone,
    "user_type": userType,
    "email_verified_at": emailVerifiedAt,
    "currency_preference_code": currencyPreferenceCode,
    "currency_preference_id": currencyPreferenceId,
    "fcm_token": fcmToken,
    "deleted_at": deletedAt,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
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
  final dynamic createdBy;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
  };
}

class Summary {
  final Counts? counts;
  final List<BalanceSummary>? balanceSummary;
  final List<TransactionSummary>? transactionSummary;
  final Transaction? latestTransaction;

  Summary({
    this.counts,
    this.balanceSummary,
    this.transactionSummary,
    this.latestTransaction,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    counts: json["counts"] == null ? null : Counts.fromJson(json["counts"]),
    balanceSummary: json["balance_summary"] == null
        ? null
        : List<BalanceSummary>.from(
            json["balance_summary"].map((x) => BalanceSummary.fromJson(x)),
          ),
    transactionSummary: json["transaction_summary"] == null
        ? null
        : List<TransactionSummary>.from(
            json["transaction_summary"].map(
              (x) => TransactionSummary.fromJson(x),
            ),
          ),
    latestTransaction: json["latest_transaction"] == null
        ? null
        : Transaction.fromJson(json["latest_transaction"]),
  );

  Map<String, dynamic> toJson() => {
    "counts": counts!.toJson(),
    "balance_summary": List<dynamic>.from(
      balanceSummary!.map((x) => x.toJson()),
    ),
    "transaction_summary": List<dynamic>.from(
      transactionSummary!.map((x) => x.toJson()),
    ),
    "latest_transaction": latestTransaction!.toJson(),
  };
}

class BalanceSummary {
  final String? accountingCurrencyId;
  final String? currencyCode;
  final String? accountsCount;
  final String? netBalance;
  final String? receivableBalance;
  final String? payableBalance;
  final String? settledAccountsCount;

  BalanceSummary({
    this.accountingCurrencyId,
    this.currencyCode,
    this.accountsCount,
    this.netBalance,
    this.receivableBalance,
    this.payableBalance,
    this.settledAccountsCount,
  });

  factory BalanceSummary.fromJson(Map<String, dynamic> json) => BalanceSummary(
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    netBalance: json["net_balance"] == null ? null : json["net_balance"],
    receivableBalance: json["receivable_balance"] == null
        ? null
        : json["receivable_balance"],
    payableBalance: json["payable_balance"] == null
        ? null
        : json["payable_balance"],
    settledAccountsCount: json["settled_accounts_count"] == null
        ? null
        : json["settled_accounts_count"],
  );

  Map<String, dynamic> toJson() => {
    "accounting_currency_id": accountingCurrencyId,
    "currency_code": currencyCode,
    "accounts_count": accountsCount,
    "net_balance": netBalance,
    "receivable_balance": receivableBalance,
    "payable_balance": payableBalance,
    "settled_accounts_count": settledAccountsCount,
  };
}

class Counts {
  final int? accounts;
  final int? counterparties;
  final int? transactions;
  final int? postedTransactions;
  final int? reversals;

  Counts({
    this.accounts,
    this.counterparties,
    this.transactions,
    this.postedTransactions,
    this.reversals,
  });

  factory Counts.fromJson(Map<String, dynamic> json) => Counts(
    accounts: json["accounts"] == null ? null : json["accounts"],
    counterparties: json["counterparties"] == null
        ? null
        : json["counterparties"],
    transactions: json["transactions"] == null ? null : json["transactions"],
    postedTransactions: json["posted_transactions"] == null
        ? null
        : json["posted_transactions"],
    reversals: json["reversals"] == null ? null : json["reversals"],
  );

  Map<String, dynamic> toJson() => {
    "accounts": accounts,
    "counterparties": counterparties,
    "transactions": transactions,
    "posted_transactions": postedTransactions,
    "reversals": reversals,
  };
}

class TransactionSummary {
  final String? accountingCurrencyId;
  final String? currencyCode;
  final String? transactionsCount;
  final String? totalAmount;
  final String? netBalanceEffect;
  final String? receivablesCreated;
  final String? receivablePayments;
  final String? payablesCreated;
  final String? payablePayments;
  final String? adjustmentEffect;
  final String? reversalEffect;

  TransactionSummary({
    this.accountingCurrencyId,
    this.currencyCode,
    this.transactionsCount,
    this.totalAmount,
    this.netBalanceEffect,
    this.receivablesCreated,
    this.receivablePayments,
    this.payablesCreated,
    this.payablePayments,
    this.adjustmentEffect,
    this.reversalEffect,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      TransactionSummary(
        accountingCurrencyId: json["accounting_currency_id"] == null
            ? null
            : json["accounting_currency_id"],
        currencyCode: json["currency_code"] == null
            ? null
            : json["currency_code"],
        transactionsCount: json["transactions_count"] == null
            ? null
            : json["transactions_count"],
        totalAmount: json["total_amount"] == null ? null : json["total_amount"],
        netBalanceEffect: json["net_balance_effect"] == null
            ? null
            : json["net_balance_effect"],
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
    "total_amount": totalAmount,
    "net_balance_effect": netBalanceEffect,
    "receivables_created": receivablesCreated,
    "receivable_payments": receivablePayments,
    "payables_created": payablesCreated,
    "payable_payments": payablePayments,
    "adjustment_effect": adjustmentEffect,
    "reversal_effect": reversalEffect,
  };
}

import 'dart:convert';

TransactionsofAccountModel transactionsofAccountModelFromJson(String str) =>
    TransactionsofAccountModel.fromJson(json.decode(str));

String transactionsofAccountModelToJson(TransactionsofAccountModel data) =>
    json.encode(data.toJson());

class TransactionsofAccountModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  TransactionsofAccountModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory TransactionsofAccountModel.fromJson(Map<String, dynamic> json) =>
      TransactionsofAccountModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
    "payload": payload!.toJson(),
  };
}

class Data {
  final List<Transaction>? transactions;

  Data({this.transactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactions: json["transactions"] == null
        ? null
        : List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
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

class Payload {
  final Pagination? pagination;

  Payload({this.pagination});

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {"pagination": pagination!.toJson()};
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

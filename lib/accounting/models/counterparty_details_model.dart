import 'dart:convert';

CounterPartyDetailsModel counterPartyDetailsModelFromJson(String str) =>
    CounterPartyDetailsModel.fromJson(json.decode(str));

String counterPartyDetailsModelToJson(CounterPartyDetailsModel data) =>
    json.encode(data.toJson());

class CounterPartyDetailsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  CounterPartyDetailsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CounterPartyDetailsModel.fromJson(Map<String, dynamic> json) =>
      CounterPartyDetailsModel(
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
  final Counterparty? counterparty;

  Data({this.counterparty});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(counterparty: Counterparty.fromJson(json["counterparty"]));

  Map<String, dynamic> toJson() => {"counterparty": counterparty!.toJson()};
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
  final Summary? summary;

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
    this.summary,
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
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
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
    "summary": summary!.toJson(),
  };
}

class Summary {
  final Snapshot? snapshot;
  final Activity? activity;
  final LatestTransaction? latestTransaction;

  Summary({this.snapshot, this.activity, this.latestTransaction});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    snapshot: json["snapshot"] == null
        ? null
        : Snapshot.fromJson(json["snapshot"]),
    activity: json["activity"] == null
        ? null
        : Activity.fromJson(json["activity"]),
    latestTransaction: json["latest_transaction"] == null
        ? null
        : LatestTransaction.fromJson(json["latest_transaction"]),
  );

  Map<String, dynamic> toJson() => {
    "snapshot": snapshot!.toJson(),
    "activity": activity!.toJson(),
    "latest_transaction": latestTransaction!.toJson(),
  };
}

class Activity {
  final dynamic from;
  final dynamic to;
  final List<ActivityByCurrency>? byCurrency;
  final int? transactionsCount;

  Activity({this.from, this.to, this.byCurrency, this.transactionsCount});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    from: json["from"] == null ? null : json["from"],
    to: json["to"] == null ? null : json["to"],
    byCurrency: json["by_currency"] == null
        ? null
        : List<ActivityByCurrency>.from(
            json["by_currency"].map((x) => ActivityByCurrency.fromJson(x)),
          ),
    transactionsCount: json["transactions_count"] == null
        ? null
        : json["transactions_count"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to,
    "by_currency": List<dynamic>.from(byCurrency!.map((x) => x.toJson())),
    "transactions_count": transactionsCount,
  };
}

class ActivityByCurrency {
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
  final String? adjustmentEffect;
  final String? reversalEffect;

  ActivityByCurrency({
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
    this.adjustmentEffect,
    this.reversalEffect,
  });

  factory ActivityByCurrency.fromJson(Map<String, dynamic> json) =>
      ActivityByCurrency(
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
    "adjustment_effect": adjustmentEffect,
    "reversal_effect": reversalEffect,
  };
}

class LatestTransaction {
  final int? id;
  final String? uuid;
  final String? transactionType;
  final String? amount;
  final String? balanceEffect;
  final String? currencyCode;
  final DateTime? transactionDate;
  final String? status;

  LatestTransaction({
    this.id,
    this.uuid,
    this.transactionType,
    this.amount,
    this.balanceEffect,
    this.currencyCode,
    this.transactionDate,
    this.status,
  });

  factory LatestTransaction.fromJson(Map<String, dynamic> json) =>
      LatestTransaction(
        id: json["id"] == null ? null : json["id"],
        uuid: json["uuid"] == null ? null : json["uuid"],
        transactionType: json["transaction_type"] == null
            ? null
            : json["transaction_type"],
        amount: json["amount"] == null ? null : json["amount"],
        balanceEffect: json["balance_effect"] == null
            ? null
            : json["balance_effect"],
        currencyCode: json["currency_code"] == null
            ? null
            : json["currency_code"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "transaction_type": transactionType,
    "amount": amount,
    "balance_effect": balanceEffect,
    "currency_code": currencyCode,
    "transaction_date":
        "${transactionDate!.year.toString().padLeft(4, '0')}-${transactionDate!.month.toString().padLeft(2, '0')}-${transactionDate!.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}

class Snapshot {
  final List<SnapshotByCurrency>? byCurrency;
  final int? accountsCount;
  final int? currenciesCount;

  Snapshot({this.byCurrency, this.accountsCount, this.currenciesCount});

  factory Snapshot.fromJson(Map<String, dynamic> json) => Snapshot(
    byCurrency: json["by_currency"] == null
        ? null
        : List<SnapshotByCurrency>.from(
            json["by_currency"].map((x) => SnapshotByCurrency.fromJson(x)),
          ),
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
    currenciesCount: json["currencies_count"] == null
        ? null
        : json["currencies_count"],
  );

  Map<String, dynamic> toJson() => {
    "by_currency": List<dynamic>.from(byCurrency!.map((x) => x.toJson())),
    "accounts_count": accountsCount,
    "currencies_count": currenciesCount,
  };
}

class SnapshotByCurrency {
  final String? accountingCurrencyId;
  final String? currencyCode;
  final int? accountsCount;
  final String? totalReceivable;
  final String? totalPayable;
  final String? netBalance;
  final String? status;

  SnapshotByCurrency({
    this.accountingCurrencyId,
    this.currencyCode,
    this.accountsCount,
    this.totalReceivable,
    this.totalPayable,
    this.netBalance,
    this.status,
  });

  factory SnapshotByCurrency.fromJson(
    Map<String, dynamic> json,
  ) => SnapshotByCurrency(
    accountingCurrencyId: json["accounting_currency_id"] == null
        ? null
        : json["accounting_currency_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"],
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
    "total_receivable": totalReceivable,
    "total_payable": totalPayable,
    "net_balance": netBalance,
    "status": status,
  };
}

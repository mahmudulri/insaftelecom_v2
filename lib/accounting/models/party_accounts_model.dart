import 'dart:convert';

PartyAccountsModel partyAccountsModelFromJson(String str) =>
    PartyAccountsModel.fromJson(json.decode(str));

String partyAccountsModelToJson(PartyAccountsModel data) =>
    json.encode(data.toJson());

class PartyAccountsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  PartyAccountsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory PartyAccountsModel.fromJson(Map<String, dynamic> json) =>
      PartyAccountsModel(
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
  final Accounts? accounts;

  Counterparty({this.accounts});

  factory Counterparty.fromJson(Map<String, dynamic> json) =>
      Counterparty(accounts: Accounts.fromJson(json["accounts"]));

  Map<String, dynamic> toJson() => {"accounts": accounts!.toJson()};
}

class Accounts {
  final List<Datum>? data;
  final Pagination? pagination;

  Accounts({this.data, this.pagination});

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination!.toJson(),
  };
}

class Datum {
  final int? id;
  final String? uuid;
  final String? resellerId;
  final String? counterpartyId;
  final dynamic officeId;
  final dynamic accountingCurrencyId;
  final String? currencyCode;
  final String? accountType;
  final String? name;
  final String? openingBalance;
  final String? currentBalance;
  final dynamic notes;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
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
    currentPage: json["current_page"],
    perPage: json["per_page"],
    totalItems: json["total_items"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total_items": totalItems,
    "total_pages": totalPages,
  };
}

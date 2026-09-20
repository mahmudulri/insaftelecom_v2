import 'dart:convert';

AllAccountsModel AllaccountsModelFromJson(String str) =>
    AllAccountsModel.fromJson(json.decode(str));

String AllaccountsModelToJson(AllAccountsModel data) =>
    json.encode(data.toJson());

class AllAccountsModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  AllAccountsModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory AllAccountsModel.fromJson(Map<String, dynamic> json) =>
      AllAccountsModel(
        success: json["success"] == null ? null : json["success"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        payload: json["payload"] == null
            ? null
            : Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? null : data!.toJson(),
    "payload": payload == null ? null : payload!.toJson(),
  };
}

class Data {
  final List<Account>? accounts;

  Data({this.accounts});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accounts: json["accounts"] == null
        ? null
        : List<Account>.from(json["accounts"].map((x) => Account.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "accounts": accounts == null
        ? null
        : List<dynamic>.from(accounts!.map((x) => x.toJson())),
  };
}

class Account {
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
  final Counterparty? counterparty;
  final Currency? currency;
  final Office? office;

  Account({
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
    this.counterparty,
    this.currency,
    this.office,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
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
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
    deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
    counterparty: json["counterparty"] == null
        ? null
        : Counterparty.fromJson(json["counterparty"]),
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    office: json["office"] == null ? null : Office.fromJson(json["office"]),
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
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
    "counterparty": counterparty == null ? null : counterparty!.toJson(),
    "currency": currency == null ? null : currency!.toJson(),
    "office": office == null ? null : office!.toJson(),
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
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
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
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
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
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
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
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
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
        : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.tryParse(json["updated_at"]),
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
    "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
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

  Map<String, dynamic> toJson() => {
    "pagination": pagination == null ? null : pagination!.toJson(),
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

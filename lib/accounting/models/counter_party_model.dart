import 'dart:convert';

CounterPartyModel counterPartyModelFromJson(String str) =>
    CounterPartyModel.fromJson(json.decode(str));

String counterPartyModelToJson(CounterPartyModel data) =>
    json.encode(data.toJson());

class CounterPartyModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  CounterPartyModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory CounterPartyModel.fromJson(Map<String, dynamic> json) =>
      CounterPartyModel(
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
  final List<Counterparty>? counterparties;

  Data({this.counterparties});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    counterparties: json["counterparties"] == null
        ? null
        : List<Counterparty>.from(
            json["counterparties"].map((x) => Counterparty.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "counterparties": counterparties == null
        ? null
        : List<dynamic>.from(counterparties!.map((x) => x.toJson())),
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
  final DateTime? deletedAt;
  final String? accountsCount;

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
    this.accountsCount,
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
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.tryParse(json["deleted_at"]),
    accountsCount: json["accounts_count"] == null
        ? null
        : json["accounts_count"].toString(),
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
    "deleted_at": deletedAt == null ? null : deletedAt!.toIso8601String(),
    "accounts_count": accountsCount,
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

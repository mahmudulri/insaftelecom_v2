import 'dart:convert';

OfficelistModel OfficelistModelFromJson(String str) =>
    OfficelistModel.fromJson(json.decode(str));

String OfficelistModelToJson(OfficelistModel data) =>
    json.encode(data.toJson());

class OfficelistModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  OfficelistModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory OfficelistModel.fromJson(Map<String, dynamic> json) =>
      OfficelistModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        payload: json["payload"] == null
            ? null
            : List<dynamic>.from(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data!.toJson(),
    "payload": payload,
  };
}

class Data {
  final List<Office>? offices;
  final Pagination? pagination;

  Data({this.offices, this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    offices: json["offices"] == null
        ? null
        : List<Office>.from(json["offices"].map((x) => Office.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "offices": offices == null
        ? null
        : List<dynamic>.from(offices!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
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
  final String? transactionCount;

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
    this.transactionCount,
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
    transactionCount: json["transactions_count"] == null
        ? null
        : json["transactions_count"],
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
    "transactions_count": transactionCount,
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

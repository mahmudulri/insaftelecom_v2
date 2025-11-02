// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

import 'dart:convert';

BranchModel branchModelFromJson(String str) =>
    BranchModel.fromJson(json.decode(str));

String branchModelToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  BranchModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
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
  final List<Hawalabranch>? hawalabranches;

  Data({
    this.hawalabranches,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        hawalabranches: List<Hawalabranch>.from(
            json["hawalabranches"].map((x) => Hawalabranch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hawalabranches":
            List<dynamic>.from(hawalabranches!.map((x) => x.toJson())),
      };
}

class Hawalabranch {
  final int? id;
  final String? name;

  Hawalabranch({
    this.id,
    this.name,
  });

  factory Hawalabranch.fromJson(Map<String, dynamic> json) => Hawalabranch(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Payload {
  final Pagination? pagination;

  Payload({
    this.pagination,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination!.toJson(),
      };
}

class Pagination {
  final int? page;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final int? itemsPerPage;
  final int? total;

  Pagination({
    this.page,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.links,
    this.itemsPerPage,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        itemsPerPage: json["items_per_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "items_per_page": itemsPerPage,
        "total": total,
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;
  final int? page;

  Link({
    this.url,
    this.label,
    this.active,
    this.page,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
        "page": page,
      };
}

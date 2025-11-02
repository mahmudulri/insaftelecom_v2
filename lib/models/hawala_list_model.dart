import 'dart:convert';

HawalaModel hawalaModelFromJson(String str) =>
    HawalaModel.fromJson(json.decode(str));

String hawalaModelToJson(HawalaModel data) => json.encode(data.toJson());

class HawalaModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final List<dynamic>? payload;

  HawalaModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory HawalaModel.fromJson(Map<String, dynamic> json) => HawalaModel(
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
  final List<Order>? orders;
  final Pagination? pagination;

  Data({
    this.orders,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
        "pagination": pagination!.toJson(),
      };
}

class Order {
  final int? id;
  final String? resellerId;
  final dynamic? hawalaBranchId;
  final String? hawalaNumber;
  final dynamic hawalaCustomNumber;
  final String? senderName;
  final String? receiverName;
  final dynamic? receiverFatherName;
  final dynamic? receiverIdCardNumber;
  final String? hawalaAmount;
  final String? hawalaAmountCurrencyId;
  final String? hawalaAmountCurrencyCode;
  final String? hawalaAmountCurrencyRate;
  final String? convertedAmountTakenFromReseller;
  final String? resellerPreferedCurrencyId;
  final String? resellerPreferedCurrencyCode;
  final String? resellerPreferedCurrencyRate;
  final String? commissionAmount;
  final bool? commissionPaidBySender;
  final bool? commissionPaidByReceiver;
  final dynamic? adminCommissionShare;
  final dynamic? branchCommissionShare;
  final dynamic? resellerCommissionShare;
  final String? status;
  final dynamic? adminNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    this.resellerId,
    this.hawalaBranchId,
    this.hawalaNumber,
    this.hawalaCustomNumber,
    this.senderName,
    this.receiverName,
    this.receiverFatherName,
    this.receiverIdCardNumber,
    this.hawalaAmount,
    this.hawalaAmountCurrencyId,
    this.hawalaAmountCurrencyCode,
    this.hawalaAmountCurrencyRate,
    this.convertedAmountTakenFromReseller,
    this.resellerPreferedCurrencyId,
    this.resellerPreferedCurrencyCode,
    this.resellerPreferedCurrencyRate,
    this.commissionAmount,
    this.commissionPaidBySender,
    this.commissionPaidByReceiver,
    this.adminCommissionShare,
    this.branchCommissionShare,
    this.resellerCommissionShare,
    this.status,
    this.adminNote,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] == null ? null : json["id"],
        resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
        hawalaBranchId:
            json["hawala_branch_id"] == null ? null : json["hawala_branch_id"],
        hawalaNumber:
            json["hawala_number"] == null ? null : json["hawala_number"],
        hawalaCustomNumber: json["hawala_custom_number"] == null
            ? null
            : json["hawala_custom_number"],
        senderName: json["sender_name"] == null ? null : json["sender_name"],
        receiverName:
            json["receiver_name"] == null ? null : json["receiver_name"],
        receiverFatherName: json["receiver_father_name"] == null
            ? null
            : json["receiver_father_name"],
        receiverIdCardNumber: json["receiver_id_card_number"] == null
            ? null
            : json["receiver_id_card_number"],
        hawalaAmount:
            json["hawala_amount"] == null ? null : json["hawala_amount"],
        hawalaAmountCurrencyId: json["hawala_amount_currency_id"] == null
            ? null
            : json["hawala_amount_currency_id"],
        hawalaAmountCurrencyCode: json["hawala_amount_currency_code"] == null
            ? null
            : json["hawala_amount_currency_code"],
        hawalaAmountCurrencyRate: json["hawala_amount_currency_rate"] == null
            ? null
            : json["hawala_amount_currency_rate"],
        convertedAmountTakenFromReseller:
            json["converted_amount_taken_from_reseller"] == null
                ? null
                : json["converted_amount_taken_from_reseller"],
        resellerPreferedCurrencyId:
            json["reseller_prefered_currency_id"] == null
                ? null
                : json["reseller_prefered_currency_id"],
        resellerPreferedCurrencyCode:
            json["reseller_prefered_currency_code"] == null
                ? null
                : json["reseller_prefered_currency_code"],
        resellerPreferedCurrencyRate:
            json["reseller_prefered_currency_rate"] == null
                ? null
                : json["reseller_prefered_currency_rate"],
        commissionAmount: json["commission_amount"] == null
            ? null
            : json["commission_amount"],
        commissionPaidBySender: json["commission_paid_by_sender"] == null
            ? null
            : json["commission_paid_by_sender"],
        commissionPaidByReceiver: json["commission_paid_by_receiver"] == null
            ? null
            : json["commission_paid_by_receiver"],
        adminCommissionShare: json["admin_commission_share"] == null
            ? null
            : json["admin_commission_share"],
        branchCommissionShare: json["branch_commission_share"] == null
            ? null
            : json["branch_commission_share"],
        resellerCommissionShare: json["reseller_commission_share"] == null
            ? null
            : json["reseller_commission_share"],
        status: json["status"] == null ? null : json["status"],
        adminNote: json["admin_note"] == null ? null : json["admin_note"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reseller_id": resellerId,
        "hawala_branch_id": hawalaBranchId,
        "hawala_number": hawalaNumber,
        "hawala_custom_number": hawalaCustomNumber,
        "sender_name": senderName,
        "receiver_name": receiverName,
        "receiver_father_name": receiverFatherName,
        "receiver_id_card_number": receiverIdCardNumber,
        "hawala_amount": hawalaAmount,
        "hawala_amount_currency_id": hawalaAmountCurrencyId,
        "hawala_amount_currency_code": hawalaAmountCurrencyCode,
        "hawala_amount_currency_rate": hawalaAmountCurrencyRate,
        "converted_amount_taken_from_reseller":
            convertedAmountTakenFromReseller,
        "reseller_prefered_currency_id": resellerPreferedCurrencyId,
        "reseller_prefered_currency_code": resellerPreferedCurrencyCode,
        "reseller_prefered_currency_rate": resellerPreferedCurrencyRate,
        "commission_amount": commissionAmount,
        "commission_paid_by_sender": commissionPaidBySender,
        "commission_paid_by_receiver": commissionPaidByReceiver,
        "admin_commission_share": adminCommissionShare,
        "branch_commission_share": branchCommissionShare,
        "reseller_commission_share": resellerCommissionShare,
        "status": status,
        "admin_note": adminNote,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
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

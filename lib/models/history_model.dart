import 'dart:convert';

HistoryModel HistoryModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String HistoryModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;
  final Payload? payload;

  HistoryModel({
    this.success,
    this.code,
    this.message,
    this.data,
    this.payload,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    success: json["success"] == null ? null : json["success"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"].toString(),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data?.toJson(),
    "payload": payload?.toJson(),
  };
}

class Data {
  final List<Order> orders;

  Data({required this.orders});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orders: json["orders"] == null
        ? []
        : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}

class Order {
  final int? id;
  final dynamic resellerId;

  final dynamic walletId;
  final dynamic walletCurrencyId;
  final String? walletDeductionMode;
  final String? walletDeductedAmount;
  final String? walletExchangeRateSnapshot;

  final String? rechargebleAccount;

  final Bundle? bundle;

  final String? discountAmount;
  final String? discountedPrice;
  final dynamic discountType;
  final dynamic discountSourceId;
  final dynamic discountSourceType;

  final bool? isCustomRecharge;
  final String? orderType;

  final dynamic transactionId;
  final dynamic refundTransactionId;
  final dynamic providerTransactionId;
  final dynamic smlUserNameUsed;

  final dynamic isPaid;
  final dynamic status;
  final dynamic rejectReason;

  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final dynamic performedBy;

  final String? vpnActivationQrCodeImage;
  final String? vpnActivationLink;

  final dynamic apiProviderId;
  final dynamic providerStatus;
  final dynamic providerTransId;
  final dynamic providerOrderCode;

  final dynamic voucherId;
  final dynamic voucherUsed;

  final dynamic playerId;

  final String? chargedAmount;
  final Currency? chargedCurrency;

  final bool? hasWalletSnapshot;
  final PaymentSnapshot? paymentSnapshot;

  final String? performedByName;

  Order({
    this.id,
    this.resellerId,
    this.walletId,
    this.walletCurrencyId,
    this.walletDeductionMode,
    this.walletDeductedAmount,
    this.walletExchangeRateSnapshot,
    this.rechargebleAccount,
    this.bundle,
    this.discountAmount,
    this.discountedPrice,
    this.discountType,
    this.discountSourceId,
    this.discountSourceType,
    this.isCustomRecharge,
    this.orderType,
    this.transactionId,
    this.refundTransactionId,
    this.providerTransactionId,
    this.smlUserNameUsed,
    this.isPaid,
    this.status,
    this.rejectReason,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.performedBy,
    this.vpnActivationQrCodeImage,
    this.vpnActivationLink,
    this.apiProviderId,
    this.providerStatus,
    this.providerTransId,
    this.providerOrderCode,
    this.voucherId,
    this.voucherUsed,
    this.playerId,
    this.chargedAmount,
    this.chargedCurrency,
    this.hasWalletSnapshot,
    this.paymentSnapshot,
    this.performedByName,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? null : json["id"],
    resellerId: json["reseller_id"] == null ? null : json["reseller_id"],
    walletId: json["wallet_id"] == null ? null : json["wallet_id"],
    walletCurrencyId: json["wallet_currency_id"] == null
        ? null
        : json["wallet_currency_id"],
    walletDeductionMode: json["wallet_deduction_mode"] == null
        ? null
        : json["wallet_deduction_mode"].toString(),
    walletDeductedAmount: json["wallet_deducted_amount"] == null
        ? null
        : json["wallet_deducted_amount"].toString(),
    walletExchangeRateSnapshot: json["wallet_exchange_rate_snapshot"] == null
        ? null
        : json["wallet_exchange_rate_snapshot"].toString(),
    rechargebleAccount: json["rechargeble_account"] == null
        ? null
        : json["rechargeble_account"].toString(),
    bundle: json["bundle"] == null ? null : Bundle.fromJson(json["bundle"]),
    discountAmount: json["discount_amount"] == null
        ? null
        : json["discount_amount"].toString(),
    discountedPrice: json["discounted_price"] == null
        ? null
        : json["discounted_price"].toString(),
    discountType: json["discount_type"] == null ? null : json["discount_type"],
    discountSourceId: json["discount_source_id"] == null
        ? null
        : json["discount_source_id"],
    discountSourceType: json["discount_source_type"] == null
        ? null
        : json["discount_source_type"],
    isCustomRecharge: json["is_custom_recharge"] == null
        ? null
        : json["is_custom_recharge"] is bool
        ? json["is_custom_recharge"]
        : json["is_custom_recharge"].toString().toLowerCase() == "true",
    orderType: json["order_type"] == null
        ? null
        : json["order_type"].toString(),
    transactionId: json["transaction_id"] == null
        ? null
        : json["transaction_id"],
    refundTransactionId: json["refund_transaction_id"] == null
        ? null
        : json["refund_transaction_id"],
    providerTransactionId: json["provider_transaction_id"] == null
        ? null
        : json["provider_transaction_id"],
    smlUserNameUsed: json["sml_user_name_used"] == null
        ? null
        : json["sml_user_name_used"],
    isPaid: json["is_paid"] == null ? null : json["is_paid"],
    status: json["status"] == null ? null : json["status"],
    rejectReason: json["reject_reason"] == null ? null : json["reject_reason"],
    deletedAt: json["deleted_at"] == null
        ? null
        : DateTime.parse(json["deleted_at"].toString()),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"].toString()),
    performedBy: json["performed_by"] == null ? null : json["performed_by"],
    vpnActivationQrCodeImage: json["vpn_activation_qr_code_image"] == null
        ? null
        : json["vpn_activation_qr_code_image"].toString(),
    vpnActivationLink: json["vpn_activation_link"] == null
        ? null
        : json["vpn_activation_link"].toString(),
    apiProviderId: json["api_provider_id"] == null
        ? null
        : json["api_provider_id"],
    providerStatus: json["provider_status"] == null
        ? null
        : json["provider_status"],
    providerTransId: json["provider_trans_id"] == null
        ? null
        : json["provider_trans_id"],
    providerOrderCode: json["provider_order_code"] == null
        ? null
        : json["provider_order_code"],
    voucherId: json["voucher_id"] == null ? null : json["voucher_id"],
    voucherUsed: json["voucher_used"] == null ? null : json["voucher_used"],
    playerId: json["player_id"] == null ? null : json["player_id"],
    chargedAmount: json["charged_amount"] == null
        ? null
        : json["charged_amount"].toString(),
    chargedCurrency: json["charged_currency"] == null
        ? null
        : Currency.fromJson(json["charged_currency"]),
    hasWalletSnapshot: json["has_wallet_snapshot"] == null
        ? null
        : json["has_wallet_snapshot"],
    paymentSnapshot: json["payment_snapshot"] == null
        ? null
        : PaymentSnapshot.fromJson(json["payment_snapshot"]),
    performedByName: json["performed_by_name"] == null
        ? null
        : json["performed_by_name"].toString(),
  );

  Order copyWith({
    int? id,
    dynamic resellerId,
    dynamic walletId,
    dynamic walletCurrencyId,
    String? walletDeductionMode,
    String? walletDeductedAmount,
    String? walletExchangeRateSnapshot,
    String? rechargebleAccount,
    Bundle? bundle,
    String? discountAmount,
    String? discountedPrice,
    dynamic discountType,
    dynamic discountSourceId,
    dynamic discountSourceType,
    bool? isCustomRecharge,
    String? orderType,
    dynamic transactionId,
    dynamic refundTransactionId,
    dynamic providerTransactionId,
    dynamic smlUserNameUsed,
    dynamic isPaid,
    dynamic status,
    dynamic rejectReason,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic performedBy,
    String? vpnActivationQrCodeImage,
    String? vpnActivationLink,
    dynamic apiProviderId,
    dynamic providerStatus,
    dynamic providerTransId,
    dynamic providerOrderCode,
    dynamic voucherId,
    dynamic voucherUsed,
    dynamic playerId,
    String? chargedAmount,
    Currency? chargedCurrency,
    bool? hasWalletSnapshot,
    PaymentSnapshot? paymentSnapshot,
    String? performedByName,
  }) {
    return Order(
      id: id ?? this.id,
      resellerId: resellerId ?? this.resellerId,
      walletId: walletId ?? this.walletId,
      walletCurrencyId: walletCurrencyId ?? this.walletCurrencyId,
      walletDeductionMode: walletDeductionMode ?? this.walletDeductionMode,
      walletDeductedAmount: walletDeductedAmount ?? this.walletDeductedAmount,
      walletExchangeRateSnapshot:
          walletExchangeRateSnapshot ?? this.walletExchangeRateSnapshot,
      rechargebleAccount: rechargebleAccount ?? this.rechargebleAccount,
      bundle: bundle ?? this.bundle,
      discountAmount: discountAmount ?? this.discountAmount,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountType: discountType ?? this.discountType,
      discountSourceId: discountSourceId ?? this.discountSourceId,
      discountSourceType: discountSourceType ?? this.discountSourceType,
      isCustomRecharge: isCustomRecharge ?? this.isCustomRecharge,
      orderType: orderType ?? this.orderType,
      transactionId: transactionId ?? this.transactionId,
      refundTransactionId: refundTransactionId ?? this.refundTransactionId,
      providerTransactionId:
          providerTransactionId ?? this.providerTransactionId,
      smlUserNameUsed: smlUserNameUsed ?? this.smlUserNameUsed,
      isPaid: isPaid ?? this.isPaid,
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      performedBy: performedBy ?? this.performedBy,
      vpnActivationQrCodeImage:
          vpnActivationQrCodeImage ?? this.vpnActivationQrCodeImage,
      vpnActivationLink: vpnActivationLink ?? this.vpnActivationLink,
      apiProviderId: apiProviderId ?? this.apiProviderId,
      providerStatus: providerStatus ?? this.providerStatus,
      providerTransId: providerTransId ?? this.providerTransId,
      providerOrderCode: providerOrderCode ?? this.providerOrderCode,
      voucherId: voucherId ?? this.voucherId,
      voucherUsed: voucherUsed ?? this.voucherUsed,
      playerId: playerId ?? this.playerId,
      chargedAmount: chargedAmount ?? this.chargedAmount,
      chargedCurrency: chargedCurrency ?? this.chargedCurrency,
      hasWalletSnapshot: hasWalletSnapshot ?? this.hasWalletSnapshot,
      paymentSnapshot: paymentSnapshot ?? this.paymentSnapshot,
      performedByName: performedByName ?? this.performedByName,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "reseller_id": resellerId,
    "wallet_id": walletId,
    "wallet_currency_id": walletCurrencyId,
    "wallet_deduction_mode": walletDeductionMode,
    "wallet_deducted_amount": walletDeductedAmount,
    "wallet_exchange_rate_snapshot": walletExchangeRateSnapshot,
    "rechargeble_account": rechargebleAccount,
    "bundle": bundle?.toJson(),
    "discount_amount": discountAmount,
    "discounted_price": discountedPrice,
    "discount_type": discountType,
    "discount_source_id": discountSourceId,
    "discount_source_type": discountSourceType,
    "is_custom_recharge": isCustomRecharge,
    "order_type": orderType,
    "transaction_id": transactionId,
    "refund_transaction_id": refundTransactionId,
    "provider_transaction_id": providerTransactionId,
    "sml_user_name_used": smlUserNameUsed,
    "is_paid": isPaid,
    "status": status,
    "reject_reason": rejectReason,
    "deleted_at": deletedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "performed_by": performedBy,
    "vpn_activation_qr_code_image": vpnActivationQrCodeImage,
    "vpn_activation_link": vpnActivationLink,
    "api_provider_id": apiProviderId,
    "provider_status": providerStatus,
    "provider_trans_id": providerTransId,
    "provider_order_code": providerOrderCode,
    "voucher_id": voucherId,
    "voucher_used": voucherUsed,
    "player_id": playerId,
    "charged_amount": chargedAmount,
    "charged_currency": chargedCurrency?.toJson(),
    "has_wallet_snapshot": hasWalletSnapshot,
    "payment_snapshot": paymentSnapshot?.toJson(),
    "performed_by_name": performedByName,
  };
}

class Bundle {
  final int? id;
  final String? bundleCode;
  final dynamic serviceId;

  final String? bundleTitle;
  final String? bundleDescription;
  final String? bundleType;
  final String? validityType;

  final String? isCustomRecharge;
  final String? amount;

  final String? buyingPrice;
  final String? adminBuyingPrice;
  final String? discountedPrice;
  final String? subResellerComissionAppliedBuyingPrice;
  final String? sellingPrice;

  final dynamic currencyId;

  final bool? hasParentComissionGroup;
  final String? subResellerAppliedComissionAmount;

  final DateTime? createdAt;

  final Currency? preferedCurrency;
  final Service? service;
  final Currency? currency;

  Bundle({
    this.id,
    this.bundleCode,
    this.serviceId,
    this.bundleTitle,
    this.bundleDescription,
    this.bundleType,
    this.validityType,
    this.isCustomRecharge,
    this.amount,
    this.buyingPrice,
    this.adminBuyingPrice,
    this.discountedPrice,
    this.subResellerComissionAppliedBuyingPrice,
    this.sellingPrice,
    this.currencyId,
    this.hasParentComissionGroup,
    this.subResellerAppliedComissionAmount,
    this.createdAt,
    this.preferedCurrency,
    this.service,
    this.currency,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
    id: json["id"] == null ? null : json["id"],
    bundleCode: json["bundle_code"] == null
        ? null
        : json["bundle_code"].toString(),
    serviceId: json["service_id"] == null ? null : json["service_id"],
    bundleTitle: json["bundle_title"] == null
        ? null
        : json["bundle_title"].toString(),
    bundleDescription: json["bundle_description"] == null
        ? null
        : json["bundle_description"].toString(),
    bundleType: json["bundle_type"] == null
        ? null
        : json["bundle_type"].toString(),
    validityType: json["validity_type"] == null
        ? null
        : json["validity_type"].toString(),
    isCustomRecharge: json["is_custom_recharge"] == null
        ? null
        : json["is_custom_recharge"].toString(),
    amount: json["amount"] == null ? null : json["amount"].toString(),

    // FIX: int/double/String সব handle করবে
    buyingPrice: json["buying_price"] == null
        ? null
        : json["buying_price"].toString(),

    adminBuyingPrice: json["admin_buying_price"] == null
        ? null
        : json["admin_buying_price"].toString(),

    discountedPrice: json["discounted_price"] == null
        ? null
        : json["discounted_price"].toString(),

    subResellerComissionAppliedBuyingPrice:
        json["sub_reseller_comission_applied_buying_price"] == null
        ? null
        : json["sub_reseller_comission_applied_buying_price"].toString(),

    sellingPrice: json["selling_price"] == null
        ? null
        : json["selling_price"].toString(),

    currencyId: json["currency_id"] == null ? null : json["currency_id"],

    hasParentComissionGroup: json["has_parent_comission_group"] == null
        ? null
        : json["has_parent_comission_group"],

    subResellerAppliedComissionAmount:
        json["sub_reseller_applied_comission_amount"] == null
        ? null
        : json["sub_reseller_applied_comission_amount"].toString(),

    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"].toString()),

    preferedCurrency: json["prefered_currency"] == null
        ? null
        : Currency.fromJson(json["prefered_currency"]),

    service: json["service"] == null ? null : Service.fromJson(json["service"]),

    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bundle_code": bundleCode,
    "service_id": serviceId,
    "bundle_title": bundleTitle,
    "bundle_description": bundleDescription,
    "bundle_type": bundleType,
    "validity_type": validityType,
    "is_custom_recharge": isCustomRecharge,
    "amount": amount,
    "buying_price": buyingPrice,
    "admin_buying_price": adminBuyingPrice,
    "discounted_price": discountedPrice,
    "sub_reseller_comission_applied_buying_price":
        subResellerComissionAppliedBuyingPrice,
    "selling_price": sellingPrice,
    "currency_id": currencyId,
    "has_parent_comission_group": hasParentComissionGroup,
    "sub_reseller_applied_comission_amount": subResellerAppliedComissionAmount,
    "created_at": createdAt?.toIso8601String(),
    "prefered_currency": preferedCurrency?.toJson(),
    "service": service?.toJson(),
    "currency": currency?.toJson(),
  };
}

class Currency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;

  final String? ignoreDigitsCount;
  final String? exchangeRatePerUsd;

  Currency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.ignoreDigitsCount,
    this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"].toString(),
    code: json["code"] == null ? null : json["code"].toString(),
    symbol: json["symbol"] == null ? null : json["symbol"].toString(),
    ignoreDigitsCount: json["ignore_digits_count"] == null
        ? null
        : json["ignore_digits_count"].toString(),

    // FIX: double/int/String সব handle করবে
    exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
        ? null
        : json["exchange_rate_per_usd"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "ignore_digits_count": ignoreDigitsCount,
    "exchange_rate_per_usd": exchangeRatePerUsd,
  };
}

class Service {
  final int? id;
  final dynamic serviceCategoryId;
  final dynamic companyId;

  final ServiceCategory? serviceCategory;
  final Company? company;

  Service({
    this.id,
    this.serviceCategoryId,
    this.companyId,
    this.serviceCategory,
    this.company,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"] == null ? null : json["id"],
    serviceCategoryId: json["service_category_id"] == null
        ? null
        : json["service_category_id"],
    companyId: json["company_id"] == null ? null : json["company_id"],
    serviceCategory: json["service_category"] == null
        ? null
        : ServiceCategory.fromJson(json["service_category"]),
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_category_id": serviceCategoryId,
    "company_id": companyId,
    "service_category": serviceCategory?.toJson(),
    "company": company?.toJson(),
  };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;
  final dynamic countryId;

  Company({this.id, this.companyName, this.companyLogo, this.countryId});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] == null ? null : json["id"],
    companyName: json["company_name"] == null
        ? null
        : json["company_name"].toString(),
    companyLogo: json["company_logo"] == null
        ? null
        : json["company_logo"].toString(),
    countryId: json["country_id"] == null ? null : json["country_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "company_logo": companyLogo,
    "country_id": countryId,
  };
}

class ServiceCategory {
  final int? id;
  final String? categoryName;
  final String? type;

  ServiceCategory({this.id, this.categoryName, this.type});

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"] == null ? null : json["id"],
        categoryName: json["category_name"] == null
            ? null
            : json["category_name"].toString(),
        type: json["type"] == null ? null : json["type"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_name": categoryName,
    "type": type,
  };
}

class PaymentSnapshot {
  final dynamic walletId;
  final dynamic walletCurrencyId;

  final String? walletDeductionMode;
  final String? walletDeductedAmount;
  final String? walletExchangeRateSnapshot;

  PaymentSnapshot({
    this.walletId,
    this.walletCurrencyId,
    this.walletDeductionMode,
    this.walletDeductedAmount,
    this.walletExchangeRateSnapshot,
  });

  factory PaymentSnapshot.fromJson(Map<String, dynamic> json) =>
      PaymentSnapshot(
        walletId: json["wallet_id"] == null ? null : json["wallet_id"],
        walletCurrencyId: json["wallet_currency_id"] == null
            ? null
            : json["wallet_currency_id"],
        walletDeductionMode: json["wallet_deduction_mode"] == null
            ? null
            : json["wallet_deduction_mode"].toString(),
        walletDeductedAmount: json["wallet_deducted_amount"] == null
            ? null
            : json["wallet_deducted_amount"].toString(),
        walletExchangeRateSnapshot:
            json["wallet_exchange_rate_snapshot"] == null
            ? null
            : json["wallet_exchange_rate_snapshot"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "wallet_id": walletId,
    "wallet_currency_id": walletCurrencyId,
    "wallet_deduction_mode": walletDeductionMode,
    "wallet_deducted_amount": walletDeductedAmount,
    "wallet_exchange_rate_snapshot": walletExchangeRateSnapshot,
  };
}

class Payload {
  final Pagination pagination;

  Payload({required this.pagination});

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    pagination: json["pagination"] == null
        ? Pagination()
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {"pagination": pagination.toJson()};
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
    currentPage: json["current_page"] == null
        ? null
        : int.tryParse(json["current_page"].toString()),
    perPage: json["per_page"] == null
        ? null
        : int.tryParse(json["per_page"].toString()),
    totalItems: json["total_items"] == null
        ? null
        : int.tryParse(json["total_items"].toString()),
    totalPages: json["total_pages"] == null
        ? null
        : int.tryParse(json["total_pages"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total_items": totalItems,
    "total_pages": totalPages,
  };
}

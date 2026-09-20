import 'dart:convert';

BundleModel bundleModelFromJson(String str) =>
    BundleModel.fromJson(json.decode(str));

String bundleModelToJson(BundleModel data) => json.encode(data.toJson());

class BundleModel {
  final bool? success;
  final Data? data;
  final Payload? payload;

  BundleModel({this.success, this.data, this.payload});

  factory BundleModel.fromJson(Map<String, dynamic> json) => BundleModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "payload": payload?.toJson(),
  };
}

class Data {
  final List<Bundle>? bundles;

  Data({this.bundles});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bundles: json["bundles"] == null
        ? null
        : List<Bundle>.from(json["bundles"].map((x) => Bundle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bundles": bundles == null
        ? null
        : List<dynamic>.from(bundles!.map((x) => x.toJson())),
  };
}

class Bundle {
  final int? id;
  final String? bundleCode;
  final String? bundleTitle;
  final String? bundleDescription;
  final String? validityType;
  final String? adminBuyingPrice;
  final String? buyingPrice;
  final String? sellingPrice;

  final Service? service;
  final Currency? currency;
  final DisplayCurrency? displayCurrency;

  Bundle({
    this.id,
    this.bundleCode,
    this.bundleTitle,
    this.bundleDescription,
    this.validityType,
    this.adminBuyingPrice,
    this.buyingPrice,
    this.sellingPrice,
    this.service,
    this.currency,
    this.displayCurrency,
  });

  /// ------------------------------------------------------------
  /// SAFE CURRENCY GETTERS
  ///
  /// API may return:
  ///   currency
  ///
  /// and sometimes may return:
  ///   display_currency
  ///
  /// display_currency has priority.
  /// If it is null, normal currency will be used.
  /// ------------------------------------------------------------

  String get currencyCode => displayCurrency?.code ?? currency?.code ?? '';

  String get currencySymbol =>
      displayCurrency?.symbol ?? currency?.symbol ?? currency?.code ?? '';

  String get currencyName => displayCurrency?.name ?? currency?.name ?? '';

  String get currencyExchangeRate =>
      displayCurrency?.exchangeRatePerUsd ?? currency?.exchangeRatePerUsd ?? '';

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
    id: json["id"] == null ? null : json["id"],
    bundleCode: json["bundle_code"] == null ? null : json["bundle_code"],
    bundleTitle: json["bundle_title"] == null ? null : json["bundle_title"],
    bundleDescription: json["bundle_description"] == null
        ? null
        : json["bundle_description"],
    validityType: json["validity_type"] == null ? null : json["validity_type"],
    adminBuyingPrice: json["admin_buying_price"] == null
        ? null
        : json["admin_buying_price"].toString(),
    buyingPrice: json["buying_price"] == null
        ? null
        : json["buying_price"].toString(),
    sellingPrice: json["selling_price"] == null
        ? null
        : json["selling_price"].toString(),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    displayCurrency: json["display_currency"] == null
        ? null
        : DisplayCurrency.fromJson(json["display_currency"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bundle_code": bundleCode,
    "bundle_title": bundleTitle,
    "bundle_description": bundleDescription,
    "validity_type": validityType,
    "admin_buying_price": adminBuyingPrice,
    "buying_price": buyingPrice,
    "selling_price": sellingPrice,
    "service": service?.toJson(),
    "currency": currency?.toJson(),
    "display_currency": displayCurrency?.toJson(),
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
  final ServiceCategory? serviceCategory;
  final Company? company;

  Service({this.id, this.serviceCategory, this.company});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"] == null ? null : json["id"],
    serviceCategory: json["service_category"] == null
        ? null
        : ServiceCategory.fromJson(json["service_category"]),
    company: json["company"] == null ? null : Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_category": serviceCategory?.toJson(),
    "company": company?.toJson(),
  };
}

class Company {
  final int? id;
  final String? companyName;
  final String? companyLogo;

  Company({this.id, this.companyName, this.companyLogo});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] == null ? null : json["id"],
    companyName: json["company_name"] == null
        ? null
        : json["company_name"].toString(),
    companyLogo: json["company_logo"] == null
        ? null
        : json["company_logo"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "company_logo": companyLogo,
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

class DisplayCurrency {
  final int? id;
  final String? name;
  final String? code;
  final String? symbol;
  final String? ignoreDigitsCount;
  final String? exchangeRatePerUsd;

  DisplayCurrency({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.ignoreDigitsCount,
    this.exchangeRatePerUsd,
  });

  factory DisplayCurrency.fromJson(Map<String, dynamic> json) =>
      DisplayCurrency(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"].toString(),
        code: json["code"] == null ? null : json["code"].toString(),
        symbol: json["symbol"] == null ? null : json["symbol"].toString(),
        ignoreDigitsCount: json["ignore_digits_count"] == null
            ? null
            : json["ignore_digits_count"].toString(),
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
  final int? totalItems;
  final int? totalPages;

  Pagination({this.currentPage, this.totalItems, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: _toInt(json["current_page"]),
    totalItems: _toInt(json["total_items"]),
    totalPages: _toInt(json["total_pages"]),
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "total_items": totalItems,
    "total_pages": totalPages,
  };
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

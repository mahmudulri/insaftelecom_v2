import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) =>
    DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) =>
    json.encode(data.toJson());

class DashboardDataModel {
  final bool? success;

  final String? message;
  final Data? data;

  DashboardDataModel({this.success, this.message, this.data});

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  final UserInfo? userInfo;
  final List<AdvertisementSlider>? advertisementSliders;

  // =========================
  // NEW WALLET FIELDS
  // =========================
  final Wallet? activeWallet;
  final List<Wallet>? wallets;

  final dynamic? balance;
  final dynamic? loanBalance;
  final dynamic? totalSoldAmount;
  final dynamic? totalRevenue;
  final dynamic? todaySale;
  final dynamic? todayProfit;
  final String? resellerGroup;

  Data({
    this.userInfo,
    this.advertisementSliders,
    this.activeWallet,
    this.wallets,
    this.balance,
    this.loanBalance,
    this.totalSoldAmount,
    this.totalRevenue,
    this.todaySale,
    this.todayProfit,
    this.resellerGroup,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userInfo: UserInfo.fromJson(json["user_info"]),
    advertisementSliders: List<AdvertisementSlider>.from(
      json["advertisement_sliders"].map((x) => AdvertisementSlider.fromJson(x)),
    ),

    // =========================
    // NEW ACTIVE WALLET
    // =========================
    activeWallet: json["active_wallet"] == null
        ? null
        : Wallet.fromJson(json["active_wallet"]),

    // =========================
    // NEW WALLETS LIST
    // =========================
    wallets: json["wallets"] == null
        ? null
        : List<Wallet>.from(json["wallets"].map((x) => Wallet.fromJson(x))),

    balance: json["balance"] == null ? null : json["balance"],
    loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
    totalSoldAmount: json["total_sold_amount"] == null
        ? null
        : json["total_sold_amount"],
    totalRevenue: json["total_revenue"] == null ? null : json["total_revenue"],
    todaySale: json["today_sale"] == null ? null : json["today_sale"],
    todayProfit: json["today_profit"] == null ? null : json["today_profit"],
    resellerGroup: json["reseller_group"] == null
        ? null
        : json["reseller_group"],
  );

  Map<String, dynamic> toJson() => {
    "user_info": userInfo!.toJson(),
    "advertisement_sliders": List<dynamic>.from(
      advertisementSliders!.map((x) => x.toJson()),
    ),

    // =========================
    // NEW WALLET FIELDS
    // =========================
    "active_wallet": activeWallet?.toJson(),
    "wallets": wallets == null
        ? null
        : List<dynamic>.from(wallets!.map((x) => x.toJson())),

    "balance": balance,
    "loan_balance": loanBalance,
    "total_sold_amount": totalSoldAmount,
    "total_revenue": totalRevenue,
    "today_sale": todaySale,
    "today_profit": todayProfit,
    "reseller_group": resellerGroup,
  };
}

// ============================================================
// WALLET
// Used for both:
// active_wallet
// wallets
// ============================================================

class Wallet {
  final dynamic? walletId;
  final Currency? currency;
  final String? balance;
  final String? payment;
  final String? availablePayment;
  final String? outstandingLoan;
  final String? earningBalance;
  final String? totalHawalaSent;
  final String? totalHawalaReceived;
  final bool? isDefault;
  final bool? isActive;
  final Report? report;

  Wallet({
    this.walletId,
    this.currency,
    this.balance,
    this.payment,
    this.availablePayment,
    this.outstandingLoan,
    this.earningBalance,
    this.totalHawalaSent,
    this.totalHawalaReceived,
    this.isDefault,
    this.isActive,
    this.report,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    walletId: json["wallet_id"] == null ? null : json["wallet_id"],
    currency: json["currency"] == null
        ? null
        : Currency.fromJson(json["currency"]),
    balance: json["balance"] == null ? null : json["balance"],
    payment: json["payment"] == null ? null : json["payment"],
    availablePayment: json["available_payment"] == null
        ? null
        : json["available_payment"],
    outstandingLoan: json["outstanding_loan"] == null
        ? null
        : json["outstanding_loan"],
    earningBalance: json["earning_balance"] == null
        ? null
        : json["earning_balance"],
    totalHawalaSent: json["total_hawala_sent"] == null
        ? null
        : json["total_hawala_sent"],
    totalHawalaReceived: json["total_hawala_received"] == null
        ? null
        : json["total_hawala_received"],
    isDefault: json["is_default"] == null ? null : json["is_default"],
    isActive: json["is_active"] == null ? null : json["is_active"],
    report: json["report"] == null ? null : Report.fromJson(json["report"]),
  );

  Map<String, dynamic> toJson() => {
    "wallet_id": walletId,
    "currency": currency?.toJson(),
    "balance": balance,
    "payment": payment,
    "available_payment": availablePayment,
    "outstanding_loan": outstandingLoan,
    "earning_balance": earningBalance,
    "total_hawala_sent": totalHawalaSent,
    "total_hawala_received": totalHawalaReceived,
    "is_default": isDefault,
    "is_active": isActive,
    "report": report?.toJson(),
  };
}

// ============================================================
// CURRENCY
// ============================================================

class Currency {
  final dynamic? id;
  final String? code;
  final String? symbol;
  final String? name;
  final String? exchangeRatePerUsd;

  Currency({
    this.id,
    this.code,
    this.symbol,
    this.name,
    this.exchangeRatePerUsd,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    symbol: json["symbol"] == null ? null : json["symbol"],
    name: json["name"] == null ? null : json["name"],
    exchangeRatePerUsd: json["exchange_rate_per_usd"] == null
        ? null
        : json["exchange_rate_per_usd"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "symbol": symbol,
    "name": name,
    "exchange_rate_per_usd": exchangeRatePerUsd,
  };
}

// ============================================================
// WALLET REPORT
// ============================================================

class Report {
  final dynamic? totalOrders;
  final dynamic? todayOrders;
  final dynamic? totalSale;
  final dynamic? totalProfit;
  final dynamic? todaySale;
  final dynamic? todayProfit;
  final Currency? reportingCurrency;

  Report({
    this.totalOrders,
    this.todayOrders,
    this.totalSale,
    this.totalProfit,
    this.todaySale,
    this.todayProfit,
    this.reportingCurrency,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    totalOrders: json["total_orders"] == null ? null : json["total_orders"],
    todayOrders: json["today_orders"] == null ? null : json["today_orders"],
    totalSale: json["total_sale"] == null ? null : json["total_sale"],
    totalProfit: json["total_profit"] == null ? null : json["total_profit"],
    todaySale: json["today_sale"] == null ? null : json["today_sale"],
    todayProfit: json["today_profit"] == null ? null : json["today_profit"],
    reportingCurrency: json["reporting_currency"] == null
        ? null
        : Currency.fromJson(json["reporting_currency"]),
  );

  Map<String, dynamic> toJson() => {
    "total_orders": totalOrders,
    "today_orders": todayOrders,
    "total_sale": totalSale,
    "total_profit": totalProfit,
    "today_sale": todaySale,
    "today_profit": todayProfit,
    "reporting_currency": reportingCurrency?.toJson(),
  };
}

class AdvertisementSlider {
  final dynamic? id;
  final String? advertisementTitle;
  final String? adSliderImageUrl;

  AdvertisementSlider({
    this.id,
    this.advertisementTitle,
    this.adSliderImageUrl,
  });

  factory AdvertisementSlider.fromJson(Map<String, dynamic> json) =>
      AdvertisementSlider(
        id: json["id"],
        advertisementTitle: json["advertisement_title"] == null
            ? null
            : json["advertisement_title"],
        adSliderImageUrl: json["ad_slider_image_url"] == null
            ? null
            : json["ad_slider_image_url"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "advertisement_title": advertisementTitle,
    "ad_slider_image_url": adSliderImageUrl,
  };
}

class UserInfo {
  final dynamic? id;
  final dynamic? userId;

  final String? resellerName;
  final String? contactName;
  final String? resellerType;

  final String? profileImageUrl;
  final String? email;
  final String? phone;
  final dynamic? countryId;
  final dynamic? provinceId;
  final dynamic? districtsId;
  final dynamic? isResellerVerified;
  final dynamic? status;
  final dynamic? balance;
  final dynamic? loanBalance;
  final String? totalearning;

  UserInfo({
    this.id,
    this.userId,
    this.resellerName,
    this.contactName,
    this.resellerType,
    this.profileImageUrl,
    this.email,
    this.phone,
    this.countryId,
    this.provinceId,
    this.districtsId,
    this.isResellerVerified,
    this.status,
    this.balance,
    this.loanBalance,
    this.totalearning,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    resellerName: json["reseller_name"] == null ? null : json["reseller_name"],
    contactName: json["contact_name"] == null ? null : json["contact_name"],
    resellerType: json["reseller_type"] == null ? null : json["reseller_type"],
    profileImageUrl: json["profile_image_url"] == null
        ? null
        : json["profile_image_url"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    countryId: json["country_id"] == null ? null : json["country_id"],
    provinceId: json["province_id"] == null ? null : json["province_id"],
    districtsId: json["districts_id"] == null ? null : json["districts_id"],
    isResellerVerified: json["is_reseller_verified"] == null
        ? null
        : json["is_reseller_verified"],
    status: json["status"] == null ? null : json["status"],
    balance: json["balance"] == null ? null : json["balance"],
    loanBalance: json["loan_balance"] == null ? null : json["loan_balance"],
    totalearning: json["total_earning_balance"] == null
        ? null
        : json["total_earning_balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "reseller_name": resellerName,
    "contact_name": contactName,
    "reseller_type": resellerType,
    "profile_image_url": profileImageUrl,
    "email": email,
    "phone": phone,
    "country_id": countryId,
    "province_id": provinceId,
    "districts_id": districtsId,
    "is_reseller_verified": isResellerVerified,
    "status": status,
    "balance": balance,
    "loan_balance": loanBalance,
    "total_earning_balance": totalearning,
  };
}

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/walletsettings_model.dart';
import '../utils/api_endpoints.dart';

class WalletSettingsApi {
  final GetStorage box = GetStorage();

  String get _token => box.read("userToken")?.toString() ?? "";

  Uri _buildWalletSettingsUrl(String endpoint) {
    final String baseUrl = ApiEndPoints.baseUrl.replaceAll(RegExp(r'/+$'), '');

    final String cleanEndpoint = endpoint.replaceAll(RegExp(r'^/+'), '');

    return Uri.parse('$baseUrl/wallet-settings/$cleanEndpoint');
  }

  /// GET: wallet-settings
  Future<WalletSettingsModel> fetchwalletsettings() async {
    final Uri url = Uri.parse(
      ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.walletsettings,
    );

    final http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    final Map<String, dynamic> responseData =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return WalletSettingsModel.fromJson(responseData);
    }

    throw Exception(
      responseData["message"]?.toString() ?? "Failed to fetch wallet settings",
    );
  }

  /// POST: wallet-settings/preferred-currency
  ///
  /// form-data:
  /// currency_id = 1
  Future<Map<String, dynamic>> updatePreferredCurrency({
    required int currencyId,
  }) async {
    final Uri url = _buildWalletSettingsUrl("preferred-currency");

    final http.MultipartRequest request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    request.fields.addAll({"currency_id": currencyId.toString()});

    return _sendMultipartRequest(request);
  }

  /// POST: wallet-settings/bundle-price-display-mode
  ///
  /// Supported values:
  /// preferred_currency
  /// bundle_currency
  Future<Map<String, dynamic>> updateBundlePriceDisplayMode({
    required String bundlePriceDisplayMode,
  }) async {
    final Uri url = _buildWalletSettingsUrl("bundle-price-display-mode");

    final http.MultipartRequest request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    request.fields.addAll({
      "bundle_price_display_mode": bundlePriceDisplayMode,
    });

    return _sendMultipartRequest(request);
  }

  /// POST: wallet-settings/deduction-mode
  ///
  /// Supported values:
  /// bundle_currency_wallet
  /// selected_wallet_conversion
  Future<Map<String, dynamic>> updateWalletDeductionMode({
    required String walletDeductionMode,
  }) async {
    final Uri url = _buildWalletSettingsUrl("deduction-mode");

    final http.MultipartRequest request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      'Authorization': 'Bearer $_token',
      'Accept': 'application/json',
    });

    request.fields.addAll({"wallet_deduction_mode": walletDeductionMode});

    return _sendMultipartRequest(request);
  }

  Future<Map<String, dynamic>> _sendMultipartRequest(
    http.MultipartRequest request,
  ) async {
    final http.StreamedResponse streamedResponse = await request.send();

    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );

    Map<String, dynamic> responseData = {};

    if (response.body.isNotEmpty) {
      final dynamic decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic>) {
        responseData = decodedData;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    }

    throw Exception(
      responseData["message"]?.toString() ?? "Unable to update wallet settings",
    );
  }
}

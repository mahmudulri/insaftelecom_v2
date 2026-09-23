import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../utils/api_endpoints.dart';

class FcmDeviceTokenController extends GetxController {
  final GetStorage box = GetStorage();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  final Uuid _uuid = const Uuid();

  StreamSubscription<String>? _tokenRefreshSubscription;

  final RxBool isSendingToken = false.obs;
  final RxBool isDeletingToken = false.obs;

  static const String _deviceIdStorageKey = 'firebase_device_id';

  static const String _currentFcmTokenStorageKey = 'current_fcm_token';

  static const String _lastSentFcmTokenStorageKey = 'last_sent_fcm_token';

  static const String _userTokenStorageKey = 'userToken';

  static String deviceTokenUrl = '${ApiEndPoints.baseUrl}device-tokens';

  String? _pendingToken;

  @override
  void onInit() {
    super.onInit();

    /*
     * Firebase token refresh listener একবার চালু থাকবে।
     */
    _listenForTokenRefresh();

    /*
     * App চালু হলে Firebase current token এবং local token
     * compare করবে। পরিবর্তিত হলে backend-এ পাঠাবে।
     */
    unawaited(checkAndSyncTokenOnAppStart());
  }

  // ============================================================
  // APP START TOKEN CHECK
  // ============================================================

  Future<bool> checkAndSyncTokenOnAppStart() async {
    try {
      final String? firebaseToken = await _firebaseMessaging.getToken();

      if (firebaseToken == null || firebaseToken.trim().isEmpty) {
        debugPrint('App start: FCM token পাওয়া যায়নি');
        return false;
      }

      final String currentToken = firebaseToken.trim();

      final String? savedToken = box.read<String>(_currentFcmTokenStorageKey);

      final String? lastSentToken = box.read<String>(
        _lastSentFcmTokenStorageKey,
      );

      final String? userToken = box.read<String>(_userTokenStorageKey);

      final bool isLoggedIn = userToken != null && userToken.trim().isNotEmpty;

      /*
       * Firebase token local token থেকে আলাদা হলে,
       * নতুন token local storage-এ save হবে।
       */
      if (savedToken != currentToken) {
        debugPrint('App start: Firebase token change হয়েছে');

        await box.write(_currentFcmTokenStorageKey, currentToken);
      } else {
        debugPrint('App start: Firebase token local token-এর সাথে same');
      }

      if (!isLoggedIn) {
        debugPrint('App start: User login নেই; token local-এ রাখা হয়েছে');
        return true;
      }

      /*
       * Token change হয়েছে অথবা token backend-এ সফলভাবে
       * পাঠানোর record নেই—তখন POST হবে।
       */
      if (savedToken != currentToken || lastSentToken != currentToken) {
        return await _syncTokenWithServer(fcmToken: currentToken, force: true);
      }

      debugPrint('App start: FCM token backend-এর সাথে synced');

      return true;
    } catch (error, stackTrace) {
      debugPrint('App start FCM token check error: $error');

      debugPrintStack(stackTrace: stackTrace);

      return false;
    }
  }

  // ============================================================
  // LOGIN TOKEN SYNC
  // ============================================================

  /// Login API successful হওয়ার পরে call করবেন।
  ///
  /// Login-এর সময় force=true রাখা হয়েছে, কারণ একই device-এ
  /// অন্য user login করলে একই FCM token নতুন user-এর সঙ্গে
  /// backend-এ register/update করা প্রয়োজন।
  Future<bool> sendCurrentTokenToServer() async {
    try {
      final String? firebaseToken = await _firebaseMessaging.getToken();

      if (firebaseToken == null || firebaseToken.trim().isEmpty) {
        debugPrint('Login sync: FCM token পাওয়া যায়নি');
        return false;
      }

      final String currentToken = firebaseToken.trim();

      /*
       * Current Firebase token local storage-এ রাখবে।
       */
      await box.write(_currentFcmTokenStorageKey, currentToken);

      return await _syncTokenWithServer(fcmToken: currentToken, force: true);
    } catch (error, stackTrace) {
      debugPrint('Login FCM token sync error: $error');

      debugPrintStack(stackTrace: stackTrace);

      return false;
    }
  }

  // ============================================================
  // FIREBASE TOKEN REFRESH
  // ============================================================

  void _listenForTokenRefresh() {
    _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (String newToken) async {
        final String refreshedToken = newToken.trim();

        if (refreshedToken.isEmpty) {
          return;
        }

        final String? savedToken = box.read<String>(_currentFcmTokenStorageKey);

        /*
         * একই token আবার emit হলে local storage update দরকার নেই।
         */
        if (savedToken == refreshedToken) {
          debugPrint('FCM refresh: Token আগের token-এর সাথে same');

          final String? lastSentToken = box.read<String>(
            _lastSentFcmTokenStorageKey,
          );

          final String? userToken = box.read<String>(_userTokenStorageKey);

          /*
           * Local token same হলেও backend sync record না থাকলে
           * আবার POST করবে।
           */
          if (userToken != null &&
              userToken.trim().isNotEmpty &&
              lastSentToken != refreshedToken) {
            await _syncTokenWithServer(fcmToken: refreshedToken, force: true);
          }

          return;
        }

        debugPrint('FCM refresh: নতুন token পাওয়া গেছে');

        /*
         * Backend request-এর আগে local storage update করা হবে,
         * যাতে network failure হলেও নতুন token হারিয়ে না যায়।
         */
        await box.write(_currentFcmTokenStorageKey, refreshedToken);

        final String? userToken = box.read<String>(_userTokenStorageKey);

        if (userToken == null || userToken.trim().isEmpty) {
          debugPrint(
            'FCM refresh: User login নেই; '
            'নতুন token local-এ save হয়েছে',
          );
          return;
        }

        final bool success = await _syncTokenWithServer(
          fcmToken: refreshedToken,
          force: true,
        );

        debugPrint('FCM refresh backend sync result: $success');
      },
      onError: (Object error) {
        debugPrint('FCM token refresh listener error: $error');
      },
    );
  }

  // ============================================================
  // POST TOKEN TO BACKEND
  // ============================================================

  Future<bool> _syncTokenWithServer({
    required String fcmToken,
    required bool force,
  }) async {
    final String normalizedToken = fcmToken.trim();

    if (normalizedToken.isEmpty) {
      return false;
    }

    final String? userToken = box.read<String>(_userTokenStorageKey);

    if (userToken == null || userToken.trim().isEmpty) {
      debugPrint('FCM POST: User API token পাওয়া যায়নি');
      return false;
    }

    final String? lastSentToken = box.read<String>(_lastSentFcmTokenStorageKey);

    if (!force && lastSentToken == normalizedToken) {
      debugPrint('FCM POST: Token আগে থেকেই backend-এ synced');
      return true;
    }

    /*
     * Request চলার সময় নতুন token এলে pending রাখবে।
     */
    if (isSendingToken.value) {
      _pendingToken = normalizedToken;

      debugPrint(
        'FCM POST: আগের request চলছে; '
        'নতুন token pending রাখা হয়েছে',
      );

      return false;
    }

    final bool result = await _postTokenToServer(
      fcmToken: normalizedToken,
      userToken: userToken.trim(),
    );

    final String? pendingToken = _pendingToken;

    _pendingToken = null;

    /*
     * আগের POST চলার সময় Firebase আরেকটি নতুন token দিলে,
     * এখন সেই token backend-এ পাঠাবে।
     */
    if (pendingToken != null &&
        pendingToken.trim().isNotEmpty &&
        pendingToken != normalizedToken) {
      await _syncTokenWithServer(fcmToken: pendingToken, force: true);
    }

    return result;
  }

  Future<bool> _postTokenToServer({
    required String fcmToken,
    required String userToken,
  }) async {
    try {
      isSendingToken.value = true;

      final String deviceId = await _getOrCreateDeviceId();

      final String deviceName = await _getDeviceName();

      final String platform = _getPlatformName();

      final Map<String, dynamic> requestBody = {
        'fcm_token': fcmToken,
        'device_id': deviceId,
        'device_name': deviceName,
        'platform': platform,
      };

      debugPrint('FCM POST URL: $deviceTokenUrl');

      debugPrint(
        'FCM POST body: '
        '${jsonEncode({'fcm_token': 'FCM_TOKEN_HIDDEN', 'device_id': deviceId, 'device_name': deviceName, 'platform': platform})}',
      );

      final http.Response response = await http
          .post(
            Uri.parse(deviceTokenUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $userToken',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      final dynamic responseData = _decodeResponse(response.body);

      debugPrint(
        'FCM POST response code: '
        '${response.statusCode}',
      );

      debugPrint('FCM POST response: $responseData');

      if (_isSuccessfulResponse(response)) {
        await box.write(_currentFcmTokenStorageKey, fcmToken);

        await box.write(_lastSentFcmTokenStorageKey, fcmToken);

        debugPrint('FCM token backend-এ successfully saved/updated');

        return true;
      }

      debugPrint('FCM token backend sync failed');

      return false;
    } on TimeoutException {
      debugPrint('FCM POST request timeout হয়েছে');

      return false;
    } catch (error, stackTrace) {
      debugPrint('FCM POST request error: $error');

      debugPrintStack(stackTrace: stackTrace);

      return false;
    } finally {
      isSendingToken.value = false;
    }
  }

  // ============================================================
  // DELETE/DISABLE TOKEN ON LOGOUT
  // ============================================================

  /// Logout করার আগে অবশ্যই এই method call করবেন।
  ///
  /// Flow:
  /// 1. Current/saved FCM token নেবে
  /// 2. DELETE API call করবে
  /// 3. Backend success হলে local token records remove করবে
  /// 4. Firebase-এর actual token delete করবে না
  Future<bool> disableTokenBeforeLogout() async {
    if (isDeletingToken.value) {
      debugPrint('FCM DELETE request ইতিমধ্যে চলছে');
      return false;
    }

    final String? userToken = box.read<String>(_userTokenStorageKey);

    if (userToken == null || userToken.trim().isEmpty) {
      debugPrint('FCM DELETE: User API token পাওয়া যায়নি');

      return false;
    }

    try {
      isDeletingToken.value = true;

      /*
       * প্রথমে Firebase থেকে live/current token নেওয়ার চেষ্টা।
       */
      String? fcmToken = await _firebaseMessaging.getToken();

      /*
       * Firebase থেকে না পেলে local saved token ব্যবহার করবে।
       */
      if (fcmToken == null || fcmToken.trim().isEmpty) {
        fcmToken = box.read<String>(_currentFcmTokenStorageKey);
      }

      /*
       * Current token না থাকলে last sent token ব্যবহার করবে।
       */
      if (fcmToken == null || fcmToken.trim().isEmpty) {
        fcmToken = box.read<String>(_lastSentFcmTokenStorageKey);
      }

      if (fcmToken == null || fcmToken.trim().isEmpty) {
        debugPrint('FCM DELETE: কোনো saved token পাওয়া যায়নি');

        /*
         * Token না থাকলে local stale values clean করবে।
         */
        await _clearLocalFcmTokenData();

        return true;
      }

      final String normalizedToken = fcmToken.trim();

      final Map<String, dynamic> requestBody = {'fcm_token': normalizedToken};

      debugPrint('FCM DELETE URL: $deviceTokenUrl');

      debugPrint(
        'FCM DELETE body: '
        '{"fcm_token":"FCM_TOKEN_HIDDEN"}',
      );

      final http.Request request = http.Request(
        'DELETE',
        Uri.parse(deviceTokenUrl),
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userToken.trim()}',
      });

      request.body = jsonEncode(requestBody);

      final http.StreamedResponse streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: 30));

      final String responseBody = await streamedResponse.stream.bytesToString();

      final http.Response response = http.Response(
        responseBody,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
        request: request,
      );

      final dynamic responseData = _decodeResponse(response.body);

      debugPrint(
        'FCM DELETE response code: '
        '${response.statusCode}',
      );

      debugPrint('FCM DELETE response: $responseData');

      if (_isSuccessfulResponse(response)) {
        /*
         * Backend disable সফল হওয়ার পর local copy remove।
         */
        await _clearLocalFcmTokenData();

        _pendingToken = null;

        debugPrint(
          'FCM token backend-এ disabled এবং local storage থেকে removed',
        );

        return true;
      }

      debugPrint(
        'FCM token backend disable failed; '
        'local token রাখা হয়েছে',
      );

      return false;
    } on TimeoutException {
      debugPrint('FCM DELETE request timeout হয়েছে');

      return false;
    } catch (error, stackTrace) {
      debugPrint('FCM DELETE request error: $error');

      debugPrintStack(stackTrace: stackTrace);

      return false;
    } finally {
      isDeletingToken.value = false;
    }
  }

  /// Backend token disable সফল হওয়ার পরে local saved copies remove।
  Future<void> _clearLocalFcmTokenData() async {
    await box.remove(_currentFcmTokenStorageKey);

    await box.remove(_lastSentFcmTokenStorageKey);

    debugPrint('Local FCM token records removed');
  }

  // ============================================================
  // DEVICE INFORMATION
  // ============================================================

  Future<String> _getOrCreateDeviceId() async {
    String? deviceId = box.read<String>(_deviceIdStorageKey);

    if (deviceId == null || deviceId.trim().isEmpty) {
      deviceId = _uuid.v4();

      await box.write(_deviceIdStorageKey, deviceId);
    }

    return deviceId;
  }

  Future<String> _getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await _deviceInfoPlugin.androidInfo;

        final String manufacturer = androidInfo.manufacturer.trim();

        final String model = androidInfo.model.trim();

        if (manufacturer.isNotEmpty && model.isNotEmpty) {
          return '$manufacturer $model';
        }

        return model.isNotEmpty ? model : 'Android Device';
      }

      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;

        return iosInfo.name.trim().isNotEmpty ? iosInfo.name.trim() : 'iPhone';
      }

      return 'Unknown Device';
    } catch (error) {
      debugPrint('Device name error: $error');

      return Platform.isAndroid ? 'Android Device' : 'Unknown Device';
    }
  }

  String _getPlatformName() {
    if (Platform.isAndroid) {
      return 'android';
    }

    if (Platform.isIOS) {
      return 'ios';
    }

    return 'unknown';
  }

  // ============================================================
  // HELPERS
  // ============================================================

  dynamic _decodeResponse(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    try {
      return jsonDecode(responseBody);
    } catch (_) {
      return responseBody;
    }
  }

  bool _isSuccessfulResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return false;
    }

    final dynamic decoded = _decodeResponse(response.body);

    if (decoded is Map && decoded.containsKey('success')) {
      return decoded['success'] == true;
    }

    return true;
  }

  String? get savedCurrentFcmToken {
    return box.read<String>(_currentFcmTokenStorageKey);
  }

  String? get lastSentFcmToken {
    return box.read<String>(_lastSentFcmTokenStorageKey);
  }

  @override
  void onClose() {
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }
}

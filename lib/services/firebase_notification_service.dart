import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef NotificationCallback =
    FutureOr<void> Function(Map<String, dynamic> data);

typedef NotificationNavigationCallback =
    FutureOr<void> Function(String type, Map<String, dynamic> data);

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// একই notification দুইবার process হওয়া বন্ধ করার জন্য।
  final Set<String> _processedEvents = <String>{};

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  /*
   * নিচের callbacks আপনার existing controllers/methods
   * দিয়ে main.dart বা dependency injection থেকে configure করবেন।
   */
  NotificationCallback? onRefreshOrders;
  NotificationCallback? onRefreshGeneralNotifications;
  NotificationCallback? onRefreshBalance;
  NotificationCallback? onRefreshPayments;
  NotificationCallback? onRefreshHawala;

  static const String _channelId = 'jahanpay_realtime_notifications';

  static const String _channelName = 'JahanPay Notifications';

  static const String _channelDescription =
      'Order, balance, payment and Hawala updates';

  static const AndroidNotificationChannel _notificationChannel =
      AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

  /// Controller refresh এবং navigation callbacks এখানে set হবে।
  void configure({
    NotificationCallback? refreshOrders,
    NotificationCallback? refreshGeneralNotifications,
    NotificationCallback? refreshBalance,
    NotificationCallback? refreshPayments,
    NotificationCallback? refreshHawala,
    NotificationNavigationCallback? navigate,
  }) {
    onRefreshOrders = refreshOrders;
    onRefreshGeneralNotifications = refreshGeneralNotifications;
    onRefreshBalance = refreshBalance;
    onRefreshPayments = refreshPayments;
    onRefreshHawala = refreshHawala;
  }

  Future<void> initialize() async {
    await _requestNotificationPermission();
    await _initializeLocalNotifications();
    await _getFcmToken();

    _listenForTokenRefresh();
    _listenForForegroundMessages();
    _listenForNotificationTap();

    /*
     * App terminated অবস্থায় notification tap করে
     * open করা হয়েছে কি না check করবে।
     */
    await _handleInitialNotification();
  }

  Future<void> _requestNotificationPermission() async {
    final NotificationSettings settings = await _firebaseMessaging
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          announcement: false,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
        );

    log(
      'Notification permission: '
      '${settings.authorizationStatus}',
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(_notificationChannel);

    /*
     * Android 13+ local notification permission.
     * FCM permission-এর পাশাপাশি এটি রাখা safe।
     */
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<String?> _getFcmToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();

      log('FCM TOKEN: $token');

      return token;
    } catch (error, stackTrace) {
      log('Unable to get FCM token', error: error, stackTrace: stackTrace);

      return null;
    }
  }

  void _listenForTokenRefresh() {
    _tokenRefreshSubscription?.cancel();

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
      (String newToken) {
        log('FCM TOKEN REFRESHED: $newToken');

        /*
             * আপনার FcmDeviceTokenController ইতিমধ্যে
             * refreshed token Laravel API-তে পাঠাবে।
             */
      },
      onError: (Object error) {
        log('FCM token refresh error: $error');
      },
    );
  }

  /// App foreground/open থাকলে এখানে notification আসবে।
  void _listenForForegroundMessages() {
    _foregroundSubscription?.cancel();

    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          message.data,
        );

        _printMessage(source: 'FOREGROUND', message: message);

        if (_isDuplicate(message)) {
          log(
            'Duplicate FCM event ignored: '
            '${_createDeduplicationKey(message)}',
          );
          return;
        }

        /*
             * App screen-এর data সঙ্গে সঙ্গে refresh হবে।
             */
        await _performRefreshAction(data);

        /*
             * Foreground-এ heads-up notification দেখাবে।
             */
        await _showForegroundNotification(message);
      },
      onError: (Object error) {
        log('Foreground FCM listener error: $error');
      },
    );
  }

  /// App background থেকে notification tap করে open হলে।
  void _listenForNotificationTap() {
    _openedAppSubscription?.cancel();

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        _printMessage(source: 'BACKGROUND NOTIFICATION TAP', message: message);

        await _handleNotificationInteraction(
          Map<String, dynamic>.from(message.data),
        );
      },
      onError: (Object error) {
        log('Notification tap listener error: $error');
      },
    );
  }

  /// App completely terminated অবস্থায় tap করে open হলে।
  Future<void> _handleInitialNotification() async {
    try {
      final RemoteMessage? initialMessage = await _firebaseMessaging
          .getInitialMessage();

      if (initialMessage == null) {
        return;
      }

      _printMessage(
        source: 'TERMINATED NOTIFICATION TAP',
        message: initialMessage,
      );

      /*
       * App-এর GetMaterialApp build হওয়ার জন্য
       * সামান্য delay রাখা হয়েছে।
       */
      await Future<void>.delayed(const Duration(milliseconds: 800));

      await _handleNotificationInteraction(
        Map<String, dynamic>.from(initialMessage.data),
      );
    } catch (error, stackTrace) {
      log('Initial notification error', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final Map<String, dynamic> data = Map<String, dynamic>.from(message.data);

    final String type = data['type']?.toString() ?? '';

    final String status = data['status']?.toString() ?? '';

    final String title = _buildNotificationTitle(
      type: type,
      status: status,
      backendTitle: message.notification?.title?.toString(),
    );

    final String body =
        message.notification?.body?.toString() ??
        data['message']?.toString() ??
        '';

    final BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      body,
      contentTitle: title,

      // Order ID বা অন্য summary দেখাবে না।
      summaryText: null,
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,

          importance: Importance.max,
          priority: Priority.max,

          playSound: true,
          enableVibration: true,
          enableLights: true,

          ticker: title,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.status,

          styleInformation: bigTextStyle,

          autoCancel: true,
          ongoing: false,
          onlyAlertOnce: false,

          // Notification-এর time hide করবে।
          showWhen: false,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      _notificationId(message),
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  String _buildNotificationTitle({
    required String type,
    required String status,
    String? backendTitle,
  }) {
    if (type == 'order_status') {
      switch (status) {
        case '0':
          return '⏳ Order Pending';

        case '1':
          return '✅ Order Confirmed';

        case '2':
          return '❌ Order Rejected';

        default:
          return backendTitle?.trim().isNotEmpty == true
              ? backendTitle!
              : '📦 Order Status Updated';
      }
    }

    switch (type) {
      case 'general_notification':
        return backendTitle?.trim().isNotEmpty == true
            ? '🔔 $backendTitle'
            : '🔔 New Notification';

      case 'balance_update':
        return backendTitle?.trim().isNotEmpty == true
            ? '💰 $backendTitle'
            : '💰 Balance Updated';

      case 'payment_update':
        return backendTitle?.trim().isNotEmpty == true
            ? '💳 $backendTitle'
            : '💳 Payment Updated';

      case 'hawala_update':
        return backendTitle?.trim().isNotEmpty == true
            ? '💱 $backendTitle'
            : '💱 Hawala Updated';

      default:
        return backendTitle?.trim().isNotEmpty == true
            ? backendTitle!
            : 'JahanPay Notification';
    }
  }

  Future<void> _handleLocalNotificationTap(
    NotificationResponse response,
  ) async {
    final String? payload = response.payload;

    if (payload == null || payload.trim().isEmpty) {
      return;
    }

    try {
      final dynamic decoded = jsonDecode(payload);

      if (decoded is! Map) {
        return;
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(decoded);

      log('Local notification clicked: $data');

      await _handleNotificationInteraction(data);
    } catch (error, stackTrace) {
      log(
        'Invalid local notification payload',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _handleNotificationInteraction(Map<String, dynamic> data) async {
    /*
     * Notification tap করলে fresh data load হবে।
     */
    await _performRefreshAction(data);

    final String type = data['type']?.toString() ?? '';

    if (type.isEmpty) {
      return;
    }

    /*
     * Related page navigation callback।
     */
  }

  Future<void> _performRefreshAction(Map<String, dynamic> data) async {
    final String type = data['type']?.toString() ?? '';

    log('Performing refresh for type: $type');

    switch (type) {
      case 'order_status':
        await onRefreshOrders?.call(data);
        break;

      case 'general_notification':
        await onRefreshGeneralNotifications?.call(data);
        break;

      case 'balance_update':
        await onRefreshBalance?.call(data);
        break;

      case 'payment_update':
        await onRefreshPayments?.call(data);
        break;

      case 'hawala_update':
        await onRefreshHawala?.call(data);
        break;

      default:
        log('Unknown notification type: $type');
    }
  }

  bool _isDuplicate(RemoteMessage message) {
    final String key = _createDeduplicationKey(message);

    if (_processedEvents.contains(key)) {
      return true;
    }

    _processedEvents.add(key);

    /*
     * Memory বড় হওয়া বন্ধ করার জন্য।
     */
    if (_processedEvents.length > 300) {
      _processedEvents.clear();
      _processedEvents.add(key);
    }

    /*
     * একই event কিছুক্ষণ পরে আবার validভাবে আসতে পারে।
     */
    Future<void>.delayed(const Duration(seconds: 10), () {
      _processedEvents.remove(key);
    });

    return false;
  }

  String _createDeduplicationKey(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;

    final String type = data['type']?.toString() ?? '';

    final String event = data['event']?.toString() ?? '';

    final String orderId = data['order_id']?.toString() ?? '';

    final String status = data['status']?.toString() ?? '';

    /*
     * Order status-এর জন্য:
     * type + event + order_id + status
     */
    if (type == 'order_status') {
      return '$type|$event|$orderId|$status';
    }

    /*
     * অন্য notification-এর জন্য Firebase message ID
     * ব্যবহার করা হবে।
     */
    return message.messageId ?? '$type|${data.toString()}';
  }

  int _notificationId(RemoteMessage message) {
    final String uniqueKey =
        message.messageId ?? _createDeduplicationKey(message);

    return uniqueKey.hashCode & 0x7fffffff;
  }

  void _printMessage({required String source, required RemoteMessage message}) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(message.data);

    log('========== FCM: $source ==========');

    log('Message ID: ${message.messageId}');

    log('Title: ${message.notification?.title}');

    log('Body: ${message.notification?.body}');

    log('Type: ${data['type']}');

    log('Event: ${data['event']}');

    log('Order ID: ${data['order_id']}');

    log('Status: ${data['status']}');

    log('Reseller ID: ${data['reseller_id']}');

    log('Message: ${data['message']}');

    log('Full data: $data');

    log('======================================');
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
  }
}

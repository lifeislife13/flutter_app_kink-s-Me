import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Notifications importantes Kink’s Me',
    importance: Importance.high,
  );

  static Future<void> initializeNotifications() async {
    try {
      // Notifications locales
      const AndroidInitializationSettings initAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(
        android: initAndroid,
      );
      await _localNotifications.initialize(initSettings);
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      // FCM background handler
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

      // Token
      String? token = await _messaging.getToken();
      log("📲 FCM Token: $token");

      // Foreground listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(message);
      });

      log("✅ Notifications initialisées");
    } catch (e) {
      log("❌ Erreur d'initialisation des notifs : $e");
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Notifications importantes Kink’s Me',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    log("🔔 Notification en arrière-plan : ${message.messageId}");
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel murmuresChannel =
      AndroidNotificationChannel(
    'murmures_channel',
    'Murmures discrets',
    description: 'Notifications privées pour les messages ou murmures',
    importance: Importance.low,
    playSound: false,
    enableLights: false,
    enableVibration: false,
    showBadge: false,
  );

  /// Initialise Firebase Messaging + Local Notifications
  static Future<void> initialize(BuildContext context) async {
    // 🔐 Autorisation des notifications (iOS / Android 13+)
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ Abonnement automatique au topic "allUsers" si autorisé
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance.subscribeToTopic("allUsers");
      debugPrint("✅ Abonné au topic allUsers");
    } else {
      debugPrint("🚫 Autorisation refusée pour les notifications");
    }

    // 📲 Récupération du token FCM
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("📲 FCM TOKEN : $token");

    // 🔧 Initialisation de la configuration Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_stat_kinksme');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // 📡 Création du canal de notifications
    final android =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(murmuresChannel);

    // 👂 Listener pour les messages reçus quand l’app est ouverte
    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    // 🚪 Lorsque l’utilisateur clique sur une notification (app en background ou kill)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📬 Notification ouverte depuis l’arrière-plan");

      final route = message.data['route'];
      if (route != null && context.mounted) {
        Navigator.pushNamed(context, route);
      }
    });
  }

  /// Gère les notifications reçues en foreground
  static Future<void> _handleForegroundNotification(
      RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    debugPrint("📩 Notification reçue : ${notification?.title}");

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? 'Nouvelle notification',
        notification.body ?? 'Un murmure vous attend...',
        NotificationDetails(
          android: AndroidNotificationDetails(
            murmuresChannel.id,
            murmuresChannel.name,
            channelDescription: murmuresChannel.description,
            importance: Importance.low,
            priority: Priority.low,
            playSound: false,
            icon: 'ic_stat_kinksme',
          ),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kinksme/theme_provider.dart';
import 'package:kinksme/firebase_options.dart';
import 'package:kinksme/models/message_style.dart';

import 'package:kinksme/screens/about_screen.dart';
import 'package:kinksme/screens/agenda_secret_screen.dart';
import 'package:kinksme/screens/age_check_screen.dart';
import 'package:kinksme/screens/boudoir_screen.dart';
import 'package:kinksme/screens/boutique_screen.dart';
import 'package:kinksme/screens/cercle_des_murmures_screen.dart';
import 'package:kinksme/screens/chat_and_messaging_screen.dart';
import 'package:kinksme/screens/forgot_password_screen.dart';
import 'package:kinksme/screens/geolocation_screen.dart';
import 'package:kinksme/screens/glossary_screen.dart';
import 'package:kinksme/screens/home_screen.dart';
import 'package:kinksme/screens/journal_brulant_screen.dart';
import 'package:kinksme/screens/kink_elegance_screen.dart';
import 'package:kinksme/screens/ma_kinksphere_screen.dart';
import 'package:kinksme/screens/map_screen.dart';
import 'package:kinksme/screens/missive_screen.dart';
import 'package:kinksme/screens/notifications_screen.dart';
import 'package:kinksme/screens/plume_secrete_screen.dart';
import 'package:kinksme/screens/presentation_screen.dart';
import 'package:kinksme/screens/profile_menu_screen.dart';
import 'package:kinksme/screens/profile_screen.dart';
import 'package:kinksme/screens/profile_setup_screen.dart';
import 'package:kinksme/screens/register_screen.dart';
import 'package:kinksme/screens/settings_screen.dart';
import 'package:kinksme/screens/terms_screen.dart';
import 'package:kinksme/screens/plan_site_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Message en arrière-plan : \${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifications de haute importance',
    description: 'Notifications importantes pour Kink\'s Me',
    importance: Importance.high,
  );

  @override
  void initState() {
    super.initState();
    _initializeLocalNotifications();
    _setupFirebaseMessaging();
  }

  Future<void> _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('ic_stat_kinksme');
    const InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);
    final androidPlatform =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlatform?.createNotificationChannel(channel);
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notifications de haute importance',
          channelDescription: 'Notifications importantes pour Kink\'s Me',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: 'Default_Sound',
    );
  }

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenHome = prefs.getBool('seenHome') ?? false;
    final seenRegister = prefs.getBool('seenRegister') ?? false;
    final seenPresentation = prefs.getBool('seenPresentation') ?? false;
    final seenSetup = prefs.getBool('seenSetup') ?? false;

    if (!seenHome) return const AgeCheckScreen();
    if (!seenPresentation) return const HomeScreen();
    if (!seenRegister) return const RegisterScreen();
    if (!seenSetup) return const PresentationScreen();
    return const ProfileSetupScreen();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: "Kink's Me 🚀",
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data ?? const ProfileMenuScreen();
          }
        },
      ),
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/presentation':
        page = const PresentationScreen();
        break;
      case '/register':
        page = const RegisterScreen();
        break;
      case '/forgotPassword':
        page = const ForgotPasswordScreen();
        break;
      case '/profileSetup':
        page = const ProfileSetupScreen();
        break;
      case '/geoLocation':
        page = const GeolocationScreen();
        break;
      case '/home':
        page = const HomeScreen();
        break;
      case '/map':
        page = const MapScreen();
        break;
      case '/chat':
        page = const ChatAndMessagingScreen(
          isChat: true,
          userPseudo: 'Chat par défaut',
          userPhoto: '',
        );
        break;
      case '/messaging':
        page = const ChatAndMessagingScreen(
          isChat: false,
          userPseudo: 'Missive par défaut',
          userPhoto: '',
        );
        break;
      case '/profile':
        page = const ProfileScreen();
        break;
      case '/terms':
        page = const TermsScreen();
        break;
      case '/settings':
        page = const SettingsScreen();
        break;
      case '/profileMenu':
        page = const ProfileMenuScreen();
        break;
      case '/glossary':
        page = const GlossaryScreen();
        break;
      case '/boudoir':
        page = const BoudoirScreen();
        break;
      case '/agenda':
        page = const AgendaSecretScreen();
        break;
      case '/boutique':
        page = const BoutiqueScreen();
        break;
      case '/journalBrulant':
        page = const JournalBrulantScreen();
        break;
      case '/about':
        page = const AboutScreen();
        break;
      case '/kinkElegance':
        page = const KinkEleganceScreen();
        break;
      case '/missive':
        final args = settings.arguments as Map<String, dynamic>;
        page = MissiveScreen(
          message: args['message'] as String,
          signature: args['signature'] as String,
          style: args['style'] as MessageStyle? ?? MessageStyle.parcheminDAntan,
        );
        break;
      case '/notifications':
        page = const NotificationsScreen();
        break;
      case '/kinksphere':
        page = const MaKinksphereScreen();
        break;
      case '/cercleMurmures':
        page = const CercleDesMurmuresScreen();
        break;
      case '/planSite':
        page = const PlanDuSiteScreen();
        break;
      case '/plumeSecrete':
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final style = MessageStyle.values.firstWhere(
          (e) => e.toString() == args['style'],
          orElse: () => MessageStyle.parcheminDAntan,
        );
        page = PlumeSecreteScreen(
          text: args['text'] ?? "",
          signature: args['signature'] ?? "",
          style: style,
          manualSignatureBase64: args['manualSignatureBase64'],
        );
        break;

      default:
        page = const ProfileMenuScreen();
    }

    return MaterialPageRoute(builder: (ctx) => page, settings: settings);
  }
}

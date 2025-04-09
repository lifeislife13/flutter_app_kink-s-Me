import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'theme_provider.dart';
import 'services/firebase_notification_service.dart';

// Import screens & models
import 'models/message_style.dart';
import 'screens/about_screen.dart';
import 'screens/account_screen.dart';
import 'screens/agenda_secret_screen.dart';
import 'screens/age_check_screen.dart';
import 'screens/boudoir_editor_screen.dart';
import 'screens/boudoir_screen.dart';
import 'screens/boutique_screen.dart';
import 'screens/cercle_des_murmures_screen.dart';
import 'screens/chat_and_messaging_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/geolocation_screen.dart';
import 'screens/glossary_screen.dart';
import 'screens/highlighted_kinks_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_brulant_screen.dart';
import 'screens/kink_elegance_screen.dart';
import 'screens/ma_kinksphere_screen.dart';
import 'screens/map_screen.dart';
import 'screens/missive_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/plan_site_screen.dart';
import 'screens/plume_secrete_screen.dart';
import 'screens/presentation_screen.dart';
import 'screens/profile_menu_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/terms_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 [BG] Message reçu : ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 📲 Notifs BG
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔐 AppCheck sécurisé ou debug
  const debugToken = String.fromEnvironment('FIREBASE_APPCHECK_DEBUG_TOKEN');

  await FirebaseAppCheck.instance.activate(
    androidProvider: debugToken.isNotEmpty
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.debug,
  );

  // 🔍 Logs de debug utiles
  try {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint("🔐 Utilisateur Firebase Auth : $user");

    final token = await FirebaseAppCheck.instance.getToken(true);
    debugPrint("🧪 Token AppCheck : $token");

    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("📲 FCM Token : $fcmToken");
  } catch (e) {
    debugPrint("❌ Erreur AppCheck / FCM : $e");
  }

  if (debugToken.isNotEmpty) {
    debugPrint(
        "🆔 Token Debug à copier dans la Console Firebase : $debugToken");
  }

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
  @override
  void initState() {
    super.initState();

    // 🔥 Auth check
    FirebaseAuth.instance.authStateChanges().listen((user) {
      debugPrint("🔐 Utilisateur connecté : ${user != null}");
    });

    // ✅ Permission pour notifs
    FirebaseMessaging.instance.requestPermission();

    // 🔔 Listener pour les notifs en foreground
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseNotificationService.initialize(context);
    });
  }

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final seenHome = prefs.getBool('seenHome') ?? false;
    final seenPresentation = prefs.getBool('seenPresentation') ?? false;
    final seenRegister = prefs.getBool('seenRegister') ?? false;
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
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data ?? const ProfileMenuScreen();
        },
      ),
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;
    Widget page;

    switch (name) {
      case '/presentation':
        page = const PresentationScreen();
        break;
      case '/register':
        page = const RegisterScreen();
        break;
      case '/forgotPassword':
        page = const ForgotPasswordScreen();
        break;
      case '/boudoirEditor':
        page = const BoudoirEditorScreen();
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
      case '/highlightedKinks':
        page = const HighlightedKinksScreen();
        break;
      case '/feedback':
        page = const FeedbackScreen();
        break;
      case '/account':
        page = const AccountScreen();
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
      case '/missive':
        final mArgs = args as Map<String, dynamic>? ?? {};
        page = MissiveScreen(
          message: mArgs['message'] ?? '',
          signature: mArgs['signature'] ?? '',
          style: MessageStyle.values.firstWhere(
            (e) => e.toString() == mArgs['style'],
            orElse: () => MessageStyle.parcheminDAntan,
          ),
        );
        break;
      case '/plumeSecrete':
        final pArgs = args as Map<String, dynamic>? ?? {};
        final style = MessageStyle.values.firstWhere(
          (e) => e.toString() == pArgs['style'],
          orElse: () => MessageStyle.parcheminDAntan,
        );
        page = PlumeSecreteScreen(
          text: pArgs['text'] ?? "",
          signature: pArgs['signature'] ?? "",
          style: style,
          manualSignatureBase64: pArgs['manualSignatureBase64'],
        );
        break;
      default:
        page = const ProfileMenuScreen();
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/visitor_logs/visitor_logs_screen.dart';
import 'screens/add_visitor/add_visitor_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/api_data/api_data_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';
import 'dart:developer'; // For better logging

import 'firebase_options.dart';

// Top-level function for handling background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message received: ${message.messageId}');
  
  // If the message contains a notification, show it manually if needed
  // (FCM usually shows it if it has a 'notification' property, but for consistency)
  if (message.notification != null) {
    await NotificationService().init(); // Ensure initialized in the new isolate
    await NotificationService().showInstantNotification(
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? '',
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    // Request permission (required for Android 13+)
    await FirebaseMessaging.instance.requestPermission();
    
    // Retrieve the FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    
    // Print to the debug console
    log("FCM TOKEN: $token");
    
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService().init();
  } catch (e) {
    debugPrint('Firebase/Notification initialization failed: $e');
  }
  runApp(const VisitorLogApp());
}

class VisitorLogApp extends StatelessWidget {
  const VisitorLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lab 8: Wrap entire app with ChangeNotifierProvider for global state management
    return ChangeNotifierProvider<AppStateProvider>(
      create: (_) => AppStateProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Digital Visitor Log',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF475569),
            primary: const Color(0xFF475569),
            secondary: const Color(0xFF64748B),
            surface: const Color(0xFFF8FAFC),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF334155),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF475569), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF475569),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
              TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        // Lab 8: Session persistence – SplashScreen checks Firebase auth state
        home: const SplashScreen(),
        // Lab 8: Named routes for structured navigation
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/logs': (context) => const VisitorLogsScreen(),
          '/add-visitor': (context) => const AddVisitorScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/api-data': (context) => const ApiDataScreen(),
        },
      ),
    );
  }
}

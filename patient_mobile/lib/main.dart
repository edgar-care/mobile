import 'package:edgar/models/onboarding.dart';
import 'package:edgar/models/simulation_intro.dart';
import 'package:edgar/screens/simulation/appointement_page.dart';
import 'package:edgar/screens/simulation/confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/screens/auth.dart';
import 'package:edgar/screens/landingPage/help.dart';
import 'package:edgar/screens/login.dart';
import 'package:edgar/screens/register.dart';
import 'package:edgar/screens/simulation/warning_page.dart';
import 'package:edgar/screens/simulation/chat_page.dart';
import 'package:edgar/models/dashboard.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:push/push.dart';

import 'screens/landingPage/annuaire_medecin.dart';
import 'screens/landingPage/landing_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();
  runApp(const MyApp());
}

Future<void> initializePushNotifications() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted || status.isLimited) {
    await Permission.notification.request();
  }

  await Push.instance.requestPermission();

  Push.instance.onNewToken.listen((message) {
    Logger().i("Received a push notification: $message");
    // Handle the message or show a local notification
  });

  Push.instance.onNotificationTap.listen((message) {
    Logger().i("Notification tapped: $message");
    // Handle the notification tap event
  });
}

Future<FlutterLocalNotificationsPlugin>
    initializeFlutterLocalNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsApple =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsApple,
      macOS: initializationSettingsApple);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  return flutterLocalNotificationsPlugin;
}

Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String tittle,
    String descrition) async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'Important Notifications', // Channel Name
      channelDescription:
          'This channel is used for important notifications.', // Channel description
      importance: Importance.max,
      priority: Priority.high,
      icon:
          'mipmap/launcher_icon', // Reference the icon by name (no path, no extension)
      playSound: true,
      enableLights: true,
      color: Colors.blue, // Optional: set the accent color of the icon
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS-specific customizations can be added here if needed
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      tittle, // Title
      descrition, // Body
      platformChannelSpecifics,
      payload: 'Notification Payload', // Optional payload
    );

    Logger().d("Notification with custom icon displayed successfully");
  } catch (e) {
    Logger().e("Error displaying notification with custom icon: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notifications
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          await initializeFlutterLocalNotifications();

      // Initialize push notifications and request permissions
      await initializePushNotifications();

      // Show a test notification (optional, remove in production)
      await Future.delayed(const Duration(seconds: 5));
      await showNotification(flutterLocalNotificationsPlugin, "Test",
          "This is a test notification");
    });

    return MaterialApp(
      title: 'edgar',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Raleway'),
      initialRoute: "/",
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const Login(),
        '/auth': (context) => const AuthScreen(),
        '/register': (context) => const Register(),
        '/help': (context) => const HelpScreen(),
        '/annuaire-medecin': (context) => const AnnuaireMedecin(),
        '/warning': (context) => const WarningPage(),
        '/chat': (context) => const ChatPage(),
        '/dashboard': (context) => const DashBoardPage(),
        '/simulation/confirmation': (context) => const ConfirmationPage(),
        '/simulation/intro': (context) => const IntroSimulation(),
        '/simulation/appointement': (context) => const AppointmentPage(),
        '/onboarding': (context) => const Onboarding(),
      },
    );
  }
}

import 'package:edgar/widget.dart';
import 'package:edgar_pro/2FA/desactivate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar_pro/models/dashboard.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:push/push.dart';
import 'models/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());

  runApp(
    ChangeNotifierProvider(
      create: (context) => BottomSheetModel(),
      child: const MainApp(),
    ),
  );
}

Future<void> initializePushNotifications() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted || status.isLimited) {
    await Permission.notification.request();
  }

  await Push.instance.requestPermission();

  Push.instance.onNewToken.listen((message) {
    // Handle the message or show a local notification
  });

  Push.instance.onNotificationTap.listen((message) {
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
  } catch (e) {
    // catch clauses
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notifications
      // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      //     await initializeFlutterLocalNotifications();

      // Initialize push notifications and request permissions
      await initializePushNotifications();

      // Initialize WebSocket service

      // Show a test notification (optional, remove in production)
      await Future.delayed(const Duration(seconds: 5));
      // await showNotification(flutterLocalNotificationsPlugin, "Test",
      //     "This is a test notification");
    });
  }

  @override
  Widget build(BuildContext context) {
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
          fontFamily: 'Poppins'),
      initialRoute: "/",
      routes: {
        "/": (context) => const Auth(),
        "/dashboard": (context) => const DashBoard(),
        "/desactivate": (context) => const Desactivate(),
      },
    );
  }
}

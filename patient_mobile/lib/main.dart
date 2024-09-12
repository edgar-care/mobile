import 'package:edgar_app/models/onboarding.dart';
import 'package:edgar_app/models/simulation_intro.dart';
import 'package:edgar_app/screens/landingPage/connexion_page.dart';
import 'package:edgar_app/screens/simulation/appointement_page.dart';
import 'package:edgar_app/screens/simulation/confirmation_page.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar_app/screens/simulation/warning_page.dart';
import 'package:edgar_app/screens/simulation/chat_page.dart';
import 'package:edgar_app/models/dashboard.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:push/push.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BottomSheetModel(),
      child: const MyApp(),
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebSocketService? _webSocketService;
  List<Chat> chats = [];
  bool isChatting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notifications
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          await initializeFlutterLocalNotifications();

      // Initialize push notifications and request permissions
      await initializePushNotifications();

      fetchData();

      // Initialize WebSocket service
      await _initializeWebSocketService(flutterLocalNotificationsPlugin);

      // Show a test notification (optional, remove in production)
      await Future.delayed(const Duration(seconds: 5));
      await showNotification(flutterLocalNotificationsPlugin, "Test",
          "This is a test notification");
    });
  }

  void updateIsChatting(bool value) {
    setState(() {
      isChatting = value;
    });
  }

  Future<void> _initializeWebSocketService(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    _webSocketService = WebSocketService(
      onReceiveMessage: (data) {
        setState(() {
          Chat? chatToUpdate = chats.firstWhere(
            (chat) => chat.id == data['chat_id'],
          );
          chatToUpdate.messages.add(
            Sms(
              message: data['message'],
              ownerId: data['owner_id'],
              time: data['sended_time'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(data['sended_time'])
                  : DateTime.now(),
            ),
          );
        });
        if (isChatting) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
      },
      onReady: (data) {},
      onCreateChat: (data) {
        setState(() {
          chats.add(
            Chat(
              id: data['chat_id'],
              messages: [],
              recipientIds: [
                Participant(
                  id: data['recipient_ids'][0],
                  lastSeen: DateTime.now(),
                ),
                Participant(
                  id: data['recipient_ids'][1],
                  lastSeen: DateTime.now(),
                ),
              ],
            ),
          );
        });
      },
      onGetMessages: (data) {
        setState(() {
          chats = transformChats(data);
        });
        if (isChatting) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
      },
      onReadMessage: (data) {},
      // Handle the askMobileConnection action
      onAskMobileConnection: (data) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");
        Logger().i('AskMobileConnection: $data');
        _webSocketService?.responseMobileConnection(
          token!,
          data['uuid'],
        );
      },

      onResponseMobileConnection: (data) {
        Logger().i('ResponseMobileConnection response: $data');
      },
    );
    await _webSocketService?.connect();
    _webSocketService?.sendReadyAction();
    _webSocketService?.getMessages();
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }

  Future<void> fetchData() async {
    FlutterNativeSplash.remove();
    return;
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
          fontFamily: 'Raleway'),
      initialRoute: "/",
      routes: {
        '/': (context) => const ConnexionPage(),
        '/warning': (context) => const WarningPage(),
        '/chat': (context) => const ChatPage(),
        '/dashboard': (context) => DashBoardPage(
            chats: chats,
            webSocketService: _webSocketService,
            isChatting: isChatting,
            scrollController: _scrollController,
            updateIsChatting: updateIsChatting),
        '/simulation/confirmation': (context) => const ConfirmationPage(),
        '/simulation/intro': (context) => const IntroSimulation(),
        '/simulation/appointement': (context) => const AppointmentPage(),
        '/onboarding': (context) => const Onboarding(),
      },
    );
  }
}

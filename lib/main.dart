import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/screens/info_page.dart';
import 'screens/loged_home_page.dart';
import 'screens/chat_box_page.dart';
import 'screens/login_hint_page.dart';
import 'screens/no_loged_start_analayse_page.dart';
import 'screens/doctors_list_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Raleway'),
      routes: {
        '/': (context) =>
            const StartTheAnalyse(title: 'StartTheAnalyseNoLoged'),
        '/home': (context) => const LogedHomePage(title: 'home'),
        '/chat': (context) => const ChatBoxPage(title: 'chat'),
        '/login': (context) => const LoginHintPage(title: 'login'),
        '/info': (context) => const InfoPage(title: 'info'),
        '/doctors': (context) => const DoctorsListPage(title: 'doctors'),
      },
    );
  }
}

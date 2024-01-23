import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/screens/auth.dart';
import 'package:edgar/screens/landingPage/help.dart';
import 'package:edgar/screens/login.dart';
import 'package:edgar/screens/register.dart';
import 'package:edgar/screens/simulation/warning_page.dart';
import 'package:edgar/screens/simulation/chat_page.dart';
import 'package:edgar/models/dashboard.dart';

import 'screens/landingPage/annuaire_medecin.dart';
import 'screens/landingPage/landing_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'edgar',
      debugShowCheckedModeBanner: false,
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
      },
    );
  }
}

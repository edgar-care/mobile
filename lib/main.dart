import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/screens/auth.dart';
import 'package:prototype_1/screens/help.dart';
import 'package:prototype_1/screens/login.dart';
import 'package:prototype_1/screens/accueil_page.dart';
import 'package:prototype_1/screens/register.dart';
import 'package:prototype_1/screens/information_personnel.dart';
import 'package:prototype_1/screens/warning_page.dart';
import 'package:prototype_1/screens/chat_page.dart';

import 'screens/annuaire_medecin.dart';
import 'screens/landing_page.dart';
import 'screens/connexion_validate.dart';

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
        '/connexion-validate': (context) => const ConnexionValidate(),
        '/home': (context) => const HomePage(),
        '/person': (context) => const InformationPersonnel(),
        '/warning': (context) => const WarningPage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}

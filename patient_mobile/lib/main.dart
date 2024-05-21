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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/landingPage/annuaire_medecin.dart';
import 'screens/landingPage/landing_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

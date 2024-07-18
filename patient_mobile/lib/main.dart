import 'package:edgar_app/models/onboarding.dart';
import 'package:edgar_app/models/simulation_intro.dart';
import 'package:edgar_app/screens/landingPage/connexion_page.dart';
import 'package:edgar_app/screens/simulation/appointement_page.dart';
import 'package:edgar_app/screens/simulation/confirmation_page.dart';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar_app/screens/simulation/warning_page.dart';
import 'package:edgar_app/screens/simulation/chat_page.dart';
import 'package:edgar_app/models/dashboard.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BottomSheetModel(),
      child: const MyApp(),
    ),
  );
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
        '/': (context) => const ConnexionPage(),
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

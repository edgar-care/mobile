import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar_pro/models/dashboard.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  initializeDateFormatting();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'edgar',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr')
      ],
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Raleway'),
    initialRoute: "/",
      routes: { 
        "/": (context) => const Auth(),
        "/dashboard":(context) => const DashBoard(),
      },
    );
  }
}

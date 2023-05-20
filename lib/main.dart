import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/screens/auth.dart';
import 'package:prototype_1/screens/login.dart';
import 'screens/landing_page.dart';

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
      initialRoute: "/login",
      routes: {
        '/login': (context) => const Login(),
        '/auth':(context) => const AuthScreen(),
        //'/': (context) => const LandingPage(),
        // '/info': ,
        // '/login': ,
        // '/auth': ,
        // '/register': ,
        // '/register_validate': ,
      },
    );
  }
}

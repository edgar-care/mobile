import 'package:flutter/material.dart';

class AuthPages extends StatefulWidget {
  const AuthPages({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _AuthPagesState createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> with TickerProviderStateMixin {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo/small-width-blue-edgar-logo.png'),
      ),
    );


  }
}


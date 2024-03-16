import 'package:flutter/material.dart';
import 'package:edgar_pro/screens/auth/login_page.dart';
import 'package:edgar_pro/screens/auth/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  int _selectedIndex = 0;

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkb2N0b3IiOnsiaWQiOiI2NWU3NTQwOGY2MTIyY2JkOGM0MWQ5YzciLCJlbWFpbCI6InRlc3QrNTBAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmEkMTAkUmJMb3plTHhuR1lVaU1sYjJRREkuT3FWbDJ4OGw2QmdYY3lKRzBjSXc5MFRjVThkVDNPbGkiLCJuYW1lIjoiRWRnYXIiLCJmaXJzdG5hbWUiOiJBc3Npc3RhbnQiLCJhZGRyZXNzIjp7InN0cmVldCI6IjEgcnVlIGR1IG3DqWRlY2luIiwiemlwX2NvZGUiOiI2OTAwMCIsImNvdW50cnkiOiJGcmFuY2UiLCJjaXR5IjoiTHlvbiJ9fX0.ymrhvY7qerZrX-uwDrR7Ob_oSO08jkjKc0HpV5PwQ88');
    final token = prefs.getString('token');
    if (token != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      Login(callback: updateSelectedIndex),
      Register(callback: updateSelectedIndex),
    ];
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: pages[_selectedIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

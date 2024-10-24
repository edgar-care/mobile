import 'package:edgar_pro/screens/auth/register_info_page.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/screens/auth/login_page.dart';
import 'package:edgar_pro/screens/auth/register_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String authEmail = '';
  String authPassword = '';
  int _selectedIndex = 0;

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void registerCallback(String email, String password) {
    setState(() {
      authEmail = email;
      authPassword = password;
      _selectedIndex = 2;
    });

  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/dashboard');
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      Login(callback: updateSelectedIndex),
      Register(callback: updateSelectedIndex, registerCallback: registerCallback),
      Register2(updateSelectedIndex: updateSelectedIndex, email: authEmail, password: authPassword),
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

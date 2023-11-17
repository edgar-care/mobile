import 'package:flutter/material.dart';
import 'package:medecin_mobile/screens/auth/login_page.dart';
import 'package:medecin_mobile/screens/auth/register_page.dart';


class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

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
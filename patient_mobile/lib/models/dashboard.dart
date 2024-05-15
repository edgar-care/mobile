import 'package:edgar/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar/screens/dashboard/accueil_page.dart';
import 'package:edgar/screens/dashboard/information_personnel.dart';
import 'package:edgar/screens/dashboard/gestion_rendez_vous.dart';
import 'package:edgar/screens/dashboard/file_page.dart';
import 'package:edgar/screens/dashboard/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const GestionRendezVous(),
    const InformationPersonnel(),
    const FilePage(),
    const InformationPersonnel(),
    const ChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    checkSession(context);
  }

  // Pile pour suivre l'index des onglets visités
  final List<int> _navigationStack = [0];

  void checkSession(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _previousIndex = _selectedIndex;
      });
      _pageController
          .animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() {
          if (_navigationStack.isEmpty || _navigationStack.last != index) {
            _navigationStack.add(index);
          }
          _selectedIndex = index;
        });
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _selectedIndex = _previousIndex;
        _pageController.jumpToPage(_selectedIndex);
        if (_navigationStack.isNotEmpty) {
          _previousIndex = _navigationStack.last;
        }
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 84),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: _widgetOptions,
                ),
              ),
            ),
            CustomBottomBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable


import 'package:edgar_pro/screens/dashboard/agenda_page.dart';
import 'package:animations/animations.dart';
import 'package:edgar_pro/screens/dashboard/chat_page.dart';
import 'package:edgar_pro/screens/dashboard/diagnostic_page.dart';
import 'package:edgar_pro/screens/dashboard/patientele_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_page.dart';
import 'package:edgar_pro/screens/dashboard/services.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/appbar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0;
  int _previousIndex = 0;
  String _id = "";
  final List<int> _navigationStack = [0];

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  void updateId(String id) {
    setState(() {
      _id = id;
    });
  }

  String getId() {
    return _id;
  }

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = index;
        if (_navigationStack.isEmpty || _navigationStack.last != index) {
          _navigationStack.add(index);
        }
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _selectedIndex = _previousIndex;
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
    final List<Widget> pages = <Widget>[
      const Agenda(),
      const Rdv(),
      Services(tapped: _onItemTapped,),
      const Patient(),
      const Diagnostic(),
      const ChatPageDashBoard(),
    ];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 400),
                  reverse: _previousIndex > _selectedIndex,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return FadeThroughTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                  child: pages[_selectedIndex],
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

import 'package:animations/animations.dart';
import 'package:edgar/screens/dashboard/traitement_page.dart';
import 'package:edgar/services/websocket.dart';
import 'package:edgar/utils/chat_utils.dart';
import 'package:edgar/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar/screens/dashboard/accueil_page.dart';
import 'package:edgar/screens/dashboard/information_personnel.dart';
import 'package:edgar/screens/dashboard/gestion_rendez_vous.dart';
import 'package:edgar/screens/dashboard/file_page.dart';
import 'package:edgar/screens/dashboard/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DashBoardPage extends StatefulWidget {
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  bool isChatting;
  final List<Chat> chats;
  void Function(bool) updateIsChatting;
  DashBoardPage(
      {super.key,
      required this.chats,
      required this.webSocketService,
      required this.isChatting,
      required this.scrollController,
      required this.updateIsChatting});

  @override
  DashBoardPageState createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    checkSession(context);
  }

  final List<int> _navigationStack = [0];

  void checkSession(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/');
    }
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
    final List<Widget> widgetOptions = <Widget>[
      const HomePage(),
      const GestionRendezVous(),
      const TraitmentPage(),
      const FilePage(),
      const InformationPersonnel(),
      ChatPage(
          chats: widget.chats,
          webSocketService: widget.webSocketService,
          isChatting: widget.isChatting,
          scrollController: widget.scrollController,
          updateIsChatting: widget.updateIsChatting),
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
                  child: widgetOptions[_selectedIndex],
                ),
              ),
            ),
            CustomBottomBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              chats: widget.chats,
              webSocketService: widget.webSocketService,
              isChatting: widget.isChatting,
              scrollController: widget.scrollController,
              updateIsChatting: widget.updateIsChatting,
            ),
          ],
        ),
      ),
    );
  }
}


// ignore: must_be_immutable


import 'package:edgar/colors.dart';
import 'package:edgar_pro/screens/dashboard/agenda_page.dart';
import 'package:animations/animations.dart';
import 'package:edgar_pro/screens/dashboard/chat_page.dart';
import 'package:edgar_pro/screens/dashboard/chat_patient_page.dart';
import 'package:edgar_pro/screens/dashboard/diagnostic_page.dart';
import 'package:edgar_pro/screens/dashboard/document_page.dart';
import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_patient_page.dart';
import 'package:edgar_pro/screens/dashboard/services.dart';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/appbar.dart';

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  final List<Chat> chats;
  DashBoard({
    super.key,
    required this.chats,
    required this.webSocketService,
    required this.scrollController,
  });

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
      Services(
        tapped: _onItemTapped,
      ),
      const Diagnostic(),
      ChatPageDashBoard(
          chats: widget.chats,
          webSocketService: widget.webSocketService,
          scrollController: widget.scrollController),
      const Text('Aide',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.blue950)),
      PatientPage(id: getId(), setPages: updateSelectedIndex, setId: updateId),
      PatientPageRdv(
        id: getId(),
        setPages: updateSelectedIndex,
        setId: updateId,
      ),
      DocumentPage(
        id: _id,
        setPages: updateSelectedIndex,
        setId: updateId,
      ),
      ChatPatient(
          id: getId(),
          setPages: updateSelectedIndex,
          setId: updateId,
          chats: widget.chats,
          webSocketService: widget.webSocketService,
          scrollController: widget.scrollController),
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

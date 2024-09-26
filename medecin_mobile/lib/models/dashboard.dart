import 'package:edgar/colors.dart';
import 'package:edgar_pro/main.dart';
import 'package:edgar_pro/screens/dashboard/agenda_page.dart';
import 'package:animations/animations.dart';
import 'package:edgar_pro/screens/dashboard/chat_page.dart';
import 'package:edgar_pro/screens/dashboard/chat_patient_page.dart';
import 'package:edgar_pro/screens/dashboard/diagnostic_page.dart';
import 'package:edgar_pro/screens/dashboard/document_page.dart';
import 'package:edgar_pro/screens/dashboard/patient_list_page.dart';
import 'package:edgar_pro/screens/dashboard/patientele_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_page.dart';
import 'package:edgar_pro/screens/dashboard/rdv_patient_page.dart';
import 'package:edgar_pro/screens/dashboard/services.dart';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/appbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  const DashBoard({
    super.key,
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
  WebSocketService? _webSocketService;
  List<Chat> chats = [];
  bool isChatting = false;
  final ScrollController _scrollController = ScrollController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notifications
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          await initializeFlutterLocalNotifications();

      // Initialize push notifications and request permissions

      // Initialize WebSocket service
      await _initializeWebSocketService(flutterLocalNotificationsPlugin);
    });
  }

  void updateIsChatting(bool value) {
    setState(() {
      isChatting = value;
    });
  }

  Future<void> _initializeWebSocketService(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    _webSocketService = WebSocketService(
      onReceiveMessage: (data) {
        setState(() {
          Chat? chatToUpdate = chats.firstWhere(
            (chat) => chat.id == data['chat_id'],
          );
          chatToUpdate.messages.add(
            Sms(
              message: data['message'],
              ownerId: data['owner_id'],
              time: data['sended_time'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(data['sended_time'])
                  : DateTime.now(),
            ),
          );
        });
        if (isChatting) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
      },
      onReady: (data) {},
      onGetMessages: (data) {
        setState(() {
          chats = transformChats(data);
        });
        if (isChatting) {
          Future.delayed(const Duration(milliseconds: 200), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          });
        }
      },
      onReadMessage: (data) {},
      // Handle the askMobileConnection action
      onAskMobileConnection: (data) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token");
        Logger().i('AskMobileConnection: $data');
        _webSocketService?.responseMobileConnection(
          token!,
          data['uuid'],
        );
      },

      onResponseMobileConnection: (data) {
        Logger().i('ResponseMobileConnection response: $data');
      },
    );
    await _webSocketService?.connect();
    _webSocketService?.sendReadyAction();
    _webSocketService?.getMessages();
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
      Patient(setPages: updateSelectedIndex,
        setId: updateId,),
      const Diagnostic(),
      ChatPageDashBoard(
          chats: chats,
          webSocketService: _webSocketService,
          scrollController: _scrollController),
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
          chats: chats,
          webSocketService: _webSocketService,
          scrollController: _scrollController),
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

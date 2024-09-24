import 'package:animations/animations.dart';
import 'package:edgar_app/main.dart';
import 'package:edgar_app/screens/dashboard/sante_page.dart';
import 'package:edgar_app/screens/dashboard/traitement_page.dart';
import 'package:edgar_app/services/websocket.dart';
import 'package:edgar_app/utils/chat_utils.dart';
import 'package:edgar_app/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar_app/screens/dashboard/accueil_page.dart';
import 'package:edgar_app/screens/dashboard/information_personnel.dart';
import 'package:edgar_app/screens/dashboard/gestion_rendez_vous.dart';
import 'package:edgar_app/screens/dashboard/file_page.dart';
import 'package:edgar_app/screens/dashboard/chat_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  DashBoardPageState createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  WebSocketService? _webSocketService;
  List<Chat> chats = [];
  bool isChatting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notifications
      checkSession(context);
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          await initializeFlutterLocalNotifications();

      // Initialize push notifications and request permissions

      // Initialize WebSocket service
      await _initializeWebSocketService(flutterLocalNotificationsPlugin);
    });
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
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
      onCreateChat: (data) {
        setState(() {
          chats.add(
            Chat(
              id: data['chat_id'],
              messages: [],
              recipientIds: [
                Participant(
                  id: data['recipient_ids'][0],
                  lastSeen: DateTime.now(),
                ),
                Participant(
                  id: data['recipient_ids'][1],
                  lastSeen: DateTime.now(),
                ),
              ],
            ),
          );
        });
      },
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
      SantePage(
        onItemTapped: _onItemTapped,
      ),
      const TraitmentPage(),
      const FilePage(),
      const InformationPersonnel(),
      ChatPage(
        chats: chats,
        webSocketService: _webSocketService,
        isChatting: isChatting,
        scrollController: _scrollController,
        updateIsChatting: updateIsChatting,
      ),
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
              chats: chats,
              webSocketService: _webSocketService,
              isChatting: isChatting,
              scrollController: _scrollController,
              updateIsChatting: updateIsChatting,
            ),
          ],
        ),
      ),
    );
  }
}


// ignore: must_be_immutable


import 'dart:convert';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_list.dart';
import 'package:edgar_pro/widgets/Chat/chat_page.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatPageDashBoard extends StatefulWidget {
  const ChatPageDashBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ChatState createState() => ChatState();
}

class ChatState extends State<ChatPageDashBoard> {
  WebSocketService? _webSocketService;
  String idDoctor = '';
  List<Chat> chats = [];
  String id = "";
  String patientName = "";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeWebSocketService();
    fetchData();
  }

  Future<void> _initializeWebSocketService() async {
    _webSocketService = WebSocketService(
      onReceiveMessage: (data) {
        setState(() {
          Chat? chatToUpdate = chats.firstWhere(
            (chat) => chat.id == data['chat_id'],
          );
          chatToUpdate.messages.add(
            Message(
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
    );
    await _webSocketService?.connect();
    _webSocketService?.sendReadyAction();
    _webSocketService?.getMessages();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        prefs.setString('id', jsonDecode(decodedPayload)['doctor']["id"]);
        setState(() {
          idDoctor = jsonDecode(decodedPayload)['doctor']["id"];
        });
      } catch (e) {
        Logger().e('Error decoding token: $e');
      }
    } else {
      Logger().w('Token is null or empty');
    }
  }

  ValueNotifier<int> selected = ValueNotifier(0);
  Chat? chatSelected;
  bool isChatting = false;
  void updateSelection(int newSelection) {
    setState(() {
      selected.value = newSelection;
    });
  }

  void setChatting(bool value, Chat? chat, String? patientname) {
    setState(() {
      isChatting = value;
      chatSelected = chat;
      patientName = patientname!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _webSocketService?.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (isChatting) ...[
              Expanded(
                child: ChatPage(
                  onClick: setChatting,
                  webSocketService: _webSocketService,
                  chat: chats.firstWhere(
                    (chat) => chat.id == chatSelected!.id,
                  ),
                  patientName: patientName,
                  doctorId: idDoctor,
                  controller: _scrollController,
                ),
              ),
            ],
            if (!isChatting) ...[
              Container(
                key: const ValueKey("Header"),
                decoration: BoxDecoration(
                  color: AppColors.blue700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    Image.asset(
                      "assets/images/logo/edgar-high-five.png",
                      height: 40,
                      width: 37,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      "Ma messagerie",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: AppColors.white),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ChatList(
                onClick: setChatting,
                webSocketService: _webSocketService!,
                chats: chats,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

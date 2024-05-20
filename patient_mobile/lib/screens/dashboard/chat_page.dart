import 'package:edgar/services/doctor.dart';
import 'package:edgar/services/websocket.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/utlis/chat_utils.dart';
import 'package:edgar/widget/card_conversation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String chatId = '664bad52f8fd0b0e3021a072'; // Set your chat ID
  WebSocketService? _webSocketService;
  String idPatient = '';
  List<Chat> chats = [];
  List<dynamic> doctors = [];

  @override
  void initState() {
    super.initState();
    getDoctors();
    _initializeWebSocketService();
    fetchData();
  }

  Future<void> getDoctors() async {
    await getAllDoctor().then((value) {
      setState(() {
        doctors = value;
      });
    });
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
      },
      onReadMessage: (data) {},
    );
    await _webSocketService?.connect();
    _webSocketService?.sendReadyAction();
    _webSocketService?.getMessages();
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        setState(() {
          idPatient = jsonDecode(decodedPayload)['patient']["id"];
          Logger().i('Patient ID: $idPatient');
        });
      } catch (e) {
        Logger().e('Error decoding token: $e');
      }
    } else {
      Logger().w('Token is null or empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            Image.asset(
              'assets/images/logo/edgar-high-five.png',
              width: 40,
            ),
            const SizedBox(width: 16),
            const Text(
              'Ma messagerie',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: CardConversation(
                    lastMsg: chats[index].messages.last.message,
                    name: (doctors.firstWhere(
                        (element) =>
                            element['id'] == chats[index].recipientIds[0].id ||
                            element['id'] == chats[index].recipientIds[1].id,
                        orElse: () => {})['name']),
                    time: chats[index].messages.last.time,
                    unread: getUnreadMessages(chats[index], idPatient)),
              );
            },
          ),
        ),
      ],
    );
  }
}

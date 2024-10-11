import 'dart:convert';
import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_list.dart';
import 'package:edgar_pro/widgets/Chat/chat_page.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatPageDashBoard extends StatefulWidget {
  WebSocketService? webSocketService;
  // ignore: prefer_final_fields
  ScrollController scrollController;
  final List<Chat> chats;
  
  ChatPageDashBoard({
    super.key,
    required this.chats,
    required this.webSocketService,
    required this.scrollController,
  });

  @override
  // ignore: library_private_types_in_public_api
  ChatState createState() => ChatState();
}

class ChatState extends State<ChatPageDashBoard> {
  String idDoctor = '';
  String id = "";
  String patientName = "";


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      try {
        String encodedPayload = token.split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        prefs.setString('id', jsonDecode(decodedPayload)["id"]);
        setState(() {
          idDoctor = jsonDecode(decodedPayload)["id"];
        });
      } catch (e) {
        // catch clauses
      }
    } else {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (isChatting) ...[
              Expanded(
                child: ChatPage(
                  onClick: setChatting,
                  webSocketService: widget.webSocketService,
                  chat: widget.chats.firstWhere(
                    (chat) => chat.id == chatSelected!.id,
                  ),
                  patientName: patientName,
                  doctorId: idDoctor,
                  controller: widget.scrollController,
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
                webSocketService: widget.webSocketService!,
                chats: widget.chats,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

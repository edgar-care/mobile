import 'package:edgar_pro/services/web_socket_services.dart';
import 'package:edgar/colors.dart';
import 'package:edgar_pro/widgets/Chat/chat_card.dart';
import 'package:edgar_pro/widgets/Chat/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatList extends StatefulWidget {
  Function(bool, Chat?, String?) onClick;
  WebSocketService webSocketService;
  List<Chat> chats = [];
  ChatList(
      {super.key,
      required this.onClick,
      required this.webSocketService,
      required this.chats});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String id = '';
  List<String> patientId = [];

  Future<void> getAllPatientsName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id')!;
    for (var i = 0; i < widget.chats.length; i++) {
      patientId.add(
        widget.chats[i].recipientIds
            .firstWhere((element) => element.id != id)
            .id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder<void>(
            future: getAllPatientsName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blue700,
                ));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading patient name'));
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemCount: widget.chats.length,
                  itemBuilder: (context, index) {
                    return ChatCard(
                      chat: widget.chats[index],
                      unread: getUnreadMessages(widget.chats[index], id),
                      service: widget.webSocketService,
                      patientId: patientId[index],
                      onClick: widget.onClick,
                    );
                  },
                );
              }
            }));
  }
}

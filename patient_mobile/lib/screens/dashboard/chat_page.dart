import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/card_conversation.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> conv = [
    {
      'name': 'Edgar',
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': '12:00',
      'unread': 2,
    },
    {
      'name': 'Edgar',
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': '12:00',
      'unread': 2,
    },
    {
      'name': 'Edgar',
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': '12:00',
      'unread': 3,
    },
    {
      'name': 'Edgar',
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': '12:00',
      'unread': 1,
    },
    {
      'name': 'Edgar',
      'message': 'Bonjour, comment puis-je vous aider?',
      'time': '12:00',
      'unread': 2,
    }
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {}

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
            child: FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: conv.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CardConversation(
                          name: conv[index]['name'],
                          lastMsg: conv[index]['message'],
                          time: DateTime.now(),
                          unread: conv[index]['unread'],
                        ),
                      );
                    },
                  );
                })),
      ],
    );
  }
}

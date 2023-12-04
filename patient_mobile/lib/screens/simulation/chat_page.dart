import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/services/getResponseConversation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  var sessionId = '';

  @override
  void initState() {
    super.initState();
    getSessionId();
  }

  Future<void> getSessionId() async {
    await dotenv.load();
    final url = '${dotenv.env['URL']}diagnostic/initiate';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    setState(() {
      sessionId = jsonDecode(response.body)['sessionId'];
    });
  }

  List<List<dynamic>> messages = [[
    'Bonjour, je suis Edgar, votre assistant médical. Comment puis-je vous aider ?',
    false,
  ]];

  Future<void> parseUserInput(String userInput) async {
    Object? response = getResponseMessage(context, userInput, sessionId);
    Map<String, dynamic> responseMap = response as Map<String, dynamic>;
    String question = responseMap['question'] as String;
    bool done = responseMap['done'] as bool;

    if (done) {
      Navigator.pop(context);
    } else {
      messages.add([question, false]);
    }
  }

  TextEditingController messageController = TextEditingController(); // Controller for the text input field
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue600,
        title: const Text(
          'Conversation avec notre assistant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of the back button here
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false, // Reverse the order of the messages
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index][0];
                final isSender = messages[index][1];

                return ListTile(
                  title: Align(
                    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSender ? AppColors.blue700 : AppColors.grey950,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(BootstrapIcons.arrow_right_circle_fill, color: AppColors.blue950),
                        onPressed: () {
                          sendMessage(true);
                          // parseUserInput(messageController.text);
                           messages.add(["next question", false]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(bool isSender) {
    String message = messageController.text;
    setState(() {
      messages.add([message, isSender]);
      messageController.clear();
    });
  }
}
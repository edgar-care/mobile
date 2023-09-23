import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/bottom_navbar.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<List<dynamic>> messages = [[
    'Bonjour, je suis Edgar, votre assistant médical. Comment puis-je vous aider ?',
    false,
  ]];
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
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          sendMessage(true);
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
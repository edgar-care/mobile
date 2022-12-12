import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widget/appbar.dart';
import '../styles/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Message {
  final String text;
  final bool isSender;

  Message({required this.text, required this.isSender});

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        isSender = json['isSender'];
}

class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  List<Message> messages = [
    Message(text: 'Hello', isSender: false),
    Message(text: 'Hi', isSender: true),
    Message(text: 'How are you?', isSender: false),
    Message(text: 'I am fine', isSender: true),
    Message(text: 'What about you?', isSender: false),
    Message(text: 'I am also fine', isSender: true),
  ];

  String msg = '';

  @override
  Widget build(BuildContext context) {
    void addMessage(Message msg) {
      setState(() {
        messages.add(msg);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCustom(widget.title, context),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            for (var message in messages) ...[
              BubbleNormal(
                text: message.text,
                isSender: message.isSender,
                color: message.isSender ? AppColors.blue500 : AppColors.grey800,
                tail: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              alignment: Alignment.center,
              height: 60,
              child: TextField(
                onChanged: (value) => setState(() {
                  msg = value;
                }),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: const TextStyle(
                    color: AppColors.grey500,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.grey100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (msg == 'end') {
                        Navigator.pushNamed(context, '/login');
                      }
                      if (msg.isNotEmpty) {
                        addMessage(Message(text: msg, isSender: true));
                      }
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: AppColors.blue500,
                      size: 18,
                    ),
                  ),
                ),
              ))),
    );
  }
}

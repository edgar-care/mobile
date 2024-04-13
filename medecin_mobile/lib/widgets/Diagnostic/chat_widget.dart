import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatList extends StatelessWidget {
  ChatList({super.key});
  List<Map<String, String>> chatList = [
    {'question': 'Hello, how can I help you today?', 'answer': 'I need help with my account'},
    {'question': 'What seems to be the problem?', 'answer': 'I can\'t log in'},
    {'question': 'Have you tried resetting your password?', 'answer': 'Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work'},
    {'question': 'Please provide me with your email address', 'answer': 'test@gmail.com'},
    {'question': 'Thank you, I will look into this and get back to you shortly', 'answer': 'Thank you'},
    {'question': 'Hello, how can I help you today?', 'answer': 'I need help with my account'},
    {'question': 'What seems to be the problem?', 'answer': 'I can\'t log in'},
    {'question': 'Have you tried resetting your password?', 'answer': 'Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work'},
    {'question': 'Please provide me with your email address', 'answer': 'test@gmail.com'},
    {'question': 'Thank you, I will look into this and get back to you shortly', 'answer': 'Thank you'},{'question': 'Hello, how can I help you today?', 'answer': 'I need help with my account'},
    {'question': 'What seems to be the problem?', 'answer': 'I can\'t log in'},
    {'question': 'Have you tried resetting your password?', 'answer': 'Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work'},
    {'question': 'Please provide me with your email address', 'answer': 'test@gmail.com'},
    {'question': 'Thank you, I will look into this and get back to you shortly', 'answer': 'Thank you'},{'question': 'Hello, how can I help you today?', 'answer': 'I need help with my account'},
    {'question': 'What seems to be the problem?', 'answer': 'I can\'t log in'},
    {'question': 'Have you tried resetting your password?', 'answer': 'Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work Yes, but it still doesn\'t work'},
    {'question': 'Please provide me with your email address', 'answer': 'test@gmail.com'},
    {'question': 'Thank you, I will look into this and get back to you shortly', 'answer': 'Thank you'},
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child:Expanded(
        child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: chatList.length * 2,
        itemBuilder: (context, index) {
              return _buildChatItem(index % 2 == 0 ? "question" : "answer", chatList[index ~/ 2][index % 2 == 0 ? "question" : "answer"]!, context);
        }
    )));
  }

  Widget _buildChatItem(String type, String message, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      alignment: type == "question" ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: type == "question" ? AppColors.green100 : AppColors.blue200,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        )
      ),
    );
  }
}
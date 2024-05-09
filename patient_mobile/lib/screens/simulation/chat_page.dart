import 'dart:convert';

import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/services/getResponseConversation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setState(() {
      sessionId = jsonDecode(response.body)['sessionId'];
    });
  }

  List<List<dynamic>> messages = [
    [
      'Bonjour, je m’appel Edgar et je serai votre assistant tout au long de cette simulation.Pour commencer, pouvez-vous me dire où vous avez mal ?',
      false,
    ]
  ];

  Future<void> parseUserInput(String userInput) async {
    final response = await getResponseMessage(context, userInput, sessionId);
    final Map<String, dynamic> jsonData = json.decode(response.toString());

    final question = jsonData['question'];
    bool done = jsonData['done'] as bool;
    if (done) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/simulation/confirmation');
    } else {
      setState(() {
        messages.add([question, false]);
      });
    }
  }

  void sendMessage(bool isSender, String message) {
    setState(() {
      messages.add([message, isSender]);
    });
  }

// Controller for the text input field
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: false, // Reverse the order of the messages
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final item = messages[index][0];
                    final isSender = messages[index][1];

                    Widget content;
                    if (item is String) {
                      content = Text(
                        item,
                        style: TextStyle(
                          color: isSender ? AppColors.grey700 : AppColors.black,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    } else if (item is Widget) {
                      content = item;
                    } else {
                      content = const Text('Unsupported item type');
                    }

                    return ListTile(
                      title: Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: content,
                      ),
                    );
                  },
                ),
              ),
              CustomFieldSearch(
                onValidate: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  sendMessage(true, value);
                  parseUserInput(value);
                },
                label: 'Ecriver votre message ici...',
                icon: SvgPicture.asset("assets/images/utils/search.svg"),
                keyboardType: TextInputType.text,
              ),
            ],
          )),
    );
  }
}

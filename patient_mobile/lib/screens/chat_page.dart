import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<List<dynamic>> messages = [[
    'Bonjour, je suis Edgar, votre assistant médical. Comment puis-je vous aider ?',
    false,
  ]];

  List<String> symptomsType = ["maux_de_tetes", "vision_trouble", "fievre", "maux_de_ventre", "vomissements"];

  Map<String, dynamic> symptomsContext = {
    "maux_de_tetes": { "symptoms": "Maux de tête", "present": null },
    "vision_trouble": { "symptoms": "Vision trouble", "present": null },
    "fievre": { "symptoms": "Fièvre", "present": null },
    "maux_de_ventre": { "symptoms": "Maux de ventre", "present": null },
    "vomissements": { "symptoms": "Vomissements", "present": null },
  };

  Future<void> parseUserInput(String userInput) async {
    await dotenv.load();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uncodeToken = JWT.decode(token!);
    final payload = uncodeToken.payload;
    // ignore: unused_local_variable
    final id = payload['patient']['id'];
    final url = '${dotenv.env['URL']}/nlp';
    final urlexam = '${dotenv.env['URL']}/exam';
    final responseNLP = await http.post(
    Uri.parse(url),
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'symptoms': symptomsType, // Replace 'symptomsType' with the actual list of symptoms
      'input': userInput,
      }),
    );

    if (responseNLP.statusCode == 200) {
      final nlpData = jsonDecode(responseNLP.body);
      final context = nlpData['context']; 

      final responseExam = await http.post(
      Uri.parse(urlexam),
      headers: {
      'Content-Type': 'application/json',
      },
      body: jsonEncode({
      'context': context,
      }),
      );

      if (responseExam.statusCode == 200) {
        final examData = jsonDecode(responseExam.body);
        final nextQuestion = examData['question'];
        // ignore: unused_local_variable
        final symptoms = examData['symptoms'];
        final done = examData['done'];

        if (done) {
          setState(() {
            messages.add([nextQuestion, false]);
            });
          } else {
            setState(() {
              messages.add([nextQuestion, false]);
            });
          }
        } 
      else {
        setState(() {
        messages.add(['Une erreur est survenue lors de la requête d\'examen', false]);
        });
      }
    } else {
      setState(() {
      messages.add(['Une erreur est survenue lors de la requête NLP', false]);
      });
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
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          sendMessage(true);
                          parseUserInput(messageController.text);
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
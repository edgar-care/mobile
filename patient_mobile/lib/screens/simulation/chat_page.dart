import 'dart:convert';
import 'package:edgar/services/diagnotic.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/services/getResponseConversation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

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
    await initiateDiagnostic().then((value) {
      setState(() {
        sessionId = value;
      });
    });
  }

  List<dynamic> messages = [
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

  void sendMessage(bool isSender, String message) async {
    setState(() {
      messages.add([message, true]);
    });
    await getDiagnostic(sessionId, message).then((value) {
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la récupération des données'),
          ),
        );
        return;
      }
      Logger().i(value);
      if (value['done'] == true) {
        Logger().i("here");
        setState(() {
          messages.add(Buttons(
            variant: Variante.primary,
            size: SizeButton.sm,
            msg: const Text('Continuer la simulation'),
            onPressed: () {
              Navigator.pushNamed(context, '/simulation/appointement');
            },
          ));
        });
        return;
      }
      setState(() {
        Logger().i('no here');
        messages.add([value['question'], false]);
      });
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
                    final message = messages[index];
                    if (message[0] is Buttons) {
                      return message[0];
                    } else if (message[1] == false) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 48,
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              message[0],
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 48,
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              message[0],
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              CustomFieldSearch(
                onValidate: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  sendMessage(true, value);
                  setState(() {
                    value = '';
                  });
                },
                label: 'Ecriver votre message ici...',
                icon: SvgPicture.asset("assets/images/utils/search.svg"),
                keyboardType: TextInputType.text,
                onlyOnValidate: true,
              ),
            ],
          )),
    );
  }
}

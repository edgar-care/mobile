import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar/services/diagnotic.dart';
import 'package:edgar/widget/buttons.dart';
import 'package:edgar/widget/field_custom.dart';
import 'package:edgar/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var sessionId = '';

  final ScrollController _scrollController = ScrollController();

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
      'Bonjour, je m’appel Edgar et je serai votre assistant tout au long de cette simulation. Pour commencer, pouvez-vous me dire où vous avez mal ?',
      false,
    ]
  ];

  void sendMessage(bool isSender, String message) async {
    setState(() {
      messages.add([message[0].toUpperCase() + message.substring(1), true]);
    });
    await getDiagnostic(sessionId, message).then((value) {
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
            message: "Erreur lors de l'envoie", context: context));
        return;
      }
      if (value['done'] == true) {
        setState(() {
          messages.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Buttons(
                variant: Variante.primary,
                size: SizeButton.md,
                msg: const Text('Continuer la simulation'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('sessionId', sessionId);
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/simulation/appointement');
                },
              ),
            ),
          );
        });
        goMid();
        return;
      }
      setState(() {
        messages.add([value['question'], false]);
        goMid();
      });
    });
  }

  void goMid() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  if (message is Padding) {
                    return message;
                  } else if (message[1] == false) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 48,
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            message[0],
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Text(
                            message[0],
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
            const SizedBox(height: 16),
            if (messages.last is! Padding)
              CustomFieldSearch(
                onValidate: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  if (messages.last is! Buttons) {
                    sendMessage(true, value.trim());
                  }
                },
                label: 'Ecriver votre message ici...',
                icon: const Icon(
                  BootstrapIcons.send_fill,
                  color: AppColors.black,
                  size: 16,
                ),
                keyboardType: TextInputType.text,
                onlyOnValidate: true,
                onOpen: () {
                  goMid();
                },
              ),
          ],
        ),
      ),
    );
  }
}

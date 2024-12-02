// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/diagnotic.dart';
import 'package:edgar_app/services/nlp.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var sessionId = '';
  bool isLoading = true;

  List<dynamic> messages = [
    [
      'Bonjour, je m’appel Edgar et je serai votre assistant tout au long de cette simulation. Pour commencer, pouvez-vous me dire où vous avez mal ?',
      false,
    ]
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> getStatusNlp() async {
    await getNlpUp(context).then(
      (value) {
        if (value == true) {
          setState(
            () {
              isLoading = false;
            },
          );
        }
      },
    );
  }

  Future<void> loadSession() async {
    await getSessionId();
    await getStatusNlp();
    if (isLoading) {
      Timer.periodic(
        Duration(seconds: 8),
        (timer) async {
          await getStatusNlp();
        },
      );
    }
  }

  Future<void> getSessionId() async {
    await initiateDiagnostic(context).then((value) {
      setState(() {
        sessionId = value;
      });
    });
  }

  void sendMessage(bool isSender, String message) async {
    setState(() {
      messages.add([message[0].toUpperCase() + message.substring(1), true]);
    });
    await getDiagnostic(sessionId, message, context).then((value) {
      if (value.isEmpty) {
        TopErrorSnackBar(message: 'Erreur lors de la récupération des données')
            .show(context);
        return;
      }
      if (value['done'] == true) {
        setState(() {
          messages.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text('Continuer la simulation'),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('sessionId', sessionId);
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

  Widget _buildWarningBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.red200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.red400, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: const Text(
        "Ce projet est uniquement destiné à des fins de démonstration. Ne pouvant garantir la sécurité et l'anonymisation de vos données de santé, nous vous demandons de ne pas saisir d'informations personnelles ou médicales sensibles.",
        style: TextStyle(
          color: AppColors.black,
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

// Controller for the text input field
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.blue700,
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
              ),
              const SizedBox(height: 24),
              Text(
                'Initialisation de votre assistant...',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildWarningBox(),
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

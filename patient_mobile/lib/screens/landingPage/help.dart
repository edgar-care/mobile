import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/styles/colors.dart';
import 'package:edgar/widget/plain_button.dart';
import 'package:edgar/widget/navbar.dart';
import 'package:http/http.dart' as http;

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      body: _ChildBody(),
    );
  }
}

Future<MessageResponse> sendContactForm(String email, String name, String message) async {
  try {
    if (!emailValidityChecker(email)) {
      return MessageResponse(title: 'Adresse mail invalide', status: 'error');
    }
    if (name.isEmpty) {
      return MessageResponse(title: 'Merci de renseigner votre nom', status: 'error');
    }
    if (message.isEmpty) {
      return MessageResponse(title: 'Merci de renseigner votre message', status: 'error');
    }

    await dotenv.load();
    final airtableKey = dotenv.env['AIRTABLE_KEY'];

    final response = await http.post(
      Uri.parse('https://api.airtable.com/v0/apppNB1HHznqlQND3/tblYv0iZL8XQLXwGH'),
      headers: {
        'Authorization': 'Bearer $airtableKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'records': [
          {
            'fields': {
              'Email': email,
              'Name': name,
              'Message': message,
              'Date': DateTime.now().toIso8601String(),
            },
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      return MessageResponse(title: 'Une erreur est survenue, merci de réessayer', status: 'error');
    }

    return MessageResponse(title: 'Message envoyé', status: 'success');
  } catch (error) {
    return MessageResponse(title: 'Une erreur est survenue, merci de réessayer', status: 'error');
  }
}

bool emailValidityChecker(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

class MessageResponse {
  final String title;
  final String status;

  MessageResponse({required this.title, required this.status});
}

class _ChildBody extends StatelessWidget {
  const _ChildBody();


  @override
  Widget build(BuildContext context) {

    var mail = "";
    var question = "";
    var name = "";

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.only(left: 24.0, top: 30),
          child: Text("Adresse mail :",
              style: TextStyle(
                  color: AppColors.blue700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 96,
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                mail = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Nom :",
              style: TextStyle(
                  color: AppColors.blue700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 96,
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                name = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Question :",
              style: TextStyle(
                  color: AppColors.blue700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 42,
            height: 175,
            child: TextField(
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (value) {
                question = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: PlainButton(text: "Envoyer", onPressed: () async {
            final response = await sendContactForm(mail, name, question);
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(response.title),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SizedBox(width: 20),
              QuestionsCard(
                question:
                    "Que ce passe-t-il si le rendez-vous n'est pas utile ?",
                answer:
                    "Si le médecin juge que le rendez-vous n'est pas utile, le rendez-vous sera annulé et vous recevrez un message avec toutes les informations liées à l'annulation avec un motif et une solution pour calmer vos symptômes",
              ),
              SizedBox(width: 20),
              QuestionsCard(
                question:
                    "Donc edgar c'est juste une application de prise de rendez-vous ?",
                answer:
                    "Oui, c'est une application de prise de rendez-vous médicaux mais pas seulement. Le but d'edgar est de pouvoir centraliser l'entièreté de votre santé, pour vous et votre médecins. Vous pourrez retrouver l'ensemble de vos informations de santé à un seul et unique endroit",
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}

class QuestionsCard extends StatelessWidget {
  final String question;
  final String answer;
  const QuestionsCard(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 201,
      height: 240,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.blue700,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
              question,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 10),
            Center(
                child: Text(
              answer,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }
}

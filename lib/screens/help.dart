import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/navbar.dart';
import 'package:prototype_1/widget/plain_button.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Adresse mail :",
              style: TextStyle(
                  color: AppColors.blue700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          TextFieldBlock(children: [
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez votre adresse mail',
              ),
            ),
            const SizedBox(height: 10),
            const Text("Question :",
                style: TextStyle(
                    color: AppColors.blue700,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez votre question',
              ),
            ),
            PlainButton(text: "Envoyer", onPressed: () {}),
          ]),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: PageView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Row(
                      children: [
                        QuestionsCard(
                            question:
                                "Que ce passe-t-il si le rendez-vous n'est pas utile ?",
                            answer:
                                "Si le médecin juge que le rendez-vous n'est pas utile, le rendez-vous sera annulé et vous recevrez un message avec toutes les informations liées à l'annulation avec un motif et une solution pour calmer vos symptômes"),
                        SizedBox(width: 10),
                      ],
                    );
                  } else {
                    return const Row(
                      children: [
                        QuestionsCard(
                            question:
                                "Que ce passe-t-il si le rendez-vous n'est pas utile ?",
                            answer:
                                "Si le médecin juge que le rendez-vous n'est pas utile, le rendez-vous sera annulé et vous recevrez un message avec toutes les informations liées à l'annulation avec un motif et une solution pour calmer vos symptômes"),
                        SizedBox(width: 10),
                      ],
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TextFieldBlock extends StatelessWidget {
  final List<Widget> children;
  const TextFieldBlock({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Text(
            question,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 10),
          Center(
              child: Text(
            answer,
            style: const TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:prototype_1/widget/plain_button.dart';
import 'package:prototype_1/widget/navbar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Navbar(),
      body: _ChildBody(),
    );
  }
}

class _ChildBody extends StatelessWidget {
  const _ChildBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
        const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: SizedBox(
            width: 248,
            height: 32,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
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
        const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: SizedBox(
            width: 337,
            height: 175,
            child: TextField(
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: PlainButton(text: "Envoyer", onPressed: () {}),
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
        )
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

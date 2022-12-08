// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/widget/cards.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../widget/button.dart';
import '../styles/colors.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title),
      body: _ChildBody(),
      backgroundColor: AppColors.blue100,
    );
  }
}

class _ChildBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text("Merci pour cet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(width: 5),
              GradientText(
                "échange",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                colors: const [
                  AppColors.blue500,
                  AppColors.pink500,
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
              "Nous avons besoin d'un médecin, pour examiner votre analyse :",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              print('taped');
            },
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    const Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "x km de votre position",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            height: 30,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  const Text(
                    "Dr A.",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "x km de votre position",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    const Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "x km de votre position",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    const Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "x km de votre position",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

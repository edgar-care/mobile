import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../styles/colors.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title, context),
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
              Navigator.pushNamed(context, '/home');
            },
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
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
                children: const [
                  Text(
                    "Dr A.",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
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
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
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
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: SizedBox(
              width: 300,
              height: 30,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: const [
                    Text(
                      "Dr A.",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
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

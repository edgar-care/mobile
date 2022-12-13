// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:prototype_1/screens/chat_box_page.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title, context),
        backgroundColor: Colors.white,
        body: _ChildBody());
  }
}

class _ChildBody extends StatefulWidget {
  @override
  State<_ChildBody> createState() => _ChildBodyState();
}

class _ChildBodyState extends State<_ChildBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  int selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Avant de commencer, j\'ai besoin de',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            GradientText(
              ' quelques informations',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
              colors: const [
                Color.fromRGBO(22, 54, 217, 1),
                Color.fromRGBO(217, 22, 186, 1),
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            const Text('Quel est votre sexe ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    onButtonPressed(0);
                  },
                  child: SizedBox(
                    height: 48,
                    width: 76,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedButtonIndex == 0
                              ? AppColors.blue300
                              : AppColors.blue100),
                      child: Image.asset("assets/images/utils/male.png"),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    onButtonPressed(1);
                  },
                  child: SizedBox(
                    height: 48,
                    width: 76,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedButtonIndex == 1
                              ? AppColors.blue300
                              : AppColors.blue100),
                      child: Image.asset("assets/images/utils/female.png"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 28,
            ),
            const Text('Quel est votre âge ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: TextFormField(
                validator: ValidatorHelper.mandatoryField(),
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.blue100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  hintText: 'Votre âge',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text('Quel est votre taille ? (en cm)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: TextFormField(
                validator: ValidatorHelper.mandatoryField(),
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.blue100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  hintText: 'Votre taille',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text('Quel est votre poids ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: TextFormField(
                validator: ValidatorHelper.mandatoryField(),
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.blue100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none)),
                  hintText: 'Votre poids',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => ChatBoxPage(title: 'chat')));
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.blue400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                "Valider mes informations",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }
}

class ValidatorHelper {
  static String? Function(String?) mandatoryField() {
    return (String? text) {
      if (text != null && text.isNotEmpty) {
        return null;
      } else {
        return "required";
      }
    };
  }
}

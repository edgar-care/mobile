// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../widget/appbar.dart';
import '../widget/button.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(title, context),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
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
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w700),
                colors: const [
                  Color.fromRGBO(22, 54, 217, 1),
                  Color.fromRGBO(217, 22, 186, 1),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Quel est votre sexe ?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 61,
                      width: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.blue100),
                        child: Image.asset("assets/images/utils/male.png"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 61,
                      width: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.blue100),
                        child: Image.asset("assets/images/utils/female.png"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text('Quel est votre âge ?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(
                width: 200,
                child: TextFormField(
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
                height: 50,
              ),
              const Text('Quel est votre taille ? (en cm)',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(
                width: 200,
                child: TextFormField(
                  //  textInputAction: TextInputAction.next,
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
                height: 50,
              ),
              const Text('Quel est votre poids ?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(
                width: 200,
                child: TextFormField(
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
                height: 50,
              ),
              PrimaryButton(
                  'Valider mes informations',
                  'chat',
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  context),
            ]),
          ),
        ));
  }
}

class SexButton {
  bool isSelected;
  SexButton({required this.isSelected});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

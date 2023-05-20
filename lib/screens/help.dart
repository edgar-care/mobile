import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aide")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Une question ? Besoin d'aide ?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Contactez-nous via le formulaire ci-dessous",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.lightBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Votre nom complet',
                  labelStyle: TextStyle(
                      color: AppColors.textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.lightBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Votre adresse mail',
                  labelStyle: TextStyle(
                      color: AppColors.textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.lightBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Votre message',
                  labelStyle: TextStyle(
                      color: AppColors.textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class TextFieldBlock extends StatelessWidget {
  final List<Widget> children;
  const TextFieldBlock({required this.children});

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

import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo/full-width-colored-edgar-logo.png",
                width: 164),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.darkBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Adresse mail',
                  labelStyle: TextStyle(color: AppColors.textBlue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.darkBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(color: AppColors.textBlue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            PlainButton(text: "Connexion", onPressed: () {}),
            const SizedBox(height: 20),
            const Text("Pas encore inscrit ?", style: TextStyle(color: AppColors.textBlue, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            EmptyButton(text: "Enregistrez-vous", onPressed: () {
              Navigator.pushNamed(context, '/auth');
            }),
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

class PlainButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const PlainButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.buttonBlue,
        minimumSize: const Size(180, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

class EmptyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const EmptyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        side: const BorderSide(color: AppColors.lightBlue, width: 2),
        backgroundColor: Colors.white,
        minimumSize: const Size(180, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: AppColors.textBlue, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
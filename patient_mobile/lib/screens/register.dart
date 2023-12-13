import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar/styles/colors.dart';

class Register extends StatelessWidget {
  const Register({super.key});

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
                    borderSide:
                        BorderSide(color: AppColors.darkBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Adresse mail',
                  labelStyle: TextStyle(
                      color: AppColors.textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 20),
            const PasswordTextFieldBlock(),
            const SizedBox(height: 20),
            PlainButton(
                text: "Inscrivez-vous",
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                }),
            const SizedBox(height: 20),
            const Text("Déjà inscrit ?",
                style: TextStyle(
                    color: AppColors.textBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            EmptyButton(
                text: "Se connecter",
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }),
          ],
        ),
      ),
    );
  }
}

class PasswordTextFieldBlock extends StatefulWidget {
  const PasswordTextFieldBlock({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordTextFieldBlockState createState() => _PasswordTextFieldBlockState();
}

class _PasswordTextFieldBlockState extends State<PasswordTextFieldBlock> {
  bool _obscureText = true;

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
        children: [
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.darkBlue, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              labelText: 'Mot de passe',
              labelStyle: const TextStyle(
                  color: AppColors.textBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? BootstrapIcons.eye : BootstrapIcons.eye_slash,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
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

class PlainButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const PlainButton({super.key, required this.text, required this.onPressed});

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
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

class EmptyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const EmptyButton({super.key, required this.text, required this.onPressed});

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
      child: Text(text,
          style: const TextStyle(
              color: AppColors.textBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }
}

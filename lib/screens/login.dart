import 'package:flutter/material.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

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
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ]),
            const SizedBox(height: 20),
            TextFieldBlock(children: [
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.darkBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Mot de passe',
                  labelStyle: TextStyle(
                      color: AppColors.textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ]),
            const SizedBox(height: 20),
            PlainButton(
                text: "Connexion",
                onPressed: () async {
                  const url =
                      'https://dvpm9zw6vc.execute-api.eu-west-3.amazonaws.com/auth/p/login';
                  final response = await http.post(
                    Uri.parse(url),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'email': email, 'password': password}),
                  );
                  if (response.statusCode == 200) {
                    Navigator.pushNamed(context, '/connexion-validate');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Identifiants incorrects'),
                      ),
                    );
                  }
                }),
            const SizedBox(height: 20),
            const Text("Pas encore inscrit ?",
                style: TextStyle(
                    color: AppColors.textBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            EmptyButton(
                text: "Enregistrez-vous",
                onPressed: () {
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

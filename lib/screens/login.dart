// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:prototype_1/widget/snackbar.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  Color borderColor = AppColors.blue800;

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
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: borderColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Adresse mail',
                  labelStyle: const TextStyle(
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
                decoration:  InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: borderColor, width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: 'Mot de passe',
                  labelStyle: const TextStyle(
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
                await dotenv.load();
                await dotenv.load();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String url = '${dotenv.env['URL']}auth/p/login';
                ScaffoldMessenger.of(context).showSnackBar(
                  WaittingSnackBar(
                    message: 'Connexion en cours...',
                    context: context,
                  ),
                );
                final response = await http.post(
                  Uri.parse(url),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'email': email, 'password': password}),
                );
                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  final token = jsonDecode(response.body)['token'];
                  prefs.setString('token', token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    ValidateSnackBar(
                      message: 'Connexion réussie',
                      context: context,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.pushNamed(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  final scaffoldContext = context;
                  setState(() {
                    borderColor = AppColors.red700;
                  });
                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                    ErrorSnackBar(
                      message: 'Identifiants incorrects ou mot de passe invalide',
                      context: scaffoldContext,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    borderColor = AppColors.blue800;
                  });
                }
              },
            ),
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
                  Navigator.pushNamed(context, '/register');
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

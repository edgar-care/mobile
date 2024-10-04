// ignore_for_file: must_be_immutable

import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';
import 'package:edgar/widget.dart';

class Register extends StatefulWidget {
  Function(int) callback;
  Function registerCallback;
  Register({super.key, required this.callback, required this.registerCallback});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: AppColors.blue700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Image.asset('assets/images/logo/new_white_logo.png',
                        height: 60, width: 200),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 320,
                      child: Text('Bienvenue sur la plateforme edgar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                        width: 320,
                        child: Text(
                            'Inscrivez-vous pour accéder à votre espace médecin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Adresse mail",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomField(
                          action: TextInputAction.next,
                          label: "prenom.nom@gmail.com",
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Mot de passe",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomField(
                          action: TextInputAction.next,
                          label: "Minimum 8 caractères",
                          keyboardType: TextInputType.text,
                          isPassword: true,
                          onChanged: (value) {
                            setState(() {
                              password = value.trim();
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        Buttons(
                          variant: Variant.primary,
                          msg: const Text("Continuer"),
                          size: SizeButton.md,
                          onPressed: () {
                            if (email.isNotEmpty && password.isNotEmpty) {
                              widget.registerCallback(email, password);
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                ErrorSnackBar(
                                  message: 'Veuillez remplir tous les champs',
                                  context: context,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous êtes déjà inscrit ?",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Buttons(
                        variant: Variant.secondary,
                        msg: const Text("Se connecter"),
                        size: SizeButton.md,
                        onPressed: () {
                          widget.callback(0);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

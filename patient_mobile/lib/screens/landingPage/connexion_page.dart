import 'dart:convert';

import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue700,
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          SvgPicture.asset("assets/images/logo/newLogosvg.svg"),
          const Spacer(),
          Image.asset("assets/images/logo/edgar_cut.png"),
          Container(
            padding: const EdgeInsets.all(32),
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              border: BorderDirectional(
                top: BorderSide(
                  color: AppColors.white,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Gagne du temps avec l'assistant virtuel du pré-diagnostic",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  "Accéder à votre espace patient, gérer vos rendez-vous et bien plus",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 42,
                ),
                GestureDetector(
                  onTap: () {
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(
                              model: model,
                              children: [
                                ModalRegister(
                                  model: model,
                                  isRegister: true,
                                ),
                                ModalLogin(
                                  model: model,
                                  isLogin: false,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "Inscription",
                          style: TextStyle(
                            color: AppColors.blue700,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    final model =
                        Provider.of<BottomSheetModel>(context, listen: false);
                    model.resetCurrentIndex();

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Consumer<BottomSheetModel>(
                          builder: (context, model, child) {
                            return ListModal(
                              model: model,
                              children: [
                                ModalLogin(
                                  model: model,
                                  isLogin: true,
                                ),
                                ModalRegister(model: model, isRegister: false)
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.blue700,
                        border: Border.all(color: AppColors.white, width: 2)),
                    child: const Center(
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}

class ModalLogin extends StatefulWidget {
  final BottomSheetModel model;
  final bool isLogin;
  const ModalLogin({super.key, required this.model, required this.isLogin});

  @override
  State<ModalLogin> createState() => _ModalLoginState();
}

class _ModalLoginState extends State<ModalLogin> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Bon retour sur la plateforme edgar",
      subtitle:
          "Connectez-vous avec votre compte pour accéder à votre espace patient, gérer vos rendez-vous et bien plus.",
      icon: IconModal(
        icon: SvgPicture.asset(
          "assets/images/utils/pailette.svg",
          width: 18,
          // ignore: deprecated_member_use
          // color: AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          "Addresse mail",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "prenom.nom@gmail.com",
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Mot de passe",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "Minimum 8 caractères",
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          child: const Text(
            "Mot de passe oublié ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text("Connexion"),
          onPressed: () async {
            await dotenv.load();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String url = '${dotenv.env['URL']}auth/p/login';
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              InfoSnackBar(
                message: 'Connexion en cours...',
                // ignore: use_build_context_synchronously
                context: context,
              ),
            );
            final response = await http.post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email, 'password': password}),
            );

            Logger().i("Good");
            if (response.statusCode == 200) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final token = jsonDecode(response.body)['token'];
              prefs.setString('token', token);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SuccessSnackBar(
                  message: 'Connexion réussie',
                  // ignore: use_build_context_synchronously
                  context: context,
                ),
              );
              await Future.delayed(const Duration(seconds: 3));
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/dashboard');
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final scaffoldContext = context;
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                ErrorSnackBar(
                  message: 'Identifiants incorrects ou mot de passe invalide',
                  // ignore: use_build_context_synchronously
                  context: scaffoldContext,
                ),
              );
            }
          },
        )
      ],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Vous n'êtes pas encore inscrit ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text("Créer un compte"),
            onPressed: () {
              if (widget.isLogin) {
                widget.model.changePage(1);
              } else {
                widget.model.changePage(0);
              }
            },
          )
        ],
      ),
    );
  }
}

class ModalRegister extends StatefulWidget {
  final BottomSheetModel model;
  final bool isRegister;
  const ModalRegister(
      {super.key, required this.model, required this.isRegister});

  @override
  State<ModalRegister> createState() => _ModalRegisterState();
}

class _ModalRegisterState extends State<ModalRegister> {
  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";

    bool emailValidityChecker(String email) {
      return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    }

    return ModalContainer(
      title: "Bon retour sur la plateforme edgar",
      subtitle:
          "Un compte edgar vous permettra de suivre votre santé ainsi que prendre des rendez-vous pour vous et vos proches.",
      icon: IconModal(
        icon: SvgPicture.asset(
          "assets/images/utils/pailette.svg",
          width: 18,
          // ignore: deprecated_member_use
          // color: AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          "Addresse mail",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "prenom.nom@gmail.com",
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Mot de passe",
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        CustomField(
          label: "Minimum 8 caractères",
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          action: TextInputAction.next,
          isPassword: true,
        ),
        const SizedBox(height: 8),
        const SizedBox(
          height: 24,
        ),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text("Inscription"),
          onPressed: () async {
            if (password == "" || email == "") {
              // ignore: use_build_context_synchronously

              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Veuillez remplir tous les champs",
                  // ignore: use_build_context_synchronously
                  context: context));
              return;
            }
            if (password.length < 8) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message:
                      "Le mot de passe doit contenir au moins 8 caractères",
                  // ignore: use_build_context_synchronously
                  context: context));
              return;
            }
            if (!emailValidityChecker(email)) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Adresse mail invalide",
                  // ignore: use_build_context_synchronously
                  context: context));
              return;
            }
            var reponse = await RegisterUser(email, password);
            if (reponse) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
                  message: "Inscription réussie",
                  // ignore: use_build_context_synchronously
                  context: context));
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/onboarding');
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                  message: "Erreur lors de l'inscription",
                  // ignore: use_build_context_synchronously
                  context: context));
            }
          },
        )
      ],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Vous êtes déja encore inscrit ?",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.md,
            msg: const Text("Se connecter à un compte"),
            onPressed: () {
              if (widget.isRegister) {
                widget.model.changePage(1);
              } else {
                widget.model.changePage(0);
              }
            },
          )
        ],
      ),
    );
  }
}